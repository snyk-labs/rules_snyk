load("//snyk/private:snyk.bzl", "snyk_aspect")

def _snyk_scan_impl(ctx):
    print('_snyk_scan_impl | name=' + str(ctx.attr.name))
    print("_snyk_scan_impl | target=" + str(ctx.attr.target.label))

snyk_scan_maven = rule(
    implementation = _snyk_scan_impl,
    attrs = {
        'target' : attr.label(aspects = [snyk_aspect]),
        'deps' : attr.label_list(aspects = [snyk_aspect]),
        'oss_type' : attr.string(default = ''),
    },
)

def snyk_maven(name, target, out = None, **kwargs):
    snyk_scan_maven(
        name = target.replace(":","") + "." + name + "_test",
        target = target,
        oss_type = "maven",
        **kwargs
    )

    snyk_scan_maven(
        name = target.replace(":","") + "." + name + "_monitor",
        target = target,
        oss_type = "maven",
        **kwargs
    )

    snyk_scan_maven(
        name = target.replace(":","") + "." + name + "_depgraph",
        target = target,
        oss_type = "maven",
        **kwargs
    )
