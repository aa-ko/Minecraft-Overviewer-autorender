import subprocess
import schedule
import time
import multiprocessing

render_interval_in_minutes = 15
cooldown_interval_in_seconds = 30
thread_count = multiprocessing.cpu_count()

def run_renderer():
    print("Running renderer..")
    res = subprocess.run(["./overviewer.py", "--rendermodes=smooth-lighting", "-p%s"%thread_count, "/world", "/cache"])
    if res.returncode is not 0:
        print("Something went wrong when executing renderer.")
    else:
        print("Render seems to be successful. Trying to copy result to mounted target folder.")
        subprocess.run(["rsync", "-qcr", "--delete", "/cache/", "/render"])

print("Running renderer once immediately and then scheduling a run every", render_interval_in_minutes, "minutes..")
run_renderer()
schedule.every(render_interval_in_minutes).minutes.do(run_renderer)

while(True):
    schedule.run_pending()
    print("No job scheduled. Sleeping for", cooldown_interval_in_seconds, "seconds..")
    time.sleep(cooldown_interval_in_seconds)
