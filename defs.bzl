""" Entrypoint for Snyk macros """

load("//snyk/maven:rules.bzl", _snyk_maven = "snyk_maven")
load("//snyk/gomod:rules.bzl", _snyk_gomod = "snyk_gomod")
#load("//snyk/pip:rules.bzl", _snyk_pip = "snyk_pip")

load("//snyk/tester:rules.bzl", _snyk_python_tester = "snyk_python_tester")

snyk_maven = _snyk_maven
snyk_gomod = _snyk_gomod
# snyk_pip = _snyk_pip

snyk_python_tester = _snyk_python_tester
