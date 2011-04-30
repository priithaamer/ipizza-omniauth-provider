$:.push File.expand_path("../lib", __FILE__)
require 'ipizza-omniauth-provider/version'

Gem::Specification.new do |s|
  s.name        = 'ipizza-omniauth-provider'
  s.version     = Ipizza::Omniauth::Provider::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Priit Haamer']
  s.email       = ['priit@fraktal.ee']
  s.homepage    = 'http://github.com/priithaamer/ipizza-omniauth-provider'
  s.summary     = %q{iPizza authentication strategy for OmniAuth}
  s.description = %q{Integrates iPizza authentication to your rails app almost effortlessly}

  s.rubyforge_project = 'ipizza-omniauth-provider'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  s.add_dependency(%q<ipizza>, ['= 0.4.4'])
end
