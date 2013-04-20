# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'simple_zabbix/version'

Gem::Specification.new do |s|
  s.name        = 'simple_zabbix'
  s.version     = SimpleZabbix::VERSION
  s.authors     = ['Shawn Veader']
  s.email       = %w(shawn@veader.org)
  s.homepage    = 'https://github.com/veader/simple_zabbix'
  s.summary     = %q{Very simple Zabbix API client.}
  s.description = %q{Simple implementation of the Zabbix API in ruby.}
  s.licenses    = %w(MIT)

  s.add_dependency('json')

  s.rubyforge_project = 'simple_zabbix'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)
end