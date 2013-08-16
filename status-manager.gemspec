Gem::Specification.new do |s|
  s.name        = 'status-manager'
  s.version     = '0.1.3'
  s.date        = '2013-08-16'
  s.summary     = "ActiveRecord Model Status Manager"
  s.description = "ActiveRecord Model Status Manager"
  s.authors     = ["Keepcosmos"]
  s.email       = 'keepcosmos@gmail.com'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  
  s.homepage    = 'https://github.com/keepcosmos/status-manager'
end