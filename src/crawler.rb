require 'bundler/setup'
require 'mechanize'
require 'erb'
require_relative './slack_app'

class Crawler
  attr_reader :agent, :url, :page
  USER_AGENT = 'Mac Safari'.freeze

  def initialize(url = nil)
    @agent = Mechanize.new
    agent.user_agent = USER_AGENT
    agent.log = Logger.new($stderr)
    @url = url
    @page = sign_in_page || agent.get(url)
  end

  private

  # need override
  def sign_in_page
    false
  end
end

class MoneyForwardCrawler < Crawler
  SESSION_URL = 'https://moneyforward.com/users/sign_in'.freeze
  SIGN_IN_EMAIL_FIELD = 'sign_in_session_service[email]'.freeze
  SIGN_IN_PASS_FIELD = 'sign_in_session_service[password]'.freeze
  SEARCH_DOM_TARGET = '#monthly_total_table_home tbody tr td'.freeze

  def initialize(url = SESSION_URL)
    super
  end

  def post_result
    slack_app = SlackApp.new(
      channel_code: ENV['CHANNEL_CODE'],
      attachments: attachments_result
    )

    slack_app.post_message
  end

  private

  def sign_in_page
    login_page = agent.get(url)
    form = login_page.forms[0]
    form.field_with(name: SIGN_IN_EMAIL_FIELD).value = ENV['SIGN_IN_EMAIL']
    form.field_with(name: SIGN_IN_PASS_FIELD).value = ENV['SIGN_IN_PASSWORD']
    agent.submit(form)
  end

  def result
    table = page.search(SEARCH_DOM_TARGET)
    @result ||= {
      income: table[0].children.text,
      expenses: table[1].children.text,
      balance: table[2].children.text
    }

    @result
  end

  def attachments_result
    @result = result
    erb = ERB.new(File.read('./src/views/moneyfoward_crawler.json.erb'))
    erb.result(binding)
  end
end
