var Transport = React.createClass({
  getInitialState: function() {
    return { data: this.props.data };
  },
  render: function() {
    return(
      <Col s={12} m={2} l={3}>
        <div id={this.state.data.id} className={'entry '+this.state.data.status}>
          <div className='input-field left' style={{'marginTop':'-10px'}}>
            <div className='cb-label'>Done</div>
            <Checkbox id={'car-done-'+this.state.data.id} />
          </div>
          {this.state.data.transport_name != null ? this.state.data.transport_name : '???' }
        </div>
      </Col>
    );
  }
});

/* Example */
// var Vehicle = React.createClass({
// });
//
// var Airplane = React.createClass({
//     methodA: function() {
//       if (this.refs != null) return this.refs.vehicle.methodA();
//     },
//     render: function() {
//         return (
//             <Vehicle ref="vehicle">
//                 <h1>J/K I'm an airplane</h1>
//             </Vehicle>
//         );
//     }
// });
