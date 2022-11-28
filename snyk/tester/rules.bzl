load("//snyk:rules.bzl", _tester = "snyk_python_tester_rule")

def snyk_python_tester(
        name,
    ):
    
    _tester(
        name = name + "_python_tester",
    )

