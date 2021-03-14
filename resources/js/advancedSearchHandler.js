"use strict";
if (window.location.pathname.includes('index.html')) {
    
    $(document).ready(function () {
        
        document.getElementById('both').addEventListener("change", function () {
            if (document.getElementById('both').checked == true) {
                document.getElementById('to').disabled = true
                document.getElementById('from').placeholder = 'Oddi wrth neu at'
            } else {
                document.getElementById('to').disabled = false
                document.getElementById('from').placeholder = 'Oddi wrth'
            }
        })
    })
};
 
if (window.location.pathname.includes('detail.html')) {
                
                // When the user clicks on the 'back' button...
                document.getElementById('back').onclick = function (e) {
                    // ... check if they landed on the 'detail' page from an advanced search...
                    if (sessionStorage.getItem('advancedSearch') == 'yes') {
                        // ... if so, open the index.html page appending a 'advancedSearch' parameter.
                        // The XQuery app:mainTable code has a check: if the 'advancedSearch' parameter is set
                        // then do not run the fetch-all-records XQuery.
                          const pe1Name = sessionStorage.getItem('pe1Name');
                          const pe1id = sessionStorage.getItem('pe1id');
                          const both = sessionStorage.getItem('both');
                          const pe2Name = sessionStorage.getItem('pe2Name');
                          const pe2id = sessionStorage.getItem('pe2id');
                          const origin = sessionStorage.getItem('origin');
                          const plid = sessionStorage.getItem('plid');
                          const dateFrom = sessionStorage.getItem('dateFrom');
                          const dateTo = sessionStorage.getItem('dateTo');
                          const sourceRef = sessionStorage.getItem('sourceRef');
                          const source = sessionStorage.getItem('source');
                          const includeUndated = sessionStorage.getItem('includeUndated');
                        var newpage = window.open("index.html?advancedSearch=yes&pe1id=" + pe1id + "&pe2id=" + pe2id + "&both=" + both + "&plid=" + plid + "&sourceRef=" + sourceRef + "&dateFrom=" + dateFrom + "&dateTo=" + dateTo, "_self");
                          
                    } else {
                        var newpage = window.open("index.html", "_self");
                        
                    }
                }
            }




function advancedSearchFromDetail () {
    
     // Get the page of the table the user was looking at.
    var page = sessionStorage.getItem('pageTable')
    
    var table = $('#mainTable').DataTable()
    
    table.clear()
    table.draw()
    
    
    // Otherwise it means that the user is calling the function from the 'detail' page
    // and they want to see the populated advanced search tab and the filtered results in the table.
    // document.getElementById('mainTableRows').innerHTML = '<tr align="center";><td colspan="4"><h6>Loading results</h6></td></tr>'
    parameters()
    
    // Display the 'loading' wheel.
    document.getElementById('mainTableRows').innerHTML = '<div class="loader"></div>'
    
    // Get the parameters in the sessionStorage
    const pe1Name = sessionStorage.getItem('pe1Name');
    const pe1id = sessionStorage.getItem('pe1id');
    const both= sessionStorage.getItem('both');
    const pe2Name = sessionStorage.getItem('pe2Name');
    const pe2id = sessionStorage.getItem('pe2id');
    const origin = sessionStorage.getItem('origin');
    const plid = sessionStorage.getItem('plid');
    const dateFrom = sessionStorage.getItem('dateFrom');
    const dateTo = sessionStorage.getItem('dateTo');
    const includeUndated = sessionStorage.getItem('includeUndated');
    const source = sessionStorage.getItem('source');
    
    // Build a form data object to submit to the XHR call. 
    const data = new FormData()
    data.append('pe1id', pe1id)
    data.append('both', both)
    data.append('pe2id', pe2id)
    data.append('plid', plid)
    data.append('dateFrom', dateFrom)
    data.append('dateTo', dateTo)
    data.append('includeUndated', includeUndated) 
    data.append('sourceRef', sourceRef) 
    
    var oReq = new XMLHttpRequest(); 
    
    oReq.open("post", 'modules/advanced_search.xq', true);
    oReq.send(data);
    
    oReq.onreadystatechange = function () {
        if (oReq.readyState === XMLHttpRequest.DONE && oReq.status === 200) {
            const result = JSON.parse(oReq.responseText);
            
            // check if the result is null
            if (result == '')
            
            // if it is, just clean the table
            {
                document.getElementById('result').innerHTML = 'There are no results'
                table.draw()
            } else {
                // deleted the extra comma generated by the incoming JSON when there's more than one person or place.
                result.forEach(function (record) {
                    if (Array.isArray(record[5])) {
                        record[5] = record[5].join('');
                    }
                    if (Array.isArray(record[4])) {
                        record[4] = record[4].join('');
                    }
                    if (Array.isArray(record[3])) {
                        record[3] = record[3].join('');
                    }
                    if (Array.isArray(record[2])) {
                        record[2] = record[2].join('');
                    }
                });
                
                table.rows.add(result)
                table.draw()
            }
            
               // Include missing-date items or not, according to the state of the switch
               // before submitting the form
               includeUndated()
        }
    }
    
};

function advancedSearch (oFormElement) {

/* This is a function which navigates the XML tree and outputs what we want from it.
 * It might be useful at some point, i.e. for outputting XML elements from the XML files
 * via plain JavaScript and XHR.

function advancedSearch (oFormElement) {

function nsResolver(prefix) {
  var ns = {
    'xml' : 'http://www.w3.org/XML/1998/namespace',
    'tei': 'http://www.tei-c.org/ns/1.0'
  };
  return ns[prefix] || null;
}
    
    const Connect = new XMLHttpRequest();
    
    Connect.open("GET", "data/persons_places.xml", false);
    Connect.setRequestHeader("Content-Type", "text/xml");
    Connect.send(null);
    var xmldoc = Connect.responseXML;
    const surname = xmldoc.evaluate('string(//tei:person[@xml:id="pe_054"]/tei:persName/tei:surname)', xmldoc, nsResolver, XPathResult.STRING_TYPE, null)
    console.log(surname) */

    // event.preventDefault()
    var table = $('#mainTable').DataTable()
    
    //sessionStorage.setItem('pageTable', '0')
    table.clear()
    table.draw()
        
    // Empty the id-holder fields in case the user deleted the persons' or places' names
        
        if (document.getElementById('to').value === '') {
            document.getElementById('id-holder-to').value = ''
        }
        if (document.getElementById('from').value === '') {
            document.getElementById('id-holder-from').value = ''
        }
        if (document.getElementById('origin').value === '') {
            document.getElementById('id-holder-origin').value = ''
        }
        if (document.getElementById('source').value === '') {
            document.getElementById('id-holder-source').value = ''
        }
    
    // If we want to allow all empty fields and therefore get all the records, invalidate this 'if':
    //if (oFormElement.pe1id.value == '' && oFormElement.pe2id.value == '') {
     //   alert('You have to enter at least one person.');
     //   return false;
    //} else 
    
    if ((oFormElement.pe1id.value == '' && oFormElement.from.value != '') || (oFormElement.pe2id.value == '' && oFormElement.to.value != '') || (oFormElement.plid.value == '' && oFormElement.origin.value != '') || (oFormElement.sourceRef.value == '' && oFormElement.source.value != '')){
        alert('Please make sure you have filled all the fields correctly');
        return false;
    }  else {
    
        // Display a courtesy 'Loading...' message.
        // document.getElementById('mainTableRows').innerHTML = '<tr align="center";><td colspan="6"><h6>Loading results...</h6></td></tr>'
        
        document.getElementById('mainTableRows').innerHTML = '<div class="loader"></div>'
        
        // Save the parameters in the sessionStorage; we'll need them later if the user
        // goes to the 'detail' page and comes back to the table...
        const pe1Name = document.getElementById('from').value
        sessionStorage.setItem('pe1Name', pe1Name);
        const pe1id = document.getElementById('id-holder-from').value
        sessionStorage.setItem('pe1id', pe1id);
        const pe2Name = document.getElementById('to').value
        sessionStorage.setItem('pe2Name', pe2Name);
        const pe2id = document.getElementById('id-holder-to').value
        sessionStorage.setItem('pe2id', pe2id);
        const both = document.getElementById('both').checked
        sessionStorage.setItem('both', both);
        const origin = document.getElementById('origin').value
        sessionStorage.setItem('origin', origin);
        const plid = document.getElementById('id-holder-origin').value
        sessionStorage.setItem('plid', plid);
        const dateFrom = document.getElementById('dateFrom').value
        sessionStorage.setItem('dateFrom', dateFrom);
        const dateTo = document.getElementById('dateTo').value
        sessionStorage.setItem('dateTo', dateTo);
        const source = document.getElementById('source').value
        sessionStorage.setItem('source', source);
        const sourceRef = document.getElementById('id-holder-source').value
        sessionStorage.setItem('sourceRef', sourceRef);
        
        // ...and if something changed in the form set an item in the sessionStorage which tells it that the user
        // did and advanced search to true, otherwise to false. This will be used when the user will go back to the search results
        // from the detail page.
        

    if ((pe1id == '' && pe2id == '' && plid == '' && sourceRef == '') && (dateFrom == '1725') && (dateTo == '1786')) {
        sessionStorage.setItem('advancedSearch', 'false')
          // Also clean the URL from any previous parameter.
          window.history.pushState({},
          document.title, "" + "index.html");
    } else {sessionStorage.setItem('advancedSearch', 'yes');
          // Also clean the URL from any previous parameter.
          window.history.pushState({},
          document.title, "" + "index.html");}
        

        
        // Proceed with the XHR request.
        const oReq = new XMLHttpRequest();
        const data = new FormData(oFormElement)
        
        oReq.open("post", oFormElement.action, true);
        oReq.send(data);
        
        // Disable the input fields while the XHR call is being executed.
        document.getElementById('from').disabled = true
        document.getElementById('to').disabled = true
        document.getElementById('both').disabled = true
        document.getElementById('origin').disabled = true
        document.getElementById('source').disabled = true
        document.getElementById('slider').classList.add('disabled')
        document.getElementById('dateFrom').disabled = true
        document.getElementById('dateTo').disabled = true
        
        oReq.onreadystatechange = function () {
            if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
                const result = JSON.parse(this.responseText);
                
                // check if the result is null
                if (result == '')
                
                // if it is, just clean the table
                {
                    document.getElementById('mainTableRows').innerHTML = '<tr align="center";><td colspan="6"><h6>There are no results</h6></td></tr>'
                    // table.draw()
                } else {
                    // deleted the extra comma generated by the incoming JSON when there's more than one person or place
                    result.forEach(function (record) {
                    if (Array.isArray(record[5])) {
                            record[5] = record[5].join('');
                        }
                        if (Array.isArray(record[4])) {
                            record[4] = record[4].join('');
                        }
                        if (Array.isArray(record[3])) {
                            record[3] = record[3].join('');
                        }
                        if (Array.isArray(record[2])) {
                            record[2] = record[2].join('');
                        }
                    });
                    
                    table.rows.add(result)
                    table.draw();
                    
                }
                
               // Enable back the input fields.
               document.getElementById('from').disabled = false
               if (sessionStorage.getItem('both') == 'false') {
               document.getElementById('to').disabled = false} else {document.getElementById('to').disabled = true} 
               document.getElementById('both').disabled = false
               document.getElementById('origin').disabled = false
               document.getElementById('source').disabled = false
               document.getElementById('slider').classList.remove('disabled')
               document.getElementById('dateFrom').disabled = false
               document.getElementById('dateTo').disabled = false
               
               // Include missing-date items or not, according to the state of the switch
               // before submitting the form
               includeUndated()
    
            }
        }
    }
    
    
}

/* Reset code:
 * 
 * // If the user clicks on the 'reset table' button then resets all the fields, making a new XHR call for
    // harvesting all the unfiltered data.
    if (reset) {
        // sessionStorage.setItem('advancedSearch', 'no') 
        sessionStorage.clear()
        // document.getElementById('mainTableRows').innerHTML = '<tr align="center";><td colspan="6"><h6>Loading results...</h6></td></tr>'
        document.getElementById('mainTableRows').innerHTML = '<div class="loader"></div>'
        
        // Proceed with the XHR request
          const dataReset = new FormData()
          dataReset.append('pe1id', '')
          dataReset.append('pe2id', '')
          dataReset.append('plid', '')
          dataReset.append('dateFrom', '1725')
          dataReset.append('dateTo', '1786')
          dataReset.append('includeUndated', 'on')
          var oReq = new XMLHttpRequest();
          
          oReq.onprogress = function (event) {
            console.log('done')
          };
          
          oReq.open("post", 'modules/advanced_search.xq', true);
          oReq.send(dataReset);
          
          // Close the 'advanced search' tab and change the 'expand/collaps icon'...
    // document.getElementById("advanced_search").style.display = "none";
    // document.getElementById("advancedSearchArrow").attributes.class.nodeValue = 'fi-expand-down'
        
    // ...reset the <input> fields in the form...
    document.getElementById('id-holder-from').value = '';
    document.getElementById('id-holder-to').value = '';
    document.getElementById('from').value = '';
    document.getElementById('to').value = '';
    document.getElementById('origin').value = '';
    document.getElementById('id-holder-origin').value = ''; 
    document.getElementById('includeUndated').checked = true;
    
     // ...and reinitialise the slider with the maximum year-range
    const sliderReset = document.getElementById("slider");
    const optionsReset = {
        "initialStart": '1725',
        "initialEnd": '1786'
    };
    
    const elemReset = new Foundation.Slider($(sliderReset), optionsReset);
    document.getElementById('dateFrom').value = 1725;
    document.getElementById('dateTo').value = 1786;
    // Fix the filler's width.    
    document.getElementsByClassName('slider-fill')[0].style.cssText = 'width: 0px; min-width: 100%; left: 0%;'
    
    
    // Also clean the URL from any parameter.
    window.history.pushState({},
    document.title, "" + "index.html");
          
    }
     *  */