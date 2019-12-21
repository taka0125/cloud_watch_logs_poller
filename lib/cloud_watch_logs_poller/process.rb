module CloudWatchLogsPoller
  class Process
    def initialize(interval, debug: false)
      @client = Aws::CloudWatchLogs::Client.new
      @interval = interval
      @debug = debug
    end

    def execute(log_group_name:, log_stream_name_prefix: nil, filter_pattern: nil, start_time: Time.now, &block)
      params = {
        log_group_name: log_group_name,
        log_stream_name_prefix: log_stream_name_prefix,
        start_time: start_time.is_a?(Time) ? start_time.to_i * 1000 : start_time,
        filter_pattern: filter_pattern,
        interleaved: true
      }

      loop do
        loop do
          result = @client.filter_log_events(params)
          result.events.each do |event|
            block.call(Event.convert_from_filtered_log_event(event))
          end

          debug_log(params)
          debug_log(result)

          break unless result.next_token

          params[:next_token] = result.next_token
        end

        sleep(@interval)
      end
    rescue Interrupt
      puts "Polling stopped."
    end

    private

    def debug_log(message)
      return unless @debug

      puts "[#{Time.now}] #{message}"
    end
  end
end
