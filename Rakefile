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
  sh 'rm -rf .yardoc/ doc/ *.gem'
end

desc 'Build SNAPSHOT gem'
task :snapshot do
  v = Time.new.strftime '%Y%m%d%H%M%S'
  f = 'lib/obfusk/data/version.rb'
  sh "sed -ri~ 's!(SNAPSHOT)!\\1.#{v}!' #{f}"
  sh 'gem build obfusk-data.gemspec'
end

desc 'Undo SNAPSHOT gem'
task 'snapshot-undo' do
  sh 'git checkout -- lib/obfusk/data/version.rb'
end
