class WebhookController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  protect_from_forgery except: [:callback] # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
    end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          serverURL = "https://0933030a9358.ngrok.io"
          returnMessage = ""

          if 
            !User.find_by(line_id: event['source']['userId'])
            if event.message['text'].include?("授業") && event.message['text'].include?("設定")
              returnMessage = "#{serverURL}/users/#{event['source']['userId']}/#{event['replyToken']}/sign_up"
            else
              returnMessage = "「授業設定」と入力して、初期設定をしてください！"
            end
          elsif User.find_by(line_id: event['source']['userId'])
            returnMessage = "曜日と時限（半角：1〜7)を指定してね！\n次の授業が知りたいときは、「次」と入力してね！\nあるいは「授業設定」と入力して時間割を編集してね！"
            if event.message['text'].include?("授業") && event.message['text'].include?("設定")
              user = User.find_by(line_id: event['source']['userId'])
              user.pass = event['replyToken']
              user.save
              returnMessage = "#{serverURL}/users/#{event['source']['userId']}/#{event['replyToken']}/sign_in"
              logger.debug("settings")
            elsif event.message['text'].include?("次")
              returnMessage = find_next_class(event['source']['userId']) 
            else
              days = ["日", "月", "火", "水", "木", "金", "土"]
              class_nums = ["1", "2", "3", "4", "5", "6", "7"]
              for i in 0..6 do
                if event.message['text'].include?(days[i])
                  for j in 0..6 do
                      user = User.find_by(line_id: event['source']['userId'])
                      course = user.course_infos.find_by(day: i, time: j + 1)
                    if event.message['text'].include?(class_nums[j]) && course.course
                      course_time = user.course_times.find_by(class_num: class_nums[j])
                      start_time = Time.new(2020, 1, 1, course_time.start_hour, course_time.start_minute, 0)
                      end_time = Time.new(2020, 1, 1, course_time.end_hour, course_time.end_minute, 0)
                      returnMessage = "#{days[i]}曜#{j+1}限（#{start_time.strftime("%H:%M")}-#{end_time.strftime("%H:%M")}）\n授業名：#{course.course}\n教員名：#{course.prof}\n教室（ZoomID）：#{course.location}\nPass: #{course.pass}"
                    elsif event.message['text'].include?(class_nums[j]) && !course.course
                      returnMessage = "授業はありません"
                    end
                  end
                end
              end
            end
          end
            
          message = {
            type: 'text',
            text: returnMessage
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end

    "OK"
  end
end

def find_next_class(line_id)
  nowIs = Time.new
  nowDay = nowIs.wday
  nowHour = nowIs.hour 
  nowMin = nowIs.min
  user = User.find_by(line_id: line_id)

  for i in 0..6 do
    searchDay = (nowDay + i) % 7
    searchHour = 0;

    if searchDay == nowDay
      searchHour = nowHour
    else
      searchHour = 6
    end
    courseTimes = user.course_times.all.order(:class_num)
    while searchHour < 24
      courseTimes.each do |course_time|
        startHour = course_time.start_hour
        startMin = course_time.start_minute
        if searchDay == nowDay && searchHour == startHour && searchHour == nowHour && nowMin > startMin
          logger.debug("already over")
        elsif searchHour == startHour && user.course_infos.find_by(time: course_time.class_num, day: searchDay).course
          days = ["日", "月", "火", "水", "木", "金", "土"]
          course = user.course_infos.find_by(time: course_time.class_num, day: searchDay)
          start_time = Time.new(2020, 1, 1, course_time.start_hour, course_time.start_minute, 0)
          end_time = Time.new(2020, 1, 1, course_time.end_hour, course_time.end_minute, 0)
          returnMessage = "#{days[searchDay]}曜#{course.time}限（#{start_time.strftime("%H:%M")}-#{end_time.strftime("%H:%M")}）\n授業名：#{course.course}\n教員名：#{course.prof}\n教室（ZoomID）：#{course.location}\nPass: #{course.pass}"
          return returnMessage
        end
      end
      searchHour += 1
    end
  end

end