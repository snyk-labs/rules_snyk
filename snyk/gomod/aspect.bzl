load("@io_bazel_rules_go//go/private:providers.bzl", "GoLibrary")
GoModDeps = provider(
    fields = {
        "all_gomod_dep_coordinates": "Array of Go module coordinates for all dependencies",
        "each_gomod_dep_coordinates": "Each of coordinates"
    },
)

# taken from rules_jvm_external
_ASPECT_ATTRS = [
    "deps",
    "exports",
    "runtime_deps",
]
_GOMOD_PREFIX = "go_version="
_STOP_TAGS = ["gomod:compile-only", "no-gomod"]

def _read_coordinates(tags):
    coordinates = []
    for stop_tag in _STOP_TAGS:
        if stop_tag in tags:
            return None

    for tag in tags:
        if tag.startswith(_GOMOD_PREFIX):
            coordinates.append(tag[len(_GOMOD_PREFIX):])

    if len(coordinates) > 1:
        fail("Zero or one set of coordinates should be defined: %s" % coordinates)

    if len(coordinates) == 1:
        #print("coordinates: " + str(coordinates))
        return coordinates[0]

    return None

def _gomod_deps_aspect_impl(target, ctx):
    #print("provider info: " + str(target[\@io_bazel_rules_go\/\/go\/private\:providers\.bzl\%GoLibrary]))
    print("provider info: " + str(target[GoLibrary]))
    #print("buildinfo info: " + str(target[BuildInfo]))
    if not GoLibrary in target:
        return [GoModDeps(all_gomod_dep_coordinates = depset(), each_gomod_dep_coordinates = {})]

    gomod_coordinates = []
    each_gomod_coordinates = []

    all_deps = []
    for attr in _ASPECT_ATTRS:
        all_deps.extend(getattr(ctx.rule.attr, attr, []))


    print("tags: " + str(ctx.rule.attr.tags))
    coords = str(target[GoLibrary].importpath) + "@" + str(_read_coordinates(ctx.rule.attr.tags))

    if not coords:
        pass
        # TODO: decide if this is worth it or too noisy
        # print("[!] No gomod coordinates found for dep: %s" % (target.label))
    else:
        gomod_coordinates.extend([coords])
        #each_gomod_coordinates.extend([struct(child="", parent=target)])

    # this is the recursive bit of apsects, each "sub" dep will already have gomod_coordinates
    # so we keep "bubbling them up" to the final target
    for dep in ctx.rule.attr.deps:
        print("provider info: " + str(dep[GoLibrary]))
        gomod_coordinates.extend(dep[GoModDeps].all_gomod_dep_coordinates.to_list())

        #print("gomod_coordinates num elements: " + str(len(gomod_coordinates)))
        each_gomod_coordinates.append({'parent': str(coords), 'child': str(dep[GoLibrary])})

        if len(dep[GoModDeps].each_gomod_dep_coordinates) > 0:
            for child_parent_combination in dep[GoModDeps].each_gomod_dep_coordinates:
                if child_parent_combination not in each_gomod_coordinates:
                    #print("child_parent_combination:" + str(child_parent_combination))
                    #print("tags: " + str(ctx.rule.attr.tags))
                    #print("gomod_coordinates: " + str(gomod_coordinates))
                    each_gomod_coordinates.append(child_parent_combination)


    return [GoModDeps(
        all_gomod_dep_coordinates = depset(gomod_coordinates),
        each_gomod_dep_coordinates = each_gomod_coordinates
    )]

gomod_deps_aspect = aspect(
    implementation = _gomod_deps_aspect_impl,
    attr_aspects = _ASPECT_ATTRS,
)