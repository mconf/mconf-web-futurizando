# -*- coding: utf-8 -*-
# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

class PlansController < ApplicationController

  load_and_authorize_resource

  layout :determine_layout
  def determine_layout
    case params[:action].to_sym
    when :pricing, :index
      "no_sidebar"
    else
      "application"
    end
  end

  def index
  end

  def pricing
    # The view expects the plans in this exact order
    plan1 = Plan.find_by_code('G-BASIC-M')
    plan2 = Plan.find_by_code('G-BASIC-Y')
    plan3 = Plan.find_by_code('G-PREMIUM-M')
    plan4 = Plan.find_by_code('G-PREMIUM-Y')
    @plans = [plan1, plan2, plan3, plan4]
  end

  def fetch
    # plans = Stripe::Plan.all
    # Plan.update_from_stripe(plans)
    # redirect_to plans_path, :notice => t("plans.fetch.success")
  end

end
