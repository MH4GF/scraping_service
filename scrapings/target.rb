class Target
  # AWS lambda handler
  def self.handler(event:, context:)
    new.execute
  end

  def execute
    raise NotImplementedError
  end

  def need_sign_in?
    raise NotImplementedError
  end

  def crawl_params
    {
        target_url: '',
        sign_in_form_number: 0,
        sign_in_email_field: '',
        sign_in_email: '',
        sign_in_password_field: '',
        sign_in_password: '',
        search_dom_target: ''
    }
  end
end
