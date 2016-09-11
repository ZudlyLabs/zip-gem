require "aws-sdk"

module Zip
  class KinesisClient

     attr_reader :aws_region_name, :stream_name, :aws_key, :aws_secret, :client

     def initialize(aws_region_name, stream_name, aws_key, aws_secret)
       @stream_name = stream_name
       @client = Aws::Kinesis::Client.new(region: aws_region_name, access_key_id: aws_key, secret_access_key: aws_secret)
     end

     def publish(event_subject, event_timestamp, event)
       @client.put_records({
         stream_name: @stream_name,
         records: [{
           data: {event_subject: event_subject,
                  event_timestamp: event_timestamp,
                  event_metadata: event}.to_json, 
           partition_key: "part_00"
         }]
       })
     end

  end
end
