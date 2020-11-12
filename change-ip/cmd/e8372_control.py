import e8372_api as api
import sys
import time

action = sys.argv[1]
gw     = sys.argv[2]
print('Action', action, 'on', gw)

ctx = api.login(gw)

if action == "reboot":
  api.reboot(ctx)
elif action == "reconnect":
  api.disconnect(ctx)
  time.sleep(2)
  api.connect(ctx)
elif action == "status":
  api.isConnected(ctx)

if action == "reboot" or action == "reconnect":
  with open('output/ips.txt', 'a') as f:
    f.write("restarted\n")
