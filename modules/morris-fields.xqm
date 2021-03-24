xquery version "3.1";

(: This module contains functions for constructing values for eXist's fields. 
 : The functions are called from the fields definitions in collection.xconf. 
 :)

module namespace mf = "http://morrisiaid.colegcymraeg.ac.uk/ns/xquery/fields";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare variable $mf:indicesPersons := doc("/db/apps/morrisiaid/data/persons_places.xml")//tei:listPerson;
declare variable $mf:indicesPlaces := doc("/db/apps/morrisiaid/data/persons_places.xml")//tei:listPlace;

(: ====================================================== :)
(: Functions called by collection.xconf field definitions :)
(: ====================================================== :)

(: not every item has a sender with an ID :)
declare function mf:get-sender-ids($item as element(tei:item)) as xs:string* {
    $item/tei:ab[@type eq "sent"]/tei:persName/@ref
};

(: not every item has a sender with an ID :)
declare function mf:get-sender-names($item as element(tei:item)) as xs:string? {
    let $sender-ids := mf:get-sender-ids($item)
    return
        if (exists($sender-ids)) then
            $sender-ids
                => for-each(function($person-id) { mf:get-person($person-id) })
                => for-each(function($person) { mf:get-person-name($person) })
                => string-join("; ")
        else
            ()
};

(: not every item has a recipient with an ID :)
declare function mf:get-recipient-ids($item as element(tei:item)) as xs:string* {
    $item/tei:ab[@type eq "received"]/tei:persName/@ref
};

(: not every item has a recipient with an ID :)
declare function mf:get-recipient-names($item as element(tei:item)) as xs:string? {
    let $recipient-ids := mf:get-recipient-ids($item)
    return
        if (exists($recipient-ids)) then
            $recipient-ids
                => for-each(function($person-id) { mf:get-person($person-id) })
                => for-each(function($person) { mf:get-person-name($person) })
                => string-join("; ")
        else
            ()
};

(: not every item has a known place of origin :)
declare function mf:get-sent-place-ids($item as element(tei:item)) as xs:string* {
    $item/tei:ab[@type eq "sent"]/tei:placeName/@ref
};

(: not every item has a known place of origin :)
declare function mf:get-sent-place-names($item as element(tei:item)) as xs:string? {
    let $place-ids := mf:get-sent-place-ids($item)
    return
        if (exists($place-ids)) then
            $place-ids
                => for-each(function($place-id) { mf:get-place($place-id) })
                => for-each(function($place) { mf:get-place-name($place) })
                => string-join("; ")
        else
            ()
};

(: not every item has a known place of origin :)
declare function mf:get-received-place-ids($item as element(tei:item)) as xs:string* {
    $item/tei:ab[@type eq "received"]/tei:placeName/@ref
};

(: not every item has a known place of origin :)
declare function mf:get-received-place-names($item as element(tei:item)) as xs:string? {
    let $place-ids := mf:get-received-place-ids($item)
    return
        if (exists($place-ids)) then
            $place-ids
                => for-each(function($place-id) { mf:get-place($place-id) })
                => for-each(function($place) { mf:get-place-name($place) })
                => string-join("; ")
        else
            ()
};

(: not every item has a sent date :)
declare function mf:get-date-sent($item as element(tei:item)) as xs:string? {
    $item/tei:ab[@type eq "sent"]/tei:date/@when
};

(: not every item has a sent year :)
declare function mf:get-year-sent($item as element(tei:item)) as xs:string? {
    let $date := mf:get-date-sent($item)
    return
        (: Even if date is empty, we still populate the year-sent field with an empty string 
         : to ensure the record isn't omitted from results when the year-sent field is queried :)
        if ($date eq ()) then
            ""
        (: A date that begins with a "-" has an unknown year. Store the full unknown date
         : in the year-sent field. :)
        else if (starts-with($date, "-")) then
            $date
        else 
            substring($date, 1, 4)
};

(: ================ :)
(: Helper functions :)
(: ================ :)


declare function mf:get-person($person-id as xs:string) as element(tei:person)? {
    $mf:indicesPersons/id($person-id)
};

declare function mf:get-person-name($person as element(tei:person)) as xs:string {
    $person/tei:persName ! (tei:forename || " " || tei:surname)
};

declare function mf:get-place($place-id as xs:string) as element(tei:place)? {
    $mf:indicesPlaces/id($place-id)
};

declare function mf:get-place-name($place as element(tei:place)) as xs:string {
    $place/tei:placeName/tei:geogName
};
