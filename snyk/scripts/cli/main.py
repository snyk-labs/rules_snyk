import sys
import json
import os
import typer
import snyk
import requests
import logging
from uuid import UUID

#set up logging
logger = logging.getLogger(__name__)
FORMAT = "[%(filename)s:%(lineno)4s - %(funcName)s ] %(message)s"
logging.basicConfig(format=FORMAT)
logger.setLevel(logging.WARN)

app = typer.Typer(add_completion=False)

# globals
g={}
DEPGRAPH_BASE_TEST_URL = "/test/dep-graph?org="
DEPGRAPH_BASE_MONITOR_URL = "/monitor/dep-graph?org="


print("Hello from CLI!")

@app.callback(no_args_is_help=True)
def main(ctx: typer.Context,
    package_source: str = typer.Option(
        "maven",
        case_sensitive=False,
        envvar="PACKAGE_SOURCE",
        help="Name of the package source, e.g. maven"
    ),
    depgraph_file: str = typer.Option(
        None,
        envvar="SNYK_DEPGRAPH_FILE",
        help="Path to file with JSON of the Snyk Depgraph"
    ),
    debug: bool = typer.Option(
        False,
        help="Set log level to debug"
    ),
):

    if debug:
        typer.echo("*** DEBUG MODE ENABLED ***", file=sys.stderr)
        logger.setLevel(logging.DEBUG)

    f = open(depgraph_file)
    g['depgraph_json'] = json.load(f)

@app.command()
def test(
    summarize: bool = typer.Option(
        False, 
        "--summarize", 
        help="Display summarized stats of the snyk test, rather than the complete JSON output"
    ),
    snyk_token: str = typer.Option(
        None,
        envvar="SNYK_TOKEN",
        help="Please specify your Snyk token"
    )
    ,
    snyk_org_id: str = typer.Option(
        None,
        envvar="SNYK_ORG_ID",
        help="Please specify the Snyk ORG ID to run commands against"
    )
):

    snyk_client = snyk.SnykClient(snyk_token)

    #dep_graph: DepGraph = g['dep_graph']
    typer.echo("Testing depGraph via Snyk API ...", file=sys.stderr)
    response: requests.Response = test_depgraph(snyk_client, g['depgraph_json'], snyk_org_id)
    
    json_response = response.json()
    print(json.dumps(json_response, indent=4))

    if str(json_response['ok']) == "False":
        typer.echo("exiting with code 1", file=sys.stderr)
        sys.exit(1)

@app.command()
def monitor(
    summarize: bool = typer.Option(
        False, 
        "--summarize", 
        help="Display summarized stats of the snyk test, rather than the complete JSON output"
    ),
    snyk_token: str = typer.Option(
        None,
        envvar="SNYK_TOKEN",
        help="Please specify your Snyk token"
    )
    ,
    snyk_org_id: str = typer.Option(
        None,
        envvar="SNYK_ORG_ID",
        help="Please specify the Snyk ORG ID to run commands against"
    )
):

    snyk_client = snyk.SnykClient(snyk_token)

    #dep_graph: DepGraph = g['dep_graph']
    typer.echo("Monitoring depGraph via Snyk API ...", file=sys.stderr)
    response: requests.Response = monitor_depgraph(snyk_client, g['depgraph_json'], snyk_org_id)
    
    json_response = response.json()
    print(json.dumps(json_response, indent=4))

    if str(json_response['ok']) == "False":
        typer.echo("exiting with code 1", file=sys.stderr)
        sys.exit(1)

# Utility functions
def test_depgraph(snyk_client, depgraph: str, org_id: UUID) -> requests.Response:
        return snyk_client.post(f"{DEPGRAPH_BASE_TEST_URL}{org_id}", body=depgraph)

def monitor_depgraph(snyk_client, depgraph: str, org_id: UUID) -> requests.Response:
        return snyk_client.post(f"{DEPGRAPH_BASE_MONITOR_URL}{org_id}", body=depgraph)
