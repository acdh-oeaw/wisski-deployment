jQuery(function($) {
    "use strict";
    /* You can safely use $ in this code block to reference jQuery */


   
    $(document).ready(function() {
       
        /** get the imprint **/
        if(window.location.href.indexOf("browser/imprint") >= 0 ){
            const imprintService = 'https://shared.acdh.oeaw.ac.at/acdh-common-assets/api/imprint.php?serviceID=7404';
            $.get(imprintService, function(response){
                response = "<h2><span class='title'>Imprint</span></h2><hr><br/>" + response;
                document.getElementById('block-mainpagecontent').innerHTML = response;
            });
        };
        
        
        //enable bootstrap tooltip
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
        });

        //Cite-this widget
        $('#cite-tooltip-mla').tooltip(); 
        $('#cite-tooltip-mla').on('click', function(event) {
            if (!$(this).hasClass('tooltip-active')) {
                $(this).addClass('tooltip-active');
            } else {
                $(this).removeClass('tooltip-active');
                $(this).tooltip('hide');
            }
        });
        
     

    });

    /* You can safely use $ in this code block to reference jQuery */
});