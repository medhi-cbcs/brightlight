var Carpool = React.createClass({
  getInitialState: function() {
    return {
      shuttles: this.props.shuttles,
      privateCars: this.props.privateCars,
      departedCars: this.props.departedCars,
      waitingList: this.props.waitingList
    };
  },
  getDefaultProps: function() {
    return { shuttles:[], privateCars:[], departedCars:[], waitingList:[] };
  },

  componentDidMount: function() {
    $("#carpool_scanner").codeScanner({
      minEntryChars: 10,
      onScan: function($element, barcode){
        carpool_scanner($element, barcode);
      }
    });
  },

  addCarpool: function(transport, category) {
    var transports;
    if (category==='PrivateCar') {
      transports = React.addons.update(this.state.privateCars, { $push: [transport] });
      this.setState({ privateCars: transports });
    } else if (category==='Shuttle') {
      transports = React.addons.update(this.state.shuttles, { $push: [transport] });
      this.setState({ shuttles: transports });
    }
  },
  deleteCarpool: function(transport, category) {
    if (category==='PrivateCar') {
      var index = this.state.privateCars.indexOf(transport);
      var transports = React.addons.update(this.state.privateCars,
                                        { $splice: [[index, 1]] });
      this.replaceState({ privateCars: transports});
    } else if (category==='Shuttle') {
      var index = this.state.shuttles.indexOf(transport);
      var transports = React.addons.update(this.state.shuttles,
                                        { $splice: [[index, 1]] });
      this.replaceState({ shuttles: transports});
    }
  },

  render: function() {
    return(
      <div className='carpool'>
        <nav>
          <div className='nav-wrapper'>
            <div className='brand-logo' style={{marginLeft: '20px', fontSize:'1.5em'}}>Carpool</div>
            <ul className='right'>
              <li>
                <div className='input-field'>
                  <AutoUpdate />
                </div>
              </li>
            </ul>
          </div>
        </nav>

        <div className='card carpool'>
          <Tabs className='tabs z-depth-1'>
            <Tab title="Shuttle Cars"><Shuttles data={this.props.shuttles} /></Tab>
            <Tab title="Car Riders"><PrivateCars data={this.props.privateCars} /></Tab>
            <Tab title="Waiting"><WaitingList data={this.props.waitingList} /></Tab>
            <Tab title="Done"><DepartedCars data={this.props.departedCars} /></Tab>
          </Tabs>
        </div>
        <input id='carpool_scanner' disabled='true' />
      </div>
    )
  }
});
