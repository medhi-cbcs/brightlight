// This is just a holder for the props and children for tab, thus
// there is no logic here.
var Tab = React.createClass({
  propTypes: {
    title: React.PropTypes.node.isRequired,
    tabWidth: React.PropTypes.number,
    active: React.PropTypes.bool,
    disabled: React.PropTypes.bool
  },
  getDefaultProps: function(){
    return {
      active: false,
      disabled: false
    }
  },
  render: function(){
    return React.createElement(null);
  }
});


