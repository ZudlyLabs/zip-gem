# Zyudly Official Ruby Client Library

zip-gem is the official Ruby Client for the [Zyudly Intelligence Platform](https://zyudlylabs.com) API. 

### Installation

```
git clone git@github.com:ZudlyLabs/zip-gem.git
gem build 
gem build zip.gemspec
gem install zip-0.1.0.gem
```

or add to your Gemfile:

    gem 'zip'

or install from Rubygems:

    gem install zip

Zip gem is tested with Ruby 2.0 + and on:

### Usage

```
require "zip"
client = Zip::KinesisClient.new("stream_name", aws_region_name)
client.publish(:new_user, Time.now, {"name" => "sample name", attr1: "attr1 value"})

```
