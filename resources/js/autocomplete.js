var options={theme: "square", requestDelay: 500, cssClasses: "col", url: "data/persons_places.xml",
        dataType: "xml", xmlElementName: "person", getValue: function(element){
        var $surname=$(element).find("surname").text().replace(/\s\s+/g, ' ');
        var $forename=$(element).find("forename").text().replace(/\s\s+/g, ' '); 
        var $addname=$(element).find("addName").text().replace(/\s\s+/g, ' ');
        var $peid=$(element).attr("xml:id");
        if ($forename && $surname){return $surname + ", " + $forename} else if ($surname == '') {return $forename} else {return $surname}; ;},
        list:{maxNumberOfElements: 1000, sort:{enabled: true}, requestDelay: 500, match:{enabled: true}, onChooseEvent: function(){var value=$("#from").getSelectedItemData().attributes["xml:id"].value;
        $("#id-holder-from").val(value).trigger("change");
        // advancedSearch(document.getElementById('advancedSearch'))
        }}};
        
        $("#from").easyAutocomplete(options);
        
var options={theme: "square", requestDelay: 500, cssClasses: "col", url: "data/persons_places.xml",
        dataType: "xml", xmlElementName: "person", getValue: function(element){
        var $surname=$(element).find("surname").text().replace(/\s\s+/g, ' ');
        var $forename=$(element).find("forename").text().replace(/\s\s+/g, ' '); 
        var $addname=$(element).find("addName").text().replace(/\s\s+/g, ' ');
        var $peid=$(element).attr("xml:id");
        if ($forename && $surname){return $surname + ", " + $forename} else if ($surname == '') {return $forename} else {return $surname}; ;},
        list:{maxNumberOfElements: 1000, sort:{enabled: true}, requestDelay: 500, match:{enabled: true}, onChooseEvent: function(){var value=$("#to").getSelectedItemData().attributes["xml:id"].value;
        $("#id-holder-to").val(value).trigger("change");
        // advancedSearch(document.getElementById('advancedSearch'))
        }}};
        
        $("#to").easyAutocomplete(options);
        
var options={theme: "square", requestDelay: 500, cssClasses: "col", url: "data/persons_places.xml",
        dataType: "xml", xmlElementName: "place", getValue: function(element){
        var $geogName=$(element).find("geogName").text().replace(/\s\s+/g, ' ');
        var $plid=$(element).attr("xml:id");
        if ($geogName){return $geogName}; ;},
        list:{maxNumberOfElements: 1000, sort:{enabled: true}, match:{enabled: true}, onChooseEvent: function(){var value=$("#origin").getSelectedItemData().attributes["xml:id"].value;
        $("#id-holder-origin").val(value).trigger("change");
        // advancedSearch(document.getElementById('advancedSearch'))
        }}};
        
        $("#origin").easyAutocomplete(options);
        
var options={theme: "square", requestDelay: 500, cssClasses: "col", url: "data/manifestations.xml",
        dataType: "xml", xmlElementName: "item", getValue: function(element){
        var $sourceidno=$(element).find("idno").text().replace(/\s\s+/g, ' ');
        var $sourcerepo=$(element).find("repository").text().replace(/\s\s+/g, ' ');
        var $sourceped=$(element).find('ab[type="p_e_d"]').text().replace(/\s\s+/g, ' ');
        var $ref=$(element).find("ref").text();
        if ($sourceidno !== 'n.a.'){return $sourcerepo + ',' + $sourceidno} else if ($sourceped) {return $sourceped}; ;},
        list:{maxNumberOfElements: 1000, sort:{enabled: true}, match:{enabled: true}, onChooseEvent: function(){var value=$("#source").getSelectedItemData().firstElementChild.textContent; // The first child is always the <ref> element
        $("#id-holder-source").val(value).trigger("change");
        // advancedSearch(document.getElementById('advancedSearch'))
        }}};
        
        $("#source").easyAutocomplete(options);