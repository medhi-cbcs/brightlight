# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

function filterSectionOptions(id, name) {
  var grade_ids = #{raw @grade_level_ids};
  $("#grade").html("Grade "+name);
  grade_ids.forEach(function(g){
    if(id!=g) {
      $(".grade-"+g).hide();
    } else {
      $(".grade-"+id).show();
    }
  })
}
function filterStudentOptions(id, name) {
  $("#section").html("Section "+name);
  $.getJSON("/students.json?section="+id, null, function (data) {
    console.log("Parsing /students.json?section="+id);
    var list = "";
    $.each(data, function(i,item){
        list += "<li><a href='/student_books?st="+item.id+"'>"+item.name+"</a></li>";
    });
    $("#student-options").html(list);
  });
}
