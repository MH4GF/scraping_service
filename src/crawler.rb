require 'mechanize'
require 'erb'
require_relative './slack_app'
require_relative './credentials'

class MoneyForwardCrawler
  attr_reader :agent, :page
  USER_AGENT = 'Mac Safari'.freeze
  SESSION_URL = 'https://moneyforward.com/users/sign_in'.freeze
  SIGN_IN_EMAIL_FIELD = 'sign_in_session_service[email]'.freeze
  SIGN_IN_PASS_FIELD = 'sign_in_session_service[password]'.freeze
  SEARCH_DOM_TARGET = '#monthly_total_table_home tbody tr td'.freeze

  # AWS lambda handler
  def self.handler(event:, context:)
    new.post_result
  end

  def initialize
    @agent = Mechanize.new
    agent.user_agent = USER_AGENT
    agent.log = Logger.new($stderr)
    @page = sign_in_page
  end

  def post_result
    slack_app = SlackApp.new(
      channel_code: Credentials.decrypted['slack_channel_code'],
      attachments: attachments_result
    )

    slack_app.post_message
  end

  private

  def sign_in_page
    login_page = agent.get(SESSION_URL)
    form = login_page.forms[0]
    form.field_with(name: SIGN_IN_EMAIL_FIELD).value = Credentials.decrypted['sign_in_email']
    form.field_with(name: SIGN_IN_PASS_FIELD).value = Credentials.decrypted['sign_in_password']
    agent.submit(form)
  end

  def attachments_result
    @result ||= select_result(crawl)
    erb = ERB.new(File.read('./views/moneyfoward_crawler.json.erb'))
    erb.result(binding)
  end

  def select_result(crawled)
    {
        income: crawled[0].children.text,
        expenses: crawled[1].children.text,
        balance: crawled[2].children.text
    }
  end

  def crawl
    page.search(SEARCH_DOM_TARGET)
  end
end
