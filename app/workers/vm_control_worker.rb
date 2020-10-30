class VmControlWorker
  include Sidekiq::Worker

  def perform(order_id)
    really_slow_task(order_id)
  end

  private

  def really_slow_task(payload)
    puts 'Starting really slow task!'

    puts "Payload: #{payload}"
    sleep 10

    puts 'Slow task finished'
  end

end
