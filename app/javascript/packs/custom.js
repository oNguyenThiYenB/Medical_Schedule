function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('.image')
        .attr('src', e.target.result)
        .width(200)
        .height(200);
    };

    reader.readAsDataURL(input.files[0]);
  }
}

function readURL_file(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('.file_name')
        .append(fileReader.fileName)
    };

    reader.readAsDataURL(input.files[0]);
  }
}

$(document).ready(function() {
  $('.alert').delay(5000).fadeOut();

  $(document).on('change', '.upload_image', function(){
    readURL(this);
  });

  $(document).on('change', '.upload_file', function(){
    readURL_file(this);
  });

  $("#user_image").bind("change", function() {
    var size_in_megabytes = this.files[0].size/1048576;
    if (size_in_megabytes > 5) {
      alert(I18n.t('choose_smaller_file'));
    }
  });

  $('#calendar').fullCalendar({
    weekends: false,
    slotDuration: '00:15',
    minTime: '06:00:00',
    maxTime: '18:00:01',
    events: $('#calendar').data('schedule'),

    dayClick: function(date, jsEvent, view) {
      $('#calendar').fullCalendar('changeView', 'agendaDay');
      $('#calendar').fullCalendar('gotoDate', date);
    },

    eventClick: function(calEvent, jsEvent, view) {
      if (view.type == 'month' || view.type == 'agendaWeek' ) {
        $('#calendar').fullCalendar('changeView', 'agendaDay');
        $('#calendar').fullCalendar('gotoDate', calEvent.start);
        return false;
      }
    },

    eventMouseout: function(calEvent, jsEvent) {
      $(this).css('z-index', 8);
      $('.tooltipevent').remove();
    },
    defaultView: 'month',

    header: {
      center: 'month,agendaWeek,agendaDay'
    },

    eventMouseover: function(calEvent, jsEvent) {
      var duration = calEvent.start.format("HH:mm") + ' - ' + calEvent.end.format("HH:mm")
      var tooltip = '<div class="tooltipevent" style="width:200px;background:white;border-style:inset;padding: 15px;position:absolute;z-index:10001;">' + duration + '</br>' + calEvent.title + '</div>';
      var $tooltip = $(tooltip).appendTo('body');

      $(this).mouseover(function(e) {
        $(this).css('z-index', 10000);
        $tooltip.fadeIn('500');
        $tooltip.fadeTo('10', 1.9);
      }).mousemove(function(e) {
        $tooltip.css('top', e.pageY + 10);
        $tooltip.css('left', e.pageX + 20);
      });
    },
  });

  $('#my-next-button').click(function() {
    $('#calendar').fullCalendar('next');
  });

  $(".owl-carousel").owlCarousel({
		items: 1,
		loop: false,
		center: true,
		margin: 0
  });

  document.addEventListener("turbolinks:before-cache", function() {
    $('.owl-carousel').owlCarousel('destroy');
  });
});

jQuery.fn.load = function(callback){ $(window).on("load", callback) };

$.widget.bridge('uibutton', $.ui.button)
