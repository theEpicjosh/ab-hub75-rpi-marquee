pgrep -x "/home/pi/venvs/blinka_venv/bin/python" >/dev/null
killall "/home/pi/venvs/blinka_venv/bin/python" || exit 0
