$(document).ready(function () {
    if (window.location.pathname.includes('index.html')) {
        // Setup - add a text input to the cell's headers
        document.querySelectorAll('#mainTable thead th')[1].innerHTML += '<input type="text" id="searchPeFrom" placeholder="hidlydd"/>';
        document.querySelectorAll('#mainTable thead th')[2].innerHTML += '<input type="text" id="searchPeTo" placeholder="hidlydd"/>';
        document.querySelectorAll('#mainTable thead th')[3].innerHTML += '<input type="text" id="searchPlFrom" placeholder="hidlydd"/>';
        document.querySelectorAll('#mainTable thead th')[4].innerHTML += '<input type="text" id="searchPlTo" placeholder="hidlydd"/>';
        
        
        // DataTable
        var table = $('#mainTable').DataTable({
            colReorder: false,
            lengthMenu:[25, 50, 75, 100],
            retrieve: true,
            stateSave: true,
            
            "columns":[ {
                "orderable": true,
                "className": "dateSent",
                "data": "dateSent"
                
            }, {
                "orderable": false,
                "data": "personSentFullName"
            }, {
                "orderable": false,
                "data": "personReceivedFullName"
            }, {
                "orderable": false,
                "data": "placeSentName"
            }, {
                "orderable": false,
                "data": "placeReceivedName"
            }, {
                "orderable": false,
                "data": "id"
            }]
        });
        
        // Apply the filter
        
        
        $("#mainTable thead input").on('keyup change', function () {
            table.column($(this).parent().index() + ':visible').search(this.value).draw();
        });
        includeUndated()
    }
})