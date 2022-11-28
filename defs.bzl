""" Entrypoint for Snyk macros """

load("//snyk/maven:rules.bzl", _snyk_maven = "snyk_maven")
#load("//snyk/gomod:rules.bzl", _snyk_gomod = "snyk_gomod")
#load("//snyk/pip:rules.bzl", _snyk_pip = "snyk_pip")
load("//snyk/tester:rules.bzl", _snyk_python_tester = "snyk_python_tester")
load("//toolchains/python:python_interpreter.bzl", _py_download = "py_download")
load("//toolchains/python:py_binary.bzl", _py_binary = "py_binary")

snyk_maven = _snyk_maven
# snyk_gomod = _snyk_gomod
# snyk_pip = _snyk_pip
snyk_python_tester = _snyk_python_tester

py_download = _py_download
py_binary = _py_binary
