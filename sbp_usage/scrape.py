#!/usr/bin/env python3
import sys
import csv
from pathlib import Path
from datetime import datetime, timezone
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver import FirefoxOptions
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait

if len(sys.argv) != 2:
    print("USAGE: scrape.py /path/to/output/data")
    raise SystemExit("Error: Improper usage.")

OUT_FP = sys.argv[1]
LOG_FP = "/home/hans/projects/sbp_usage/sbp_usage.log"
URL = "https://seattleboulderingproject.com/occupancy"
GYM = {
    "POP": "Poplar",
    "FRE": "Fremont",
    "UPW": "Upper Walls"
}


def get_date_time():
    now = datetime.now(timezone.utc)
    date = now.strftime("%Y-%m-%d")
    time = now.strftime("%H:%M:%S").split(":")
    # server is off!
    h = int(time[0]) - 7
    h = "0" + str(h) if h < 10 else str(h)
    time[0] = h
    time = ":".join(time)
    return date, time

def lg(msg):
    date, time = get_date_time()
    msg = f"[{date} {time}] {msg}"
    lgfp = Path(LOG_FP)
    if not lgfp.exists():
        lgfp.touch()
    with open(lgfp, "a") as f:
        f.write(msg + "\n")
    print(msg)


def _get_gym_occ(frame):
    # get occupancy count from display
    driver.switch_to.frame(frame)
    count = driver.find_element(By.ID, "count").text
    # determine which gym the display is for using the gym-switcher select menu
    # (secret select menu not actually clickable)
    switcher = driver.find_element(By.ID, "gym-switcher")
    selector = Select(switcher)
    gym = selector.first_selected_option.get_attribute("value")
    # get last update time
    time = driver.find_element(By.ID, "last-update").text
    return GYM[gym], int(count), time


def process_frame(driver, url, frame_idx):
    # need to reload the page each time since we are moving to a frame,
    # but need to access all frames each time since they have no unique id other
    # than order
    driver.get(url)
    frames = driver.find_elements(By.CSS_SELECTOR, "iframe#occupancyCounter")
    return _get_gym_occ(frames[frame_idx])


if __name__ == "__main__":
    date, time = get_date_time()

    # set up webdriver
    opts = FirefoxOptions()
    opts.add_argument("--headless")
    driver = webdriver.Firefox(options=opts)
    driver.implicitly_wait(10) # secs

    # scrape data
    lg("Scraping data...")
    data = [["date", "time", "gym", "occupancy", "last_update"]]
    for idx in range(len(GYM)):
        gym, occ, upd = process_frame(driver, URL, idx)
        data.append(
            [date, time, gym, occ, upd] 
        )
        lg(" - " + gym)

    # write data
    output = Path(OUT_FP)
    if output.exists():
        lg("Appending data...")
        data.pop(0) #don't repeat header
    else:
        lg("Creating data...")

    with open(output, "a") as csvf:
        writer = csv.writer(csvf, delimiter="|")
        for row in data:
            writer.writerow(row)

    lg("Saved: " + output.as_posix())
    lg("***")
