
var Tabs = React.createClass({
  componentDidMount: function() {
    if (typeof $ !== 'undefined') {
      $(this.tabsEl).tabs()
    }
  },
  _onSelect: function(idx, e) {
    if (this.props.hasOwnProperty('onChange')) {
      this.props.onChange(idx, e)
    }
  },
  render: function() {
    return (
      <Row>
        <Col s={12}>
          <ul className='tabs'>
            {
              React.Children.map(this.props.children, function (child, idx) {
                var _child$props = child.props;
                var title = _child$props.title;
                var tabWidth = _child$props.tabWidth;
                var className = _child$props.className;
                var active = _child$props.active;
                var disabled = _child$props.disabled;
                var defaultValue = _child$props.defaultValue;
                //if (!tabWidth) {
                //  tabWidth = Math.floor(12 / count);
                //}
                var classes = {
                  tab: true,
                  disabled: disabled,
                  col: true
                };
                if (tabWidth) classes['s' + tabWidth] = true;
                var target = '#tab_' + idx;
                return (
                  <li className={classNames(classes)} key={idx}>
                    <a href={target} className={active || defaultValue === idx ? 'active' : ''}>
                      {title}
                    </a>
                  </li>
                );
              })
            }
          </ul>
        </Col>
        {
          React.Children.map(this.props.children, function (child, idx) {
            return <div id={'tab_' + idx} s={12} key={'tab' + idx}>{child.props.children}</div>;
          })
        }
      </Row>
    );
  }
});
