import sys
import json
import os
import snyk
import requests

SNYK_TOKEN = os.environ['SNYK_TOKEN']

print(f"{sys.version=}")
print(f"{sys.argv=}")

print(f"{SNYK_TOKEN=}")

snyk_client = snyk.SnykClient(SNYK_TOKEN)

print(f"{snyk_client=}")

depgraph_file = sys.argv[2]

f = open(depgraph_file)
data = json.load(f)

print(json.dumps(data))

#print("Hello from cli!")

def test_depgraph(self, depgraph: str, org_id: UUID) -> requests.Response:
        return snyk_client.post(f"{self.DEPGRAPH_BASE_TEST_URL}{org_id}", body=depgraph)

print("Testing depGraph via Snyk API ...", file=sys.stderr)
response: requests.Response = snyk_client.test_depgraph(dep_graph.graph(), snyk_org_id)

json_response = response.json()
print(json.dumps(json_response, indent=4))

if str(json_response['ok']) == "False":
    typer.echo("exiting with code 1", file=sys.stderr)
    sys.exit(1)