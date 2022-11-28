load("@rules_python//python:pip.bzl", "pip_parse")

def rules_snyk_deps(): 

    pip_parse(
        name = "snyk_py_deps",
        requirements_lock = "@rules_snyk//third_party:requirements.txt",
        visibility = ["//visibility:public"]
    )
