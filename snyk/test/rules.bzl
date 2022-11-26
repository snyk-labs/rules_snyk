load("//snyk:rules.bzl", _test = "snyk_python_test")

def snyk_python_test(
        name
    ):
    
    _test(
        name = name + "python_test",
    )
