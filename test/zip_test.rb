require 'test_helper'

class ZipTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Zip::VERSION
  end

  def test_publish_and_consume
    stream_name = ENV['AWS_KINESIS_STREAM_NAME']
    raise "Missing environment variable 'AWS_KINESIS_STREAM_NAME'" unless stream_name
    aws_region_name = ENV['AWS_REGION_NAME']
    raise "Missing environment variable 'AWS_REGION_NAME'" unless aws_region_name
    kc = Zip::KinesisClient.new(stream_name, aws_region_name)
    kc.publish("test_event_subject", Time.now, {"key" => "val"})
    sleep 5
    shard_index = 0
    resp = kc.client.describe_stream({
      stream_name: stream_name
    })
    sd = resp.stream_description
    shards = sd.shards
    shard = shards[shard_index]
    shard_id = shard.shard_id
    puts "shard_id = '#{shard_id}'"
    resp = kc.client.get_shard_iterator({
      stream_name: stream_name,
      shard_id: shard_id,
      shard_iterator_type: "LATEST"
    })
    shard_iterator = resp.shard_iterator
    puts "shard_iterator = '#{shard_iterator}'"
    resp = kc.client.get_records({
      shard_iterator: shard_iterator,
      limit: 1
    })
    puts resp.records.inspect
    assert true
  end
end
