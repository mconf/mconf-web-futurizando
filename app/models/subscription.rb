# -*- coding: utf-8 -*-
# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

class Subscription < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user

  validates :user_id, presence: true
  validates :plan_id, presence: true

  attr_reader :redirect_uri, :popup_uri

  scope :active, -> { where(completed: true, canceled: false) }

  # Saves the subscription but only after canceling the user's previous subscription,
  # if any
  def save_with_payment!
    previous = self.user.current_subscription
    if previous && previous.plan_id != self.plan_id
      previous.unsubscribe!
    end
    save!
  end

  def setup!(return_url, cancel_url)
    options = {
      pay_on_paypal: true,
      no_shipping: true,
      allow_note: true,
      logo: "http://futurizando.com.br/index_arquivos/14pmzxu-logofuturizando_06j01706j017000000.png",
      brand: Site.current.name,
      email: self.user.email
    }
    response = client.setup(
      payment_request,
      return_url,
      cancel_url,
      options
    )
    self.paypal_token = response.token
    self.save!
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    self
  end

  def cancel!
    self.canceled = true
    self.save!
    self
  end

  def complete!
    response = client.subscribe!(self.paypal_token, recurring_request)
    self.paypal_id = response.recurring.identifier
    self.completed = true
    self.save_with_payment!
    self
  end

  def unsubscribe!
    client.renew!(self.paypal_id, :Cancel)
    self.cancel!
  end

  # def details
  #   client.subscription(self.paypal_id)
  # end

  private

  def client
    Paypal::Express::Request.new Site.current.paypal_configs
  end

  def payment_request
    request_attributes =
      {
        billing_type: :RecurringPayments,
        billing_agreement_description: plan.name
      }
    Paypal::Payment::Request.new request_attributes
  end

  def recurring_request
    params = {
      start_date: Time.now,
      description: plan.name,
      billing: {
        period: plan.interval.capitalize.to_sym,
        frequency: plan.interval_count,
        amount: plan.amount_for_paypal_api,
        currency_code: plan.currency.upcase.to_sym,
      }
    }
    Paypal::Payment::Recurring.new(params)
  end

end
