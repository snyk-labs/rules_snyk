def snyk_gomod(
        name,
        target,
        snyk_project_name = "",
        snyk_organization_id = "",
        version = "bazel",
        json = False
    ):

    # print("gomod rules.bzl hello!")
    # print("gomod rules.bzl target: " + str(dir(target)))

    native.sh_binary(
        name = "snyk_test",
        args = ["test", "$(location @snyk_cli//file)", "$(location @go_sdk//:bin/go)", "$(location " + target + ")"],
        srcs = ["@rules_snyk//snyk/gomod:snyk_cli_gomod.sh"],
        data = [
            target,
            "@snyk_cli//file",
            "@go_sdk//:bin/go",
        ],
    )

    native.sh_binary(
        name = "snyk_monitor",
        args = ["monitor", "$(location @snyk_cli//file)", "$(location @go_sdk//:bin/go)", "$(location " + target + ")"],
        srcs = ["@rules_snyk//snyk/gomod:snyk_cli_gomod.sh"],
        data = [
            target,
            "@snyk_cli//file",
            "@go_sdk//:bin/go",
        ],
    )
