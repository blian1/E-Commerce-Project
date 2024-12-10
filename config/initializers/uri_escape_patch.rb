# frozen_string_literal: true

module URI
  def self.escape(str)
    CGI.escape(str.to_s)
  end
end
