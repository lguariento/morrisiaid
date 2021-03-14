xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

let $doc := doc('/db/apps/app-test2/data/file.xml')
for $record in $doc//tei:item

let $msDescElement := $record/tei:msDesc
let $type := data($record/@type)

(: update:)
let $update_type := update insert attribute type {$type} into $msDescElement

return 
    
 $type