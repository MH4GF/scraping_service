# frozen_string_literal: true

require 'mechanize'
require 'erb'

class Crawler
  attr_reader :agent, :target_page, :crawl_params
  USER_AGENT = 'Mac Safari'

  def initialize(target)
    @agent = Mechanize.new
    agent.user_agent = USER_AGENT
    agent.log = Logger.new($stderr)
    @crawl_params = target.crawl_params
    @target_page = target.need_sign_in? ? sign_in_page : params[:target_url]
  end

  def crawl
    target_page.search(crawl_params[:search_dom_target])
  end

  private

  # TODO
  # rubocop:disable Metrics/AbcSize
  def sign_in_page
    sign_in_page = agent.get(crawl_params[:target_url])
    form = sign_in_page.forms[crawl_params[:sign_in_form_number]]
    form.field_with(name: crawl_params[:sign_in_email_field]).value = crawl_params[:sign_in_email]
    form.field_with(name: crawl_params[:sign_in_password_field]).value = crawl_params[:sign_in_password]
    agent.submit(form)
  end
  # rubocop:enable Metrics/AbcSize
end
