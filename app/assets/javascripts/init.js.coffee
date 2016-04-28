window.initApp = ->
  $('select[data-dynamic-selectable-url][data-dynamic-selectable-target]').dynamicSelectable()

document.addEventListener 'page:load', initApp

$ initApp

# send get forms through turbolinks
$(document).on "submit", "form[method=get]", ->
  Turbolinks.visit(this.action+(if this.action.indexOf('?') == -1 then '?' else '&')+$(this).serialize())
  false
