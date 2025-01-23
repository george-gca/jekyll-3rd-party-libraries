# frozen_string_literal: true

require_relative "lib/jekyll-3rd-party-libraries/version"

Gem::Specification.new do |s|
  s.name        = "jekyll-3rd-party-libraries"
  s.summary     = "Force updating cached files and resources in a Jekyll site."
  s.description = "Force updating cached files and resources in a Jekyll site by adding a hash."
  s.version     = Jekyll::ThirdPartyLibraries::VERSION
  s.authors     = ["George Corrêa de Araújo"]
  s.homepage    = "https://github.com/george-gca/jekyll-3rd-party-libraries"
  s.licenses    = ["MIT"]

  # https://guides.rubygems.org/specification-reference/#metadata
  s.metadata      = {
    "source_code_uri" => "https://github.com/george-gca/jekyll-3rd-party-libraries",
    "bug_tracker_uri" => "https://github.com/george-gca/jekyll-3rd-party-libraries/issues",
    "changelog_uri"   => "https://github.com/george-gca/jekyll-3rd-party-libraries/releases",
    "homepage_uri"    => s.homepage,
  }

  all_files     = `git ls-files -z`.split("\x0")
  s.files       = all_files.grep(%r!^(lib)/!)

  s.required_ruby_version = ">= 2.3.0"

  s.add_dependency "jekyll", ">= 3.6", "< 5.0"
  s.add_dependency "css_parser"
  s.add_dependency "nokogiri"
end
