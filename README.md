# CloudWatchLogsPoller

Polling Cloud Watch Logs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloud_watch_logs_poller'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloud_watch_logs_poller

## Usage

- Set Aws credentials
  - AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY / AWS_REGION

```
interval = 10 # seconds
log_group_name = 'logs'
filter_pattern = 'ERROR'

poller_process = CloudWatchLogsPoller::Process.new(interval)
poller_process.execute(log_group_name: log_group_name, filter_pattern: filter_pattern) do |event|
  puts event
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taka0125/cloud_watch_logs_poller.
