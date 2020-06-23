module CloudWatchLogsPoller
  class Process
    def initialize(interval, debug: false)
      @client = Aws::CloudWatchLogs::Client.new
      @interval = interval
      @debug = debug
      @event_ids_by_timestamp = {}
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

            debug_log("timestamp = #{timestamp}")

            @event_ids_by_timestamp[timestamp] ||= Set.new
            next if @event_ids_by_timestamp[timestamp].include?(event_id)

            @event_ids_by_timestamp[timestamp] << event_id
            block.call(Event.convert_from_filtered_log_event(event))
          end

          debug_log(params)

          @event_ids_by_timestamp = get_latest_events_and_timestamp
          break unless result.next_token

          params[:next_token] = result.next_token
        end

        newest_timestamp = @event_ids_by_timestamp.keys.max
        params[:start_time] = newest_timestamp unless newest_timestamp.nil?
        params[:next_token] = nil
        @event_ids_by_timestamp = {}

        sleep(@interval)
      end
    rescue Interrupt
      puts "Polling stopped."
    end

    private

    def get_latest_events_and_timestamp
      newest_timestamp = @event_ids_by_timestamp.keys.max
      return {} if newest_timestamp.nil?

      {newest_timestamp => @event_ids_by_timestamp[newest_timestamp]}
    end

    def debug_log(message)
      return unless @debug

      puts "[#{Time.now}] #{message}"
    end
  end
end
