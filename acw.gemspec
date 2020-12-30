lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "acw/version"

Gem::Specification.new do |spec|
  spec.name          = "acw"
  spec.version       = Acw::VERSION
  spec.authors       = ["Anchieta Júnior"]
  spec.email         = ["santosjr87@gmail.com"]

  spec.summary       = %q{Active Campaign Wrapper.}
  spec.description   = %q{Active Campaign Wrapper.}
  spec.homepage      = "https://github.com/anchietajunior.com/acw"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/anchietajunior/acw"
  spec.metadata["changelog_uri"] = "https://github.com/anchietajunior/acw"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency 'faraday', '>= 1.0'
  spec.add_dependency 'excon', '>= 0.73.0'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake",    "~> 12.3.3"
  spec.add_development_dependency "rspec",   "~> 3.0"
  spec.add_development_dependency "vcr",     "~> 5.1"
  spec.add_development_dependency "webmock", "~> 3.8"
  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency 'solargraph', '~> 0.40'
  spec.add_development_dependency 'rubocop', '~> 1.7'
end
