jQuery(function ($) {
	'use strict';

  var App = {
		init: function () {
      this.carpoolList = [];
      this.autoPolling = false;
      this.carpoolTemplate = $("#carpool-template");
      this.waitingTemplate = '';
      this.bindEvents();
      localStorage.carpoolMark = (new Date().setHours(0,0,0,0)/1000) >> 0;
      this.poll();
    },
    bindEvents: function () {
      $("#carpool_scanner").codeScanner({
        minEntryChars: 10,
        onScan: function($element, barcode){
          carpool_scanner($element, barcode);
        }
      });
      $("#auto_update").on("change", this.checkPoll.bind(this));
      $(".carpool").on("change", "[name^='car-done']", this.carMoves.bind(this));
    },
    getShuttleCars: function() {
      this.carpoolList.filter(function(carpool){
        return carpool.category == "Shuttle";
      })
    },
    getPrivateCars: function() {
      this.carpoolList.filter(function(carpool){
        return carpool.category == "PrivateCar";
      })
    },
    getDoneCars: function() {
      this.carpoolList.filter(function(carpool){
        return carpool.status == "done";
      })
    },
    getWaitingList: function() {

    },
    create: function(car) {
      var htmlStr = this.carpoolTemplate.html()
                    .replace(/__carpool.id_/g, car.id)
                    .replace(/__carpool.transport_name_/g, car.transport_name)
                    .replace(/__carpool.status_/g, car.status);
      if (car.status == 'done') {
        $("#exit-carpool").append(htmlStr);
      } else if (car.category == 'Shuttle') {
        $("#shuttle-cars").append(htmlStr);
      } else if (car.category == 'PrivateCar') {
        $("#private-cars").append(htmlStr);
      }
    },
    update: function(car) {
      var target = $("#car-"+car.id);
      target.removeClass('ready leaving loading waiting done');
      target.addClass(car.status);
      if (car.status == 'done') {
        target.fadeOut('slow', function(){ target.remove(); });
        $("#exit-carpool").append(htmlStr);
      } 
      if (car.status == 'ready' && $("#exit-carpool").has(target).length > 0) {
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
      this.updateWaitingList(car.late_passengers);
    },
    createOrUpdate: function(car) {
      if (carpoolList.includes(car)) {
        this.update(car);
      } else {
        this.create(car);
      }
    },
    carMoves: function() {
      console.log("Car "+ $(this).prop("checked") ? "leaving" : "returning");
      var car_id = $(this).data('id');
      var car_status = $(this).prop("checked") ? "done" : "ready";
      this.updateCarStatus(car_id, car_status);
    },
    updateCarStatus: function (id, status) {
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
          this.update(data.carpool);
          console.log('Updated');
        },
        error: function() {
          Materialize.toast("Sorry...I'm confused", 5000, 'red');
        }
      });
    },
    poll: function() {
      var timeout = 3600; // 1 hour
      var timedelay = 5000;
      var now = new Date().getTime() / 1000 >> 0;
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
        if (now-ts < timeout && this.autoPolling) {
          setTimeout(poll, timedelay)
        //} else {
        };
      });
    },
    togglePolling: function() {
      if (! this.autoPolling) {
        this.poll();
        this.autoPolling = true;
      } else {
        localStorage.carpool_ts = new Date().getTime() / 1000 >> 0;
        this.autoPolling = false;
      }
    },
    scan: function (el,barcode) {
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
          this.queue(car);
          localStorage.carpool_mark = (Date.parse(car.created_at)/1000) >> 0;
        },
        error: function() {
          Materialize.toast('Error: invalid barcode', 5000, 'red');
        }
      });
    },
    queue: function(car) {
      Object.defineProperties(car, {
        "status": { set: function(s) {
          
        }}
      });
      this.carpoolList.push(car);
      this.create(car);
    },
    updateWaitingList: function(latePassengers) {
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
  };

  App.init();

});