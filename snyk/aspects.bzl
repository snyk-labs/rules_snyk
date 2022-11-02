load("//snyk/maven:rules.bzl", _read_coordinates = "read_coordinates", "MavenDeps")

# taken from rules_jvm_external
_ASPECT_ATTRS = [
    "deps",
    "exports",
    "runtime_deps",
]

def _maven_deps_aspect_impl(target, ctx):
    if not JavaInfo in target:
        return [MavenDeps(all_maven_dep_coordinates = depset())]

    maven_coordinates = []

    all_deps = []
    for attr in _ASPECT_ATTRS:
        all_deps.extend(getattr(ctx.rule.attr, attr, []))

    coords = _read_coordinates(ctx.rule.attr.tags)
    if not coords:
        pass
        # TODO: decide if this is worth it or too noisy
        # print("[!] No maven coordinates found for dep: %s" % (target.label))
    else:
        maven_coordinates.extend([coords])

    # this is the recursive bit of apsects, each "sub" dep will already have maven_coordinates
    # so we keep "bubbling them up" to the final target
    for dep in ctx.rule.attr.deps:
        maven_coordinates.extend(dep[MavenDeps].all_maven_dep_coordinates.to_list())

    return [MavenDeps(
        all_maven_dep_coordinates = depset(maven_coordinates),
    )]

maven_deps_aspect = aspect(
    implementation = _maven_deps_aspect_impl,
    attr_aspects = _ASPECT_ATTRS,
)
