UI.registerHelper 'pluralizeComment', (n) ->
  "#{n} " + switch
    when n in [5..20] then 'коментарів'
    when n % 10 is 1 then 'коментар'
    when 2 <= n % 10 <= 4 then 'коментарі'
    else
      'коментарів'

Accounts.ui.config passwordSignupFields: 'USERNAME_ONLY'