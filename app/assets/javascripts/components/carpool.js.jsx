var Carpool = React.createClass({
  render: function() {
    return(
      <div className='carpool'>
        <nav>
          <div className='nav-wrapper'>
            <div className='brand-logo' style={{marginLeft: '20px', fontSize:'1.5em'}}>Carpool</div>
            <ul className='right'>
              <li>
                <div className='input-field'>
                  <AutoUpdate />
                </div>
              </li>
            </ul>
          </div>
        </nav>
        
        <div className='card carpool'>
          <Tabs className='tabs z-depth-1'>
            <Tab title="Shuttle Cars"><Shuttles /></Tab>
            <Tab title="Car Riders"><PrivateCars /></Tab>
            <Tab title="Waiting"><WaitingList /></Tab>
            <Tab title="Done"><DepartedCars /></Tab>
          </Tabs>
        </div>
        
      </div>
    )
  }
});
