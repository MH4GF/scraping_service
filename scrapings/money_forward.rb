require_relative './target'
require_relative '../lib/crawler'
require_relative '../lib/slack_app'
require_relative '../lib/credentials'

class MoneyForward < Target
  def execute
    sender.post_message
  end

  def need_sign_in?
    true
  end

  def crawl_params
    {
        target_url: 'https://moneyforward.com/users/sign_in',
        sign_in_form_number: 0,
        sign_in_email_field: 'sign_in_session_service[email]',
        sign_in_email: ::Credentials.decrypted['sign_in_email'],
        sign_in_password_field: 'sign_in_session_service[password]',
        sign_in_password: ::Credentials.decrypted['sign_in_password'],
        search_dom_target: '#monthly_total_table_home tbody tr td'
    }.map(&:freeze).to_h.freeze
  end

  private

  def crawler
    @crawler ||= ::Crawler.new(self)
  end

  def sender
    @sender ||= ::SlackApp.new(
        channel_code: ::Credentials.decrypted['slack_channel_code'],
        attachments: attachments_result
    )
  end

  def attachments_result
    @result ||= select_result(crawler.crawl)
    erb = ERB.new(File.read('./scrapings/views/money_forward.json.erb'))
    erb.result(binding)
  end

  def select_result(crawled)
    {
        income: crawled[0].children.text,
        expenses: crawled[1].children.text,
        balance: crawled[2].children.text
    }
  end
end
