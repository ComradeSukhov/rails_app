def really_slow_task(payload)
  puts 'Starting really slow task!'

  10.times do
    putc '.'
    sleep 1
  end
  puts '.'

  puts "Payload: #{payload}"

  puts 'Slow task finished'
end

require 'eventmachine'
require 'bunny'

EventMachine.run do
  connection = Bunny.new('amqp://guest:guest@rabbitmq')
  connection.start

  channel = connection.create_channel
  queue = channel.queue('vm.control', auto_delete: true)

  queue.subscribe do |_delivery_info, _metadata, payload|
    really_slow_task(payload)
  end

  Signal.trap('INT') do
    puts 'exiting INT'
    connection.close { EventMachine.stop }
  end

  Signal.trap('TERM') do
    puts 'killing TERM'
    connection.close { EventMachine.stop }
  end
end
