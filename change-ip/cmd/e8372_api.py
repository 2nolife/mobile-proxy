# API client URL
#   https://pypi.org/project/huawei-modem-api-client/
#   https://github.com/pablo/huawei-modem-python-api-client

import huaweisms.api.user
import huaweisms.api.wlan
import huaweisms.api.device
import huaweisms.api.dialup
import json

def login(host):
  ctx = huaweisms.api.user.quick_login("admin", "admin2", modem_host=host)
  return ctx

# {'type': 'response', 'response': 'OK'}
def assertResponseOK(r):
  text = str(r).replace("\'", "\"")
  doc = json.loads(text)
  ok = doc["response"]
  assert ok == "OK", "invalid response\n"+r

def reboot(ctx):
  print("Rebooting", end = " ")
  r = huaweisms.api.device.reboot(ctx)
  assertResponseOK(r)
  print("OK")

def disconnect(ctx):
  print("Disconnecting", end = " ")
  r = huaweisms.api.dialup.disconnect_mobile(ctx)
  assertResponseOK(r)
  print("OK")

def connect(ctx):
  print("Connecting", end = " ")
  r = huaweisms.api.dialup.connect_mobile(ctx)
  assertResponseOK(r)
  print("OK")

def isConnected(ctx):
  status = huaweisms.api.dialup.get_mobile_status(ctx)
  print(status)
