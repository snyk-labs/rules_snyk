load(":aspect.bzl", "gomod_deps_aspect")
load(":depgraph.bzl", _depgraph = "snyk_gomod_depgraph")
load("//snyk:rules.bzl", _monitor = "snyk_depgraph_monitor_deps", _test = "snyk_depgraph_test_deps")

def snyk_gomod(
        name,
        target,
        snyk_project_name = "",
        snyk_organization_id = "",
        version = "bazel",
        json = False,
        #nocolor = False
    ):

    package_source = "gomod"
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

    _depgraph(
        name = depgraph_rule_name,
        target = target,
        package_source = package_source,
        # project_name = snyk_project_name,
        org_id = snyk_organization_id,
        version = version,
    )

def _snyk_scan_gomod_impl(ctx):
    # collection and processing of transitives for gomod goes here
    print('_snyk_scan_gomod_impl | handling of gomod transitives here')
    print('_snyk_scan_impl | name=' + str(ctx.attr.name))
    print("_snyk_scan_impl | oss_type=" + str(ctx.attr.oss_type))
    print("_snyk_scan_impl | target=" + str(ctx.attr.target.label))


def snyk_gomod_coordinates(gomod_target):
    print("snyk_gomod_coordinates | hello")