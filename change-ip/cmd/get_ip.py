from requests import get

ip = get('https://api.ipify.org').text
print('My public IP address is {}'.format(ip))

f=open('output/ips.txt','w+')
lines = f.read().splitlines()
last_line = lines[-1] if len(lines) > 0 else ""
if last_line != ip+"\n":
  f.write(ip+'\n')
  lines.append(ip)
f.close()

print('\nIP history')
for line in reversed(lines):
  print(line)
