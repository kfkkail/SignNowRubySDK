# -*- encoding: utf-8 -*-
require File.expand_path("../lib/signnow/version", __FILE__)

Gem::Specification.new do |s|
  s.name = 'signnow-sdk'
  s.version = SN::VERSION
  s.platform = Gem::Platform::RUBY
  s.date = '2013-11-14'
  s.summary = 'SignNow SDK'
  s.description = 'An SDK for SignNow customers to integrate eSignatures'
  s.authors = 'SignNow'
  s.email = 'lhnguyen@barracuda.com'
  s.files = `git ls-files`.split("\n")
  s.require_path = 'lib'
  s.homepage = 'http://signnow.com'

  s.add_runtime_dependency 'rest-client', '~> 2.0.0'

  s.add_development_dependency 'cucumber', '~> 1.3.8'
  s.add_development_dependency 'rspec', '~>2.14.1'
  s.add_development_dependency 'rspec-expectations'
end
