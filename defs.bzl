""" Entrypoint for all Snyk rules """

load("//snyk:maven.bzl", _snyk_maven = "snyk_maven")
#load("//snyk:gomod.bzl", _snyk_gomod = "snyk_gomod")
#load("//snyk:pip.bzl", _snyk_pip = "snyk_pip")

snyk_maven = _snyk_maven
# snyk_gomod = _snyk_gomod
# snyk_pip = _snyk_pip
