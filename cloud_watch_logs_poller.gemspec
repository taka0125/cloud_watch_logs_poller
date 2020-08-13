
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cloud_watch_logs_poller/version"

Gem::Specification.new do |spec|
  spec.name          = "cloud_watch_logs_poller"
  spec.version       = CloudWatchLogsPoller::VERSION
  spec.authors       = ["Takahiro Ooishi"]
  spec.email         = ["taka0125@gmail.com"]

  spec.summary       = %q{Polling Cloud Watch Logs}
  spec.description   = %q{Polling Cloud Watch Logs}
  spec.homepage      = "https://github.com/taka0125/cloud_watch_logs_poller"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-cloudwatchlogs", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
