class GuestsCleanupJob < ApplicationJob
  queue_as :default

  #异步任务
  def perform(*args)
    # Do something later
    sleep 10
    10.times do |i|
      puts i
      sleep 1
    end
  end
end
