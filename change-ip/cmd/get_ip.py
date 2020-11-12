from requests import get

ip = get('https://api.ipify.org').text
print('Public IP address\n{}'.format(ip))

open('output/ips.txt','a').close()

ips_txt = 'output/ips.txt'
f = open(ips_txt, 'r+')
lines = f.read().splitlines()
f.close()

last_line = lines[-1] if len(lines) > 0 else ""
if last_line != ip:
  lines.append(ip)

print('\nIP history')
for line in reversed(lines):
  print(line)

lines = list(filter(lambda line: line != "restarted", lines))
with open(ips_txt, 'w+') as f:
  f.write("\n".join(lines[-5:])+"\n")
