# -*- coding: utf-8 -*-
# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

class SubscriptionsController < ApplicationController
  #rescue_from Paypal::Exception::APIError, with: :paypal_api_error

  load_and_authorize_resource

  def create
    if current_user.subscription.nil?
      @subscription = Subscription.new
    else
      @subscription = current_user.subscription
    end

    # the id gets here as the #code of the plan
    if params[:subscription] && params[:subscription][:plan_id]
      plan = Plan.find_by_code(params[:subscription][:plan_id])
      @subscription.plan = plan
    else
      #   # TODO: improve errors
      #   flash[:error] = t('subscriptions.create.error', :errors => @subscription.errors.full_messages.join(', '))
      #   flash.keep
      #   redirect_to pricing_path
    end

    @subscription.user = current_user

    @subscription.setup!(success_subscription_url, cancel_subscription_url)
    # TODO: error if setup fails
    redirect_to @subscription.redirect_uri
  end

  def success
    handle_callback do |subscription|
      subscription.complete!
      flash[:notice] = 'Subscription Transaction Completed'
      pricing_path
    end
  end

  def cancel
    handle_callback do |subscription|
      subscription.cancel!
      flash[:warn] = 'Subscription Request Canceled'
      pricing_path
    end
  end

  def destroy
    # current_user.subscription.destroy
    # redirect_to pricing_path, :notice => t('subscriptions.destroy.success')
  end

  private

  def handle_callback
    subscription = Subscription.find_by_paypal_token! params[:token]
    @redirect_uri = yield subscription
    redirect_to @redirect_uri
  end

  def paypal_api_error(e)
    redirect_to root_url, error: e.response.details.collect(&:long_message).join('<br />')
  end

  # def subscription_params
  #   unless params[:subscription].blank?
  #     params[:subscription].permit(*subscription_allowed_params)
  #   else
  #     {}
  #   end
  # end

  # def subscription_allowed_params
  #   [ :plan ]
  # end

end
