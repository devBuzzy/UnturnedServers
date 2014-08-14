function updateCountdown(text, countdown, chars) {
  var left = chars - jQuery(text).val().length;
  obj = jQuery(countdown)
  text = ''
  color = 'black'
  if (left == 1) {
    text = ' character left.'
  } else if (left < 0) {
    text = ' characters too many.'
    color = 'red'
  } else if (left > 0 && left < chars * .10) {
    text = ' characters left.'
    color = 'orange'
  } else {
    text = ' characters left.'
  }
  jQuery(countdown).text(Math.abs(left) + text).css('color', color);
}


function countdown(text, countdown, chars) {
  jQuery(document).ready(function($) {
    updateCountdown(text, countdown, chars);
    $(text).keyup(function() {
      updateCountdown(text, countdown, chars);
    });
  });
}