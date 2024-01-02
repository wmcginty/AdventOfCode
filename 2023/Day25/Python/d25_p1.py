import sys
import re
from collections import defaultdict
import networkx as nx

input = open(sys.argv[1]).read().strip()
lines = input.split('\n')

connections = defaultdict(set)
for line in lines:
    l,r = line.split(':')
    for y in r.split():
        connections[l].add(y)
        connections[y].add(l)

graph = nx.DiGraph()

for origin, vertices in connections.items():
    for vertex in vertices:
        graph.add_edge(origin, vertex, capacity=1.0)
        graph.add_edge(vertex, origin, capacity=1.0)

for x in [list(connections.keys())[0]]:
    for y in connections.keys():
        if x != y:
            cut_value, (left, right) = nx.minimum_cut(graph, x, y)
            if cut_value == 3:
                print(len(left) * len(right))
                break
