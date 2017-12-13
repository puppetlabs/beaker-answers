source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

eval(File.read("#{__FILE__}.local"), binding) if File.exist? "#{__FILE__}.local"
