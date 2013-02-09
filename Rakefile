desc 'Run specs'
task :spec do
  sh 'rspec -cfd'
end

desc 'Generate docs'
task :docs do
  sh 'yardoc | cat'
end

desc 'List undocumented objects'
task :undocumented do
  sh 'yard stats --list-undoc'
end

desc 'Cleanup'
task :clean do
  sh 'rm -rf .yardoc/ doc/'
end
