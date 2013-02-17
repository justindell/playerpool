$ ->
  $.get "/players.json", (response) ->
    data = response.map((player) ->
      label: player.full_name + " (" + player.team_name + ")"
      value: player.full_name
      id: player.id)
    $("#player_name").autocomplete
      source: data
      minLength: 3
      select: (event, ui) ->
        $("#pick_player_id").attr "value", ui.item.id
