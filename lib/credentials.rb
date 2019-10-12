# frozen_string_literal: true

require 'yaml'

module Credentials
  def self.decrypted
    @yaml ||= YAML.load_file('./secrets.yml')
  rescue Errno::ENOENT
    raise StandardError, 'not decrypted from `encrypted_secrets.yml`.'
  end
end
