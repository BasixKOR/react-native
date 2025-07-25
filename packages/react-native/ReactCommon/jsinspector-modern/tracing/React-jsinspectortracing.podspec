# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "..", "..", "..", "package.json")))
version = package['version']

source = { :git => 'https://github.com/facebook/react-native.git' }
if version == '1000.0.0'
  # This is an unpublished version, use the latest commit hash of the react-native repo, which we’re presumably in.
  source[:commit] = `git rev-parse HEAD`.strip if system("git rev-parse --git-dir > /dev/null 2>&1")
else
  source[:tag] = "v#{version}"
end

header_search_paths = []

if ENV['USE_FRAMEWORKS']
  header_search_paths << "\"$(PODS_TARGET_SRCROOT)/../..\""
end

header_dir = 'jsinspector-modern/tracing'
module_name = "jsinspector_moderntracing"

Pod::Spec.new do |s|
  s.name                   = "React-jsinspectortracing"
  s.version                = version
  s.summary                = "Experimental performance tooling for React Native DevTools"
  s.homepage               = "https://reactnative.dev/"
  s.license                = package["license"]
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = source
  s.source_files           = podspec_sources("*.{cpp,h}", "*.h")
  s.header_dir             = header_dir
  s.pod_target_xcconfig    = {
    "HEADER_SEARCH_PATHS" => header_search_paths.join(' '),
    "CLANG_CXX_LANGUAGE_STANDARD" => rct_cxx_language_standard(),
    "DEFINES_MODULE" => "YES"}

  if ENV['USE_FRAMEWORKS'] && ReactNativeCoreUtils.build_rncore_from_source()
    s.module_name = module_name
    s.header_mappings_dir = "../.."
  end

  s.dependency "React-oscompat"
  s.dependency "React-timing"

  add_rn_third_party_dependencies(s)
  add_rncore_dependency(s)
end
