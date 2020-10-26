import subprocess
import schedule
import time
import multiprocessing
from datetime import datetime

render_interval_in_minutes = 15
cooldown_interval_in_seconds = 30
thread_count = multiprocessing.cpu_count()

def fmtlog(m):
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{ts}  {m}") 

def run_renderer():
    fmtlog("Running renderer..")
    res = subprocess.run(["./overviewer.py", "--rendermodes=smooth-lighting", "-p%s"%thread_count, "/world", "/cache"])
    if res.returncode != 0:
        fmtlog("Something went wrong when executing renderer.")
    else:
        fmtlog("Render seems to be successful. Trying to copy result to mounted target folder.")
        subprocess.run(["rsync", "-qcr", "--delete", "/cache/", "/render"])

fmtlog(f"Running renderer once immediately and then scheduling a run every {render_interval_in_minutes} minutes..")
run_renderer()
schedule.every(render_interval_in_minutes).minutes.do(run_renderer)

while(True):
    schedule.run_pending()
    fmtlog(f"No job scheduled. Sleeping for {cooldown_interval_in_seconds} seconds..")
    time.sleep(cooldown_interval_in_seconds)
