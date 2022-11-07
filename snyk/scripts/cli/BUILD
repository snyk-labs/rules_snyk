load("@rules_python//python:defs.bzl", "py_binary")
load("@rules_snyk//:requirements.bzl", "all_requirements")

py_binary(
    name = "main",
    srcs = ["main.py"],
    #deps = [
    #    requirement("pysnyk"),
    #],
    deps = all_requirements,
    visibility = ["//visibility:public"],
)

filegroup(
    name = "cli_main_zip",
    srcs = [":main"],
    visibility = ["//visibility:public"],
    output_group = "python_zip_file",
)
