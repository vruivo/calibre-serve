const makeWhere = require('../utils/makeWhere');

class Statement{

	getBookQuery(book) {
		const [where_str, value] = makeWhere('book', book, 'title', '_');

		const SQL = `SELECT
		books.id AS "book_id", books.title AS "book_title", books.sort AS "book_sort", books.author_sort AS "author_sort", books.has_cover AS "book_has_cover", books.pubdate AS "book_date", books.path AS "book_path", books.isbn AS "book_isbn", books.series_index AS "book_series_index", 
		(SELECT GROUP_CONCAT(authors_id, '|') FROM (SELECT DISTINCT authors.id authors_id FROM books_authors_link JOIN authors ON books_authors_link.author = authors.id WHERE books_authors_link.book = books.id)) AS "author_id", 
		(SELECT GROUP_CONCAT(authors_name, '|') FROM (SELECT DISTINCT authors.name authors_name FROM books_authors_link JOIN authors ON books_authors_link.author = authors.id WHERE books_authors_link.book = books.id)) AS "author_name", 
		(SELECT GROUP_CONCAT(authors_sort, '|') FROM (SELECT DISTINCT authors.sort authors_sort FROM books_authors_link JOIN authors ON books_authors_link.author = authors.id WHERE books_authors_link.book = books.id)) AS "author_sort", 
		(SELECT GROUP_CONCAT(tags_id, '|') FROM (SELECT DISTINCT tags.id tags_id FROM books_tags_link JOIN tags ON books_tags_link.tag = tags.id WHERE books_tags_link.book = books.id)) AS "tag_id", 
		(SELECT GROUP_CONCAT(tags_name, '|') FROM (SELECT DISTINCT tags.name tags_name FROM books_tags_link JOIN tags ON books_tags_link.tag = tags.id WHERE books_tags_link.book = books.id)) AS "tag_name", 
		(SELECT GROUP_CONCAT(series_id, '|') FROM (SELECT DISTINCT series.id series_id FROM books_series_link JOIN series ON books_series_link.series = series.id WHERE books_series_link.book = books.id)) AS "series_id", 
		(SELECT GROUP_CONCAT(series_name, '|') FROM (SELECT DISTINCT series.name series_name FROM books_series_link JOIN series ON books_series_link.series = series.id WHERE books_series_link.book = books.id)) AS "series_name", 
		(SELECT GROUP_CONCAT(series_sort, '|') FROM (SELECT DISTINCT series.sort series_sort FROM books_series_link JOIN series ON books_series_link.series = series.id WHERE books_series_link.book = books.id)) AS "series_sort", 
		(SELECT GROUP_CONCAT(data_book, '|') FROM (SELECT DISTINCT data.id data_book FROM data WHERE data.book = books.id)) AS "data_id", 
		(SELECT GROUP_CONCAT(data_book, '|') FROM (SELECT DISTINCT data.format data_book FROM data WHERE data.book = books.id)) AS "data_format", 
		(SELECT GROUP_CONCAT(data_book, '|') FROM (SELECT DISTINCT data.uncompressed_size data_book FROM data WHERE data.book = books.id)) AS "data_size", 
		(SELECT GROUP_CONCAT(data_book, '|') FROM (SELECT data.name data_book FROM data WHERE data.book = books.id)) AS "data_name", comments.text AS "comment"
		FROM books
		LEFT JOIN comments ON (comments.book = books.id)
		WHERE (${where_str})
		GROUP BY book_title`;

		return {
			sql: SQL,
			parameters: value
		}
	}

	getTagQuery(tag) {
		const [where_str, value] = makeWhere('tags', tag);

		const SQL = `SELECT
		(SELECT GROUP_CONCAT(books_id, '|') FROM (SELECT DISTINCT books.id books_id FROM books_tags_link JOIN books ON books_tags_link.book = books.id WHERE books_tags_link.tag = tags.id)) AS "book_id", (SELECT GROUP_CONCAT(books_title, '|') FROM (SELECT DISTINCT books.title books_title FROM books_tags_link JOIN books ON books_tags_link.book = books.id WHERE books_tags_link.tag = tags.id)) AS "book_title", (SELECT GROUP_CONCAT(books_sort, '|') FROM (SELECT DISTINCT books.sort books_sort FROM books_tags_link JOIN books ON books_tags_link.book = books.id WHERE books_tags_link.tag = tags.id)) AS "book_sort", (SELECT GROUP_CONCAT(books_has_cover, '|') FROM (SELECT DISTINCT books.has_cover books_has_cover FROM books_tags_link JOIN books ON books_tags_link.book = books.id WHERE books_tags_link.tag = tags.id)) AS "book_has_cover", (SELECT GROUP_CONCAT(books_pubdate, '|') FROM (SELECT DISTINCT books.pubdate books_pubdate FROM books_tags_link JOIN books ON books_tags_link.book = books.id WHERE books_tags_link.tag = tags.id)) AS "book_pubdate", (SELECT GROUP_CONCAT(books_path, '|') FROM (SELECT DISTINCT books.path books_path FROM books_tags_link JOIN books ON books_tags_link.book = books.id WHERE books_tags_link.tag = tags.id)) AS "book_path", (SELECT GROUP_CONCAT(books_series_index, '|') FROM (SELECT DISTINCT books.series_index books_series_index FROM books_tags_link JOIN books ON books_tags_link.book = books.id WHERE books_tags_link.tag = tags.id)) AS "book_series_index", tags.name AS "tag_name", tags.id AS "tag_id", tags.count AS "tag_books_count"
		FROM tag_browser_tags \`tags\`
		INNER JOIN books_tags_link ON (books_tags_link.tag = tags.id)
		INNER JOIN books ON (books.id = books_tags_link.book)
		WHERE (${where_str})
		GROUP BY tags.name`;

		return {
			sql: SQL,
			parameters: value
		}
	}

	getSeriesQuery(series) {
		const [where_str, value] = makeWhere('series', series);

		const SQL = `SELECT
		(SELECT GROUP_CONCAT(books_id, '|') FROM (SELECT DISTINCT books.id books_id FROM books_series_link JOIN books ON books_series_link.book = books.id WHERE books_series_link.series = series.id)) AS "book_id", (SELECT GROUP_CONCAT(books_title, '|') FROM (SELECT DISTINCT books.title books_title FROM books_series_link JOIN books ON books_series_link.book = books.id WHERE books_series_link.series = series.id)) AS "book_title", (SELECT GROUP_CONCAT(books_sort, '|') FROM (SELECT DISTINCT books.sort books_sort FROM books_series_link JOIN books ON books_series_link.book = books.id WHERE books_series_link.series = series.id)) AS "book_sort", (SELECT GROUP_CONCAT(books_has_cover, '|') FROM (SELECT DISTINCT books.has_cover books_has_cover FROM books_series_link JOIN books ON books_series_link.book = books.id WHERE books_series_link.series = series.id)) AS "book_has_cover", (SELECT GROUP_CONCAT(books_pubdate, '|') FROM (SELECT DISTINCT books.pubdate books_pubdate FROM books_series_link JOIN books ON books_series_link.book = books.id WHERE books_series_link.series = series.id)) AS "book_pubdate", (SELECT GROUP_CONCAT(books_path, '|') FROM (SELECT DISTINCT books.path books_path FROM books_series_link JOIN books ON books_series_link.book = books.id WHERE books_series_link.series = series.id)) AS "book_path", (SELECT GROUP_CONCAT(books_series_index, '|') FROM (SELECT DISTINCT books.series_index books_series_index FROM books_series_link JOIN books ON books_series_link.book = books.id WHERE books_series_link.series = series.id)) AS "book_series_index", series.id AS "series_id", series.name AS "series_name", series.sort AS "series_sort"
		FROM series
		LEFT JOIN books_series_link ON (books_series_link.series = series.id)
		LEFT JOIN books ON (books.id = books_series_link.book)
		WHERE (${where_str})
		GROUP BY series.name`;

		return {
			sql: SQL,
			parameters: value
		}
	}

	getAuthorQuery(author) {
		const [where_str, value] = makeWhere('authors', author);

		const SQL = `SELECT
		(SELECT GROUP_CONCAT(books_id, '|') FROM (SELECT DISTINCT books.id books_id FROM books_authors_link JOIN books ON books_authors_link.book = books.id WHERE books_authors_link.author = authors.id)) AS "book_id", (SELECT GROUP_CONCAT(books_title, '|') FROM (SELECT DISTINCT books.title books_title FROM books_authors_link JOIN books ON books_authors_link.book = books.id WHERE books_authors_link.author = authors.id)) AS "book_title", (SELECT GROUP_CONCAT(books_sort, '|') FROM (SELECT DISTINCT books.sort books_sort FROM books_authors_link JOIN books ON books_authors_link.book = books.id WHERE books_authors_link.author = authors.id)) AS "book_sort", (SELECT GROUP_CONCAT(books_has_cover, '|') FROM (SELECT DISTINCT books.has_cover books_has_cover FROM books_authors_link JOIN books ON books_authors_link.book = books.id WHERE books_authors_link.author = authors.id)) AS "book_has_cover", (SELECT GROUP_CONCAT(books_pubdate, '|') FROM (SELECT DISTINCT books.pubdate books_pubdate FROM books_authors_link JOIN books ON books_authors_link.book = books.id WHERE books_authors_link.author = authors.id)) AS "book_pubdate", (SELECT GROUP_CONCAT(books_path, '|') FROM (SELECT DISTINCT books.path books_path FROM books_authors_link JOIN books ON books_authors_link.book = books.id WHERE books_authors_link.author = authors.id)) AS "book_path", (SELECT GROUP_CONCAT(books_series_index, '|') FROM (SELECT DISTINCT books.series_index books_series_index FROM books_authors_link JOIN books ON books_authors_link.book = books.id WHERE books_authors_link.author = authors.id)) AS "book_series_index", (SELECT GROUP_CONCAT(series_id, '|') FROM (SELECT DISTINCT series.id series_id FROM books_series_link JOIN series ON books_series_link.series = series.id WHERE books_series_link.book = books.id)) AS "series_id", (SELECT GROUP_CONCAT(series_name, '|') FROM (SELECT DISTINCT series.name series_name FROM books_series_link JOIN series ON books_series_link.series = series.id WHERE books_series_link.book = books.id)) AS "series_name", (SELECT GROUP_CONCAT(series_sort, '|') FROM (SELECT DISTINCT series.sort series_sort FROM books_series_link JOIN series ON books_series_link.series = series.id WHERE books_series_link.book = books.id)) AS "series_sort", tag_browser_authors.count AS "authors_books_count", authors.id AS "author_id", authors.name AS "author_name", authors.sort AS "author_sort"
		FROM authors
		INNER JOIN tag_browser_authors ON (tag_browser_authors.id = authors.id)
		INNER JOIN books_authors_link ON (books_authors_link.author = authors.id)
		INNER JOIN books ON (books.id = books_authors_link.book)
		WHERE (${where_str})
		GROUP BY author_name`;
		
		return {
			sql: SQL,
			parameters: value
		}
	}




	prepareQueryGetTag(tag) {
		const where_str = (tag == undefined) ? `tags.id LIKE '%'` : `tags.id = ?`;

		const SQL = "SELECT books.id AS book_id, books.title AS book_title, books.sort AS book_sort, books.has_cover AS book_has_cover, books.pubdate AS book_pubdate, books.path AS book_path, books.series_index AS book_series_index, tags.id AS tag_id, tags.name AS tag_name" +
			" FROM ((books" +
			" INNER JOIN books_tags_link ON books.id = books_tags_link.book )" +
			" INNER JOIN tags ON books_tags_link.tag = tags.id )" +
			" WHERE ("+ where_str +")" +
			" ORDER BY tags.name";

		return {
			sql: SQL,
			parameters: tag
		}
	}
	processGetTagRows(rows) {
		const result = [];

		rows.forEach(row => {
			let book = {
			  book_id: row.book_id.toString(),
			  book_title: row.book_title,
			  book_sort: row.book_sort,
			  book_has_cover: row.book_has_cover.toString(),
			  book_pubdate: row.book_pubdate,
			  book_path: row.book_path,
			  book_series_index: row.book_series_index.toString()
			}
	  
			if (result.length > 0 && result[result.length-1].tag_name === row.tag_name) {
			  const prev_tag = result[result.length-1];
			  prev_tag.tag_books_count++;
			  prev_tag.books.push(book);
			}
			else {
			  result.push({
				tag_name: row.tag_name,
				tag_id: row.tag_id,
				tag_books_count: 1,
				books: [book]
			  });
			}
		})
		return result;
	}


	prepareQueryGetBook(book) {
		const where_str = (book == undefined) ? `books.id LIKE '%'` : `books.id = ?`;

		const SQL = `SELECT
		books.id AS "book_id", books.title AS "book_title", books.sort AS "book_sort", books.author_sort AS "author_sort", books.has_cover AS "book_has_cover", books.pubdate AS "book_pubdate", books.path AS "book_path", books.isbn AS "book_isbn", books.series_index AS "book_series_index",
		authors.id AS author_id, authors.name AS author_name, authors.sort AS author_sort,
		tags.id AS tag_id, tags.name AS tag_name,
		series.id AS series_id, series.name AS series_name, series.sort AS series_sort,
		data.id AS data_id, data.format AS data_format, data.uncompressed_size AS data_uncompressed_size, data.name AS data_name,
		comments.text AS comments_text
		FROM ((((((((books 
		INNER JOIN books_authors_link ON books.id = books_authors_link.book )
		INNER JOIN authors ON books_authors_link.author = authors.id )
		INNER JOIN books_tags_link ON books.id = books_tags_link.book )
		INNER JOIN tags ON books_tags_link.tag = tags.id )
		LEFT JOIN books_series_link ON books.id = books_series_link.book )
		LEFT JOIN series ON books_series_link.series = series.id )
		INNER JOIN data ON data.book = books.id )
		LEFT JOIN comments ON comments.book = books.id )
		WHERE (${where_str})
		ORDER BY books.title`;

		return {
			sql: SQL,
			parameters: book
		}
	}
	processGetBookRows(rows) {
		const result = [];

		rows.forEach(row => {
			let book = {
			  book_id: row.book_id,
			  book_title: row.book_title,
			  book_sort: row.book_sort,
			  book_has_cover: row.book_has_cover,
			  book_date: row.book_pubdate,
			  book_path: row.book_path,
			  book_series_index: row.book_series_index,
			  book_isbn: row.book_isbn,
			  comment: row.comments_text
			}

			let tag = {
				tag_id:   row.tag_id.toString(),
				tag_name: row.tag_name
			}

			let author = {
				author_id:   row.author_id.toString(),
				author_name: row.author_name,
				author_sort: row.author_sort
			}

			let series = {
				series_id:   row.series_id ? row.series_id.toString() : undefined,
				series_name: row.series_name,
				series_sort: row.series_sort
			}

			let data = {
				data_id:   row.data_id.toString(),
				data_name: row.data_name,
				data_format: row.data_format,
				data_size: row.data_uncompressed_size.toString()
			}
	  
			if (result.length > 0 && result[result.length-1].book_id === row.book_id) {
			  const prev_book = result[result.length-1];
				if (author.author_id && !prev_book.authors.find(prev => prev.author_id === author.author_id)) {
					prev_book.authors.push(author);
				}
				if (tag.tag_id && !prev_book.tags.find(prev => prev.tag_id === tag.tag_id)) {
					prev_book.tags.push(tag);
				}
				if (series.series_id && !prev_book.series.find(prev => prev.series_id === series.series_id)) {
					prev_book.series.push(series);
				}
				if (data.data_id && !prev_book.data.find(prev => prev.data_id === data.data_id)) {
					prev_book.data.push(data);
				}
			}
			else {
			  result.push({
				...book,
				authors: [author],
				tags: [tag],
				series: series.id ? [series] : [],
				data: [data]
			  });
			}
		})
		return result;
	}
}

function makeStatement(){
	return new Statement();
}

makeStatement.Statement = Statement;

module.exports = makeStatement;