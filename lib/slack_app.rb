require 'json'
require 'rest-client'
require_relative './credentials'

class SlackApp
  attr_reader :header, :channel_code, :attachments
  POST_MESSAGE_URL = 'https://slack.com/api/chat.postMessage'.freeze

  def initialize(channel_code: '', attachments: [])
    @header = {
      content_type: 'application/json; charset=utf-8',
      Authorization: "Bearer #{Credentials.decrypted['slack_app_token']}"
    }
    @channel_code = channel_code
    @attachments = attachments
  end

  def post_message
    RestClient.post(POST_MESSAGE_URL, json_body, header)
  end

  private

  def json_body
    {
      channel: channel_code,
      as_user: false,
      attachments: attachments
    }.to_json
  end
end
