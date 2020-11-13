# unit setup script
import sys
import os
import stat

# servers
server1_host    = "intel@ha.kanalov.net"
server1_sshport = "2424"
server2_host    = "intel@cr.kanalov.net"
server2_sshport = "2424"

# unit tunnel ports
start_port = int(sys.argv[1])
unit_port_ssh   = str(start_port)
unit_port_cp    = str(start_port+1)
unit_port_http  = str(start_port+2)
unit_port_socks = str(start_port+3)
unit_port_vpn   = str(start_port+4)

unit_prvkey  = "mobileproxy1_rsa"
unit_pubkey  = "mobileproxy1_rsa.pub"

user_home = "/home/pi"
project = "mobile-proxy"

#
# setup steps
#

bin_dir = user_home+"/"+project+"/bin"
unit_dir = user_home+"/"+project+"/unit"

if not os.path.exists(unit_dir):
  os.mkdir(unit_dir)

# template
print("Template: ssh-tunnels")
with open(bin_dir+"/ssh-tunnels.template.sh", "r") as f:
  template = f.read()

template = template.format(
  srv1_host = server1_host,
  srv1_port = server1_sshport,
  prv_key   = unit_prvkey,
  port1     = unit_port_ssh,
  port2     = unit_port_cp,
  port3     = unit_port_http,
  port4     = unit_port_socks,
  port5     = unit_port_vpn
)

filename = unit_dir+"/ssh-tunnels.sh"
with open(filename, "w") as f:
  f.write(template)

st = os.stat(filename)
os.chmod(filename, st.st_mode | stat.S_IEXEC)

# template
print("Template: startup")
with open(bin_dir+"/startup.template.sh", "r") as f:
  template = f.read()

filename = unit_dir+"/startup.sh"
with open(filename, "w") as f:
  f.write(template)

st = os.stat(filename)
os.chmod(filename, st.st_mode | stat.S_IEXEC)

# check
print("Patching: /etc/rc.local")
rclocal_patch = "sudo su -l pi -c \"exec /home/pi/mobile-proxy/unit/startup.sh\""
with open("/etc/rc.local", "r") as f:
  rclocal = f.read()
rclocal_ok = rclocal_patch in rclocal

# check
filenames = [
  "mobileproxy1_rsa",
  "mobileproxy1_rsa.pub",
  "ssh-tunnels.sh",
  "startup.sh"
]
ok = True
for filename in filenames:
  if not os.path.exists(unit_dir+"/"+filename):
    print("ERROR Unit directory is missing '"+filename+"'")
    ok = False

if ok:
  print("Unit configured!")
  if not rclocal_ok:
    print("Make sure '/etc/rc.local' contains")
    print("""  sudo su -l pi -c "exec /home/pi/mobile-proxy/unit/startup.sh" """)
  print("Don't forget to reboot")
