var Transport = {
  id:'',
  transportName: '',
  _status: 'ready',
  template: function() { return $("#carpool-template") },
  htmlStr: function() { return this.template().html()
            .replace(/__carpool.id_/g, this.id)
            .replace(/__carpool.transport_name_/g, this.transportName)
            .replace(/__carpool.status_/g, this.status);
  },  
  node: function() { return $("#car-" + this.id) },
  doneCheckBox: function() { return $("#car-done-" + this.id) },
  render: function() {
    var container;
    if (this.status == 'done') {
      container = $("#exit-carpool");
    } else if (this.category == 'private') {
      container = $("#private-cars");
    } else if (this.category == 'shuttle') {
      container = $("#shuttle-cars");
    }
    container.append(this.htmlStr());
    this.doneCheckBox().prop("checked", this.status == 'done');
    console.log("Rendered transport "+this.transportName+" with status "+this.status+" in "+container.selector);
  },
  set status(s) {
    console.log("Changing status from "+this.status+" to "+s); 
    this._status = s;
    this.node().removeClass('ready leaving loading waiting done')
      .addClass(this._status);
    console.log("Now, "+this._status+" check: "+$("#car-done-"+this.id).prop("checked"));
    if (s == 'done' || (this._status == "ready" && $("#exit-carpool").has(this.node()).length > 0)) {
      var transport = this;
      this.node().fadeOut('slow', function(){ 
        this.remove(); 
        transport.render(); 
        console.log("Element removed! status: "+transport.status); 
      });      
    }
  },
  get status() {
    return this._status;
  }
};

var CarpoolApp = {
  init: function () {
    CarpoolApp.carpoolList = [];
    CarpoolApp.autoPolling = false;
    // CarpoolApp.carpoolTemplate = $("#carpool-template");
    // CarpoolApp.waitingTemplate = '';
    CarpoolApp.bindEvents();
    localStorage.carpool_mark = (new Date().setHours(0,0,0,0)/1000) >> 0;
    CarpoolApp.poll();
  },

  bindEvents: function () {
    $("#carpool_scanner").codeScanner({
      minEntryChars: 9, 
      maxEntryTime: 500,
      onScan: function($element, barcode){
        console.log("Scanned "+barcode);
        CarpoolApp.handleScan($element, barcode);
      }
    });
    $("#auto_update").on("change", CarpoolApp.togglePolling.bind(this));
    $(".carpool").on("change", "[name^='car-done']", CarpoolApp.carMoves.bind(this));
  },

  handleScan: function (el, barcode) {
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
        Materialize.toast('Welcome! ' + car.id + '-' + car.transport_name, 5000, 'green');        
        CarpoolApp.create(car);
        localStorage.carpool_mark = (Date.parse(car.created_at) / 1000) >> 0;
      },
      error: function() {
        Materialize.toast('Error: invalid barcode', 5000, 'red');
      }
    });
  },

  // queue: function(car) {    
  //   CarpoolApp.create(car);    
  // },

  getShuttleCars: function() {
    CarpoolApp.carpoolList.filter(function(carpool){
      return carpool.category == "shuttle";
    })
  },

  getPrivateCars: function() {
    CarpoolApp.carpoolList.filter(function(carpool){
      return carpool.category == "private";
    })
  },

  getDoneCars: function() {
    CarpoolApp.carpoolList.filter(function(carpool){
      return carpool.status == "done";
    })
  },

  getWaitingList: function() {

  },

  create: function(car) {
    console.log('Creating: '+car.transport_name+', status:'+car.status+', category:'+car.category);
    var transport = Object.create(Transport);
    transport.category = car.category;
    transport._status = car.status;
    transport.id = car.id;
    transport.transportName = car.transport_name;
    CarpoolApp.carpoolList.push(transport);
    transport.render();
  },

  update: function(car) {
    console.log('Updating: '+car.transport_name+', status:'+car.status+', category:'+car.category);
    var transport = CarpoolApp.carpoolList.find(function(c){ return c.id == car.id; });
    console.log("Car "+transport.transportName+" Done? " + transport.doneCheckBox().prop("checked"));
    transport.status = car.status;
    CarpoolApp.updateWaitingList(car.late_passengers);
  },

  createOrUpdate: function(car) {
    if (CarpoolApp.carpoolList.find(function(transport) {return transport.id == car.id })) {
      console.log("Updating "+car.transport_name);
      CarpoolApp.update(car);
    } else {
      console.log("Creating "+car.transport_name);
      CarpoolApp.create(car);
    }
  },

  carMoves: function(e) {
    var el = e.target;
    var $el = $(el);       
    var carId = $el.data('id');
    var carStatus = $el.prop("checked") ? "done" : "ready";
    // console.log("Car "+ ($el.prop("checked") ? "leaving" : "returning"));
    CarpoolApp.uploadCarStatus(carId, carStatus);
  },

  uploadCarStatus: function (id, status) {
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
        CarpoolApp.update(data.carpool);        
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
          CarpoolApp.createOrUpdate(car);
          CarpoolApp.updateWaitingList(car.late_passengers);
        });
        localStorage.carpool_ts = now;
      }
      localStorage.carpool_mark = now;
      if (localStorage.carpool_ts == null || localStorage.carpool_ts == "null"){
        localStorage.carpool_ts = now;
      }
      ts = parseInt(localStorage.carpool_ts);
      if (now-ts < timeout && CarpoolApp.autoPolling) {
        setTimeout(CarpoolApp.poll, timedelay)
      //} else {
      };
    });
  },

  togglePolling: function() {
    console.log("Toggle polling");
    if (! CarpoolApp.autoPolling) {
      CarpoolApp.poll();
      CarpoolApp.autoPolling = true;
    } else {
      localStorage.carpool_ts = new Date().getTime() / 1000 >> 0;
      CarpoolApp.autoPolling = false;
    }
  },

  updateWaitingList: function(latePassengers) {
    //console.log("Update waiting list: "+late_passengers);
    if (latePassengers && latePassengers.length > 0) {
      $.each(latePassengers, function(i, pax) {
        var target = $("#wait-pax-" + pax.id);
        if (target.length == 0 && pax.active) {
          //console.log("Waiting list: adding "+pax.name);
          var htmlStr = "<div class='wait-pax' id='wait-pax-" + pax.id + "'>" + pax.name + " (" + pax.class + ")</div>";
          $("#waiting-list").append(htmlStr);
        } else if (!pax.active) {
          //console.log("Waiting list: removing "+pax.name);
          target.fadeOut('slow', function(){ target.remove(); });
        }
      });
    }
  }

};
