load("//third_party:py_requirements.bzl", install_vendored_deps = "install_deps")

def rules_snyk_deps(): 
    # Install vendored from py_requirements.bzl (for downstream workspaces)
    install_vendored_deps()
