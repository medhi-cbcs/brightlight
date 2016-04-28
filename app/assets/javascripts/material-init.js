// See this post in stackoverflow
// http://stackoverflow.com/questions/22811654/ruby-on-rails-4-javascript-not-executed
//
$(document).on('ready page:load', function () {
	$('.collapsible').collapsible({
		accordion : true 				// A setting that changes the collapsible behavior to expandable instead of the default accordion style
	});

	$('select').material_select();

	$('ul.tabs').tabs();

	$('.dropdown-button').dropdown({
		induration: 300,
		outduration: 225,
		constrain_width: false, 	// Does not change width of dropdown to that of the activator
		hover: false, 						// Activate on hover
		gutter: 0, 								// Spacing from edge
		beloworigin: true, 				// Displays dropdown below the button
		alignment: 'left' 				// Displays dropdown with edge aligned to the left of button
	});

	$(".sidebar-collapse").sideNav();

	$(".right-sidebar-collapse").sideNav({
		edge: 'right'
	});

	$('.modal-trigger').leanModal();

	// $(".datepicker").pickadate({
	// 	format: 'yyyy-mm-dd',
	// 	formatSubmit: 'yyyy-mm-dd',
	// 		selectMonths: false, 	// Creates a dropdown to control month
	// 		selectYears: 15 			// Creates a dropdown of 15 years to control year
	// });
});

(function($) {
    $.fn.scrollTo = function() {
        $('html, body').animate({
            scrollTop: $(this).offset().top + 'px'
        }, 'fast');
        return this; // for chaining...
    }
})(jQuery);
