$(document).on("ready page:load", function(){
	if ($("body.settings").length == 0) return;


	// Finalize Book Conditions
	var toggle_finalize_student_books_button = function() {
		var checked = $('#finalize_student_books input.checkbox:checked').length > 0;
		if (checked) {
			$('#finalize-student-books-button').removeClass("disabled");
		} else {
			$('#finalize-student-books-button').addClass("disabled");
		}
		$('#finalize-student-books-button').prop("disabled", !checked);
	};

	var finalize_student_books_checkbox = function() {
		toggle_finalize_student_books_button();
		$("#finalize_student_books .allcheckboxes").prop("checked", $("#finalize_student_books .allcheckboxes").data("total") == $('input.checkbox:checked').length);
	}

	$("#finalize_student_books .checkbox").on("change", finalize_student_books_checkbox.bind(this));
	$("#finalize_student_books").on("change", ".allcheckboxes", function(e) {
		$(".checkbox.checkbox").prop("checked", $(e.target).prop("checked"));
		toggle_finalize_student_books_button();
	}.bind(this));


	// Prepare Book Receipts
	var toggle_prepare_book_receipts_button = function() {
		var checked = $('#prepare_book_receipts input.checkbox:checked').length > 0;
		if (checked) {
			$('#prepare_book_receipts-button').removeClass("disabled");
		} else {
			$('#prepare_book_receipts-button').addClass("disabled");
		}
		$('#prepare_book_receipts-button').prop("disabled", !checked);
	};

	var prepare_book_receipts_checkbox = function() {
		toggle_prepare_book_receipts_button();
		$("#prepare_book_receipts .allcheckboxes").prop("checked", $("#prepare_book_receipts .allcheckboxes").data("total") == $('input.checkbox:checked').length);
	}

	$("#prepare_book_receipts .checkbox").on("change", prepare_book_receipts_checkbox.bind(this));
	$("#prepare_book_receipts").on("change", ".allcheckboxes", function(e) {
		$(".checkbox.checkbox").prop("checked", $(e.target).prop("checked"));
		toggle_prepare_book_receipts_button();
	}.bind(this));

	
	// Finalize Book Condition from Receipts
	var toggle_finalize_condition_book_receipts_button = function() {
		var checked = $('#finalize_condition_book_receipts input.checkbox:checked').length > 0;
		if (checked) {
			$('#finalize_condition_book_receipts-button').removeClass("disabled");
		} else {
			$('#finalize_condition_book_receipts-button').addClass("disabled");
		}
		$('#finalize_condition_book_receipts-button').prop("disabled", !checked);
	};

	var finalize_condition_book_receipts_checkbox = function() {
		toggle_finalize_condition_book_receipts_button();
		$("#finalize_condition_book_receipts .allcheckboxes").prop("checked", $("#finalize_condition_book_receipts .allcheckboxes").data("total") == $('input.checkbox:checked').length);
	}

	$("#finalize_condition_book_receipts .checkbox").on("change", finalize_condition_book_receipts_checkbox.bind(this));
	$("#finalize_condition_book_receipts").on("change", ".allcheckboxes", function(e) {
		$(".checkbox.checkbox").prop("checked", $(e.target).prop("checked"));
		toggle_finalize_condition_book_receipts_button();
	}.bind(this));


	// Create Student Book Loans from Receipts
	var toggle_prepare_student_books_button = function() {
		var checked = $('#prepare_student_books input.checkbox:checked').length > 0;
		if (checked) {
			$('#prepare_student_books-button').removeClass("disabled");
		} else {
			$('#prepare_student_books-button').addClass("disabled");
		}
		$('#prepare_student_books-button').prop("disabled", !checked);
	};

	var prepare_student_books_checkbox = function() {
		toggle_prepare_student_books_button();
		$("#prepare_student_books .allcheckboxes").prop("checked", $("#prepare_student_books .allcheckboxes").data("total") == $('input.checkbox:checked').length);
	}

	$("#prepare_student_books .checkbox").on("change", prepare_student_books_checkbox.bind(this));
	$("#prepare_student_books").on("change", ".allcheckboxes", function(e) {
		$(".checkbox.checkbox").prop("checked", $(e.target).prop("checked"));
		toggle_prepare_student_books_button();
	}.bind(this));
	
	// Calculate book fines
	var toggle_calc_fines_button = function() {
		var checked = $('#calculate_book_fines input.checkbox:checked').length > 0;
		if (checked) {
			$('#calculate-fines-button').removeClass("disabled");
		} else {
			$('#calculate-fines-button').addClass("disabled");
		}
		$('#calculate-fines-button').prop("disabled", !checked);
	};

	var toggle_fines_checkbox = function() {
		toggle_calc_fines_button();
		$("#calculate_book_fines .allcheckboxes").prop("checked", $("#calculate_book_fines .allcheckboxes").data("total") == $('input.checkbox:checked').length);
	}

	$("#calculate_book_fines .checkbox").on("change", toggle_fines_checkbox.bind(this));
	$("#calculate_book_fines").on("change", ".allcheckboxes", function(e) {
		$(".checkbox.checkbox").prop("checked", $(e.target).prop("checked"));
		toggle_calc_fines_button();
	}.bind(this));

});