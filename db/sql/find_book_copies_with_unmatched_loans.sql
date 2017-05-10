SELECT
    *
FROM
    book_copies T2
WHERE
    NOT EXISTS (SELECT *
        FROM
           book_loans T1
        WHERE
           T1.book_copy_id = T2.id AND
           T1.academic_year_id = 16)
    AND T2.status_id is null