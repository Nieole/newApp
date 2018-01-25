class MyWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  #定时任务执行周期
  recurrence do
    minutely(1)
    daily
  end

  def perform
    # do stuff ...
    10.times do |i|
      puts i
      sleep 1
    end
  end
end
