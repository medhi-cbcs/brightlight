var Shuttles = React.createClass({
  render: function() {
    return(
      <div className='container'>
      	<h5>Shuttle Cars</h5>
        {
          this.props.data.map(function(transport) {
            return <Transport key={transport.id} data={transport} />
          })
        }
      </div>
    );
  }
});
