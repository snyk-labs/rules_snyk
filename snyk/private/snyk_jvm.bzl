def _snyk_scan_impl(ctx):
    print('_snyk_scan_impl | name=' + str(ctx.attr.name))
    print("_snyk_scan_impl | target=" + str(ctx.attr.target.label))


snyk_scan_maven = rule(
    implementation = _snyk_scan_impl,
    attrs = {
        #'target' : attr.label(aspects = [snyk_aspect]),
        'target' : attr.label(aspects = []),
    },
)

def snyk_maven(name, target, out = None, **kwargs):
    snyk_scan_maven(
        name = target.replace(":","") + "." + name + "_test",
        target = target,
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
