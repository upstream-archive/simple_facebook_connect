# encoding: utf-8

require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "simple_facebook_connect"
    gem.summary = %Q{This plugin adds the ability to sign in/sign up using facebook connect to your Rails application.}
    gem.email = "alex@upstream-berlin.com"
    gem.homepage = "http://github.com/upstream/simple_facebook_connect"
    gem.authors = ["Alexander Lang", 'Frank Prößdorf']
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

desc 'Default: run specs.'
task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end
