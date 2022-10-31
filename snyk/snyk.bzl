def _snyk_aspect_impl(target, ctx):

    data = struct(
            originating_rule = ctx.label.name,
        )

    print("_snyk_aspect_impl | target.label.name=" + str(target.label.name))
    #print('_snyk_aspect_impl | oss_type=' + str(ctx.attr.oss_type))

    # This is critically important to propogate outputs back up the shadow graph!
    transitive_jsons = depset([ctx.label.name])

    num_deps = len(ctx.rule.attr.deps)
    print("_snyk_aspect_impl | num_deps=" + str(num_deps))

    count = 1

    for dep in ctx.rule.attr.deps:

        print('_snyk_aspect_impl | (' + str(count) + ')dep=' + str(dep.label))

        #if str(target.label).startswith("@maven//"):
        #    print("_snyk_aspect_impl | get coordinates for maven")

        info = dep.info
        transitive_jsons = depset(transitive=[info.transitive_deps, transitive_jsons])

        #print('_snyk_aspect_impl | info.transitive_deps=' + str(dep.info.transitive_deps))
        #print('_snyk_aspect_impl | transitive_jsons=' + str(transitive_jsons))

        if (count == num_deps):
            print("_snyk_aspect_impl | reached direct dep, output file here")

        count += 1

    json_file = ctx.actions.declare_file('%s.direct_deps.json' % (target.label.name))
    outputs = depset([json_file])
    print("_snyk_aspect_impl | json_file=" + str(json_file.path))

    ctx.actions.write(json_file, str(transitive_jsons))

    return struct(
        info = struct(
            transitive_deps = transitive_jsons,
            files = outputs,
        ),
    )

snyk_aspect = aspect(
    implementation = _snyk_aspect_impl,
    attr_aspects = ['deps'],
)
