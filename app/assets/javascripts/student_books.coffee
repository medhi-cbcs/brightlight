# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

`$('#book_copy').on('cocoon:after-insert', function() {
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
          // console.log("Barcode Scanned: " + barcode);
          // assign value to some input (or do whatever you want)
          var field = $("[name$='[barcode]']:last");
          field.val(barcode);
          $.getJSON("/book_copies/"+barcode+".json", null, function (data) {
            console.log(data);
            book = data.book_copy;
            $(".titles:last").html(book.book_edition.title);
            $(".add_fields").trigger('click');
          }).fail(function(){
            Materialize.toast("Invalid barcode.", 4000, 'red');
          });
        }
        chars = [];
        pressed = false;
      },500);
    }
    pressed = true;
  });
  $(document).on("keypress","[name$='[barcode]']", (function(e){
    if ( e.which === 13 ) {
      e.preventDefault();
      $.getJSON("/book_copies/"+$(e.target).val()+".json", null, function (data) {
        console.log(data);
        book = data.book_copy;
        $(".titles:last").html(book.book_edition.title);
        $(".add_fields").trigger('click');
        $("[name$='[barcode]']:last").focus();
      }).fail(function(){
        Materialize.toast("Invalid barcode.", 5000, 'red');
      });
    }
  }));
});
`
