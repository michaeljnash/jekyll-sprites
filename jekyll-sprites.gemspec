# frozen_string_literal: true

require_relative "lib/jekyll-sprites/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-sprites"
  spec.version = Jekyll::Sprites::VERSION
  spec.authors = ["Michael Nash"]
  spec.email = ["mjnash194@gmail.com"]

  spec.summary = <<-SUMMARY
    Provides a liquid tag to include svgs which are then converted to sprites
    and bundled into spritesheets based on their usage throughout site pages.
    Each page only loads the sprites required, and no more.
  SUMMARY
  spec.homepage = "https://github.com/michaeljnash/jekyll-sprites"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_dependency "jekyll", ">= 3.0", "< 5.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
