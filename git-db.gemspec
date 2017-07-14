Gem::Specification.new do |s|
  s.name        = 'git-dd'
  s.version     = '0.1.0'
  s.date        = '2017-07-14'
  s.summary     = 'git command to delete branches interactively'
  s.authors     = ["Weiqing Chu"]
  s.email       = 'cwq1913@gmail.com'
  s.files       = ["lib/git-db.rb"]
  s.homepage    = 'http://rubygems.org/gems/hola'
  s.license     = 'MIT'

  s.add_runtime_dependency 'tty-prompt', '0.12.0'
  s.executables << 'git-dd'
end