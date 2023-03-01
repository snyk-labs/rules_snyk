load(":aspect.bzl", "maven_deps_aspect")
load(":depgraph.bzl", _depgraph = "snyk_maven_depgraph")
load(
    "//snyk:rules.bzl", 
    _test = "snyk_depgraph_test_deps", 
    _monitor = "snyk_depgraph_monitor_deps",
    _print_deps = "snyk_depgraph_print_deps"
)

def snyk_maven(
        name,
        target,
        # snyk_project_name = "",
        snyk_organization_id = "",
        version = "bazel",
        json = False,
        #nocolor = False
    ):
    
    package_source = "maven"
    depgraph_rule_name = name + "_depgraph"
    
    _test(
        name = name + "_test",
        package_source = package_source,
        org_id = snyk_organization_id, 
        depgraph = depgraph_rule_name,
        json = json,
        #nocolor = nocolor,
    )

    _monitor(
        name = name + "_monitor",
        package_source = package_source,
        org_id = snyk_organization_id, 
        depgraph = depgraph_rule_name,
        json = json,
        # nocolor = nocolor,
    )

    _print_deps(
        name = name + "_print_deps",
        package_source = package_source,
        depgraph = depgraph_rule_name,
        json = json,
        # nocolor = nocolor,
    )

    _depgraph(
        name = depgraph_rule_name,
        target = target,
        package_source = package_source,
        # project_name = snyk_project_name,
        org_id = snyk_organization_id, 
        version = version,
    )
