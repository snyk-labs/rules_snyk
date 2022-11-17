# snyk-cli
This is a Python CLI utility script, used by the bazel rules, for testing and monitoring open source dependency graphs with Snyk's [Depgraph API](https://snyk.docs.apiary.io/#reference/test/dep-graph)

```
$ python3 cli/main.py --help
[usage]
  --depgraph-file
    	File to test/monitor
  --snyk-org-id
    	Snyk Organization ID to test/monitor against
  --package-source
      OSS source type, e.g. maven
  --json
    	Display full JSON response instead of the default output
      
[commands]
test
monitor
```
