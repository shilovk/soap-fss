require_relative "lib/soap/fss/version"

Gem::Specification.new do |spec|
  spec.name        = "soap-fss"
  spec.version     = Soap::Fss::VERSION
  spec.authors     = ["Konstantin Shilov"]
  spec.email       = ["shilovk@gmail.com"]
  spec.homepage    = "http://fss.ru"
  spec.summary     = "SOAP FSS interface"
  spec.description = "Tools for working with FSS WSDL."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://github.com/shilovk"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/shilovk"
  spec.metadata["changelog_uri"] = "https://github.com/shilovk"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.5"
end
