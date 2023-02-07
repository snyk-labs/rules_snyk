load(":aspect.bzl", "GoModDeps", "gomod_deps_aspect")

_DEPGRAPH_SCHEMA_VERSION = "1.2.0"

def _snyk_gomod_depgraph_impl(ctx):
    project_name = ctx.attr.project_name
    if project_name == "":
        project_name = "//%s:%s" % (ctx.attr.target.label.package, ctx.attr.target.label.name)
    project_version = ctx.attr.version
    project_id = "%s@%s" % (project_name, project_version)
    dep_graph = struct(
        schemaVersion = _DEPGRAPH_SCHEMA_VERSION,
        pkgManager = struct(
            name = "gomodules"
        ),
        pkgs = [
            struct(
                id = project_id,
                info = struct(
                    name = project_name,
                    version = project_version
                )
            )
        ],
        graph = struct(
            rootNodeId = "root-node",
            nodes = [
                struct(
                    nodeId = "root-node",
                    pkgId = project_id,
                    deps = [],
                )
            ]
        )
    )

    coordinates = ctx.attr.target[GoModDeps].all_gomod_dep_coordinates
    # each_coordinates = ctx.attr.target[GoModDeps].each_gomod_dep_coordinates
    # print("ctx.attr.target[GoModDeps]: " + str(ctx.attr.target[GoModDeps]))
    # print("each coordinates: " + str(each_coordinates))
    added_coordinates = []
    for coordinate in sorted(coordinates.to_list()):
        # print("coordinate: " + str(coordinate))
        parts = coordinate.split("@")
        name = parts[0]
        version = parts[1]
        # the version should always be the last part after splitting on ':'
        # version = parts[-1]
        # gomod_id = "%s@%s" % (name, version)
        gomod_id = coordinate

        # we should track if we've added the coordinate before, and if we have, then continue the loop so we don't get duplicate pkg ids
        if gomod_id in added_coordinates:
            continue

        dep_graph.pkgs.append(struct(
            id = gomod_id,
            info = struct(
                name = name,
                version = version
            )
        ))

        dep_graph.graph.nodes[0].deps.append(struct(
            nodeId = gomod_id
        ))

        dep_graph.graph.nodes.append(struct(
            nodeId = gomod_id,
            pkgId = gomod_id,
            deps = []
        ))

        added_coordinates.append(gomod_id)


    dep_graph_request = struct(
        depGraph = dep_graph
    )

    outputfile = ctx.actions.declare_file(ctx.attr.name + ".json")
    ctx.actions.write(outputfile, dep_graph_request.to_json())
    return [DefaultInfo(files = depset([outputfile]))]

snyk_gomod_depgraph = rule(
    attrs = {
        "package_source": attr.string(
            doc = "The package source type. If not provided, will be 'maven'",
            default = "",
        ),
        "project_name": attr.string(
            doc = "The project name for Snyk. If not provided, will be <target_name>",
            default = "",
        ),
        "org_id": attr.string(
            doc = "The Snyk Org ID to use",
            default = "",
        ),
        "target": attr.label(
            doc = "The Java Library target to scan",
            mandatory = True,
            #providers = [GoPkgInfo],
            aspects = [gomod_deps_aspect],
        ),
        "version": attr.string(
            doc = "Version to submit to Snyk. Default: dev",
            default = "dev"
        ),
    },
    implementation = _snyk_gomod_depgraph_impl,
)