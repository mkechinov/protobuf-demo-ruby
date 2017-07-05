# require 'protobuf'
require './lib/demo/message_pb'
require 'benchmark'
require 'json'

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


times = 100000

puts "** Test encoding (#{times} iterations) **"
puts "** JSON: "
puts Benchmark.measure { times.times { json_sample.to_json } }


puts "** Protobuf: "
puts Benchmark.measure { times.times {
  sender = Demo::Person.new
  sender.first_name = json_sample[:sender][:first_name]
  sender.last_name = json_sample[:sender][:last_name]
  sender.email = json_sample[:sender][:email]
  receiver = Demo::Person.new
  receiver.first_name = json_sample[:receiver][:first_name]
  receiver.last_name = json_sample[:receiver][:last_name]
  receiver.email = json_sample[:receiver][:email]
  message = Demo::Letter.new sender: sender, receiver: receiver, subject: json_sample[:subject], body: json_sample[:body]
  Demo::Letter.encode(message)
} }


puts

puts "** Test decoding (#{times} iterations) **"

json_string = json_sample.to_json

sender = Demo::Person.new
sender.first_name = json_sample[:sender][:first_name]
sender.last_name = json_sample[:sender][:last_name]
sender.email = json_sample[:sender][:email]
receiver = Demo::Person.new
receiver.first_name = json_sample[:receiver][:first_name]
receiver.last_name = json_sample[:receiver][:last_name]
receiver.email = json_sample[:receiver][:email]
message = Demo::Letter.new sender: sender, receiver: receiver, subject: json_sample[:subject], body: json_sample[:body]
protobuf_string = Demo::Letter.encode(message)


puts "** JSON: "
puts Benchmark.measure { times.times { JSON.parse(json_string) } }

puts "** Protobuf: "
puts Benchmark.measure { times.times { Demo::Letter.decode(protobuf_string) } }


puts

puts "** Test message size **"
puts "** JSON: #{json_string.length} bytes"
puts "** Protobuf: #{protobuf_string.length} bytes"

puts

puts "** Inspect message **"
puts "** JSON: #{json_string}"
puts "** Protobuf: #{protobuf_string}"
