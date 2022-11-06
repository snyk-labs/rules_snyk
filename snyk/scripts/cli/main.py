import sys
import json
import os
import snyk

SNYK_TOKEN = os.environ['SNYK_TOKEN']

print(f"{sys.version=}")
print(f"{sys.argv=}")

print(f"{SNYK_TOKEN=}")

client = snyk.SnykClient(SNYK_TOKEN)

print(f"{client=}")

depgraph_file = sys.argv[2]

f = open(depgraph_file) 
data = json.load(f)

print(json.dumps(data))

#print("Hello from cli!")
