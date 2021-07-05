# frozen_string_literal: true

require 'yaml'

module Credentials
  def self.decrypted
    file_path = File.expand_path('../config/secrets.yml', __dir__)
    @yaml ||= YAML.load_file(file_path)
  rescue Errno::ENOENT
    raise StandardError, 'not decrypted from `encrypted_secrets.yml`.'
  end
end
