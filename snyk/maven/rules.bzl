load("//snyk:aspects.bzl", "maven_deps_aspect")
load("//snyk:depgraph.bzl", _monitor = "snyk_depgraph_monitor_deps", _test = "snyk_depgraph_test_deps")
load("//snyk/maven:depgraph.bzl", _depgraph = "snyk_maven_depgraph")

MavenDeps = provider(
    fields = {
        "all_maven_dep_coordinates": "Array of Maven coordinates for all dependencies",
    },
)

# taken from rules_jvm_external
_MAVEN_PREFIX = "maven_coordinates="
_STOP_TAGS = ["maven:compile-only", "no-maven"]

def read_coordinates(tags):
    coordinates = []
    for stop_tag in _STOP_TAGS:
        if stop_tag in tags:
            return None

    for tag in tags:
        if tag.startswith(_MAVEN_PREFIX):
            coordinates.append(tag[len(_MAVEN_PREFIX):])

    if len(coordinates) > 1:
        fail("Zero or one set of coordinates should be defined: %s" % coordinates)

    if len(coordinates) == 1:
        return coordinates[0]

    return None

#def _snyk_scan_maven_impl(ctx):
#    print('_snyk_scan_maven_impl | generating flat deps output file')
#    #print("_snyk_scan_maven_impl | oss_type=" + str(ctx.attr.oss_type))

#    accumulated_deps = []
#    #outputs = depset()

#    flat_deps_snyk_depgraph = ctx.actions.declare_file(ctx.attr.target.label.name + ".snyk_depgraph.json")

#    for dep in ctx.attr.deps:
#        info = dep.info
#        accumulated_deps.append(info.transitive_deps)
#        #outputs = depset(transitive=[outputs, info.transitive_deps])

#    #print("_snyk_scan_maven_impl | accumulated_deps=" + str(accumulated_deps))

#    flat_deps_file = ctx.actions.declare_file('%s.json' % (ctx.attr.target.label.name))
#    print('_snyk_scan_maven_impl | flat_deps_file=' + flat_deps_file.path)

#    ctx.actions.write(flat_deps_file, str(accumulated_deps))

#    print('_snyk_scan_maven_impl | flat_deps_snyk_depgraph=' + flat_deps_snyk_depgraph.path)

#    print("_snyk_scan_maven_impl | python_script=" + str(dir(ctx.executable.python_script)))

#    ctx.actions.run(
#        executable = ctx.executable.python_script,
#        arguments = [" > " + str(flat_deps_snyk_depgraph.path)],
#        outputs = [flat_deps_snyk_depgraph],
#    )

#    return [DefaultInfo(
#        files = depset([flat_deps_file]),
#        executable = flat_deps_snyk_depgraph
#    )]

#snyk_scan_maven = rule(
#    implementation = _snyk_scan_maven_impl,
#    attrs = {
#        'target' : attr.label(aspects = [snyk_aspect]),
#        'deps' : attr.label_list(aspects = [snyk_aspect]),
#        'oss_type' : attr.string(default = 'maven'),
#        'python_script': attr.label(
#            executable = True,
#            cfg = "exec",
#            allow_files = True,
#            default = "@rules_snyk//snyk/private/bazel2snyk:main",
#        ),
#    },
#)

def snyk_maven(
        name,
        target,
        snyk_project_name = "",
        snyk_organization_id = "",
        version = "dev",
        json = False,
        nocolor = False):
    
    depgraph_rule_name = target.replace(":","") + "." + name + "_depgraph"
    
    _test(
        name = target.replace(":","") + "." + name + "_test",
        org_id = snyk_organization_id, 
        depgraph = depgraph_rule_name,
        json = json,
        nocolor = nocolor,
    )

    _monitor(
        name = target.replace(":","") + "." + name + "_monitor",
        org_id = snyk_organization_id, 
        depgraph = depgraph_rule_name,
        json = json,
        nocolor = nocolor,
    )

    _depgraph(
        name = depgraph_rule_name,
        target = target,
        project_name = snyk_project_name,
        org_id = snyk_organization_id, 
        version = version,
    )
