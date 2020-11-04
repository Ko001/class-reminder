class PushNextClassJob < ApplicationJob
  queue_as :default

  def perform
    puts "hello, there"
  end
end
