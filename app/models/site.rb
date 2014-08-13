# -*- coding: utf-8 -*-
# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

class Site < ActiveRecord::Base

  # Returns the current (default) site
  def self.current
    first || create
  end

  def signature_in_html
    if signature
      return signature.gsub(/\r\n?/,'<br>')
    else
      return ""
    end
  end

  # HTTP protocol based on SSL setting
  def protocol
    "http#{ ssl? ? 's' : nil }"
  end

  # Domain http url considering protocol
  # e.g. http://server.org
  def domain_with_protocol
    "#{protocol}://#{domain}"
  end

  # Nice formatted email address for the Site
  def email_with_name
    "#{name} <#{email}>"
  end

  def paypal_configs
    if Rails.env == "production"
      {
        username: self.paypal_username_live,
        password: self.paypal_password_live,
        signature: self.paypal_signature_live,
        sandbox: self.paypal_sandbox
      }
    else
      {
        username: self.paypal_username_test,
        password: self.paypal_password_test,
        signature: self.paypal_signature_test,
        sandbox: self.paypal_sandbox
      }
    end
  end

end
