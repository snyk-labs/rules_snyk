load("@rules_python//python:defs.bzl", "py_binary")

py_binary(
    name = "main",
    srcs = ["main.py"],
    python_version = "PY3",
    #python_interpreter = ["@py_darwin_x86_64//:toolchain", "@py_darwin_arm64//:toolchain", "@py_linux_x86_64//:toolchain"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "main_zip",
    srcs = [":main"],
    visibility = ["//visibility:public"],
    output_group = "python_zip_file",
)
