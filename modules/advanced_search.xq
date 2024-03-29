xquery version "3.1";

(: Receive user-supplied query parameters, query fields, and format results. 
 : If no parameters are received, show all results. 
 :
 : Compared to the earlier version without fields, the performance of this query
 : is much better, because we used fields to pre-compute and pre-construct so many 
 : of the values that we previously had to do at query time.
 : 
 : @see https://exist-db.org/exist/apps/doc/lucene#facets-and-fields
 :)

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace search = "https://www.porth.ac.uk/morrisiaid/search";

declare option output:method "json";
declare option output:media-type "application/json";


declare function search:detail() {
let $pe1id := request:get-parameter("pe1id", ())[. ne ""]
let $pe2id := request:get-parameter("pe2id", ())[. ne ""]
let $both := request:get-parameter("both", "false")[. ne ""]
let $plid := request:get-parameter("plid", ())[. ne ""]
let $dateFrom := request:get-parameter("dateFrom", ())[. ne ""]
let $dateTo := request:get-parameter("dateTo", ())[. ne ""]
let $sourceRef := request:get-parameter("sourceRef", ())[. ne ""]

let $doc := doc("/db/apps/app-morrisiaid/data/master_file.xml")

let $start-time := util:system-dateTime()

let $all-records := $doc//tei:item
let $query-pe1 := 

        (
            if (exists($pe1id)) then
                (
                    if ($both eq "false") then
                        "sender-ids:" || $pe1id
                    else if ($both eq "on" or $both eq "true") then
                        "(sender-ids:" || $pe1id || " OR recipient-ids:" || $pe1id || ")"
                    else
                        ()
                )
            else
                ()
        )
let $query-pe2 := 
        (
            if (exists($pe2id)) then
                "recipient-ids:" || $pe2id
            else
                ()
        )
let $query-place :=
        (
            if (exists($plid)) then
                (
                    "(place-sent-ids:" || $plid || " OR place-received-ids:" || $plid || ")"
                )
            else
                ()
        )
let $query-date :=
        (
            if ($dateFrom eq '1725' and $dateTo eq '1786') then
                ()
            else 
                "year-sent:[" || $dateFrom || " TO " || $dateTo || "]"
            (: else if (exists($dateFrom)) then
                'year-sent:["' || $dateFrom || '" TO *]'
            else if (exists($dateTo)) then
                'year-sent:[* TO "' || $dateTo || '"]'
                :)
        )
        
let $query-string := normalize-space($query-pe1 || " " || $query-pe2 || " " || $query-place || " " || $query-date)[. ne ""]

let $options := 
    map { 
        (: https://exist-db.org/exist/apps/doc/lucene#parameters :)
        "default-operator": "and",
        "phrase-slop": 0,
        "leading-wildcard": "no",
        "filter-rewrite": "yes",
        (: https://exist-db.org/exist/apps/doc/lucene#retrieve-fields :)
        "fields": 
            (
                "date-sent", 
                "sender-names", 
                "recipient-names", 
                "place-sent-names", 
                "place-received-names"
            ) 
    }
let $records := $all-records[ft:query(., $query-string, $options)]
let $results :=
    for $record in $records
    let $dateSent := ft:field($record, "date-sent")
    let $personSentFullNames := ft:field($record, "sender-names")
    let $personReceivedFullNames := ft:field($record, "recipient-names")
    let $placeSentNames := ft:field($record, "place-sent-names")
    let $placeReceivedNames := ft:field($record, "place-received-names")
    let $id := <a href="detail.html?emloID={data($record/@xml:id)}"><span class="fi-envelope-open"/></a>
    return
        map {
            "0": $dateSent,
            "1": $personSentFullNames,
            "2": $personReceivedFullNames,
            "3": $placeSentNames,
            "4": $placeReceivedNames,
            "5": $id,
            "6": $sourceRef
        }
        
let $end-time := util:system-dateTime()

return
    map { 
        "request": map {
            "pe1id": $pe1id,
            "pe2id": $pe2id,
            "both": $both,
            "plid": $plid,
            "dateFrom": $dateFrom,
            "dateTo": $dateTo,
            "sourceRef": $sourceRef
        },
        "lucene": map {
            "query-string": $query-string,
            "options": $options
        },
        "statistics": map {
            "result-count": count($results),
            "start-time": $start-time,
            "end-time": $end-time,
            "duration": ($end-time - $start-time) div xs:dayTimeDuration("PT1S") || "s"
        },
        "results":
            array { $results }
    }
};

search:detail()
