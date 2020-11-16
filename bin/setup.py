# unit setup script
# python3 setup.py {user} {port}

import sys
import os
import stat

if len(sys.argv) != 3:
  print("Use: setup.py {user} {port}")
  sys.exit(1)

# servers
server1_host    = "ha.kanalov.net"
server1_sshport = "2426"
server2_host    = "cr.kanalov.net"
server2_sshport = "2426"

# unit tunnel ports
remote_user     = sys.argv[1]
start_port      = int(sys.argv[2])
unit_port_ssh   = str(start_port)
unit_port_cp    = str(start_port+1)
unit_port_http  = str(start_port+2)
unit_port_socks = str(start_port+3)
unit_port_vpn   = str(start_port+4)

user_home = "/home/pi"
project = "mobile-proxy"

#
# setup steps
#

other_dir = user_home+"/"+project+"/other"
unit_dir = user_home+"/"+project+"/unit"

if not os.path.exists(unit_dir):
  os.mkdir(unit_dir)

def sh_template(name):
  print("Template: "+name)
  with open(other_dir + "/"+name+".template.sh", "r") as f:
    template = f.read()

  template = template.format(
    srv_user=remote_user,
    srv1_host=server1_host,
    srv1_port=server1_sshport,
    port1=unit_port_ssh,
    port2=unit_port_cp,
    port3=unit_port_http,
    port4=unit_port_socks,
    port5=unit_port_vpn
  )

  filename = unit_dir + "/"+name+".sh"
  with open(filename, "w") as f:
    f.write(template)

  st = os.stat(filename)
  os.chmod(filename, st.st_mode | stat.S_IEXEC)

sh_template("ssh-tunnels")
sh_template("startup")
sh_template("change-key")
sh_template("change-pwd")

# check
rclocal_patch = "sudo su -l pi -c \"exec /home/pi/mobile-proxy/unit/startup.sh\""
with open("/etc/rc.local", "r") as f:
  rclocal = f.read()
rclocal_ok = rclocal_patch in rclocal

ok = True
for filename in [ "ssh-tunnels.sh", "startup.sh" ]:
  if not os.path.exists(unit_dir+"/"+filename):
    print("ERROR Unit directory is missing '"+filename+"'")
    ok = False

if ok:
  print("Unit configured!")
  if not rclocal_ok:
    print("Make sure '/etc/rc.local' contains")
    print("""  sudo su -l pi -c "exec /home/pi/mobile-proxy/unit/startup.sh" """)
  print("Don't forget to reboot")
