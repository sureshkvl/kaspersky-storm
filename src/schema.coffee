schema_kaspersky =
    name: "kaspersky"
    type: "object"
    additionalProperties: false
    properties:
        "HAVE_KASPERSKY"            :      {"type":"boolean", "required":false}
        "KASPERSKY_SCAN_TIMEOUT"    :      {"type":"number", "required":false}
        "KASPERSKY_MAX_SESSIONS"    :      {"type":"number", "required":true}
        "HTTP_VIRUS_TEMPLATE" :
            type : "object"
            properties :
                "filename"          :       {"type":"string", "required":true}
                "encoding"          :       {"type":"string", "required":true}
                "data"              :       {"type":"string", "required":true}
        "HTTP_AV_SCAN"              :       {"type":"boolean", "required":false}
        "KASPERSKY_HTTP_UPLOAD"     :       {"type":"boolean", "required":false}
        "KASPERSKY_HTTP_DOWNLOAD"   :       {"type":"boolean", "required":false}
        "MAIL_AV_SCAN"              :       {"type":"boolean", "required":false}
        "KASPERSKY_SMTP"            :       {"type":"boolean", "required":false}
        "KASPERSKY_POP3"            :       {"type":"boolean", "required":false} 
        "KASPERSKY_IMAP"            :       {"type":"boolean", "required":false}

module.exports.kaspersky = schema_kaspersky