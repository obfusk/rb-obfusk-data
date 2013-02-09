desc 'Run specs'
task :spec do
  sh 'rspec'
end

desc 'Generate docs'
task :docs do
  sh 'yardoc | cat'
end

desc 'List undocumented objects'
task :undocumented do
  sh 'yard stats --list-undoc'
end
