'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }

var Col = function Col(_ref) {
  var children = _ref.children;
  var className = _ref.className;
  var _ref$node = _ref.node;
  var C = _ref$node === undefined ? 'div' : _ref$node;
  var s = _ref.s;
  var m = _ref.m;
  var l = _ref.l;
  var offset = _ref.offset;

  var other = _objectWithoutProperties(_ref, ['children', 'className', 'node', 's', 'm', 'l', 'offset']);

  var sizes = { s: s, m: m, l: l };
  var classes = { col: true };
  constants.SIZES.forEach(function (size) {
    classes[size + sizes[size]] = sizes[size];
  });

  if (offset) {
    offset.split(' ').forEach(function (off) {
      classes['offset-' + off] = true;
    });
  }

  return React.createElement(
    C,
    _extends({}, other, { className: cx(classes, className) }),
    children
  );
};

Col.propTypes = {
  children: React.PropTypes.node,
  className: React.PropTypes.string,
  /**
   * Columns for large size screens
   */
  l: React.PropTypes.number,
  /**
   * Columns for middle size screens
   */
  m: React.PropTypes.number,
  /**
   * The node to be used for the column
   * @default div
   */
  node: React.PropTypes.node,
  /**
   * To offset, simply add s2 to the class where s signifies the screen
   * class-prefix (s = small, m = medium, l = large) and the number after
   * is the number of columns you want to offset by.
   */
  offset: React.PropTypes.string,
  /**
   * Columns for small size screens
   */
  s: React.PropTypes.number
};
