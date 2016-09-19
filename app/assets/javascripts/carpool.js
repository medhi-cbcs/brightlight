/* Carpool */

var carpoolList = [];
function carpool_scanner(el,barcode) {
  url = "/carpools";
  var dataToSend = new Object();
  dataToSend = { carpool: { barcode: barcode }};
  var jsonData = JSON.stringify(dataToSend);
  $.ajax({
    type: 'POST',
    contentType: "application/json; charset=utf-8",
    url: url,
    data: jsonData,
    dataType: 'json',
    success: function(data) {
      var car = data.carpool;
      Materialize.toast('Welcome! '+car.id+'-'+car.transport_name, 5000, 'green');
      updateCarpoolInfo(car);
      localStorage.carpool_mark = (Date.parse(car.created_at)/1000) >> 0;
    },
    error: function() {
      Materialize.toast('Error: invalid barcode', 5000, 'red');
    }
  });
}

function checkPoll(){
  if ($("#auto_update").prop("checked")) {
    poll();
  } else {
    localStorage.carpool_ts = new Date().getTime() / 1000 >> 0;
  }
}

// poll() function will ask for new data since last time it ran every timedelay seconds
// It will timeout itself after 1 hour without any new data
function poll() {
  var timeout = 3600; // 1 hour
  var timedelay = 5000;
  var now = new Date().getTime() / 1000 >> 0;
  var autoCheck = ($("#auto_update").prop("checked"));
  $.getJSON('/carpools/poll?lpax&since='+localStorage.carpool_mark, null, function(data) {
    if (data.length > 0) {
      $.each(data, function(i,car){
        updateCarpoolInfo(car);
        updateWaitingList(car.late_passengers);
      });
      localStorage.carpool_ts = now;
    }
    localStorage.carpool_mark = now;
    if (localStorage.carpool_ts == null || localStorage.carpool_ts == "null"){
      localStorage.carpool_ts = now;
    }
    ts = parseInt(localStorage.carpool_ts);
    if (now-ts < timeout && autoCheck) {
      setTimeout(poll, timedelay)
    //} else {
    };
  });
}

function carMoves() {
  console.log("Car "+ $(this).prop("checked") ? "leaving" : "returning");
  updateCarStatus($(this).data('id'), $(this).prop("checked") ? "done" : "ready");
}

function updateCarStatus(id, status) {
  url = "/carpools/" + id + "?lpax";
  var dataToSend = new Object();
  dataToSend = { carpool: { status: status }};
  var jsonData = JSON.stringify(dataToSend);
  $.ajax({
    type: 'PATCH',
    contentType: "application/json; charset=utf-8",
    url: url,
    data: jsonData,
    dataType: 'json',
    success: function(data) {
      updateCarpoolInfo(data.carpool);
      console.log('Updated');
    },
    error: function() {
      Materialize.toast("Sorry...I'm confused", 5000, 'red');
    }
  });
}

function updateCarpoolInfo(car) {  
  var idx = $.inArray(car,carpoolList);
  if (idx >= 0) {
    carpoolList[idx].status = car.status;
  } else {
    Object.defineProperties(car, {
      "status": { set: function(s) {
        
      }}
    });
    carpoolList.push(car);
  }
  var target = $("#car-"+car.id);
  var htmlStr = $("#carpool-template").html()
    .replace(/__carpool.id_/g, car.id)
    .replace(/__carpool.transport_name_/g, car.transport_name)
    .replace(/__carpool.status_/g, car.status);
  if (target.length == 0) {
    if(car.category=='PrivateCar') {
      $("#private-cars").append(htmlStr);
    } else if (car.category=='Shuttle') {
      $("#shuttle-cars").append(htmlStr);
    }
  } else {
    target.removeClass('ready leaving loading waiting done');
    target.addClass(car.status);
  }
  if (car.status == "done") {
    target.fadeOut('slow', function(){ target.remove(); });
    $("#exit-carpool").append(htmlStr);
  }
  if (car.status == "ready" && $("#exit-carpool").has(target).length > 0) {
    target.fadeOut('slow', function(){ target.remove(); });
    if(car.category=='PrivateCar') {
      $("#private-cars").append(htmlStr);
    } else if (car.category=='Shuttle') {
      $("#shuttle-cars").append(htmlStr);
    }
  }
  console.log("Car "+car.transport_name+" Done? "+$("#car-done-"+car.id).prop("checked"));
  console.log("Status? "+car.status);
  $("#car-done-"+car.id).prop("checked", car.status == 'done');
  console.log("Now, "+car.id+" check: "+$("#car-done-"+car.id).prop("checked"));
  updateWaitingList(car.late_passengers);
}

function updateWaitingList(latePassengers) {
  //console.log("Update waiting list: "+late_passengers);
  if (latePassengers && latePassengers.length > 0) {
    $.each(latePassengers, function(i,pax) {
      var target = $("#wait-pax-" + pax.id);
      if (target.length == 0 && pax.active) {
        //console.log("Waiting list: adding "+pax.name);
        var html_str = "<div class='wait-pax' id='wait-pax-" + pax.id + "'>" + pax.name + " (" + pax.class + ")</div>";
        $("#waiting-list").append(html_str);
      } else if (!pax.active) {
        //console.log("Waiting list: removing "+pax.name);
        target.fadeOut('slow', function(){ target.remove(); });
      }
    });
  }
}

function carpoolDocumentReady(){
  $("#carpool_scanner").codeScanner({
    minEntryChars: 10,
    onScan: function($element, barcode){
      carpool_scanner($element, barcode);
    }
  });
  $("#auto_update").on("change", checkPoll);
  $(".carpool").on("change", "[name^='car-done']", carMoves);
  // $("[name^='car-wait']").on("change", car_to_wait_list);
  localStorage.carpoolMark = (new Date().setHours(0,0,0,0)/1000) >> 0;
  poll();
}


// function car_waiting() {
//   var id = $(this).data('id');
//   $.getJSON("/carpools/"+id, function(data){
//     var car = data.carpool;
//     var pax_list = "";
//     $.each(car.passengers, function(idx, passenger){
//       pax_list += $("#pax-list-template").html()
//         .replace(/__pax.id_/g, passenger.id)
//         .replace(/__pax.name_/g, passenger.name)
//         .replace(/__pax.class_/g, passenger.class);
//     });
//     var html_str = $("#carpool-passenger-template").html()
//       .replace(/__passengers.list_/i, pax_list);
//     $("#show-modal").html(html_str);
//     $("#show-modal").openModal();
//   });
// }

// function car_to_wait_list() {
//   var id = $(this).data('id');
//   $.ajax({
//     url: "/carpools/" + id + "/edit",
//     success: function(data) {
//       update_carpool_info(data.carpool);
//       update_waiting_list(data.carpool.late_passengers);
//     },
//     error: function() {
//       Materialize.toast("Sorry...I'm confused", 5000, 'red');
//     }
//   });
// }
