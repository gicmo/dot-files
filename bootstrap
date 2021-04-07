#!/usr/bin/python3
import os
import pathlib
import subprocess
import tempfile


REPOS = {
    "devel": "https://github.com/gicmo/dot-devel.git",
    "emacs": "https://github.com/gicmo/dot-emacs.git",
    "files": "https://github.com/gicmo/dot-files.git",
    "fish": "https://github.com/gicmo/dot-fish.git",
    "homeshick": "git://github.com/andsens/homeshick.git"
}


HS_SCRIPT = r"""#!/bin/bash
source ~/.homesick/repos/homeshick/homeshick.sh
homeshick -b -f link
"""


def clone(repo, dest):
    subprocess.run(["git", "clone", "--recursive", repo, dest],
                   check=True)


def link():
    with tempfile.TemporaryDirectory() as tmp:
        script = pathlib.Path(tmp, "script.sh")
        with open(script, "w") as f:
            f.write(HS_SCRIPT)
        script.chmod(0o770)
        subprocess.run(["/bin/bash", script], check=True)


def main():
    home = os.getenv("HOME")
    for repo, url in REPOS.items():
        print(f"{repo} -> {url}")
        dest = os.path.join(home, ".homesick", "repos", repo)
        if os.path.exists(dest):
            continue
        clone(url, dest)

    link()


if __name__ == "__main__":
    main()
