$ ->
  if isOnPage 'plans', 'pricing'

    $('.purchase-button').on 'click', (e) ->
      e.preventDefault()

      planId = $(this).attr('data-plan-id')
      $('#subscription_plan_id').val(planId)
      $('#subscription-form')[0].submit()
