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
          serverURL = "https://085622d94ed5.ngrok.io"
          returnMessage = ""
          if event.message['text'] == "授業設定" && User.find_by(line_id: event['source']['userId'])
            session[:line_id] = event['source']['userId']
            session[:reply_token] = event['replyToken']
            returnMessage = "#{serverURL}/users/#{event['source']['userId']}/#{event['replyToken']}/sign_in"
          elsif event.message['text'] == "授業設定" && !User.find_by(line_id: event['source']['userId'])
            returnMessage = "#{serverURL}/users/#{event['source']['userId']}/#{event['replyToken']}/sign_up"

          elsif User.find_by(line_id: event['source']['userId'])
            returnMessage = "曜日と時限（半角：1〜7)を指定してね！" #\n次の授業が知りたいときは、「次」と入力してね！
            days = ["日", "月", "火", "水", "木", "金", "土"]
            class_nums = ["1", "2", "3", "4", "5", "6", "7"]
            for i in 0..6 do
              if event.message['text'].include?(days[i])
                for j in 0..6 do
                    user = User.find_by(line_id: event['source']['userId'])
                    course = user.course_infos.find_by(day: i, time: j + 1)
                  if event.message['text'].include?(class_nums[j]) && course.course
                    course_time = user.course_times.find_by(class_num: class_nums[j])
                    returnMessage = "#{days[i]}曜#{j+1}限（#{course_time.start_hour}:#{course_time.start_minute}-#{course_time.end_hour}:#{course_time.end_minute}）\n授業名：#{course.course}\n教員名：#{course.prof}\n教室（ZoomID）：#{course.location}\nPass: #{course.pass}"
                  elsif event.message['text'].include?(class_nums[j]) && !course.course
                    returnMessage = "授業はありません"
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