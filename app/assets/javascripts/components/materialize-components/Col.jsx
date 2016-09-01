'use strict';
'use strict';

var Col = React.createClass({
  propTypes: {
    l: React.PropTypes.number,
    m: React.PropTypes.number,
    s: React.PropTypes.number,
     /* To offset, simply add s2 to the class where s signifies the screen
     * class-prefix (s = small, m = medium, l = large) and the number after
     * is the number of columns you want to offset by.
     */
    offset: React.PropTypes.string
  },
  render: function() {
    return(
      <div {...this.props} 
        className={'col'+' s'+this.props.s+' m'+this.props.m+' l'+this.props.l+' offset'+this.props.offset}>
        {this.props.children}
      </div>
    )
  }
});