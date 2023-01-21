import subprocess
import multiprocessing
import os


def run_renderer():
    print("Running renderer..")
    res = subprocess.run(["./overviewer.py",
                          "--rendermodes=smooth-lighting",
                          "/world",
                          "/cache"])
    if res.returncode != 0:
        print("Something went wrong when executing renderer.")
        return False
    else:
        print("Render seems to be successful.")
        return True


def gen_poi():
    print("Generating POIs..")
    res = subprocess.run(["./overviewer.py",
                          "--genpoi",
                          "/world",
                          "/cache"])
    if res.returncode != 0:
        print("Something went wrong when generating POIs.")
        return False
    else:
        print("POI generation seems to be successful.")
        return True


def copy_result():
    subprocess.run(["rsync",
                    "-qcr",
                    "--delete",
                    "/cache/",
                    "/render"])


def apply_env_variables():
    thread_count = os.environ.get("MCOVAR_THREAD_COUNT")
    if thread_count is None or thread_count <= 0:
        thread_count = multiprocessing.cpu_count()
    return {
        thread_count: thread_count
    }


apply_env_variables()
while(True):
    render_res = run_renderer()
    poi_res = gen_poi()
    if render_res and poi_res:
        print("Trying to copy result to mounted target folder.")
        copy_result()
