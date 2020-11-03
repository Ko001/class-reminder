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
          serverURL = "https://8b3147f97321.ngrok.io"
          settingLink = ""
          if event.message['text'] == "授業設定" && User.find_by(line_id: event['source']['userId'])
            session[:line_id] = event['source']['userId']
            session[:reply_token] = event['replyToken']
            settingLink = "#{serverURL}/users/#{event['source']['userId']}/#{event['replyToken']}/sign_in"
          elsif event.message['text'] == "授業設定" && !User.find_by(line_id: event['source']['userId'])
            settingLink = "#{serverURL}/users/#{event['source']['userId']}/#{event['replyToken']}/sign_up"
          else
            settingLink = "無し"
          end
          message = {
            type: 'text',
            text: settingLink
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end

    "OK"
  end
end