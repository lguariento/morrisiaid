xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

      let $pe1id := 'pe_027'
      let $pe2id := 'pe_116'
      let $pl := 'pl_096'
let $doc := doc("/db/apps/morrisiaid-db/data/master_file.xml")
    for $entry in $doc//tei:ab[@type = "sent"][tei:persName/@ref = $pe1id] 
    and $doc//tei:ab[@type = "received"][tei:persName/@ref = $pe2id]
    and $doc//tei:ab[@type = 'sent'][tei:placeName/@ref= $pl]
    let $itemId := $entry
    return
        $itemId