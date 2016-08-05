# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
  $('#book_copy').on('cocoon:after-insert', function() {
    $('select').material_select();
  });
  $(document).ready(function() {
    var pressed = false;
    var chars = [];
    $(window).keypress(function(e) {
      if (e.which >= 45 && e.which <= 112) {
          chars.push(String.fromCharCode(e.which));
      }
      if (pressed == false) {
        setTimeout(function(){
          if (chars.length >= 11) {
            var barcode = chars.join("");
            var field = $("[name$='[barcode]']:last");
            field.val(barcode);
            $.getJSON("/book_copies/"+barcode+".json?empl="+#{@teacher.id}, null, function (data) {
              insert_values(data);
              pressed = false;
            }).fail(function(){
              $("[name$='[barcode]']:last").val('');
              Materialize.toast("Invalid barcode.", 4000, 'red');
              pressed = false;
            });
          }
          chars = [];
        },500);
      }
      pressed = true;
    });
    $(document).on("keypress","[name$='[barcode]']", (function(e){
      var c = String.fromCharCode(e.which);
      if ( $.trim($(e.target).val()).length >= 10 ) {
        var barcode = $.trim($(e.target).val()+c);
        e.preventDefault();
        $.getJSON("/book_copies/"+barcode+".json", null, function (data) {
          insert_values(data);
          $("[name$='[barcode]']:last").focus();
        }).fail(function(){
          $(e.target).val('');
          Materialize.toast("Invalid barcode.", 5000, 'red');
        });
      }
    }));
    var insert_values = function (data) {
      book = data.book_copy;
      $(".titles:last").html(book.book_edition.title);
      $(".book_copy_ids:last").val(book.id);
      $(".academic_year_ids:last").val(book.academic_year.academic_year_id);
      $(".book_edition_ids:last").val(book.book_edition.id);
      $(".book_title_ids:last").val(book.book_title.id);
      $(".barcodes:last").val(book.barcode);
      $(".bkudids:last").val(book.book_title.bkudid);
      $(".add_fields").trigger('click');
    };
  });
