var CarpoolApp = (function(){
  
  var Transport = {
    id:'',
    transportName: '',
    _status: 'ready',
    expectedPassengers: [],
    
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
      // console.log("Rendered transport "+this.transportName+" with status "+this.status+" in "+container.selector);
    },

    set status(s) {
      if (this._status != s) {
        console.log("Changing status from "+this.status+" to "+s); 
        this._status = s;
        this.node().removeClass('ready leaving loading waiting done')
          .addClass(this._status);
        // console.log("Now, "+this._status+" check: "+$("#car-done-"+this.id).prop("checked"));
        if (s == 'done' || (this._status == "ready" && $("#exit-carpool").has(this.node()).length > 0)) {
          var transport = this;
          this.node().fadeOut('slow', function(){ 
            this.remove(); 
            transport.render(); 
            console.log("Element removed! status: "+transport.status); 
          });      
        }
        this.uploadStatus();
      }      
    },

    get status() {
      return this._status;
    },

    getPax: function(paxId) {
      return this.expectedPassengers.find(function(pax) {
        return pax.id == paxId;
      })
    },

    uploadStatus: function () {
      url = "/carpools/" + this.id;
      var dataToSend = new Object();
      dataToSend = { carpool: {
                      status: this.status
                   } };
      var jsonData = JSON.stringify(dataToSend);
      $.ajax({
        type: 'PATCH',
        contentType: "application/json; charset=utf-8",
        url: url,
        data: jsonData,
        dataType: 'json',
        success: function(data) {
          console.log("Car status uploaded: "+status);
          // Carpool.update(data.carpool);        
        },
        error: function() {
          Materialize.toast("Sorry...I'm confused", 5000, 'red');
        }
      });
    },

    updateExpectedPassengers: function(passengers){
      console.log("Updating list of expected passengers");
      console.log(passengers);
      var transport = this;
      if (passengers) {
        $.each(passengers, function(idx, pax){
          var passenger = transport.getPax(pax.id);
          if (passenger) {
            console.log("Found passenger " + passenger.name);
            passenger.status = pax.status;
            if (pax.status == false) {
              console.log("Removing pax "+pax.name+" from "+this.transportName);
              transport.removeExpectedPax(pax.id);
            }      
          } else {
            console.log("Adding passenger " + pax.name);
            var listEntry = ExpectedPax.init(transport, pax);
            transport.expectedPassengers.push(listEntry);
            listEntry.render();
          }
        });
      }      
    },

    updateExpectedPassengerStatus: function(id, status){
      var pax = this.getPax(id);
      if (pax) pax.status = status;
      if (!status) this.removeExpectedPax(pax.id);
    },

    removeExpectedPax: function(paxId) {
      var pax = this.getPax(paxId);
      var index = this.expectedPassengers.indexOf(pax);
      if (index > -1) {
        this.expectedPassengers.splice(index,1);
      }
      if (this.expectedPassengers.length == 0) {
        console.log('No more waiting for passengers: '+this.transportName);
        this.status = 'done';
      }
    }
  };

  var ExpectedPax = {
    id:'',
    name: '',
    grade: '',
    transportName: '',
    transportId: '',
    _active: false,

    init: function(transport, passenger) {      
      var listEntry = Object.create(ExpectedPax);
      listEntry.id = passenger.id;    
      listEntry._active = passenger.status;
      listEntry.name = passenger.name;
      listEntry.grade = passenger.grade;
      listEntry.transportId = transport.id;
      listEntry.transportName = transport.transportName; 
      return listEntry;
    },
    
    template: function() { return $("#expected-pax-template") },
    
    htmlStr: function() { return this.template().html()
              .replace(/__transport.name_/g, this.transportName)
              .replace(/__transport.id_/g, this.transportId)
              .replace(/__pax.id_/g, this.id)
              .replace(/__pax.name_/g, this.name)
              .replace(/__pax.grade_/g, this.grade);
    },  
    
    node: function() { return $("#pax-" + this.id) },
    
    statusCheckBox: function() { return $("#pax-status-" + this.id) },
    
    render: function() {
      // console.log("Rendered pax " + this.name);
      var container = $("#expected-pax-list");
      container.append(this.htmlStr());
      this.statusCheckBox().prop("checked", this.status);
    },
    
    set status(s) { 
      if (this._active != s) {
        this._active = s;
        if (s == false) {          
          this.node().fadeOut('slow', function(){ 
            this.remove();        
          });      
        }
        this.uploadStatus();
      }      
    },
    
    get status() {
      return this._active;
    },

    uploadStatus: function () {
      url = "/pax/" + this.id;
      var dataToSend = new Object();
      dataToSend = { late_passenger: { active: this.status } };
      var jsonData = JSON.stringify(dataToSend);
      $.ajax({
        type: 'PATCH',
        contentType: "application/json; charset=utf-8",
        url: url,
        data: jsonData,
        dataType: 'json',
        success: function(data) {
          console.log("Pax status uploaded.");     
        },
        error: function() {
          Materialize.toast("Sorry...I'm confused", 5000, 'red');
        }
      });
    },

  };

  var Carpool = {
    init: function () {
      Carpool.carpoolList = [];
      Carpool.autoPolling = false;
      Carpool.bindEvents();
      localStorage.carpool_mark = (new Date().setHours(0,0,0,0)/1000) >> 0;
      Carpool.poll();
    },

    bindEvents: function () {
      $("#carpool_scanner").codeScanner({
        minEntryChars: 9, 
        maxEntryTime: 500,
        onScan: function($element, barcode){
          console.log("Scanned "+barcode);
          Carpool.handleScan($element, barcode);
        }
      });
      $("#auto_update").on("change", Carpool.togglePolling.bind(this));
      $(".carpool").on("change", "[name^='car-done']", Carpool.carMoves.bind(this));
      $(".carpool").on("change", "[name^='pax-status']", Carpool.paxMoves.bind(this));
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
          Carpool.create(car);
          localStorage.carpool_mark = (Date.parse(car.created_at) / 1000) >> 0;
        },
        error: function() {
          Materialize.toast('Error: invalid barcode', 5000, 'red');
        }
      });
    },

    getShuttleCars: function() {
      Carpool.carpoolList.filter(function(carpool){
        return carpool.category == "shuttle";
      })
    },

    getPrivateCars: function() {
      Carpool.carpoolList.filter(function(carpool){
        return carpool.category == "private";
      })
    },

    getDoneCars: function() {
      Carpool.carpoolList.filter(function(carpool){
        return carpool.status == "done";
      })
    },

    getWaitingList: function() {

    },

    getTransport: function(transportId) {
      return Carpool.carpoolList.find(function(transport) {
        return transport.id == transportId;
      })
    },

    create: function(car) {
      var transport = Object.create(Transport);
      transport.category = car.category;
      transport._status = car.status;
      transport.id = car.id;
      transport.transportName = car.transport_name;
      Carpool.carpoolList.push(transport);
      transport.render();
      if (car.late_passengers) {
        $.each(car.late_passengers, function(idx, passenger) {
          var listEntry = ExpectedPax.init(transport, passenger);
          transport.expectedPassengers.push(listEntry);
          listEntry.render(); 
        });
      }
    },

    update: function(car) {      
      var transport = Carpool.getTransport(car.id);
      console.log('Updating '+transport.transportName);
      transport.updateExpectedPassengers(car.late_passengers);
      transport.status = car.status;      
    },

    createOrUpdate: function(car) {
      if (Carpool.getTransport(car.id)) {
        Carpool.update(car);
      } else {
        Carpool.create(car);
      }
    },

    carMoves: function(e) {
      var $el = $(e.target);       
      var carId = $el.data('id');
      var transport = Carpool.getTransport(carId);
      transport.status = $el.prop("checked") ? "done" : "ready";
    },

    poll: function() {
      var timeout = 3600; // 1 hour
      var timedelay = 5000;
      var now = new Date().getTime() / 1000 >> 0;
      $.getJSON('/carpools/poll?lpax=1&since='+localStorage.carpool_mark, null, function(data) {
        if (data.length > 0) {
          $.each(data, function(i,car){
            Carpool.createOrUpdate(car);
          });
          localStorage.carpool_ts = now;
        }
        localStorage.carpool_mark = now;
        if (localStorage.carpool_ts == null || localStorage.carpool_ts == "null"){
          localStorage.carpool_ts = now;
        }
        ts = parseInt(localStorage.carpool_ts);
        if (now-ts < timeout && Carpool.autoPolling) {
          setTimeout(Carpool.poll, timedelay)
        };
      });
    },

    togglePolling: function() {
      if (! Carpool.autoPolling) {
        Carpool.poll();
        Carpool.autoPolling = true;
      } else {
        localStorage.carpool_ts = new Date().getTime() / 1000 >> 0;
        Carpool.autoPolling = false;
      }
    },

    paxMoves: function(e) {
      var el = e.target;
      var $el = $(el);       
      var paxId = $el.data('id');
      var paxStatus = $el.prop("checked");
      var transportId = $el.data('transport');      
      var transport = Carpool.getTransport(transportId);
      transport.updateExpectedPassengerStatus(paxId, paxStatus);
    }

  };

  return Carpool;
})();