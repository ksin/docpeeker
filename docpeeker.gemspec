# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docpeeker/version'

Gem::Specification.new do |spec|
  spec.name          = "docpeeker"
  spec.version       = Docpeeker::VERSION
  spec.authors       = ["Connor Harwood", "Kevin Lee", "Simon Zhang", "Tuan Duong"]
  spec.email         = ["harwood.connor@gmail.com"]
  spec.summary       = %q{Quickly find a method in Roby-docs!}
  spec.description   = %q{Accepts a string and searches Ruby-docs for methods matching that string. It will open tabs in your browser for each match it finds.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables << 'docpeeker'
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.8.7'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'open-uri'
end
