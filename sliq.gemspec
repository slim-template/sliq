# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/lib/sliq/version'
require 'date'

Gem::Specification.new do |s|
  s.name              = 'sliq'
  s.version           = Sliq::VERSION
  s.date              = Date.today.to_s
  s.authors           = ['Daniel Mendler']
  s.email             = ['mail@daniel-mendler.de']
  s.summary           = 'Slim and Liquid working together.'
  s.description       = 'Process template with Slim and Liquid afterwards.'
  s.homepage          = 'http://slim-lang.com/'
  s.rubyforge_project = s.name
  s.license           = 'MIT'

  s.files             = `git ls-files`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths     = %w(lib)

  s.add_runtime_dependency('slim', ['~> 3.0'])
  s.add_runtime_dependency('liquid', ['~> 3.0'])
end
