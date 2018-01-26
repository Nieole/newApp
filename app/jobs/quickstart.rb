require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '3s' do
  @times ||= 0
  puts @times += 1
  puts 'Hello... Rufus'
  # puts User.all.size
end
scheduler.join
