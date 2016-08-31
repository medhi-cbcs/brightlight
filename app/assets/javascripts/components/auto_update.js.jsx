var AutoUpdate = React.createClass({
  _clicked: function() {
  },
  render: function() {
    return(
      <span onClick={this._clicked}>
        <input type="checkbox" id='auto_update'/>
        <label htmlFor='auto_update'>Auto Update </label>
      </span>
    );
  }
});
