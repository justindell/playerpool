$ ->
  $('.sortable').sortable {
    update: (event, ui) ->
      data = $(this).sortable('serialize')
      $.post "/users/update_all", data, (response) ->
        location.reload()}
