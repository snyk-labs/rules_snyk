"""Repository rules for rules_py_simple"""

_OS_MAP = {
    "darwin": "@platforms//os:osx",
    "linux": "@platforms//os:linux",
    "windows": "@platforms//os:windows",
}

_ARCH_MAP = {
    "x86_64": "@platforms//cpu:x86_64",
    "arm64": "@platforms//cpu:arm64",
}

def _py_download(ctx):
    """
    Downloads and builds a Python distribution.
    Args:
        ctx: Repository context.
    """
    ctx.report_progress("downloading python")
    ctx.download_and_extract(
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        stripPrefix = "python",
    )

    ctx.report_progress("generating build file")
    os_constraint = _OS_MAP[ctx.attr.os]
    arch_constraint = _ARCH_MAP[ctx.attr.arch]

    constraints = [os_constraint, arch_constraint]

    # So Starlark doesn't throw an indentation error when this gets injected.
    constraints_str = ",\n        ".join(['"%s"' % c for c in constraints])

    # Inject our string substitutions into the BUILD file template, and drop said BUILD file in the WORKSPACE root of the repository.
    substitutions = {
        "{constraints}": constraints_str,
        "{interpreter_path}": ctx.attr._interpreter_path,
    }

    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
        substitutions = substitutions,
    )

    return None

py_download = repository_rule(
    implementation = _py_download,
    attrs = {
        "urls": attr.string_list(
            mandatory = True,
            doc = "String list of mirror URLs where the Python distribution can be downloaded.",
        ),
        "sha256": attr.string(
            mandatory = True,
            doc = "Expected SHA-256 sum of the archive.",
        ),
        "os": attr.string(
            mandatory = True,
            values = ["darwin", "linux", "windows"],
            doc = "Host operating system.",
        ),
        "arch": attr.string(
            mandatory = True,
            values = ["x86_64", "arm64"],
            doc = "Host architecture.",
        ),
        "_interpreter_path": attr.string(
            default = "bin/python3",
            doc = "Path you'd expect the python interpreter binary to live.",
        ),
        "_build_tpl": attr.label(
            default = "//toolchains/python:BUILD.dist.bazel.tpl",
            doc = "Label denoting the BUILD file template that get's installed in the repo.",
        ),
    },
)
