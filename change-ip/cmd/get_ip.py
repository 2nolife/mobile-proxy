# modem public IP and history of 5 last IPs
# previous IPs saved into a file

from requests import get

# public IP
ip = get('https://api.ipify.org').text
print('Public IP address\n{}'.format(ip))

# store IPs in file
open('output/ips.txt','a').close()

ips_txt = 'output/ips.txt'
with open(ips_txt, 'r+') as f:
  lines = f.readlines()

last_line = lines[-1] if len(lines) > 0 else ""
if last_line != ip:
  lines.append(ip)

print('\nIP history')
for line in reversed(lines):
  print(line)

lines = list(filter(lambda line: line != "restarted", lines))
with open(ips_txt, 'w+') as f:
  f.write("\n".join(lines[-5:])+"\n")
