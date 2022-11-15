# Copyright 2022 Marqeta. All rights reserved.
# Use of this source code is governed by an Apache 2.0 style license
# that can be found in the LICENSE file

def _snyk_depgraph_test_deps_impl(ctx):
  depgraph_file = ctx.attr.depgraph.files.to_list()[0]
  args = [
      "--depgraph-file",
      depgraph_file.short_path,
      "--package-source",
      ctx.attr.package_source,
      "test",
  ]
  if ctx.attr.org_id:
      args.append("--snyk-org-id %s" %( ctx.attr.org_id ))
  #if ctx.attr.json:
  #    args.append("-json")
  #if ctx.attr.nocolor:
  #    args.append("-nocolor")

  ctx.actions.write(
      output = ctx.outputs.executable,
      content = "\n".join([
          "#!/bin/bash",
          "exec python3 %s %s" % (ctx.executable._snyk_cli_zip.short_path, " ".join(args))
      ]),
      is_executable = True,
   )

  runfiles = ctx.runfiles(files = [ctx.executable._snyk_cli_zip, depgraph_file])
  return [DefaultInfo(
      runfiles = runfiles
  )]

def _snyk_depgraph_monitor_deps_impl(ctx):
  depgraph_file = ctx.attr.depgraph.files.to_list()[0]
  args = [
      "--depgraph-file",
      depgraph_file.short_path,
      "--package-source",
      ctx.attr.package_source,
      "test",
  ]
  if ctx.attr.org_id:
      args.append("--snyk-org-id %s" %( ctx.attr.org_id ))
  #if ctx.attr.json:
  #    args.append("-json")
  #if ctx.attr.nocolor:
  #    args.append("-nocolor")

  ctx.actions.write(
      output = ctx.outputs.executable,
      content = "\n".join([
          "#!/bin/bash",
          "exec python3 %s %s" % (ctx.executable._snyk_cli.short_path, " ".join(args))
      ]),
      is_executable = True,
  )
  runfiles = ctx.runfiles(files = [ctx.executable._snyk_cli, depgraph_file])
  return [DefaultInfo(runfiles = runfiles)]

snyk_depgraph_test_deps = rule(
  attrs = {
        "_snyk_cli": attr.label(
            default = "//snyk/scripts/cli:main",
            cfg = "host",
            executable = True,
        ),
        "_snyk_cli_zip": attr.label(
            default = "//snyk/scripts/cli:main_zip", 
            cfg = "host", 
            executable = True
        ),
        "package_source": attr.string(
            doc = "The package source type",
            #default = "maven",
            #mandatory = True
        ),
        "depgraph": attr.label(
            mandatory = True
        ),
        "org_id": attr.string(
            doc = "The Snyk Org ID to use",
        ),
        "json": attr.bool(
            doc = "Dump full JSON output",
            default = False
        ),
        "nocolor": attr.bool(
            doc = "Don't display colors",
            default = False
        )
    },
    implementation = _snyk_depgraph_test_deps_impl,
    executable = True
)

snyk_depgraph_monitor_deps = rule(
  attrs = {
        "_snyk_cli": attr.label(
            default = "//snyk/scripts/cli:main",
            cfg = "host",
            executable = True,
        ),
        "_snyk_cli_zip": attr.label(
            default = "//snyk/scripts/cli:main_zip", 
            cfg = "host", 
            executable = True
        ),
        "package_source": attr.string(
            doc = "The package source type", 
            #default = "maven",
            #mandatory = True
        ),
        "depgraph": attr.label(
            mandatory = True
        ),
        "org_id": attr.string(
            doc = "The Snyk Org ID to use",
            default = "",
        ),
        "json": attr.bool(
            doc = "Dump full JSON output",
            default = False
        ),
        "nocolor": attr.bool(
            doc = "Don't display colors",
            default = False
        )
    },
    implementation = _snyk_depgraph_monitor_deps_impl,
    executable = True
)
