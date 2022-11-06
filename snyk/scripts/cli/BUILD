#load("@rules_python//python:defs.bzl", "py_binary")
load("@py_deps//:requirements.bzl", "requirement")

py_binary(
    name = "main",
    srcs = ["main.py"],
    deps = [
        requirement("pysnyk"),
    ],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "cli_main_zip",
    srcs = [":main"],
    visibility = ["//visibility:public"],
    output_group = "python_zip_file",
)
