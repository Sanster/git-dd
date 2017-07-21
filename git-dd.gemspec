Gem::Specification.new do |s|
  s.name        = 'git-dd'
  s.version     = '0.3.0'
  s.date        = '2017-07-21'
  s.summary     = 'git command to delete branches interactively'
  s.authors     = ["Weiqing Chu"]
  s.email       = 'cwq1913@gmail.com'
  s.homepage    = 'https://github.com/Sanster/git-dd'
  s.license     = 'MIT'

  s.add_runtime_dependency 'tty-prompt', '0.12.0'
  s.add_runtime_dependency 'rainbow'

  s.add_development_dependency 'rspec', '~>3.6'
  s.add_development_dependency 'rake'

  s.files       = ["lib/git-dd.rb", "lib/const.rb"]
  s.executables << 'git-dd'
end