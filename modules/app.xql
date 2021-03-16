xquery version "3.1";

module namespace app = "https://www.porth.ac.uk/morrisiaid/templates";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

import module namespace templates = "http://exist-db.org/xquery/templates";
import module namespace config = "https://www.porth.ac.uk/morrisiaid/config" at "config.xqm";

import module namespace search = "https://www.porth.ac.uk/morrisiaid/search" at "advanced_search.xq";

declare variable $app:doc := doc('/db/apps/app-morrisiaid/data/master_file.xml');
declare variable $app:indicesPersons := doc('/db/apps/app-morrisiaid/data/persons_places.xml')//tei:listPerson;
declare variable $app:indicesPlaces := doc('/db/apps/app-morrisiaid/data/persons_places.xml')//tei:listPlace;

declare function app:mainTable($node as node(), $model as map(*), $advancedSearch, $pe1id, $both, $pe2id, $plid, $dateFrom, $dateTo, $sourceRef) {
    
    if ($advancedSearch eq 'yes') then
        
        
        array {
            
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
            if (exists(tei:ab[@type = 'sent']/tei:date/@when) and substring(tei:ab[@type = 'sent']/tei:date/@when, 1, 1) ne '-') then
                
                xs:int(substring(tei:ab[@type = 'sent']/tei:date/@when, 1, 4)) >= xs:int($dateFrom)
                and
                xs:int(substring(tei:ab[@type = 'sent']/tei:date/@when, 1, 4)) <= xs:int($dateTo)
                
                
                (:...otherwise it means that the year is missing and it's incomplete. If that's the case,
            check if the checkbox 'incomplete' is checked or not. If it is checked, the condition is true and
            the portion of the $condition is true. The form submits the includeUndated parameter as 'on' if checked,
            so we will check for that too.    
            
        else if ($includeUndated eq 'on' or $includeUndated eq 'true') then
                true() :)
            else
                true()
            
            )
                satisfies $condition
            ]
            
            let $dateSent := data($record/tei:ab[@type = "sent"]/tei:date/@when)
            
            let $personSentNumber := count($record/tei:ab[@type = "sent"]/tei:persName)
            let $personSentFullName :=
            for $personSent at $pos in $record/tei:ab[@type = "sent"]/tei:persName
            let $personSentID := data($personSent/@ref)
            let $personSentForename := $indicesPersons/tei:person[@xml:id = $personSentID]/tei:persName/tei:forename
            let $personSentSurname := $indicesPersons/tei:person[@xml:id = $personSentID]/tei:persName/tei:surname
            let $fullNameSent := if ($personSentNumber eq ($pos)) then
                $personSentForename || ' ' || $personSentSurname
            else
                $personSentForename || ' ' || $personSentSurname || '; '
            return
                $fullNameSent
            
            let $personReceivedNumber := count($record/tei:ab[@type = "received"]/tei:persName)
            let $personReceivedFullName :=
            for $personReceived at $pos in $record/tei:ab[@type = "received"]/tei:persName
            let $personReceivedID := data($personReceived/@ref)
            let $personReceivedForename := $indicesPersons/tei:person[@xml:id = $personReceivedID]/tei:persName/tei:forename
            let $personReceivedSurname := $indicesPersons/tei:person[@xml:id = $personReceivedID]/tei:persName/tei:surname
            let $fullNameReceived := if ($personReceivedNumber eq ($pos)) then
                $personReceivedForename || ' ' || $personReceivedSurname
            else
                $personReceivedForename || ' ' || $personReceivedSurname || '; '
            return
                $fullNameReceived
            
            let $placeSentNumber := count($record/tei:ab[@type = "sent"]/tei:placeName)
            let $placeSentName :=
            for $placeSent at $pos in $record/tei:ab[@type = "sent"]/tei:placeName
            let $placeSentID := data($placeSent/@ref)
            let $placeSentgeogName := $indicesPlaces/tei:place[@xml:id = $placeSentID]/tei:placeName/tei:geogName/text()
            let $placeSent := if ($placeSentNumber eq ($pos)) then
                $placeSentgeogName
            else
                $placeSentgeogName || '; '
            return
                $placeSent
            
            let $placeReceivedNumber := count($record/tei:ab[@type = "received"]/tei:placeName)
            let $placeReceivedName :=
            for $placeReceived at $pos in $record/tei:ab[@type = "received"]/tei:placeName
            let $placeReceivedID := data($placeReceived/@ref)
            let $placeReceivedgeogName := $indicesPlaces/tei:place[@xml:id = $placeReceivedID]/tei:placeName/tei:geogName/text()
            let $placeReceived := if ($placeReceivedNumber eq ($pos)) then
                $placeReceivedgeogName
            else
                $placeReceivedgeogName || '; '
            return
                $placeReceived
            
            
            let $id := <a
                href="detail.html?emloID={data($record/@xml:id)}">{data($record/@xml:id)}</a>
            
            return
                
                <tr><td>{$dateSent}</td><td>{$personSentFullName}</td><td>{$personReceivedFullName}</td>
                    <td>{$placeSentName}</td><td>{$placeReceivedName}</td><td><a
                            class='detailLink'
                            href="detail.html?emloID={$id}"><span
                                class="fi-envelope-open"></span></a></td></tr>
        
        }
    
    else
        
        
        for $record in $app:doc//tei:item
        
        let $id := data($record/@xml:id)
        
        let $dateSent := data($record/tei:ab[@type = "sent"]/tei:date/@when)
        
        let $personSentNumber := count($record/tei:ab[@type = "sent"]/tei:persName)
        
        
        (:let $personSentFullName := app:getFullName($id, 'sent', $personSentNumber):)
        
        let $personSentFullName :=
        for $personSent at $pos in $record/tei:ab[@type = "sent"]/tei:persName
        let $personSentID := data($personSent/@ref)
        let $personSentForename := $app:indicesPersons/tei:person[@xml:id = $personSentID]/tei:persName/tei:forename
        let $personSentSurname := $app:indicesPersons/tei:person[@xml:id = $personSentID]/tei:persName/tei:surname
        let $fullNameSent := if ($personSentNumber eq ($pos)) then
            $personSentForename || ' ' || $personSentSurname
        else
            $personSentForename || ' ' || $personSentSurname || '; '
        return
            $fullNameSent
        
        let $personReceivedNumber := count($record/tei:ab[@type = "received"]/tei:persName)
        let $personReceivedFullName :=
        for $personReceived at $pos in $record/tei:ab[@type = "received"]/tei:persName
        let $personReceivedID := data($personReceived/@ref)
        let $personReceivedForename := $app:indicesPersons/tei:person[@xml:id = $personReceivedID]/tei:persName/tei:forename
        let $personReceivedSurname := $app:indicesPersons/tei:person[@xml:id = $personReceivedID]/tei:persName/tei:surname
        let $fullNameReceived := if ($personReceivedNumber eq ($pos)) then
            $personReceivedForename || ' ' || $personReceivedSurname
        else
            $personReceivedForename || ' ' || $personReceivedSurname || '; '
        return
            $fullNameReceived
        
        let $placeSentNumber := count($record/tei:ab[@type = "sent"]/tei:placeName)
        let $placeSentName :=
        for $placeSent at $pos in $record/tei:ab[@type = "sent"]/tei:placeName
        let $placeSentID := data($placeSent/@ref)
        let $placeSentgeogName := $app:indicesPlaces/tei:place[@xml:id = $placeSentID]/tei:placeName/tei:geogName/text()
        let $placeSent := if ($placeSentNumber eq ($pos)) then
            $placeSentgeogName
        else
            $placeSentgeogName || '; '
        return
            $placeSent
        
        let $placeReceivedNumber := count($record/tei:ab[@type = "received"]/tei:placeName)
        let $placeReceivedName :=
        for $placeReceived at $pos in $record/tei:ab[@type = "received"]/tei:placeName
        let $placeReceivedID := data($placeReceived/@ref)
        let $placeReceivedgeogName := $app:indicesPlaces/tei:place[@xml:id = $placeReceivedID]/tei:placeName/tei:geogName/text()
        let $placeReceived := if ($placeReceivedNumber eq ($pos)) then
            $placeReceivedgeogName
        else
            $placeReceivedgeogName || '; '
        return
            $placeReceived
        
        return
            
            <tr><td>{$dateSent}</td><td>{$personSentFullName}</td><td>{$personReceivedFullName}</td>
                <td>{$placeSentName}</td><td>{$placeReceivedName}</td><td><a
                        class='detailLink'
                        href="detail.html?emloID={$id}"><span
                            class="fi-envelope-open"></span></a></td></tr>
};

declare function app:detail($node as node(), $model as map(*), $emloID) {
    
    let $xsl := (
    <xsl:stylesheet
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:tei="http://www.tei-c.org/ns/1.0"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        exclude-result-prefixes="tei"
        version="3.0">
        <xsl:template
            match="//tei:hi">
            <xsl:element
                name="i">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
        <xsl:template
            match="//tei:ref">
            
            <xsl:element
                name='a'>
                
                <xsl:attribute
                    name='href'>
                    <xsl:text>detail.html?emloID=</xsl:text>
                    <xsl:value-of
                        select="current()/@target"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        
        </xsl:template>
        <xsl:template
            match="tei:idno[processing-instruction('morrisiaid')[.='book-title']]">
            <xsl:element
                name="i">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
    </xsl:stylesheet>)
    
    let $params :=
    <parameters>
        {
            for $p in request:get-parameter-names()
            let $val := request:get-parameter($p, ())
                where not($p = ("document", "directory", "stylesheet"))
            return
                <param
                    name="{$p}"
                    value="{$val}"/>
        }
    </parameters>
    
    let $app:doc := doc('/db/apps/app-morrisiaid/data/master_file.xml')
    let $app:indicesPersons := doc('/db/apps/app-morrisiaid/data/persons_places.xml')//tei:listPerson
    let $app:indicesPlaces := doc('/db/apps/app-morrisiaid/data/persons_places.xml')//tei:listPlace
    let $record := $app:doc//tei:item[@xml:id = $emloID]
    
    let $id := $emloID
    
    let $personSentNumber := count($record/tei:ab[@type = "sent"]/tei:persName)
    let $personSentFullName :=
    for $personSent at $pos in $record/tei:ab[@type = "sent"]/tei:persName
    let $personSentID := data($personSent/@ref)
    let $autorAsMarked := $personSent/text()
    let $personSentForename := $app:indicesPersons/tei:person[@xml:id = $personSentID]/tei:persName/tei:forename
    let $personSentSurname := $app:indicesPersons/tei:person[@xml:id = $personSentID]/tei:persName/tei:surname
    let $personSentCert := $personSent/@cert
    let $fullNameSent :=
    if ($personSentID) then
        (if ($personSentForename) then
            $personSentForename || ' ' || $personSentSurname
        else
            $personSentSurname) ||
        (if ($personSentCert eq 'high') then
            " (tybiedig)"
        else
            if ($personSentCert eq 'medium') then
                " (lledgywir)"
            else
                if ($personSentCert eq 'low') then
                    " (ansicr)"
                else
                    '')
    else
        ''
    return
        if ($personSentNumber eq ($pos)) then
            $fullNameSent
        else
            $fullNameSent || ';'
    
    let $autorsAsMarked :=
    for $personSent at $pos in $record/tei:ab[@type = "sent"]/tei:persName
    let $personSentID := data($personSent/@ref)
    let $autorAsMarked := $personSent/text()
    
    return
        if ($autorAsMarked) then
            ' [' || $autorAsMarked || ']'
        else
            ''
            
            (:return
        $fullNameSent:)
    
    let $personReceivedNumber := count($record/tei:ab[@type = "received"]/tei:persName)
    let $personReceivedFullName :=
    for $personReceived at $pos in $record/tei:ab[@type = "received"]/tei:persName
    let $addresseeAsMarked := $personReceived/text()
    let $personReceivedID := data($personReceived/@ref)
    let $personReceivedForename := $app:indicesPersons/tei:person[@xml:id = $personReceivedID]/tei:persName/tei:forename
    let $personReceivedSurname := $app:indicesPersons/tei:person[@xml:id = $personReceivedID]/tei:persName/tei:surname
    let $personReceivedCert := $personReceived/@cert
    let $fullNameReceived :=
    if ($personReceivedID) then
        (if ($personReceivedForename) then
            ($personReceivedForename || ' ' || $personReceivedSurname)
        
        else
            $personReceivedSurname) ||
        (if ($personReceivedCert eq 'high') then
            " (tybiedig)"
        else
            if ($personReceivedCert eq 'medium') then
                " (lledgywir)"
            else
                if ($personReceivedCert eq 'low') then
                    " (ansicr)"
                else
                    '')
    else
        ''
    return
        if ($personReceivedNumber eq ($pos)) then
            $fullNameReceived
        else
            $fullNameReceived || ';'
    
    let $addresseesAsMarked :=
    for $personReceived at $pos in $record/tei:ab[@type = "received"]/tei:persName
    let $addresseeAsMarked := $personReceived/text()
    return
        if ($addresseeAsMarked) then
            ' [' || $addresseeAsMarked || ']'
        else
            ''
            
            (:return
        $fullNameReceived :)
    
    let $placeSentNumber := count($record/tei:ab[@type = "sent"]/tei:placeName)
    let $placeSentName :=
    for $placeSent at $pos in $record/tei:ab[@type = "sent"]/tei:placeName
    let $placeSentID := data($placeSent/@ref)
    let $originAsMarked := $placeSent/text()
    let $placeSentgeogName := $app:indicesPlaces/tei:place[@xml:id = $placeSentID]/tei:placeName/tei:geogName
    let $placeSentCert := $placeSent/@cert
    let $fullPlaceNameSent :=
    if ($placeSentID) then
        $placeSentgeogName ||
        (if ($placeSentCert eq 'high') then
            " (tybiedig)"
        else
            if ($placeSentCert eq 'medium') then
                " (lledgywir)"
            else
                if ($placeSentCert eq 'low') then
                    " (ansicr)"
                else
                    '')
        (: || (if ($originAsMarked) then
            ' [' || $originAsMarked || ']'
        else
            '') :)
    else
        ''
    
    return
        if ($placeSentNumber eq ($pos)) then
            $fullPlaceNameSent
        else
            $fullPlaceNameSent || '; '
    
    let $originsAsMarked :=
    for $placeSent at $pos in $record/tei:ab[@type = "sent"]/tei:placeName
    let $originAsMarked := $placeSent/text()
    return
        if ($originAsMarked) then
            ' [' || normalize-space($originAsMarked) || ']'
        else
            ''
    
    let $placeReceivedNumber := count($record/tei:ab[@type = "received"]/tei:placeName)
    let $placeReceivedName :=
    for $placeReceived at $pos in $record/tei:ab[@type = "received"]/tei:placeName
    let $placeReceivedID := data($placeReceived/@ref)
    let $placeReceivedAsMarked := $placeReceived/text()
    let $placeReceivedgeogName := $app:indicesPlaces/tei:place[@xml:id = $placeReceivedID]/tei:placeName/tei:geogName
    let $placeReceivedCert := $placeReceived/@cert
    let $fullPlaceNameReceived :=
    if ($placeReceivedID) then
        $placeReceivedgeogName ||
        (if ($placeReceivedCert eq 'high') then
            " (tybiedig)"
        else
            if ($placeReceivedCert eq 'medium') then
                " (lledgywir)"
            else
                if ($placeReceivedCert eq 'low') then
                    " (ansicr)"
                else
                    '')
        (: || (if ($placeReceivedAsMarked) then
            ' [' || $placeReceivedAsMarked || ']'
        else
            '') :)
    else
        ''
    return
        if ($placeReceivedNumber eq ($pos)) then
            $fullPlaceNameReceived
        else
            $fullPlaceNameReceived || ';'
    
    let $placesReceivedAsMarked :=
    for $placeReceived at $pos in $record/tei:ab[@type = "received"]/tei:placeName
    let $placeReceivedAsMarked := $placeReceived/text()
    
    return
        if ($placeReceivedAsMarked) then
            ' [' || $placeReceivedAsMarked || ']'
        else
            ''
    
    
    let $sentDateStandardised := data($record/tei:ab[@type = 'sent']/tei:date/@when)
    let $sentDateMarked := $record/tei:ab[@type = 'sent']/tei:date
    let $sentDateMarkedCert := $record/tei:ab[@type = 'sent']/tei:date/@cert
    let $calendar := $record/tei:ab[@type = 'sent']/tei:date/tei:seg
    
    let $receivedDateMarked := data($record/tei:ab[@type = 'received']/tei:date/@when)
    
    (:notes:)
    
    let $noteDateSent := $record/tei:ab[@type = 'sent']/tei:note[@type = 'date_sent']
    let $notePlaceSent := $record/tei:ab[@type = 'sent']/tei:note[@type = 'place_sent']
    let $noteAuthorSent := $record/tei:ab[@type = 'sent']/tei:note[@type = 'person_sent']
    
    let $notePlaceReceived := $record/tei:ab[@type = 'received']/tei:note[@type = 'place_received']
    let $notePersonReceived := $record/tei:ab[@type = 'received']/tei:note[@type = 'person_received']
    
    let $incipit := $record/tei:ab[@type = 'incipit']
    let $explicit := $record/tei:ab[@type = 'explicit']
    let $notesContent := $record/tei:note[@type = 'content']
    let $language := $record/tei:lang/text()
    let $languageNote := $record/tei:lang/tei:note
    
    
    (: manifestations :)
    
    let $manifestationsDoc := doc('/db/apps/app-morrisiaid/data/manifestations.xml')
    let $manifestationsDoc_how_many := count($manifestationsDoc//tei:item[tei:ref/text() eq $emloID])
    let $manifestations := for $manifestation at $pos in $manifestationsDoc//tei:item[tei:ref/text() eq $emloID]
    let $type := data($manifestation/tei:msDesc/@type)
    let $repository := $manifestation/tei:msDesc/tei:msIdentifier/tei:repository
    let $idno := $manifestation/tei:msDesc/tei:msIdentifier/tei:idno
    let $p_e_d := $manifestation/tei:msDesc/tei:ab[@type = 'p_e_d']
    let $MSnote := $manifestation/tei:msDesc/tei:ab[@type = 'note']
    let $count := count($type = 'P')
        order by ($type = 'P') descending
    return
        <div
            class='callout primary'><p><b>Math: </b>{
                    switch ($type)
                        case 'Ll'
                            return
                                "Llawysgrif"
                        case 'P'
                            return
                                'Printiedig'
                        case 'A'
                            return
                                'Arall'
                        case 'CLl'
                            return
                                'Copi llawysgrif'
                        case 'D'
                            return
                                'Drafft'
                        case 'Deth'
                            return
                                'Detholiad'
                        default return
                            ''
            }</p>
        {
            if ($repository ne 'n.a.') then
                <p><b>Cronfa: </b>{$repository}</p>
            else
                ''
        }
        {
            if ($idno ne 'n.a.') then
                <p><b>Rhif adnabod: </b>{transform:transform($idno, $xsl, $params)}</p>
            else
                ''
        }
        {
            if ($p_e_d ne '') then
                <p><b>Ffynhonnell: </b>{transform:transform($p_e_d, $xsl, $params)}</p>
            else
                ''
        }
        {
            if ($MSnote ne '') then
                <p><b>Nodyn: </b>{transform:transform($MSnote, $xsl, $params)}</p>
            else
                ''
        }
        <!--{if ($manifestationsDoc_how_many ne $pos) then <hr/> else ''}-->
    </div>


return
    
    (<div
        class='callout'><h2>Manylion {$emloID}</h2>
        {
            if ($personSentFullName = '') then
                ''
            else
                <p><b>Awdur: </b>{$personSentFullName}
                    {$autorsAsMarked}</p>
        }
        {
            if ($noteAuthorSent eq '') then
                ''
            else
                <p><b>Nodyn ynghylch awdur: </b>
                    {$noteAuthorSent}</p>
        }
        {
            if ($placeSentName = '') then
                ''
            else
                <p><b>Lleoliad awdur: </b>
                    {$placeSentName}
                    {$originsAsMarked}</p>
        }
        {
            if ($notePlaceSent eq '') then
                ''
            else
                <p><b>Nodyn ynghylch lleoliad ysgrifennu: </b>{$notePlaceSent}</p>
        }
        {
            if ((string-join($sentDateMarked/text()/normalize-space(), '') = '') and (empty($sentDateStandardised)) or $sentDateStandardised = '') then
                ''
            else
                <p><b>Dyddiad anfon: </b>
                    {
                        if ($receivedDateMarked eq '' or empty($receivedDateMarked)) then
                            $sentDateStandardised
                        else
                            $sentDateStandardised || ' hyd ' || $receivedDateMarked
                    }
                    
                    {
                        if ($sentDateMarkedCert eq 'high') then
                            " (tybiedig)"
                        else
                            if ($sentDateMarkedCert eq 'medium') then
                                " (lledgywir)"
                            else
                                if ($sentDateMarkedCert eq 'low') then
                                    " (ansicr)"
                                else
                                    ''
                    }
                    {
                        if (empty($sentDateMarked/text()) or string-join($sentDateMarked/text()/normalize-space()) = '') then
                            ''
                        else
                            (' [' || string-join($sentDateMarked/text()/normalize-space(), '') || ']')
                    }
                    {
                        if ($calendar ne 'Calendr Iŵl' or empty($calendar)) then
                            ''
                        else
                            ' (calendr gwreiddiol: Iŵl)'
                    }
                </p>
        }
        
        {
            if ($noteDateSent eq '') then
                ''
            else
                <p><b>Nodyn ynghylch dyddiad anfon: </b>
                    {transform:transform($noteDateSent, $xsl, $params)}</p>
        }
        {
            if ($personReceivedFullName = '') then
                ''
            else
                <p><b>Derbynnydd: </b>
                    {$personReceivedFullName}
                    {$addresseesAsMarked}</p>
        }
        {
            if ($notePersonReceived = '') then
                ''
            else
                <p><b>Nodyn ynghylch derbynnydd: </b>{$notePersonReceived}</p>
        }
        {
            if ($placeReceivedName = '') then
                ''
            else
                <p><b>Lleoliad derbynnydd: </b>{$placeReceivedName}
                    {$placesReceivedAsMarked}</p>
        }
        {
            if ($notePlaceReceived eq '') then
                ''
            else
                <p><b>Nodyn ynghylch Lleoliad derbynnydd: </b>{$notePlaceReceived}</p>
        }
        {
            if (empty($language) or $language = '' or $language/text() eq '') then
                ''
            else
                <p><b>Iaith: </b>{$language}</p>
        }
        {
            if (empty($languageNote) or $languageNote/text() eq '' or $languageNote eq '') then
                ''
            else
                <p><b>Defnydd o iaith: </b>{$languageNote}</p>
        }
        {
            if ($notesContent = '') then
                ''
            else
                <p><b>Nodiadau cyffredinol: </b>{transform:transform($notesContent, $xsl, $params)}</p>
        }
        {
            if ($incipit eq '') then
                ''
            else
                <p><b>Cychwyneiriau: </b><lb/>{$incipit}</p>
        }
        {
            if ($explicit eq '') then
                ''
            else
                <p><b>Diweddglo: </b><lb/>{$explicit}</p>
        }
        
        <h3>Ceir {$manifestationsDoc_how_many} ymddangosiad</h3>
        {$manifestations}
    </div>)

};
