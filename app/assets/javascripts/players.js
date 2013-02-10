$(function() {
  $.get("/players.json", function(data) {
    playerMap = {};
    $(data).each(function(i,player) {
      playerMap[player.full_name] = player.id;
    })
    $('#player_name').typeahead({
      minLength: 3,
      source: function(query, process) {
        process(Object.keys(playerMap));
      },
      updater: function(item) {
        $('#user_team_player_id').val(playerMap[item]);
        return item;
      }
    });
  });
});
