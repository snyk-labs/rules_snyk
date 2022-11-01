load("//snyk/private:snyk.bzl", "snyk_aspect")

def _snyk_scan_maven_impl(ctx):
    print('_snyk_scan_maven_impl | generating flat deps output file')
    #print("_snyk_scan_maven_impl | oss_type=" + str(ctx.attr.oss_type))

    accumulated_deps = []
    #outputs = depset()

    flat_deps_snyk_depgraph = ctx.actions.declare_file(ctx.attr.target.label.name + ".snyk_depgraph.json")

    for dep in ctx.attr.deps:
        info = dep.info
        accumulated_deps.append(info.transitive_deps)
        #outputs = depset(transitive=[outputs, info.transitive_deps])

    #print("_snyk_scan_maven_impl | accumulated_deps=" + str(accumulated_deps))

    flat_deps_file = ctx.actions.declare_file('%s.json' % (ctx.attr.target.label.name))
    print('_snyk_scan_maven_impl | flat_deps_file=' + flat_deps_file.path)

    ctx.actions.write(flat_deps_file, str(accumulated_deps))

    print('_snyk_scan_maven_impl | flat_deps_snyk_depgraph=' + flat_deps_snyk_depgraph.path)

    print("_snyk_scan_maven_impl | python_script=" + str(dir(ctx.executable.python_script)))

    ctx.actions.run(
        executable = ctx.executable.python_script,
        arguments = [" > " + str(flat_deps_snyk_depgraph.path)],
        outputs = [flat_deps_snyk_depgraph],
    )

    return [DefaultInfo(
        files = depset([flat_deps_file]),
        executable = flat_deps_snyk_depgraph
    )]

snyk_scan_maven = rule(
    implementation = _snyk_scan_maven_impl,
    attrs = {
        'target' : attr.label(aspects = [snyk_aspect]),
        'deps' : attr.label_list(aspects = [snyk_aspect]),
        'oss_type' : attr.string(default = 'maven'),
        'python_script': attr.label(
            executable = True,
            cfg = "exec",
            allow_files = True,
            default = "@rules_snyk//snyk/private/bazel2snyk:main",
        ),
    },
)

def snyk_maven(name, target, out = None, **kwargs):
    snyk_scan_maven(
        name = target.replace(":","") + "." + name + "_test",
        target = target,
        deps = [target],
        python_script = "@rules_snyk//snyk/private/bazel2snyk:main",
        **kwargs
    )

    snyk_scan_maven(
        name = target.replace(":","") + "." + name + "_monitor",
        target = target,
        **kwargs
    )

    snyk_scan_maven(
        name = target.replace(":","") + "." + name + "_depgraph",
        target = target,
        **kwargs
    )
