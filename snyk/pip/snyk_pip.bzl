load("//snyk/private:snyk.bzl", "snyk_aspect")

def _snyk_scan_pip_impl(ctx):
    # collection and processing of transitives for pip goes here
    print('_snyk_scan_pip_impl | handling of pip transitives here')
    print('_snyk_scan_impl | name=' + str(ctx.attr.name))
    print("_snyk_scan_impl | oss_type=" + str(ctx.attr.oss_type))
    print("_snyk_scan_impl | target=" + str(ctx.attr.target.label))

snyk_scan_pip = rule(
    implementation = _snyk_scan_pip_impl,
    attrs = {
        'target' : attr.label(aspects = [snyk_aspect]),
        'deps' : attr.label_list(aspects = [snyk_aspect]),
        'oss_type' : attr.string(default = 'pip'),
    },
)

def snyk_pip(name, target, out = None, **kwargs):
    snyk_scan_pip(
        name = target.replace(":","") + "." + name + "_test",
        target = target,
        **kwargs
    )

    snyk_scan_pip(
        name = target.replace(":","") + "." + name + "_monitor",
        target = target,
        **kwargs
    )

    snyk_scan_pip(
        name = target.replace(":","") + "." + name + "_depgraph",
        target = target,
        **kwargs
    )

def snyk_pip_coordinates(pip_target):
    print("snyk_pip_coordinates | hello")
