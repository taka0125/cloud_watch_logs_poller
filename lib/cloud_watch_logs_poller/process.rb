module CloudWatchLogsPoller
  class Process
    def initialize(interval, debug: false)
      @client = Aws::CloudWatchLogs::Client.new
      @interval = interval
      @debug = debug
      @event_ids = Set.new
      @max_timestamp = 0
    end

    def execute(log_group_name:, log_stream_name_prefix: nil, filter_pattern: nil, start_time: Time.now, &block)
      params = {
        log_group_name: log_group_name,
        log_stream_name_prefix: log_stream_name_prefix,
        start_time: start_time.is_a?(Time) ? start_time.to_i * 1000 : start_time,
        filter_pattern: filter_pattern,
        interleaved: true
      }

      debug_log("start_time = #{params[:start_time]}")

      loop do
        loop do
          result = @client.filter_log_events(params)
          result.events.each do |event|
            timestamp = event.timestamp&.to_i
            event_id = event.event_id
            @max_timestamp = timestamp if timestamp > @max_timestamp

            debug_log("timestamp = #{timestamp}")

            next if @event_ids.include?(event_id)

            @event_ids << event_id
            block.call(Event.convert_from_filtered_log_event(event))
          end

          debug_log(params)

          break unless result.next_token

          params[:next_token] = result.next_token
        end

        params[:start_time] = @max_timestamp + 1 if @max_timestamp > 0
        params[:next_token] = nil
        @event_ids = Set.new

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
