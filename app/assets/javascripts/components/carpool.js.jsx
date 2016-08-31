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
            <Tab title="Shuttle Cars">Shuttle Cars</Tab>
            <Tab title="Car Riders">Car Riders</Tab>
            <Tab title="Waiting">Waiting</Tab>
            <Tab title="Done">Done</Tab>
          </Tabs>;
          // <div className='row'>
          //   <ul className='tabs z-depth-1'>
          //     <li className='tab col s2'>
          //       <a href='#tab1'>Shuttle Cars</a>
          //     </li>
          //     <li className='tab col s2'>
          //       <a href='#tab2'>Car Riders</a>
          //     </li>
          //     <li className='tab col s2'>
          //       <a href='#tab3'>Waiting</a>
          //     </li>
          //     <li className='tab col s2'>
          //       <a href='#tab4'>Done</a>
          //     </li>
          //   </ul>
          //   <div id='tab1' className='tab-content'>
          //     <h4>Shuttle</h4>
          //   </div>
          //   <div id='tab2' className='tab-content'>
          //     <h4>Car Riders</h4>
          //   </div>
          //   <div id='tab3' className='tab-content'>
          //     <h4>Waiting</h4>
          //   </div>
          //   <div id='tab4' className='tab-content'>
          //     <h4>Done</h4>
          //   </div>
          // </div>
        </div>
      </div>
    )
  }
});

/*
nav
  .nav-wrapper
    .brand-logo style="margin-left: 20px; font-size:1.5em"
      = "Carpool (#{Date.today})"
    ul.right
      li
        .input-field
          = check_box_tag :auto_update
          = label_tag :auto_update

.card.carpool
  .row
    ul.tabs.z-depth-1
      li.tab.col.s2
        a href='#tab1' Shuttle Cars
      li.tab.col.s2
        a href='#tab2' Car Riders
      li.tab.col.s2
        a href='#tab3' Waiting
      li.tab.col.s2
        a href='#tab4' Done

    #tab1.tab-content
      #shuttle-cars
        - @carpools.active.shuttle_cars.each do |carpool|
          .col.s12.m6.l3
            .entry id="car-#{carpool.id}" class="cars #{carpool.status}"
              .input-field.left style="margin-top:-10px"
                .cb-label Done
                = check_box_tag "car-done-#{carpool.id}", 1, false, data: {id: carpool.id}
                = label_tag "car-done-#{carpool.id}", ""
              = carpool.transport.try(:name) || "???"
              .input-field.right style="margin-top:-10px"
                .cb-label Wait
                = link_to edit_carpool_path(carpool), remote: true
                  i.material-icons style="padding-top:9px; color:salmon" pause_circle_outline

    #tab2.tab-content
      #private-cars
        - @carpools.active.private_cars.each do |carpool|
          .col.s12.m6.l3
            .entry id="car-#{carpool.id}" class="cars #{carpool.status}"
              .input-field.left style="margin-top:-10px"
                .cb-label Done
                = check_box_tag "car-done-#{carpool.id}", 1, false, data: {id: carpool.id}
                = label_tag "car-done-#{carpool.id}", ""
              = carpool.transport.try(:name) || "???"
              .input-field.right style="margin-top:-10px"
                .cb-label Wait
                = link_to edit_carpool_path(carpool), remote: true
                  i.material-icons style="padding-top:9px; color:salmon" pause_circle_outline

    #tab3.tab-content
      .container
        #waiting-list
          - @carpools.active.each do |carpool|
            - if carpool.late_passengers.active.present?
              - carpool.late_passengers.active.each do |pax|
                 .wait-pax id="wait-pax-#{pax.id}" #{carpool.transport_name} #{pax.name} (#{pax.class_name})

    #tab4.tab-content
      #exit-carpool
        - @carpools.inactive.each do |carpool|
          .col.s12.m6.l3
            .entry id="car-#{carpool.id}" class="cars #{carpool.status}"
              .input-field.left style="margin-top:-10px"
                .cb-label Done
                = check_box_tag "car-done-#{carpool.id}", 1, true, data: {id: carpool.id}
                = label_tag "car-done-#{carpool.id}", ""
              = carpool.transport.try(:name) || "???"
              .input-field.right style="margin-top:-10px"
                .cb-label Wait
                = link_to edit_carpool_path(carpool), remote: true
                  i.material-icons style="padding-top:9px; color:salmon" pause_circle_outline

= text_field_tag :carpool_scanner, "", disabled:true

#show-modal.modal.bottom-sheet

script#carpool-template type="text/x-custom-template"
  .col.s12.m6.l3
    .entry id="car-__carpool.id_" class="cars __carpool.status_"
      .input-field.left style="margin-top:-10px"
        .cb-label Done
        = check_box_tag "car-done-__carpool.id_", 1, false, data: {id: "__carpool.id_"}
        = label_tag "car-done-__carpool.id_", ""
      = "__carpool.transport_name_"
      .input-field.right style="margin-top:-10px"
        .cb-label Wait
        = link_to edit_carpool_path("__carpool.id_"), remote: true
          i.material-icons style="padding-top:9px; color:salmon" pause_circle_outline

/ script#carpool-passenger-template type="text/x-custom-template"
/   .modal-content
/     h4 Passengers
/     = "__passengers.list_"
/   .modal-footer
/     button.btn.waves-effect.waves-light type="submit" OK
/     = link_to "Cancel", "#!", class:"modal-action modal-close waves-effect waves-light btn-flat"
/
/ script#pax-list-template type="text/x-custom-template"
/   .row
/     .col.s1
/       = check_box_tag "pax-list-__pax.id_", 1, false, data: {id: "__pax.id_"}
/       = label_tag "pax-list-__pax.id_", ""
/     .col.s7
/       = "__pax.name_"
/     .col.s4
/       = "__pax.class_"

javascript:
  $(document).on("page:load", function() {
    carpool_document_ready();
  });
  $(document).ready(function() {
    carpool_document_ready();
  });
*/
