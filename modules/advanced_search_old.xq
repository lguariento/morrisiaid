xquery version "3.1";

import module namespace functx = 'http://www.functx.com';
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare option output:method "json";
declare option output:media-type "application/json";

array {
      let $pe1id := request:get-parameter("pe1id", ())[. ne ""]
      let $pe2id := request:get-parameter('pe2id', ())[. ne ""]
      let $both := request:get-parameter('both', ())[. ne ""]
      let $plid := request:get-parameter('plid', ())[. ne ""]
      let $dateFrom := request:get-parameter("dateFrom", (''))[. ne ""]
      let $dateTo := request:get-parameter("dateTo", ())[. ne ""]
      let $sourceRef := request:get-parameter("sourceRef", ())[. ne ""]
      
     let $indicesPersons := doc('/db/apps/app-morrisiaid/data/persons_places.xml')//tei:listPerson
     let $indicesPlaces := doc('/db/apps/app-morrisiaid/data/persons_places.xml')//tei:listPlace
     
    let $doc := doc("/db/apps/app-morrisiaid/data/master_file.xml")
     for $record at $pos in $doc//tei:item[
    every $condition in (
        if ($pe1id ne '') then 
            tei:ab[@type eq "sent" and ./tei:persName[@ref eq $pe1id]]/@ref= $pe1id or
            (if ($both eq 'on') then tei:ab[@type eq "received" and ./tei:persName[@ref eq $pe1id]]/@ref = $pe1id else false())
        else 
            true(),
        if ($pe2id ne '') then
            tei:ab[@type eq "received" and ./tei:persName[@ref eq $pe2id]]/@ref = $pe2id
        else 
            true(),
        if ($plid ne '') then
            tei:ab[@type eq "sent" and ./tei:placeName[@ref eq $plid]]/@ref= $plid
        else 
            true(),
        if ($sourceRef ne '') then
            .[@xml:id eq $sourceRef]/@xml:id= $sourceRef
        else 
            true(),

        (: If the date does not have a trailing '-' it means that it is complete :)
        if (exists(tei:ab[@type eq 'sent']/tei:date/@when) and substring(tei:ab[@type eq 'sent']/tei:date/@when, 1, 1) ne '-') then
            
            xs:int(substring(tei:ab[@type eq 'sent']/tei:date/@when, 1, 4)) ge xs:int($dateFrom)
            and
            xs:int(substring(tei:ab[@type eq 'sent']/tei:date/@when, 1, 4)) le xs:int($dateTo)
        
            
            (: ...otherwise it means that the year is missing and it's incomplete. If that's the case,
            check if the checkbox 'incomplete' is checked or not. If it is checked, the condition is true and
            the portion of the $condition is true. The form submits the includeUndated parameter as "on" if checked,
            so we will check for that too. 
            
        else if ($includeUndated eq 'on' or $includeUndated eq 'true') then
                true()  :)
         else true()
    ) satisfies $condition
]
    
    let $dateSent := data($record/tei:ab[@type="sent"]/tei:date/@when)
     
     (: alternative code :)
     
         let $personSentNumber := count($record/tei:ab[@type eq "sent"]/tei:persName)
    let $personSentFullName :=
        (
         for $personSent in $record/tei:ab[@type = "sent"]/tei:persName
         let $personSentID := $personSent/@ref/string()
         return $indicesPersons/tei:person/id($personSentID)/tei:persName/string-join((./tei:forename/text(),./tei:surname/text())," ")
        ) ! (if (position() > 1) then ('; ', .) else .)
        
    
    let $personReceivedNumber := count($record/tei:ab[@type eq "received"]/tei:persName)
    let $personReceivedFullName :=
        (
         for $personReceived in $record/tei:ab[@type = "sent"]/tei:persName
         let $personReceivedID := $personReceived/@ref/string()
         return $indicesPersons/tei:person/id($personReceivedID)/tei:persName/string-join((./tei:forename/text(),./tei:surname/text())," ")
        ) ! (if (position() > 1) then ('; ', .) else .)
        
    let $placeSentNumber := count($record/tei:ab[@type="sent"]/tei:placeName)
        let $placeSentName := 
        for $placeSent in $record/tei:ab[@type="sent"]/tei:placeName
        let $placeSentID := $placeSent/@ref/string()
        let $placeSentgeogName := $indicesPlaces/tei:place[@xml:id=$placeSentID]/tei:placeName/tei:geogName
        return $placeSentgeogName ! (if (position() > 1) then ('; ', .) else .)

    let $placeReceivedNumber := count($record/tei:ab[@type="sent"]/tei:placeName)
        let $placeReceivedName := 
        for $placeReceived in $record/tei:ab[@type="sent"]/tei:placeName
        let $placeReceivedID := $placeReceived/@ref/string()
        let $placeReceivedgeogName := $indicesPlaces/tei:place[@xml:id=$placeReceivedID]/tei:placeName/tei:geogName
        return $placeReceivedgeogName ! (if (position() > 1) then ('; ', .) else .)
        
     (:
     let $personSentNumber := count($record/tei:ab[@type="sent"]/tei:persName)
        let $personSentFullName := 
        for $personSent at $pos in $record/tei:ab[@type="sent"]/tei:persName
        let $personSentID := data($personSent/@ref)
        let $personSentForename := $indicesPersons/tei:person[@xml:id=$personSentID]/tei:persName/tei:forename
        let $personSentSurname := $indicesPersons/tei:person[@xml:id=$personSentID]/tei:persName/tei:surname
        let $fullNameSent := if ($personSentNumber eq ($pos)) then $personSentForename || ' ' || $personSentSurname else $personSentForename || ' ' || $personSentSurname || '; '
        return $fullNameSent
         
    let $personReceivedNumber := count($record/tei:ab[@type="received"]/tei:persName)
        let $personReceivedFullName := 
        for $personReceived at $pos in $record/tei:ab[@type="received"]/tei:persName
        let $personReceivedID := data($personReceived/@ref)
        let $personReceivedForename := $indicesPersons/tei:person[@xml:id=$personReceivedID]/tei:persName/tei:forename
        let $personReceivedSurname := $indicesPersons/tei:person[@xml:id=$personReceivedID]/tei:persName/tei:surname
        let $fullNameReceived := if ($personReceivedNumber eq ($pos)) then $personReceivedForename || ' ' || $personReceivedSurname else $personReceivedForename || ' ' || $personReceivedSurname || '; '
        return $fullNameReceived
    
    let $placeSentNumber := count($record/tei:ab[@type="sent"]/tei:placeName)
        let $placeSentName := 
        for $placeSent at $pos in $record/tei:ab[@type="sent"]/tei:placeName
        let $placeSentID := data($placeSent/@ref)
        let $placeSentgeogName := $indicesPlaces/tei:place[@xml:id=$placeSentID]/tei:placeName/tei:geogName
        let $placeSent := if ($placeSentNumber eq ($pos)) then $placeSentgeogName else $placeSentgeogName || '; '
        return $placeSent

    let $placeReceivedNumber := count($record/tei:ab[@type="received"]/tei:placeName)
        let $placeReceivedName := 
        for $placeReceived at $pos in $record/tei:ab[@type="received"]/tei:placeName
        let $placeReceivedID := data($placeReceived/@ref)
        let $placeReceivedgeogName := $indicesPlaces/tei:place[@xml:id=$placeReceivedID]/tei:placeName/tei:geogName
        let $placeReceived := if ($placeReceivedNumber eq ($pos)) then $placeReceivedgeogName else $placeReceivedgeogName || '; '
        return $placeReceived 
    :)
    
    let $id := <a href="detail.html?emloID={data($record/@xml:id)}"><span class="fi-envelope-open"></span></a>
    
    return
    
    (:<tr><td><a href="../detail.html?emloID={$id}">{$id}</a></td><td>{$dateSent}</td><td>{$personSentFullName}</td><td>{$personReceivedFullName}</td></tr>:)
    
    
         map {
         '0': $dateSent,
         '1': $personSentFullName,
         '2': $personReceivedFullName,
         '3': $placeSentName,
         '4': $placeReceivedName,
         '5': $id,
         '6': $sourceRef}
         }
    
    (:let $doc := doc("/db/apps/app-dined/data/cards/cards.xml")
    let $p1-entries := $doc//tei:persName[@ref eq $id1]/ancestor::tei:div[@type eq "entry"]
    let $p2-entries := $doc//tei:persName[@ref eq $id2]/ancestor::tei:div[@type eq "entry"]
    let $entries := $p1-entries intersect $p2-entries
    for $entry in $entries
    let $date_raw := $entry//tei:date/@when
    return
       'yes, on ' || $date_raw:)