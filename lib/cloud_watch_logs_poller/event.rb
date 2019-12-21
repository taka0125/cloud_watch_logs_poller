module CloudWatchLogsPoller
  class Event
    attr_reader :log_stream_name
    attr_reader :timestamp
    attr_reader :message
    attr_reader :ingestion_time
    attr_reader :event_id

    def initialize(log_stream_name, timestamp, message, ingestion_time, event_id)
      @log_stream_name = log_stream_name
      @timestamp = timestamp
      @message = message
      @ingestion_time = ingestion_time
      @event_id = event_id
    end

    def self.convert_from_filtered_log_event(event)
      new(
        event.log_stream_name,
        event.timestamp,
        event.message,
        event.ingestion_time,
        event.event_id
      )
    end
  end
end
