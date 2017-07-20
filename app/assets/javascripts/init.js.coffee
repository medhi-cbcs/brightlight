window.App ||= {}

App.init = ->
  $('select[data-dynamic-selectable-url][data-dynamic-selectable-target]').dynamicSelectable()

$(document).on "ready page:load", ->
  App.init()

# send get forms through turbolinks
$(document).on "submit", "form[method=get]", ->
  Turbolinks.visit(this.action+(if this.action.indexOf('?') == -1 then '?' else '&')+$(this).serialize())
  false

$(document).on 'ajax:complete', '.delete-link', ->
  $(this).closest("tr").remove()
  Materialize.toast($(this).data("message"), 4000, "green")

$(document).on 'click', '.delete-record', ->
  $(this).closest("tr").hide()
    .find("[name$='[_destroy]']").val(true)

  