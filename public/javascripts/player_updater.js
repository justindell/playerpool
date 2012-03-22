$(document).ready(
  function(){
    setInterval(function(){
      current_points = [];
      for(i=0;i<$('table tbody tr').length; i++) {
        current_points[i] = parseInt($('table tbody tr')[i].children[2].innerHTML);
      }
      $('#standings').load("/refresh?date=#{Date.today.to_s}");
      for(i=0;i<$('table tbody tr').length; i++) {
        new_points = parseInt($('table tbody tr')[i].children[2].innerHTML)
        if(current_points[i] < new_points) {
          $($('table tbody tr')[i].children[2]).effect('highlight', 2000);
          current_points[i] = new_points;
        }
      }
    }, 30000);
  });
