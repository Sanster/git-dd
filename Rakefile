task :build do
  `rm -rf ./pkg`
  `mkdir pkg`
  `gem build ./git-dd.gemspec`
  `mv git-dd-*.gem pkg`
  puts "Built " + Dir.glob("pkg/*.gem")[0]
end

task :publish do
  puts `rake build`
  puts `gem push #{Dir.glob("pkg/*.gem")[0]}`
end