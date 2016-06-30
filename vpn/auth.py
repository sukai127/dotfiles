import os,sys
import onetimepass as otp
cwd = sys.path[0]
f = open(cwd + "/authentication.code.private", 'r')
my_secret = f.read().replace('\n','')
f.close()

print str(otp.get_totp(my_secret))
