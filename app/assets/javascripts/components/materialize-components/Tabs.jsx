
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
    //let {children, className, defaultValue, ...props} = this.props;
    return (
      <Row>
        <Col s={12}>
          <ul className={tabs} ref={function(_ref){return _this2.tabsEl = _ref;}}>
            {
              React.Children.map(children, function (child, idx) {
                var _child$props = child.props;
                var title = _child$props.title;
                var tabWidth = _child$props.tabWidth;
                var className = _child$props.className;
                var active = _child$props.active;
                var disabled = _child$props.disabled;
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
                return React.createElement(
                  'li',
                  { className: cx(classes, className), key: idx },
                  React.createElement(
                    'a',
                    _extends({ href: target, className: active || defaultValue === idx ? 'active' : ''
                    }, disabled ? {} : { onClick: _this2._onSelect.bind(_this2, idx) }),
                    title
                  )
                );
              })
            }
          </ul>
        </Col>
        {
          React.Children.map(children, function (child, idx) {
            return <Col id={'tab_' + idx} s={12} key={'tab' + idx}>{child.props.children}</Col>;
          })
        }
      </Row>
    );
  }
});
