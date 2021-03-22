USE `BookData`;

-- 7.1: Author's number of books 
SELECT Authors.author, count(isbn13) FROM BookAuthors
LEFT JOIN Authors
ON BookAuthors.author_id = Authors.author_id
GROUP BY BookAuthors.author_id;

-- 7.1: List a particular author's books (use Name)
SELECT Books.title FROM Books
LEFT JOIN BookAuthors
ON BookAuthors.isbn13 = Books.isbn13
LEFT JOIN Authors
ON BookAuthors.author_id = Authors.author_id
WHERE Authors.author = "Willie Edison";

-- 7.2. Authors per book.
SELECT Books.title, count(BookAuthors.author_id) FROM Books
LEFT JOIN BookAuthors
ON BookAuthors.isbn13 = Books.isbn13
GROUP BY Books.title;

-- 7.2. Authors per book, given a book
SELECT Authors.author FROM Books
LEFT JOIN BookAuthors ON BookAuthors.isbn13 = Books.isbn13
LEFT JOIN Authors ON Authors.author_id = BookAuthors.author_id
WHERE Books.title = "Some Ether";

-- 7.3. Author royalties on a book.
SELECT sum(Books.royalties*Books.cost*Orders.copies) FROM Books
LEFT JOIN Orders
ON Orders.isbn13 = Books.isbn13
WHERE Orders.isbn13 = Books.isbn13 AND Books.title = "Some Ether";

-- 7.4. Book royalties per author.
SELECT sum(Books.royalties*Books.cost*Orders.copies) FROM Books
LEFT JOIN Orders
ON Orders.isbn13 = Books.isbn13
LEFT JOIN BookAuthors
ON BookAuthors.isbn13 = Books.isbn13
LEFT JOIN Authors
ON Authors.author_id = BookAuthors.author_id
WHERE Authors.author="Agatha Christie" AND Books.isbn13 = BookAuthors.isbn13;

-- 7.5. Books in a genre.
SELECT genre, count(title) FROM Books
GROUP BY genre;

-- 7.5. Books in a given genre.
SELECT title FROM Books
WHERE genre = 'fantasy';

-- 7.6. Books published by a publisher (count).
SELECT publisher, count(title) FROM Books
GROUP BY publisher;

-- 7.6. Books published by a publisher (list).
SELECT title FROM Books
WHERE publisher = 'Disney Press';

-- 7.7. Editors per book.
SELECT Books.title, count(BookEditors.editor_id) FROM Books
LEFT JOIN BookEditors
ON BookEditors.isbn13 = Books.isbn13
GROUP BY Books.title;

-- 7.7 Editors per a given book
SELECT Editors.editor FROM Books
LEFT JOIN BookEditors ON BookEditors.isbn13 = Books.isbn13
LEFT JOIN Editors ON Editors.editor_id = BookEditors.editor_id
WHERE Books.title = "Some Ether";

-- 7.8. Books per editor.
SELECT Editors.editor, count(isbn13) FROM BookEditors
LEFT JOIN Editors
ON BookEditors.editor_id = Editors.editor_id
GROUP BY BookEditors.editor_id;

-- 7.8: List a particular editor's books (use Name)
SELECT Books.title FROM Books
LEFT JOIN BookEditors
ON BookEditors.isbn13 = Books.isbn13
LEFT JOIN Editors
ON BookEditors.editor_id = Editors.editor_id
WHERE Editors.editor = "Willie Edison";

-- 7.9. Books in an order.
SELECT Books.title FROM Orders
LEFT JOIN Books ON Books.isbn13 = Orders.isbn13
WHERE order_id = "1";

-- 7.10. Orders for a book.
SELECT order_id FROM Orders
LEFT JOIN Books ON Books.isbn13 = Orders.isbn13
WHERE Books.title = 'The Richest Man in Babylon';

-- 7.10. Copy orders for a book.
SELECT sum(copies) FROM Orders
LEFT JOIN Books ON Books.isbn13 = Orders.isbn13
WHERE Books.title = 'The Richest Man in Babylon';

-- 7.11. Customer orders.
SELECT * FROM Orders
WHERE customer_name = "Joan Cobos";

-- 7.12. Orders per customer.
SELECT count(*) FROM Orders
WHERE customer_name = "Matt Mason";
