# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)
require "git-dd/version"

Gem::Specification.new do |s|
  s.name        = 'git-dd'
  s.version     = GitDD::VERSION
  s.date        = '2017-07-22'
  s.summary     = 'git command to delete branches interactively'
  s.authors     = ["Weiqing Chu"]
  s.email       = 'cwq1913@gmail.com'
  s.homepage    = 'https://github.com/Sanster/git-dd'
  s.license     = 'MIT'

  s.add_runtime_dependency 'tty-prompt', '0.12.0'
  s.add_runtime_dependency 'rainbow', '~> 0'
  s.add_runtime_dependency 'slop', '~> 4.5.0'

  s.add_development_dependency 'rspec', '~>3.6'
  s.add_development_dependency 'rake', '~> 0'

  s.files       = ["lib/git-dd.rb", "lib/const.rb"]
  s.executables << 'git-dd'
end