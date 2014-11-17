$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "navigator_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "navigator_rails"
  s.version     = NavigatorRails::VERSION
  s.authors     = ["mathias Kaufmann"]
  s.email       = ["me@stei.gr"]
  s.homepage    = "https://github.com/steigr/navigator_rails"
  s.summary     = "Navigation for Ruby on Rails done right (kind of)"
  s.description = "Describe your navigationbar longaside actions in your controllers and not somewhere else!"
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency 'rails', '~> 4'
  s.add_runtime_dependency 'sourcify', '~> 0.5'
  s.add_runtime_dependency 'binding_of_caller', '~> 0.7'
end
