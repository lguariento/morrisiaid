if (window.location.pathname.includes('index.html')) {
    
    $(document).ready(function () {
        
        document.getElementById('includeUndated').addEventListener("change", function () {
            if (document.getElementById('includeUndated').checked == true) {
                sessionStorage.setItem('includeUndated', 'true');
                console.log('checked')
            } else {
                sessionStorage.setItem('includeUndated', 'false')
                console.log('unchecked')
            }
            // advancedSearch(document.getElementById('advancedSearch'));
            includeUndated();
        })
    });
    
    
    function includeUndated() {
        
        $(document).ready(function () {
            
            if (String(sessionStorage.getItem('both')) == "true") {
                document.getElementById('both').checked = true
                document.getElementById('from').placeholder = 'Oddi wrth neu at'
                document.getElementById('to').disabled = true
            } else {
                document.getElementById('both').checked = false
                document.getElementById('from').placeholder = 'Oddi wrth'
            }
            
            
            if (String(sessionStorage.getItem('includeUndated')) == "true" || sessionStorage.getItem('includeUndated') == null) {
                document.getElementById('includeUndated').checked = true
            } else {
                document.getElementById('includeUndated').checked = false
            }
            
            var i
            var dates = document.getElementsByClassName('dateSent')
            
            for (i = 0; i < dates.length; i++) {
                if ((dates[i].innerText == '') || (dates[i].innerText.startsWith('-')))
                if (document.getElementById('includeUndated').checked == true) {
                    dates[i].parentElement.style.display = 'table-row'
                } else {
                    dates[i].parentElement.style.display = 'none'
                }
            }
        })
    }
}
