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

def _snyk_scan_impl(ctx):
    print('_snyk_scan_impl | oss_type=' + str(ctx.attr.oss_type))
    for dep in ctx.attr.deps:
        print("_snyk_scan_impl | dep.label=" + str(dep.label))

snyk_scan = rule(
    implementation = _snyk_scan_impl,
    attrs = {
        'deps' : attr.label_list(aspects = [snyk_aspect]),
        'oss_type': attr.string(mandatory=True, values=['maven']),
        'extension' : attr.string(default = '*'),
    },
)
