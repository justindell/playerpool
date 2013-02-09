function player_refresher(refresh_date) {
  setInterval(function(){
    current_points = [];
    for(i=0;i<$('table tbody tr').length; i++) {
      current_points[i] = parseInt($('table tbody tr')[i].children[2].innerHTML);
    }
    $('#standings').load("/refresh?date=" + refresh_date, function(){
      for(i=0;i<$('table tbody tr').length; i++) {
        new_points = parseInt($('table tbody tr')[i].children[2].innerHTML)
        if(current_points[i] < new_points) {
          $($('table tbody tr')[i].children[2]).effect('highlight', {color: "#66FF66"}, 1000);
          current_points[i] = new_points;
        }
      }
    });
  }, 30000);
}
