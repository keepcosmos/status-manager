Gem::Specification.new do |s|
  s.name        = 'status-manager'
  s.version     = '0.7.0'
  s.date        = '2013-12-20'
  s.summary     = "ActiveRecord Model Status Manager"
  s.description = "ActiveRecord Model Status Manager, It provides easy ways managing model that have many statuses."
  s.authors     = ["Keepcosmos"]
  s.email       = 'keepcosmos@gmail.com'
  s.licenses = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  
  s.homepage    = 'https://github.com/keepcosmos/status-manager'
end