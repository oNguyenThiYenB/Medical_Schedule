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
  init_date_picker('.datepicker');
  init_time_picker('.timepicker');

  $('.faculty_select').change(function(){
    var id_value_string = $(this).val();
    if (id_value_string == '') {
      // if the id is empty remove all the sub_selection options from being selectable and do not do any ajax
      $('.doctor_select option').remove();
      var row = '<option value=' + '' + '>' + 'None' + '</option>';
      $(row).appendTo('.doctor_select');
    }
    else {
      // Send the request and update sub category dropdown
      $.ajax({
        dataType: 'json',
        type: 'GET',
        url: '/appointments/for_facuty_id/' + id_value_string,
        error: function(XMLHttpRequest, errorTextStatus, error){
          alert('Failed to submit : ' + errorTextStatus.charAt(0).toUpperCase() + errorTextStatus.slice(1).toLowerCase() +' - ' + error);
        },
        success: function(data){
          // Clear all options from sub category select
          $('.doctor_select option').remove();
          if (data.length === 0) {
            row = '<option value=' + '' + '>' + 'None' + '</option>';
            $(row).appendTo('.doctor_select');
          } else {
            row = '<option value=' + '' + '>' + I18n.t("select_doctor") + '</option>';
            $(row).appendTo('.doctor_select');
          // Fill sub category select
            $.each(data, function(i, doctor){
              row = '<option value=' + doctor.id + '>' + doctor.full_name + '</option>';
              $(row).appendTo('.doctor_select');
            });
          }
        }
      });
    };
  });

  $('.doctor_select').change(function(){
    var id_value_string = $(this).val();
    var faculty_id = $('.faculty_select').val();
    if (id_value_string == '' || faculty_id == '') {
      $('.doctor_select option').remove();
      row = '<option value=' + '' + '>' + I18n.t("select_faculty_before") + '</option>';
      $(row).appendTo('.doctor_select');
      // if the id is empty remove all the sub_selection options from being selectable and do not do any ajax
      $('.date_select').removeClass('datepicker');
    } else {
      // Send the request and update sub category dropdown
      $.ajax({
        dataType: 'json',
        type: 'GET',
        url: '/appointments/for_doctor_id/' + id_value_string,
        error: function(XMLHttpRequest, errorTextStatus, error){
          alert('Failed to submit : ' + errorTextStatus.charAt(0).toUpperCase() + errorTextStatus.slice(1).toLowerCase() +' - ' + error);
        },
        success: function(data){
          var currentDate = new Date();
          var month = currentDate.getMonth() + 1;
          var day = currentDate.getDate();

          var defaultDate = (day<10 ? '0' : '') + day + '/' + (month<10 ? '0' : '') + month + '/' + currentDate.getFullYear();
          $('.datepicker').data("DateTimePicker").disabledDates([]);
          if (data.length != 0) {
            while (data.includes(defaultDate)) {
              currentDate.setDate(currentDate.getDate() + 1);
              month = currentDate.getMonth() + 1;
              day = currentDate.getDate();
              defaultDate = (day<10 ? '0' : '') + day + '/' + (month<10 ? '0' : '') + month + '/' + currentDate.getFullYear();
            }
            $('.datepicker').data("DateTimePicker").disabledDates(data);
            // $('.datepicker').data("DateTimePicker").defaultDate(defaultDate);
          }
        }
      });
    };
  });

  $('.datepicker').on('dp.change', function(e){
    var value_string = $(this).val();
    var pattern = /(\d{2})\/(\d{2})\/(\d{4})/;
    value_string = new Date(value_string.replace(pattern,'$3-$2-$1'));
    Date.parse(value_string);
    var doctor_id = $('.doctor_select').val();

    if (value_string == '' || doctor_id == '') {
      $('.time_select option').remove();
      row = '<option value=' + '' + '>' + I18n.t("select_day_and_doctor_before") + '</option>';
      $(row).appendTo('.time_select');
    } else {
      // Send the request and update sub category dropdown
      $.ajax({
        dataType: 'json',
        type: 'GET',
        url: '/appointments/for_date_picker/',
        data: { doctor_id: doctor_id, date_picker: value_string },
        error: function(XMLHttpRequest, errorTextStatus, error){
          alert('Failed to submit : ' + errorTextStatus.charAt(0).toUpperCase() + errorTextStatus.slice(1).toLowerCase() +' - ' + error);
        },
        success: function(data){
          $('.time_select option').remove();
          if (data.length === 0) {
            row = '<option value=' + '' + '>' +  I18n.t("none") + '</option>';
            $(row).appendTo('.time_select');
          } else {
            row = '<option value=' + '' + '>' + I18n.t("select_time") + '</option>';
            $(row).appendTo('.time_select');
          // Fill sub category select
            $.each(data, function(i, time){
              row = '<option value=' + time[1] + '>' + time[0] + '</option>';
              $(row).appendTo('.time_select');
            });
          }
        }
      });
    };
  });

  $('.time_select').change(function(){
    debugger;
    var id_value_string = $(this).val();
    var doctor_id = $('.doctor_select').val();
    if (id_value_string == '' || doctor_id == '') {
      $('.time_select option').remove();
      row = '<option value=' + '' + '>' + I18n.t("select_day_and_doctor_before") + '</option>';
      $(row).appendTo('.time_select');
    }
  });

  $('.alert').delay(5000).fadeOut();

  $(document).on('change', '.upload_image', function(){
    readURL(this);
  });

  $(document).on('change', '.upload_file', function(){
    readURL_file(this);
  });

  $('#user_image').bind('change', function() {
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
      var duration = calEvent.start.format('HH:mm') + ' - ' + calEvent.end.format('HH:mm')
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

  $('.owl-carousel').owlCarousel({
		items: 1,
		loop: false,
		center: true,
		margin: 0
  });

  document.addEventListener('turbolinks:before-cache', function() {
    $('.owl-carousel').owlCarousel('destroy');
  });
});

function init_date_picker(element_id) {
  var currentDate = new Date();
  $(element_id).datetimepicker({
    defaultDate: '',
    ignoreReadonly: true,
    minDate: new Date(),
    stepping: 60,
    format: 'L',
    format: 'DD/MM/YYYY',
    showTodayButton: true,
    widgetPositioning: {
      horizontal: 'auto',
      vertical: 'bottom'
    },
  });
}

function init_time_picker(element_id) {
  $(element_id).datetimepicker({
    format: 'hh:mm',
    enabledHours: [7, 9, 11, 13, 15, 17],
    stepping: 60,
    format: 'LT',
    widgetPositioning: {
      horizontal: 'auto',
      vertical: 'bottom'
    },
  });
}

jQuery.fn.load = function(callback){ $(window).on('load', callback) };

$.widget.bridge('uibutton', $.ui.button)
