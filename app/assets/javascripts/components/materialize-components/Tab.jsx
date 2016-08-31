// This is just a holder for the props and children for tab, thus
// there is no logic here.
var Tab = React.createClass({
  render: function(){
    return React.createElement(null);
  }
});

Tab.propTypes = {
  /**
  * The title shown in the tabs list
  */
  title: React.PropTypes.node.isRequired,
  /**
  * The width of the Tab
  */
  tabWidth: React.PropTypes.number,
  /**
  * Pre-select the tab
  * @default false
  */
  active: React.PropTypes.bool,
  /**
  * Disable the tab
  * @default false
  */
  disabled: React.PropTypes.bool
};

Tab.defaultProps = {
  active: false,
  disabled: false
};
