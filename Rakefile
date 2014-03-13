require "bundler/gem_tasks"

task :default => :spec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'appraisal'
namespace :spec do
  appraisals = Appraisal::File.each

  desc 'bundle install to local directory'
  task :bundle do
    appraisals.each do |appraisal|
      env = { 'BUNDLE_GEMFILE' => appraisal.gemfile_path }
      Bundler.clean_system(env, 'bundle', 'install', '-j4', '--path', 'vendor/bundle')
    end
  end

  desc 'Run RSpec for each appraisal'
  task :all => appraisals.map(&:name)

  appraisals.each do |appraisal|
    desc "Run RSpec with appraisal #{appraisal.name}"
    task appraisal.name do
      env = { 'BUNDLE_GEMFILE' => appraisal.gemfile_path }
      Bundler.clean_system(env, 'bundle', 'exec', 'rake', 'spec')
    end
  end
end
