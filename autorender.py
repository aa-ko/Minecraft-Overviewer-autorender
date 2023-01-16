import subprocess
import multiprocessing
import os

def run_renderer(params):
    print("Running renderer..")
    res = subprocess.run(["./overviewer.py", "--rendermodes=smooth-lighting", "-p%s"%(params["thread_count"]), "/world", "/cache"])
    if res.returncode is not 0:
        print("Something went wrong when executing renderer.")
    else:
        print("Render seems to be successful. Trying to copy result to mounted target folder.")
        subprocess.run(["rsync", "-qcr", "--delete", "/cache/", "/render"])

def apply_env_variables():
    thread_count = os.environ.get("MCOVAR_THREAD_COUNT")
    if thread_count is None or thread_count <= 0:
        thread_count = multiprocessing.cpu_count()
    return {
        thread_count: thread_count
    }

apply_env_variables()
while(True):
    run_renderer()
