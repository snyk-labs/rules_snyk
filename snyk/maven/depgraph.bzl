# Copyright 2022 Marqeta. All rights reserved.
# Use of this source code is governed by an Apache 2.0 style license
# that can be found in the LICENSE file

load(":aspect.bzl", "MavenDeps", "maven_deps_aspect")

_DEPGRAPH_SCHEMA_VERSION = "1.2.0"

def _snyk_maven_depgraph_impl(ctx):
    project_name = ctx.attr.project_name
    if project_name == "":
        project_name = "//%s:%s" % (ctx.attr.target.label.package, ctx.attr.target.label.name)
    project_version = ctx.attr.version
    project_id = "%s@%s" % (project_name, project_version)
    dep_graph = struct(
        schemaVersion = _DEPGRAPH_SCHEMA_VERSION,
        pkgManager = struct(
            name = "maven"
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
    coordinates = ctx.attr.target[MavenDeps].all_maven_dep_coordinates
    added_coordinates = []
    for coordinate in sorted(coordinates.to_list()):
        parts = coordinate.split(":")
        name = "%s:%s" % (parts[0], parts[1])
        # the version should always be the last part after splitting on ':'
        version = parts[-1]
        maven_id = "%s@%s" % (name, version)

        # we should track if we've added the maven coordintae before, and if we have, then continue the loop so we don't get duplicate pkg ids
        if maven_id in added_coordinates:
            continue

        dep_graph.pkgs.append(struct(
            id = maven_id,
            info = struct(
                name = name,
                version = version
            )
        ))

        dep_graph.graph.nodes[0].deps.append(struct(
            nodeId = maven_id
        ))

        dep_graph.graph.nodes.append(struct(
            nodeId = maven_id,
            pkgId = maven_id,
            deps = []
        ))

        added_coordinates.append(maven_id)


    dep_graph_request = struct(
        depGraph = dep_graph
    )

    outputfile = ctx.actions.declare_file(ctx.attr.name + "_depgraph.json")
    ctx.actions.write(outputfile, dep_graph_request.to_json())
    return [DefaultInfo(files = depset([outputfile]))]

snyk_maven_depgraph = rule(
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
            providers = [JavaInfo],
            aspects = [maven_deps_aspect],
        ),
        "version": attr.string(
            doc = "Version to submit to Snyk. Default: dev",
            default = "dev"
        ),
    },
    implementation = _snyk_maven_depgraph_impl,
)
