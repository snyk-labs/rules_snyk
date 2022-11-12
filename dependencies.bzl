#load("@rules_python//python:pip.bzl", "pip_parse")
#load("@py_deps//:requirements.bzl", "install_deps")
load("//:py_requirements.bzl", install_vendored_deps = "install_deps")

def rules_snyk_deps(): 
    # Install vendored from py_requirements.bzl (for downstream workspaces)
    install_vendored_deps()
