load("@rules_python//python:defs.bzl", "py_binary")
#load("//third_party:py_requirements.bzl", "all_requirements")
load("@snyk_py_deps//:requirements.bzl", "requirement")

py_binary(
    name = "main",
    srcs = ["main.py"],
    deps = [
        requirement("pysnyk"),
        requirement("typer")
    ],
    python_version = "PY3",
    visibility = ["//visibility:public"],
)

filegroup(
    name = "main_zip",
    srcs = [":main"],
    visibility = ["//visibility:public"],
    output_group = "python_zip_file",
)
