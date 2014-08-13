# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

module SubscriptionsHelper

  def current_subscription
    if user_signed_in?
      if current_user.subscription.nil?
        subscription = 'FREE'
      else
        if current_user.subscription.plan
          subscription = current_user.subscription.plan.code
        else
          # TODO: if a user has an old subscription he's being assumed as 'FREE'
          subscription = 'FREE'
        end
      end
    else
      subscription = nil
    end
    subscription
  end

  def format_plan_pricing(amount)
    sprintf('%.2f', amount/100.0)
  end

end
