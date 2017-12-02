require 'puppetlabs_spec_helper/rake_tasks'
require 'parallel_tests'
require 'parallel_tests/cli'

#PuppetLint.configuration.send('disable_2sp_soft_tabs')

desc "Parallel spec tests"
task :parallel_spec do
  Rake::Task[:spec_prep].invoke
  ParallelTests::CLI.new.run('--type test -t rspec spec/hosts spec/classes spec/defines spec/unit'.split)
  Rake::Task[:spec_clean].invoke
end

desc "Basic microphone"
task :microphone do
  puts "Check 1, 2, 3"
end

desc "Basic call and response"
#task :call, :response, :repeat, :needs => :microphone do |t, args|
task :call, [:response, :repeat] => [:microphone] do |t, args| #declaring tasks with dependencies
#task :call, :response, :repeat do |t, args|
  response = args[:response] || 'Task'
  repeat    = (args[:repeat] || 1).to_i
  #args.with_defaults(:response => 'Task', :repeat => 1) # alternative way to set defaults

#task :call, :response do |t, args|
#  response = args[:response] || 'Task'

#task :call do
#  response = 'Task'
    puts "When I say Rake, you say '#{response}'!" # alternative way #{args[:response]}'!

    repeat.times do
    #args[:repeat].to_i.times do # alternative to the above
      sleep 1
      puts "Rake!"
      sleep 1
      puts "#{response}!" # another way #{args[:response]}'!
    end
end
