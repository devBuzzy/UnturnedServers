function displayChart(element, days, data, type) { 
  var width = $("#stats-col").width();
  var canvas = document.getElementById(element);
  var ctx = canvas.getContext("2d");
  ctx.canvas.width = width;
  var data = {
      labels: days,
      datasets: [
          {
              label: type + " Data",
              fillColor: "rgba(151,187,205,0.2)",
              strokeColor: "rgba(151,187,205,1)",
              pointColor: "rgba(151,187,205,1)",
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(151,187,205,1)",
              data: data
          }
      ]
  };
  var chart = new Chart(ctx).Line(data);
  chart.update();
}