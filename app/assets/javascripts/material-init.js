$('.dropdown-button').dropdown({
	inDuration: 300,
	outDuration: 225,
	constrain_width: false, // Does not change width of dropdown to that of the activator
	hover: false, // Activate on hover
	gutter: 0, // Spacing from edge
	belowOrigin: true, // Displays dropdown below the button
	alignment: 'left' // Displays dropdown with edge aligned to the left of button
});
$('.collapsible').collapsible({
	accordion : false // A setting that changes the collapsible behavior to expandable instead of the default accordion style
});

// Materialize sideNav  

//Main Left Sidebar Menu
// $('.sidebar-collapse').sideNav({
// 	edge: 'left', // Choose the horizontal origin    
// });
$(".button-collapse").sideNav();

