from requests import get

ip = get('https://api.ipify.org').text
print('Public IP address\n{}'.format(ip))

open('output/ips.txt','a').close()

f = open('output/ips.txt','r+')
lines = f.read().splitlines()
f.close()

last_line = lines[-1] if len(lines) > 0 else ""
if last_line != ip:
  lines.append(ip)
  f = open('output/ips.txt', 'a')
  f.write(ip+'\n')
  f.close()

with open('output/ips.txt','w+') as f:
  f.write("\n".join(lines[-5:]))
  f.write("\n")

print('\nIP history')
for line in reversed(lines):
  print(line)
