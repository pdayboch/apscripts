# coding: utf-8
lib = File.expand_path('../lib', _FILE_)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
	spec.name 	= "apscripts"
	spec.version 	= '1.0'
	spec.authors 	= ["Philip Dayboch"]
	spec.email 	= ["philip245@gmail.com"]
	spec.summary	= %q{tests written for Meraki APs}
	spec.description = %q{SSH into Meraki APs and run commands automatically}
	spec.homepage 	= "http://domainforproject.com/"
	spec.license 	= "MIT"

	spec.files	= ['lib/apscripts.rb']
	spec.executables = ['bin/apscripts']
	spec.test_files = ['tests/test_apscripts.rb']
	spec.require_paths = ["lib"]
end
