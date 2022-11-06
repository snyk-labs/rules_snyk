import sys
import json

print(f"{sys.version=}")
print(f"{sys.argv=}")

depgraph_file = sys.argv[2]

f = open(depgraph_file) 
data = json.load(f)

print(json.dumps(data))

#print("Hello from cli!")
