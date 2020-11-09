class PushNextClassJob < ApplicationJob
  queue_as :default

  def perform
    user = User.find_by(name: "test1") #(line_id: line_id)
    line_id = user.line_id
    p line_id
    returnMessage = ""
    nowIs = Time.new
    nowDay = nowIs.wday
    nowHour = nowIs.hour 
    nowMin = nowIs.min

    searchDay = nowDay
    searchHour = nowHour

    courseTimes = user.course_times.all.order(:class_num)
    while searchHour < 24
      courseTimes.each do |course_time|
        startHour = course_time.start_hour
        startMin = course_time.start_minute
        startTime = Time.new.change(hour: startHour, min: startMin)
        if startTime > nowIs && nowIs + 60*10 > startTime && user.course_infos.find_by(time: course_time.class_num, day: searchDay).course
          days = ["日", "月", "火", "水", "木", "金", "土"]
          course = user.course_infos.find_by(time: course_time.class_num, day: searchDay)
          start_time = Time.new(2020, 1, 1, course_time.start_hour, course_time.start_minute, 0)
          end_time = Time.new(2020, 1, 1, course_time.end_hour, course_time.end_minute, 0)
          returnMessage = "もうすぐ次の授業です。\n#{days[searchDay]}曜#{course.time}限（#{start_time.strftime("%H:%M")}-#{end_time.strftime("%H:%M")}）\n授業名：#{course.course}\n教員名：#{course.prof}\n教室（ZoomID）：#{course.location}\nPass: #{course.pass}"
          message = [{
            type: 'text',
            text: returnMessage
          }, {type: 'text', text: '朝になりました。本日も頑張りましょう。食べた食べ物を「ひらがな」で入力すると、食品のカロリーと本日のトータルカロリーが表示されます。入力ミスの場合、「みす」と入力すると最新の入力を消去できます。カロリー計算に使ってください。'
          }] 
          client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
          }
          client.push_message(line_id, message)
          return
        end
      end
      searchHour += 1
    end
    logger.debug("no class")
  end

end