require "aws-sdk"

module Zip
  class KinesisClient

    attr_reader :stream_name
    attr_reader :aws_region_name, :aws_key, :aws_secret, :client

    def initialize(stream_name, aws_region=nil)
      @stream_name = stream_name
      raise "Invalid stream name '#{stream_name}' " unless stream_name =~ /^\S+$/
      # AWS Region is the only required parameter
      # Ideally, the key, and secret should be in credentials file
      aws_region = ENV['AWS_REGION'] if aws_region.nil?
      raise "Missing AWS region" unless aws_region
      raise "Invalid AWS region '#{aws_region}'" unless aws_region =~ /^\S+$/
      @client = Aws::Kinesis::Client.new({region: aws_region})
    end

    def validate_and_format(event)
      raise "Invalid format. Please refer documentation" if event.class != Hash
      event.inject({}) {|hash, (k, v)|  hash[k.to_s.gsub(" ", "_")] = v; hash }
    end

    def publish(event_subject, event_timestamp, event, partition_key = "part_00")
      formatted_event = validate_and_format(event)
      @client.put_records({
        stream_name: @stream_name,
        records: [{
          data: {
            event_subject: event_subject,
            event_timestamp: event_timestamp,
            event_metadata: formatted_event
          }.to_json,
          partition_key: partition_key
        }]
      })
    end
  end
end
