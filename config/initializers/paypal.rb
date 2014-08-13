require 'paypal/express'

Rails.application.config.to_prepare do
  if Site.table_exists? && Site.current && Site.current.respond_to?(:paypal_sandbox)
    Paypal.sandbox! if Site.current.paypal_sandbox
  else
    Paypal.sandbox! # sandbox by default
  end
end
