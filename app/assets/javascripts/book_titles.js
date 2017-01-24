$('#book_title')
  .on('cocoon:after-insert', function(e, added_task) {
    //$("#placemark").scrollTo();
    $('select').material_select();
  })
