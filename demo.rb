# require 'protobuf'
require './lib/demo/letter_pb'
require 'benchmark'
require 'json'
require 'active_support'
require 'active_support/core_ext'

system "clear"

json_sample = {
    sender: {
        first_name: 'Jonh',
        last_name: 'Doe',
        email: 'john@doe.com'
    },
    receiver: {
        first_name: 'Jane',
        last_name: 'Doe',
        email: 'jane@doe.com'
    },
    subject: 'Hi!',
    body: 'this is secret message'
}



xml_sample = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<letter>
  <sender>
    <first_name>Jonh</first_name>
    <last_name>Doe</last_name>
    <email>john@doe.com</email>
  </sender>
  <receiver>
    <first_name>Jane</first_name>
    <last_name>Doe</last_name>
    <email>jane@doe.com</email>
  </receiver>
  <subject>#{json_sample[:subject]}</subject>
  <body>#{json_sample[:body]}</body>
</letter>
XML



times = ARGV[0].to_i

# *** ENCODING ***

puts "** Test encoding (#{times} iterations) **"

puts "** XML: "
puts Benchmark.measure { times.times { json_sample.to_xml } }

puts "** JSON: "
puts Benchmark.measure { times.times { json_sample.to_json } }


puts "** Protobuf: "
puts Benchmark.measure { times.times {
  sender = Demo::Letter::Person.new
  sender.first_name = json_sample[:sender][:first_name]
  sender.last_name = json_sample[:sender][:last_name]
  sender.email = json_sample[:sender][:email]
  receiver = Demo::Letter::Person.new
  receiver.first_name = json_sample[:receiver][:first_name]
  receiver.last_name = json_sample[:receiver][:last_name]
  receiver.email = json_sample[:receiver][:email]
  message = Demo::Letter.new sender: sender, receiver: receiver, subject: json_sample[:subject], body: json_sample[:body]
  Demo::Letter.encode(message)
} }

puts


# *** DECODING ***

puts "** Test decoding (#{times} iterations) **"

json_string = json_sample.to_json

sender = Demo::Letter::Person.new
sender.first_name = json_sample[:sender][:first_name]
sender.last_name = json_sample[:sender][:last_name]
sender.email = json_sample[:sender][:email]
receiver = Demo::Letter::Person.new
receiver.first_name = json_sample[:receiver][:first_name]
receiver.last_name = json_sample[:receiver][:last_name]
receiver.email = json_sample[:receiver][:email]
message = Demo::Letter.new sender: sender, receiver: receiver, subject: json_sample[:subject], body: json_sample[:body]
protobuf_string = Demo::Letter.encode(message)


puts "** XML: "
puts Benchmark.measure { times.times { Hash.from_xml(xml_sample) } }

puts "** JSON: "
puts Benchmark.measure { times.times { JSON.parse(json_string) } }

puts "** Protobuf: "
puts Benchmark.measure { times.times { Demo::Letter.decode(protobuf_string) } }

puts


# *** DATA SIZE ***

puts "** Test message size **"
puts "** XML: #{xml_sample.length} bytes"
puts "** JSON: #{json_string.length} bytes"
puts "** Protobuf: #{protobuf_string.length} bytes"

puts

puts "** Accumulated test message size **"
puts "** XML: #{xml_sample.length * times} bytes"
puts "** JSON: #{json_string.length * times} bytes"
puts "** Protobuf: #{protobuf_string.length * times} bytes"

puts

puts "** Inspect message **"
puts "** JSON: #{json_string}"
puts "** Protobuf: #{protobuf_string}"
