import e3372_api as api
import sys
import time

action = sys.argv[1]
gw     = sys.argv[2]
print('Action', action, 'on', gw)

url = "http://"+gw
s = api.login(url)

if action == "reboot":
  api.reboot(url, s)
elif action == "reconnect":
  api.disconnect(url, s)
  time.sleep(2)
  api.connect(url, s)
elif action == "status":
  api.isConnected(url, s)

if action == "reboot" or action == "reconnect":
  f = open('output/ips.txt', 'a')
  f.write("\n")
  f.close()
