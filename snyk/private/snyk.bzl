def _snyk_aspect_impl(target, ctx):
    print("_snyk_aspect_impl | target=" + str(target.label))

    for dep in ctx.rule.attr.deps:

        print('_snyk_aspect_impl | dep=' + str(dep.label))

        for f in dep.files.to_list():
            print('_snyk_aspect_impl | dep.file=' + str(f.path))


    #return struct(
    #    files = outputs
    #)
    return []

snyk_aspect = aspect(
    implementation = _snyk_aspect_impl,
    attr_aspects = ['deps'],
)
