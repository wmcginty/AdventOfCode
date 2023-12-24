import sys
from z3 import *

D = open(sys.argv[1]).read().strip()
L = D.split('\n')

S = []
for line in L:
  pos, vel = line.split('@')
  x,y,z = pos.split(', ')
  vx,vy,vz = vel.split(', ')
  x,y,z = int(x),int(y),int(z)
  vx,vy,vz = int(vx),int(vy),int(vz)
  S.append((x,y,z,vx,vy,vz))


x,y,z,vx,vy,vz = Real('x'),Real('y'),Real('z'),Real('vx'),Real('vy'),Real('vz')
T = [Real(f'T{i}') for i in range(len(S))]
SOLVE = Solver()
for i in range(len(S)):
  SOLVE.add(x + T[i]*vx - S[i][0] - T[i]*S[i][3] == 0)
  SOLVE.add(y + T[i]*vy - S[i][1] - T[i]*S[i][4] == 0)
  SOLVE.add(z + T[i]*vz - S[i][2] - T[i]*S[i][5] == 0)
res = SOLVE.check()
M = SOLVE.model()
print(M.eval(x+y+z))
