# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SnykTestResults = provider(
    fields = {
        "issues": "Snyk test issue data"
    }
)

def _snyk_aspect_impl(target, ctx):
    no_source_files = (
        not hasattr(ctx.rule.attr, 'hdrs') and
        not hasattr(ctx.rule.attr, 'srcs') and
        not hasattr(ctx.rule.attr, 'src')
    )

    if (
        # Ignore targets in external repos
        ctx.label.workspace_name or
        # Ignore targets without source files
        no_source_files
    ):
        return  []

    if (str(target).startswith('<target //')):
        package = str(target).split(' ')[1].split(':')[0]
        print(package + ':' + ctx.rule.attr.name)

    return []

snyk_aspect = aspect(
    implementation = _snyk_aspect_impl,
    attr_aspects = ['deps'],
)

def _snyk_scan_impl(ctx):
    print('hi from _snyk_scan_impl')
    for dep in ctx.attr.deps:
        print(dep)

def _snyk_monitor_impl(ctx):
    print('hi from _snyk_monitor_impl')
    for dep in ctx.attr.deps:
        print(dep)

def _snyk_depgraph_impl(ctx):
    print('hi from _snyk_depgraph_impl')
    for dep in ctx.attr.deps:
        print(dep)

snyk_scan = rule(
    implementation = _snyk_scan_impl,
    attrs = {
        'deps' : attr.label_list(aspects = [snyk_aspect]),
        'extension' : attr.string(default = '*'),
    },
)

snyk_monitor = rule(
    implementation = _snyk_monitor_impl,
    attrs = {
        'deps' : attr.label_list(aspects = [snyk_aspect]),
        'extension' : attr.string(default = '*'),
    },
)

snyk_depgraph = rule(
    implementation = _snyk_depgraph_impl,
    attrs = {
        'deps' : attr.label_list(aspects = [snyk_aspect]),
        'extension' : attr.string(default = '*'),
    },
)

