xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

let $doc := doc('/db/apps/app-test2/data/file.xml')
for $record in $doc//tei:item

(: sent :)
let $dateSElement := $record/tei:ab[@type="sent"]/tei:date
let $whenS := data($record/@whenS)
let $calendar := data($record/@calendar)
let $certDS := data($record/@certDS)

let $persNameSElement := $record/tei:ab[@type='sent']/tei:persName
let $refPeS := data($record/@refPeS)
let $certPeS := data($record/@certPeS)

let $placeNameSElement := $record/tei:ab[@type='sent']/tei:placeName
let $refPlS := data($record/@refPlS)
let $certPlS := data($record/@certPlS)

(: received :)
let $dateRElement := $record/tei:ab[@type='received']/tei:date
let $whenR := data($record/@whenR)

let $persNameRElement := $record/tei:ab[@type='received']/tei:persName
let $refPeR := data($record/@refPeR)
let $certPeR := data($record/@certPeR)

let $placeNameRElement := $record/tei:ab[@type='received']/tei:placeName
let $refPlR := data($record/@refPlR)
let $certPlR := data($record/@certPlR)

(: content :)
(:let $incipitElement := $record/tei:ab[@type="incipit"] :)
(:let $explicitElement := $record/tei:ab[@type="explicit"] :)
(:let $noteContentElement := $record/tei:ab[@type="noteContent"] :)


(: sent update:)
let $update_whenS := update insert attribute when {$whenS} into $dateSElement
let $update_calendar := update insert attribute calendar {$calendar} into $dateSElement
let $update_certDS := update insert attribute cert {$certDS} into $dateSElement

let $update_refPeS := update insert attribute ref {$refPeS} into $persNameSElement
let $update_certPeS := update insert attribute cert {$certPeS} into $persNameSElement

let $update_refPlS := update insert attribute ref {$refPlS} into $placeNameSElement
let $update_certPlS := update insert attribute cert {$certPlS} into $placeNameSElement

(: received update:)
let $update_whenR := update insert attribute when {$whenR} into $dateRElement
let $update_refPeR := update insert attribute ref {$refPeR} into $persNameRElement
let $update_certPeR := update insert attribute cert {$certPeR} into $persNameRElement

let $update_refPlR := update insert attribute ref {$refPlR} into $placeNameRElement
let $update_certPlR := update insert attribute cert {$certPlR} into $placeNameRElement

(:  :let $update := update insert attribute xml:id {$id} into $person :)
return 
    
 $doc