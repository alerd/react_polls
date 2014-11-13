UI.registerHelper 'pluralizeComment', (n) ->
  "#{n} " + switch
    when n in [5..20] then 'коментарів'
    when n % 10 is 1 then 'коментар'
    when 2 <= n % 10 <= 4 then 'коментарі'
    else
      'коментарів'

UI.registerHelper 'random', (n) ->
  "#{n} " + switch
    when n in [5..20] then 'коментарів'
    when n % 10 is 1 then 'коментар'
    when 2 <= n % 10 <= 4 then 'коментарі'
    else
      'коментарів'

UI.registerHelper 'submittedText', ->
  new Date(@submitted).toLocaleString()


Accounts.ui.config passwordSignupFields: 'USERNAME_ONLY'


@pluralizeComment = (n) ->
  switch
    when n in [5..20] then 'людей'
    when n % 10 is 1 then 'людина'
    when 2 <= n % 10 <= 4 then 'людини'
    else
      'людей'