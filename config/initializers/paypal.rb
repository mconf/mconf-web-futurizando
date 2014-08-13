require 'paypal/express'

PAYPAL_CONFIG = if ENV['paypal_username'] # for heroku
  {
    username:  ENV['paypal_username'],
    password:  ENV['paypal_password'],
    signature: ENV['paypal_signature'],
    sandbox:   ENV['paypal_sandbox']
  }
else
  YAML.load_file("#{Rails.root}/config/paypal.yml")[Rails.env].symbolize_keys
end
Paypal.sandbox! if PAYPAL_CONFIG[:sandbox]

# Rails.application.config.to_prepare do
#   if Site.table_exists?
#     config = Rails.application.config
#     site = Site.current
#     if Rails.env == "production"
#       if site.respond_to?(:stripe_sk_live) && site.respond_to?(:stripe_pk_live)
#         if site.stripe_sk_live.blank? && site.respond_to?(:stripe_sk_test)
#           Stripe.api_key = site.stripe_sk_test
#         else
#           Stripe.api_key = site.stripe_sk_live
#         end
#         if site.stripe_pk_live.blank? && site.respond_to?(:stripe_pk_test)
#           STRIPE_PUBLIC_KEY = site.stripe_pk_test
#         else
#           STRIPE_PUBLIC_KEY = site.stripe_pk_live
#         end
#       end
#     else
#       if site.respond_to?(:stripe_sk_test) && site.respond_to?(:stripe_pk_test)
#         Stripe.api_key = site.stripe_sk_test
#         STRIPE_PUBLIC_KEY = site.stripe_pk_test
#       end
#     end
#   end
# end
