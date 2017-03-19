$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_having_string_id/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_having_string_id"
  s.version     = ActsAsHavingStringId::VERSION
  s.authors     = ["Magnus Hult"]
  s.email       = ["magnus@magnushult.se"]
  s.homepage    = "http://github.com/hult/acts_as_having_string_id"
  s.summary     = "Makes a model accept and expose a seemingly random string id"
  s.description = "Makes a model accept and expose a seemingly random string id"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0", ">= 5.0.0.1"
  s.add_dependency "base62", "~> 1.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "minitest"
end
