load("//snyk/private:snyk.bzl", "snyk_aspect")

def _snyk_scan_gomod_impl(ctx):
    # collection and processing of transitives for gomod goes here
    print('_snyk_scan_gomod_impl | handling of gomod transitives here')
    print('_snyk_scan_impl | name=' + str(ctx.attr.name))
    print("_snyk_scan_impl | oss_type=" + str(ctx.attr.oss_type))
    print("_snyk_scan_impl | target=" + str(ctx.attr.target.label))

snyk_scan_gomod = rule(
    implementation = _snyk_scan_gomod_impl,
    attrs = {
        'target' : attr.label(aspects = [snyk_aspect]),
        'deps' : attr.label_list(aspects = [snyk_aspect]),
        'oss_type' : attr.string(default = 'gomod'),
    },
)

def snyk_gomod(name, target, out = None, **kwargs):
    snyk_scan_gomod(
        name = target.replace(":","") + "." + name + "_test",
        target = target,
        **kwargs
    )

    snyk_scan_gomod(
        name = target.replace(":","") + "." + name + "_monitor",
        target = target,
        **kwargs
    )

    snyk_scan_gomod(
        name = target.replace(":","") + "." + name + "_depgraph",
        target = target,
        **kwargs
    )

def snyk_gomod_coordinates(gomod_target):
    print("snyk_gomod_coordinates | hello")
