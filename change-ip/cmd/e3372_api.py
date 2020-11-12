import requests
import xml.dom.minidom as MD

def login(baseurl):
  s = requests.Session()
  r = s.get(baseurl + "/api/webserver/token")

  doc = MD.parseString(r.text)
  token = doc.getElementsByTagName('token')[0].firstChild.toxml()
  # print("token "+token)

  s.headers.update({
    '__RequestVerificationToken': token
  })

  return s

def assertResponseOK(r):
  doc = MD.parseString(r.text)
  ok = doc.getElementsByTagName('response')[0].firstChild.toxml()
  assert ok == "OK", "invalid response\n"+r.text

def reboot(baseurl, session):
  print("Rebooting", end = " ")
  r = session.post(baseurl + "/api/device/control", data="<request><Control>1</Control></request>")
  assertResponseOK(r)
  print("OK")

def disconnect(baseurl, session):
  print("Disconnecting", end = " ")
  r = session.post(baseurl + "/api/dialup/mobile-dataswitch", data="<request><dataswitch>0</dataswitch></request>")
  assertResponseOK(r)
  print("OK")

def connect(baseurl, session):
  print("Connecting", end = " ")
  r = session.post(baseurl + "/api/dialup/mobile-dataswitch", data="<request><dataswitch>1</dataswitch></request>")
  assertResponseOK(r)
  print("OK")

def isConnected(baseurl, session):
  r = session.get(baseurl + "/api/dialup/mobile-dataswitch")
  doc = MD.parseString(r.text)
  ok = doc.getElementsByTagName('dataswitch')[0].firstChild.toxml()
  if ok == "1":
    print("Connected")
  elif ok == "0":
    print("Disconnected")
  else:
    print("invalid response")
    print(r.text)

