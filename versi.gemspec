require File.expand_path("../version.rb", __FILE__)

Gem::Specification.new do |gem|
  gem.name             = "versi"
  gem.version          = VersiVersion::VERSION
  gem.summary          = "Git Version Automation"
  gem.description      = "Release Version Automation for GIT"
  gem.authors          = ["Airton Sobral", "Guilherme Cavalcanti"]
  gem.email            = ["airtonsobral@gmail.com", "guiocavalcanti@gmail.com"]
  gem.require_paths    = %w[lib vendor]
  gem.executables      = %w[versi]
  gem.files            = Dir["README.md", "LICENSE", "lib/**/*", "vendor/*"]
  gem.test_files       = gem.files.grep(%r{^spec/})
  gem.extra_rdoc_files = %w[README.md]
  gem.homepage         = "http://rubygemgem.org/gems/versi"
  gem.license          = "MIT"

  gem.required_ruby_version = ">= 2.2"
  gem.add_dependency "clamp",      "1.1.1"
  gem.add_dependency "interactor", "3.1.0"
  gem.add_dependency "semantic",   "1.4.1"
end
