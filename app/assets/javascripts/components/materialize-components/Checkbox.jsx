'use strict';

var Checkbox = React.createClass({
  getDefaultProps: function() {
    return { id:'1', checked:true, label:' ' }
  },
  // componentDidMount: function() {
  //   if (typeof $ !== 'undefined') {
  //     $(this).tabs()
  //   }
  // }
  onChange: function(e) {
    this.setState({
      value: e.target.type === 'checkbox' ? e.target.checked : e.target.value
    });

    if (this.props.onChange) {
      this.props.onChange(e);
    }
  },
  render: function() {
    return(
      <div>
        <input type="checkbox" id={this.props.id} checked={this.props.checked}/>
        <label htmlFor={this.props.id}>{this.props.label}</label>
      </div>
    );
  }
});
