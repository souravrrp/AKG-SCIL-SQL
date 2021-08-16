SELECT l.subledger_doc_sequence_value "Doc Number",
l.effective_date "GL Date",
l.accounted_dr "Debit",
l.accounted_cr "Credit",
l.description "Description",
l.reference_4 "AR Number",
l.reference_9 "AR Type"
FROM apps.gl_je_lines l, apps.gl_je_headers h
WHERE je_source = 'Receivables'
AND h.je_header_id = l.je_header_id
AND h.LEDGER_ID = 2025
AND h.period_name = 'SEP-17'
