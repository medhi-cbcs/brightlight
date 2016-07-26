select e.title, e.isbn13, be.dupeCount, e.id
from book_editions e
inner join (
    SELECT isbn13, COUNT(*) AS dupeCount
    FROM book_editions
    GROUP BY isbn13
    HAVING COUNT(*) > 1
) be on e.isbn13 = be.isbn13