import sys
from z3 import *

input = open(sys.argv[1]).read().strip()
lines = input.split('\n')

stones = []
for line in lines:
  pos, vel = line.split('@')
  x,y,z = pos.split(', ')
  vx,vy,vz = vel.split(', ')
  x,y,z = int(x),int(y),int(z)
  vx,vy,vz = int(vx),int(vy),int(vz)
  stones.append((x,y,z,vx,vy,vz))

x,y,z,vx,vy,vz = Real('x'),Real('y'),Real('z'),Real('vx'),Real('vy'),Real('vz')
t = [Real(f't{i}') for i in range(len(stones))]
SOLVE = Solver()
for i in range(len(stones)):
  SOLVE.add(x + t[i]*vx - stones[i][0] - t[i]*stones[i][3] == 0)
  SOLVE.add(y + t[i]*vy - stones[i][1] - t[i]*stones[i][4] == 0)
  SOLVE.add(z + t[i]*vz - stones[i][2] - t[i]*stones[i][5] == 0)
res = SOLVE.check()
M = SOLVE.model()
print(M.eval(x+y+z))
