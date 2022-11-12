load("@rules_python//python:defs.bzl", "py_binary")
load("//third_party:py_requirements.bzl", "all_requirements")

py_binary(
    name = "main",
    srcs = ["main.py"],
    deps = all_requirements,
    visibility = ["//visibility:public"],
)

filegroup(
    name = "main_zip",
    srcs = [":main"],
    visibility = ["//visibility:public"],
    output_group = "python_zip_file",
)
