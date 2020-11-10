desc "This task is called by the Heroku scheduler add-on"
task :push_upcoming_class => :environment do
  puts "Pusshing"
  PushNextClassJob.perform_later
  puts "done."
end
