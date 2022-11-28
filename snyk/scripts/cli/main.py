import sys
import json
import os
import typer
import snyk
import requests
import logging
from uuid import UUID
from itertools import groupby

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

#print("Hello from CLI!")
#print(f"{sys.argv=}")

class textColor:
    red = '\033[0;31m'
    red_bold = '\033[1;31m'
    green = '\033[0;32m'
    green_bold = '\033[1;32m'
    blue = '\033[0;34m'
    cyan = '\033[0;36m'
    cyan_bold = '\033[1;36m'
    light_grey = '\033[0;37m'
    light_grey_bold = '\033[1;37m'
    dark_grey = '\033[0;90m'
    light_red = '\033[0;91m'
    light_red_bold = '\033[1;91m'
    light_green = '\033[0;92m'
    yellow = '\033[0;93m'
    yellow_bold = '\033[1;93m'
    light_blue = '\033[0;94m'
    light_cyan = '\033[0;96m'

class textStyle:
    bold = '\033[1m',
    reset = '\033[0m',
    underline = '\033[04m'

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

    #print(json.dumps(g['depgraph_json']))

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
    ),
    json: bool = typer.Option(
        False,
        "--json",
        help="return the JSON output from the test API results"
    ),
):

    snyk_client = snyk.SnykClient(snyk_token)

    #dep_graph: DepGraph = g['dep_graph']
    typer.echo("Testing via Snyk API ...", file=sys.stderr)
    response: requests.Response = test_depgraph(snyk_client, g['depgraph_json'], snyk_org_id)

    json_response = response.json()

    #for issue_data in json_response['issuesData']:
    #   print(f"{issue_data=}")
    #  print(
    #     f"{issue_data['title']}"
    #     f"{issue_data['severity']}"
    #    )
    
    if json:
        print(json.dumps(json_response, indent=4))
        sys.exit(0)

    # create a list of dictionaries with the key of the package name
    # to iterate later easily for grouped display

    def _groupby_function(k):
        return k['pkgName']

    issue_packages = sorted(json_response['issues'], key=_groupby_function) 
    logger.debug(f"{issue_packages=}")
  
    for package_name, issues in groupby(issue_packages, _groupby_function):
      issues_list = list(issues)
      logger.debug(f"{issues_list=}")

      issues_count = len(issues_list)

      print(f"\n{textColor.light_grey_bold}{package_name} ({issues_count}){textColor.light_grey}")

    #for issue in json_response['issues']:
      for issue in issues_list:
        # get the issue data for the issue id
        issues_data = json_response['issuesData']

        issue_id = issue['issueId']
        issue_link = f"{textColor.light_grey}[https://security.snyk.io/vuln/{issue_id}]"
        issue_package_name = issue['pkgName']
        issue_package_version = issue['pkgVersion']
        issue_coordinates = f"{issue_package_name}@{issue_package_version}"
        issue_title = issues_data[issue_id]['title']
        issue_severity = issues_data[issue_id]['severity']
        issue_severity_color = textColor.light_grey
        issue_severity_color_bold = textColor.light_grey_bold

        # set text colors
        if issue_severity == "low":
            issue_severity_color = textColor.cyan
            issue_severity_color_bold = textColor.cyan_bold
        if issue_severity == "medium":
            issue_severity_color = textColor.yellow
            issue_severity_color_bold = textColor.yellow_bold
        if issue_severity == "high":
            issue_severity_color = textColor.light_red
            issue_severity_color_bold = textColor.light_red_bold
        if issue_severity == "critical":
            issue_severity_color = textColor.red
            issue_severity_color_bold = textColor.red_bold
        issue_title = f"{issue_severity_color_bold}{issue_title}"

        issue_fixed_ins = f"({issue_severity_color_bold}Fixed in: N/A{textColor.light_grey})"
        if issues_data[issue_id]['fixedIn']:
            issue_fixed_ins = f"({textColor.green_bold}Fixed in: {','.join(issues_data[issue_id]['fixedIn'])}{textColor.light_grey})"
        issue_cve = ""
        if issues_data[issue_id]['identifiers']['CVE']:
            issue_cve = "- " + ','.join(issues_data[issue_id]['identifiers']['CVE']) + " "

        print(
            f"  {issue_title} "
            f"[{issue_severity}] "
            f"{issue_cve}"
            f"{issue_link} in "
            f"{issue_package_version} "
            f"{issue_fixed_ins}" 
        )

    if str(json_response['ok']) == "False":
        typer.echo("\n" + textColor.light_red + "security issues found, exiting with code 1 ...\n", file=sys.stderr)
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
    typer.echo("Monitoring via Snyk API ...", file=sys.stderr)
    response: requests.Response = monitor_depgraph(snyk_client, g['depgraph_json'], snyk_org_id)

    json_response = response.json()
    print(json.dumps(json_response, indent=4))

    if str(json_response['ok']) == "False":
        typer.echo("\n" + textColor.light_red + "security issues found, exiting with code 1 ...\n", file=sys.stderr)
        sys.exit(1)

# Utility functions
def test_depgraph(snyk_client, depgraph: str, org_id: UUID) -> requests.Response:
        return snyk_client.post(f"{DEPGRAPH_BASE_TEST_URL}{org_id}", body=depgraph)

def monitor_depgraph(snyk_client, depgraph: str, org_id: UUID) -> requests.Response:
        return snyk_client.post(f"{DEPGRAPH_BASE_MONITOR_URL}{org_id}", body=depgraph)


if __name__ == "__main__":
    logger.debug("version: ", sys.version)
    app()
