lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'k2-connect-ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'k2-connect-ruby'
  spec.version       = K2ConnectRuby::VERSION
  spec.authors       = ['DavidKar1uk1']
  spec.email         = ['David.mwangi@kopokopo.com']

  spec.summary       = 'Ruby SDK for connection to the Kopo Kopo API.'
  spec.description   = 'Ruby SDK for connection to the Kopo Kopo API, with webhook handling and JSON request parsing with the Ruby on Rails framework.'
  spec.homepage      = 'https://github.com/kopokopo/k2-connect-ruby.git'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/kopokopo/k2-connect-ruby.git'
    spec.metadata['changelog_uri'] = 'https://github.com/kopokopo/k2-connect-ruby.git/CHANGELOG.MD'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'yajl-ruby'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'net-http-persistent', '>= 3.0'
  #Testing
  spec.add_development_dependency 'rspec', '>= 3.9.0'
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
