function parameters () {$(document).ready(function () {

if (window.location.pathname.includes('index.html')) {
    
    // Save the scrolling position and return it.
    
    if (localStorage.getItem("table_scroll") != null) {
        $(window).scrollTop(localStorage.getItem("table_scroll"));
    }
    
    $(window).on("scroll", function () {
        localStorage.setItem("table_scroll", $(window).scrollTop());
    });
    }
    
    // Restore the form fields 
    var urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('advancedSearch')) {
        
        const pe1Name = sessionStorage.getItem('pe1Name');
        const pe1id = sessionStorage.getItem('pe1id');
        const pe2Name = sessionStorage.getItem('pe2Name');
        const pe2id = sessionStorage.getItem('pe2id');
        const origin = sessionStorage.getItem('origin');
        const plid = sessionStorage.getItem('plid');
        const dateFrom = sessionStorage.getItem('dateFrom');
        const dateTo = sessionStorage.getItem('dateTo');
        const source = sessionStorage.getItem('source');
        const sourceRef = sessionStorage.getItem('sourceRef');
        const includeUndated = sessionStorage.getItem('includeUndated');
        // Repopulate the input fields in the form...
        document.getElementById('id-holder-from').value = pe1id;
        document.getElementById('id-holder-to').value = pe2id;
        document.getElementById('from').value = pe1Name;
        document.getElementById('to').value = pe2Name;
        document.getElementById('origin').value = origin;
        document.getElementById('id-holder-origin').value = plid;
        document.getElementById('source').value = source;
        document.getElementById('id-holder-source').value = sourceRef;
        
        // ...the sessionStorage element for the checkbox is between inverted commas,
        // so we need to add some extra code here to account for that...
        if (includeUndated == 'true') {
            document.getElementById('includeUndated').checked = true;
        } else {
            document.getElementById('includeUndated').checked = false;
        }
        
        // ...and reinitialise the slider with the year-range
        const target = document.getElementById("slider");
        const options = {
            "initialStart": dateFrom,
            "initialEnd": dateTo
        };
        
        const elem = new Foundation.Slider($(target), options);
        document.getElementById('dateFrom').value = dateFrom;
        document.getElementById('dateTo').value = dateTo;
    }
});
}