(function(){
    function init(){
        var toggle_calc_button = function() {
            var checked = $('#calculate_fines input.checkbox:checked').length > 0;
            if (checked) {
                $('#calculate-fines-button').removeClass("disabled");
            } else {
                $('#calculate-fines-button').addClass("disabled");
            }
            $('#calculate-fines-button').prop("disabled", !checked);
        };
        var toggle_checkbox = function() {
            toggle_calc_button();
            $("#calculate_fines .allcheckboxes").prop("checked", $(".allcheckboxes").data("total") == $('input.checkbox:checked').length);
        }
        $("#calculate_fines").on("change", ".checkbox", toggle_checkbox.bind(this));
        $("#calculate_fines").on("change", ".allcheckboxes", function(e) {
            $(".checkbox.checkbox").prop("checked", $(e.target).prop("checked"));
            toggle_calc_button();
        }.bind(this));
    };
    $(document).on('page:change', function(){    
        init();
    });
})();