load("@rules_python//python:defs.bzl", "py_binary")

py_binary(
    name = "main",
    srcs = ["main.py"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "cli_main_zip",
    srcs = [":main"],
    output_group = "python_zip_file",
)
