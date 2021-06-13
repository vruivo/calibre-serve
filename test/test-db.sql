BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "authors" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL COLLATE NOCASE,
	"sort"	TEXT COLLATE NOCASE,
	"link"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("name")
);
CREATE TABLE IF NOT EXISTS "books" (
	"id"	INTEGER,
	"title"	TEXT NOT NULL DEFAULT 'Unknown' COLLATE NOCASE,
	"sort"	TEXT COLLATE NOCASE,
	"timestamp"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"pubdate"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"series_index"	REAL NOT NULL DEFAULT 1.0,
	"author_sort"	TEXT COLLATE NOCASE,
	"isbn"	TEXT COLLATE NOCASE,
	"lccn"	TEXT COLLATE NOCASE,
	"path"	TEXT NOT NULL,
	"flags"	INTEGER NOT NULL DEFAULT 1,
	"uuid"	TEXT,
	"has_cover"	BOOL DEFAULT 0,
	"last_modified"	TIMESTAMP NOT NULL DEFAULT '2000-01-01 00:00:00+00:00',
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "books_authors_link" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"author"	INTEGER NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("book","author")
);
CREATE TABLE IF NOT EXISTS "books_languages_link" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"lang_code"	INTEGER NOT NULL,
	"item_order"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	UNIQUE("book","lang_code")
);
CREATE TABLE IF NOT EXISTS "books_plugin_data" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	"val"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("book","name")
);
CREATE TABLE IF NOT EXISTS "books_publishers_link" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"publisher"	INTEGER NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("book")
);
CREATE TABLE IF NOT EXISTS "books_ratings_link" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"rating"	INTEGER NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("book","rating")
);
CREATE TABLE IF NOT EXISTS "books_series_link" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"series"	INTEGER NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("book")
);
CREATE TABLE IF NOT EXISTS "books_tags_link" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"tag"	INTEGER NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("book","tag")
);
CREATE TABLE IF NOT EXISTS "comments" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"text"	TEXT NOT NULL COLLATE NOCASE,
	PRIMARY KEY("id"),
	UNIQUE("book")
);
CREATE TABLE IF NOT EXISTS "conversion_options" (
	"id"	INTEGER,
	"format"	TEXT NOT NULL COLLATE NOCASE,
	"book"	INTEGER,
	"data"	BLOB NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("format","book")
);
CREATE TABLE IF NOT EXISTS "custom_columns" (
	"id"	INTEGER,
	"label"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"datatype"	TEXT NOT NULL,
	"mark_for_delete"	BOOL NOT NULL DEFAULT 0,
	"editable"	BOOL NOT NULL DEFAULT 1,
	"display"	TEXT NOT NULL DEFAULT '{}',
	"is_multiple"	BOOL NOT NULL DEFAULT 0,
	"normalized"	BOOL NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	UNIQUE("label")
);
CREATE TABLE IF NOT EXISTS "data" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"format"	TEXT NOT NULL COLLATE NOCASE,
	"uncompressed_size"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("book","format")
);
CREATE TABLE IF NOT EXISTS "feeds" (
	"id"	INTEGER,
	"title"	TEXT NOT NULL,
	"script"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("title")
);
CREATE TABLE IF NOT EXISTS "identifiers" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"type"	TEXT NOT NULL DEFAULT isbn COLLATE NOCASE,
	"val"	TEXT NOT NULL COLLATE NOCASE,
	PRIMARY KEY("id"),
	UNIQUE("book","type")
);
CREATE TABLE IF NOT EXISTS "languages" (
	"id"	INTEGER,
	"lang_code"	TEXT NOT NULL COLLATE NOCASE,
	PRIMARY KEY("id"),
	UNIQUE("lang_code")
);
CREATE TABLE IF NOT EXISTS "library_id" (
	"id"	INTEGER,
	"uuid"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("uuid")
);
CREATE TABLE IF NOT EXISTS "metadata_dirtied" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("book")
);
CREATE TABLE IF NOT EXISTS "annotations_dirtied" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("book")
);
CREATE TABLE IF NOT EXISTS "preferences" (
	"id"	INTEGER,
	"key"	TEXT NOT NULL,
	"val"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("key")
);
CREATE TABLE IF NOT EXISTS "publishers" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL COLLATE NOCASE,
	"sort"	TEXT COLLATE NOCASE,
	PRIMARY KEY("id"),
	UNIQUE("name")
);
CREATE TABLE IF NOT EXISTS "ratings" (
	"id"	INTEGER,
	"rating"	INTEGER CHECK("rating" > -1 AND "rating" < 11),
	PRIMARY KEY("id"),
	UNIQUE("rating")
);
CREATE TABLE IF NOT EXISTS "series" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL COLLATE NOCASE,
	"sort"	TEXT COLLATE NOCASE,
	PRIMARY KEY("id"),
	UNIQUE("name")
);
CREATE TABLE IF NOT EXISTS "tags" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL COLLATE NOCASE,
	PRIMARY KEY("id"),
	UNIQUE("name")
);
CREATE TABLE IF NOT EXISTS "last_read_positions" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"format"	TEXT NOT NULL COLLATE NOCASE,
	"user"	TEXT NOT NULL,
	"device"	TEXT NOT NULL,
	"cfi"	TEXT NOT NULL,
	"epoch"	REAL NOT NULL,
	"pos_frac"	REAL NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	UNIQUE("user","device","book","format")
);
CREATE TABLE IF NOT EXISTS "annotations" (
	"id"	INTEGER,
	"book"	INTEGER NOT NULL,
	"format"	TEXT NOT NULL COLLATE NOCASE,
	"user_type"	TEXT NOT NULL,
	"user"	TEXT NOT NULL,
	"timestamp"	REAL NOT NULL,
	"annot_id"	TEXT NOT NULL,
	"annot_type"	TEXT NOT NULL,
	"annot_data"	TEXT NOT NULL,
	"searchable_text"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	UNIQUE("book","user_type","user","format","annot_type","annot_id")
);
CREATE VIRTUAL TABLE annotations_fts USING fts5(searchable_text, content = 'annotations', content_rowid = 'id', tokenize = 'unicode61 remove_diacritics 2');
CREATE TABLE IF NOT EXISTS "annotations_fts_data" (
	"id"	INTEGER,
	"block"	BLOB,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "annotations_fts_idx" (
	"segid"	,
	"term"	,
	"pgno"	,
	PRIMARY KEY("segid","term")
) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS "annotations_fts_docsize" (
	"id"	INTEGER,
	"sz"	BLOB,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "annotations_fts_config" (
	"k"	,
	"v"	,
	PRIMARY KEY("k")
) WITHOUT ROWID;
CREATE VIRTUAL TABLE annotations_fts_stemmed USING fts5(searchable_text, content = 'annotations', content_rowid = 'id', tokenize = 'porter unicode61 remove_diacritics 2');
CREATE TABLE IF NOT EXISTS "annotations_fts_stemmed_data" (
	"id"	INTEGER,
	"block"	BLOB,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "annotations_fts_stemmed_idx" (
	"segid"	,
	"term"	,
	"pgno"	,
	PRIMARY KEY("segid","term")
) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS "annotations_fts_stemmed_docsize" (
	"id"	INTEGER,
	"sz"	BLOB,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "annotations_fts_stemmed_config" (
	"k"	,
	"v"	,
	PRIMARY KEY("k")
) WITHOUT ROWID;
INSERT INTO "authors" VALUES (1,'Leo Tolstoy','Tolstoy, Leo','');
INSERT INTO "authors" VALUES (4,'Oscar Wilde','Wilde, Oscar','');
INSERT INTO "authors" VALUES (5,'Maurice Leblanc','Leblanc, Maurice','');
INSERT INTO "books" VALUES (4,'The Importance of Being Earnest','Importance of Being Earnest, The','2021-06-08 22:51:00.592700+00:00','2014-05-25 00:00:00+00:00',1.0,'Wilde, Oscar','','','Oscar Wilde/The Importance of Being Earnest (4)',1,'b710d5cb-de53-4d06-a868-f8d7123b0417',1,'2021-06-09 17:07:54.517661+00:00');
INSERT INTO "books" VALUES (7,'Short Fiction','Short Fiction','2021-06-08 22:51:18.641871+00:00','2021-04-27 00:44:58+00:00',1.0,'Tolstoy, Leo','','','Leo Tolstoy/Short Fiction (7)',1,'34cd7560-4d47-421c-800e-22cff6f57136',1,'2021-06-09 17:07:30.351950+00:00');
INSERT INTO "books" VALUES (8,'The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar','Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The','2021-06-08 22:51:18.920552+00:00','2018-03-27 23:44:46+00:00',1.0,'Leblanc, Maurice & Tolstoy, Leo','','','Maurice Leblanc/The Extraordinary Adventures of Arse (8)',1,'2cae0e64-cfac-4268-a0e8-4f90ee53ff7b',1,'2021-06-12 12:45:48.346095+00:00');
INSERT INTO "books_authors_link" VALUES (4,4,4);
INSERT INTO "books_authors_link" VALUES (7,7,1);
INSERT INTO "books_authors_link" VALUES (8,8,5);
INSERT INTO "books_authors_link" VALUES (9,8,1);
INSERT INTO "books_languages_link" VALUES (4,4,1,0);
INSERT INTO "books_languages_link" VALUES (7,7,1,0);
INSERT INTO "books_languages_link" VALUES (8,8,1,0);
INSERT INTO "books_publishers_link" VALUES (4,4,1);
INSERT INTO "books_publishers_link" VALUES (7,7,1);
INSERT INTO "books_publishers_link" VALUES (8,8,1);
INSERT INTO "books_series_link" VALUES (2,8,1);
INSERT INTO "books_tags_link" VALUES (36,7,27);
INSERT INTO "books_tags_link" VALUES (37,7,1);
INSERT INTO "books_tags_link" VALUES (38,4,16);
INSERT INTO "books_tags_link" VALUES (39,4,18);
INSERT INTO "books_tags_link" VALUES (40,8,24);
INSERT INTO "books_tags_link" VALUES (41,8,27);
INSERT INTO "books_tags_link" VALUES (42,8,26);
INSERT INTO "books_tags_link" VALUES (43,8,1);
INSERT INTO "comments" VALUES (4,4,'A comedy skewering Victorian high society.');
INSERT INTO "comments" VALUES (9,8,'An infamous French thief plans intricate ways of stealing precious paintings and jewellery in this first collection of Arsène Lupin short stories.');
INSERT INTO "comments" VALUES (10,7,'A collection of all of the short stories and novellas written by Leo Tolstoy.');
INSERT INTO "data" VALUES (4,4,'EPUB',375170,'The Importance of Being Earnest - Oscar Wilde');
INSERT INTO "data" VALUES (7,7,'EPUB',2395917,'Short Fiction - Leo Tolstoy');
INSERT INTO "data" VALUES (9,8,'EPUB',565962,'The Extraordinary Adventures of - Maurice Leblanc');
INSERT INTO "data" VALUES (10,8,'KEPUB',593076,'The Extraordinary Adventures of - Maurice Leblanc');
INSERT INTO "identifiers" VALUES (4,4,'url','https://standardebooks.org/ebooks/oscar-wilde/the-importance-of-being-earnest');
INSERT INTO "identifiers" VALUES (8,8,'url','https://standardebooks.org/ebooks/maurice-leblanc/the-extraordinary-adventures-of-arsene-lupin-gentleman-burglar/george-morehead');
INSERT INTO "identifiers" VALUES (9,7,'url','https://standardebooks.org/ebooks/leo-tolstoy/short-fiction/louise-maude_aylmer-maude_nathan-haskell-dole_constance-garnett_j-d-duff_leo-weiner_r-s-townsend_hagberg-wright_benjamin-tucker_everymans-library_vladimir-chertkov_isabella-fyvie-mayo');
INSERT INTO "languages" VALUES (1,'eng');
INSERT INTO "library_id" VALUES (1,'d902d892-4477-4bed-a25d-109440320bd2');
INSERT INTO "preferences" VALUES (1,'bools_are_tristate','true');
INSERT INTO "preferences" VALUES (2,'user_categories','{}');
INSERT INTO "preferences" VALUES (3,'saved_searches','{}');
INSERT INTO "preferences" VALUES (4,'grouped_search_terms','{}');
INSERT INTO "preferences" VALUES (5,'tag_browser_hidden_categories','[]');
INSERT INTO "preferences" VALUES (6,'field_metadata','{
  "au_map": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {
      "cache_to_list": ",",
      "list_to_ui": null,
      "ui_to_list": null
    },
    "kind": "field",
    "label": "au_map",
    "name": null,
    "rec_index": 18,
    "search_terms": [],
    "table": null
  },
  "author_sort": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "author_sort",
    "name": "Author sort",
    "rec_index": 12,
    "search_terms": [
      "author_sort"
    ],
    "table": null
  },
  "authors": {
    "category_sort": "sort",
    "column": "name",
    "datatype": "text",
    "display": {},
    "is_category": true,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {
      "cache_to_list": ",",
      "list_to_ui": " & ",
      "ui_to_list": "&"
    },
    "kind": "field",
    "label": "authors",
    "link_column": "author",
    "name": "Authors",
    "rec_index": 2,
    "search_terms": [
      "authors",
      "author"
    ],
    "table": "authors"
  },
  "comments": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "comments",
    "name": "Comments",
    "rec_index": 7,
    "search_terms": [
      "comments",
      "comment"
    ],
    "table": null
  },
  "cover": {
    "column": null,
    "datatype": "int",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "cover",
    "name": "Cover",
    "rec_index": 17,
    "search_terms": [
      "cover"
    ],
    "table": null
  },
  "formats": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": true,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {
      "cache_to_list": ",",
      "list_to_ui": ", ",
      "ui_to_list": ","
    },
    "kind": "field",
    "label": "formats",
    "name": "Formats",
    "rec_index": 13,
    "search_terms": [
      "formats",
      "format"
    ],
    "table": null
  },
  "id": {
    "column": null,
    "datatype": "int",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "id",
    "name": null,
    "rec_index": 0,
    "search_terms": [
      "id"
    ],
    "table": null
  },
  "identifiers": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": true,
    "is_csp": true,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {
      "cache_to_list": ",",
      "list_to_ui": ", ",
      "ui_to_list": ","
    },
    "kind": "field",
    "label": "identifiers",
    "name": "Identifiers",
    "rec_index": 20,
    "search_terms": [
      "identifiers",
      "identifier",
      "isbn"
    ],
    "table": null
  },
  "languages": {
    "category_sort": "lang_code",
    "column": "lang_code",
    "datatype": "text",
    "display": {},
    "is_category": true,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {
      "cache_to_list": ",",
      "list_to_ui": ", ",
      "ui_to_list": ","
    },
    "kind": "field",
    "label": "languages",
    "link_column": "lang_code",
    "name": "Languages",
    "rec_index": 21,
    "search_terms": [
      "languages",
      "language"
    ],
    "table": "languages"
  },
  "last_modified": {
    "column": null,
    "datatype": "datetime",
    "display": {
      "date_format": "dd MMM yyyy"
    },
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "last_modified",
    "name": "Modified",
    "rec_index": 19,
    "search_terms": [
      "last_modified"
    ],
    "table": null
  },
  "marked": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "marked",
    "name": null,
    "rec_index": 23,
    "search_terms": [
      "marked"
    ],
    "table": null
  },
  "news": {
    "category_sort": "name",
    "column": "name",
    "datatype": null,
    "display": {},
    "is_category": true,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "category",
    "label": "news",
    "name": "News",
    "search_terms": [],
    "table": "news"
  },
  "ondevice": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "ondevice",
    "name": "On device",
    "rec_index": 22,
    "search_terms": [
      "ondevice"
    ],
    "table": null
  },
  "path": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "path",
    "name": "Path",
    "rec_index": 14,
    "search_terms": [],
    "table": null
  },
  "pubdate": {
    "column": null,
    "datatype": "datetime",
    "display": {
      "date_format": "MMM yyyy"
    },
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "pubdate",
    "name": "Published",
    "rec_index": 15,
    "search_terms": [
      "pubdate"
    ],
    "table": null
  },
  "publisher": {
    "category_sort": "name",
    "column": "name",
    "datatype": "text",
    "display": {},
    "is_category": true,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "publisher",
    "link_column": "publisher",
    "name": "Publisher",
    "rec_index": 9,
    "search_terms": [
      "publisher"
    ],
    "table": "publishers"
  },
  "rating": {
    "category_sort": "rating",
    "column": "rating",
    "datatype": "rating",
    "display": {},
    "is_category": true,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "rating",
    "link_column": "rating",
    "name": "Rating",
    "rec_index": 5,
    "search_terms": [
      "rating"
    ],
    "table": "ratings"
  },
  "series": {
    "category_sort": "(title_sort(name))",
    "column": "name",
    "datatype": "series",
    "display": {},
    "is_category": true,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "series",
    "link_column": "series",
    "name": "Series",
    "rec_index": 8,
    "search_terms": [
      "series"
    ],
    "table": "series"
  },
  "series_index": {
    "column": null,
    "datatype": "float",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "series_index",
    "name": null,
    "rec_index": 10,
    "search_terms": [
      "series_index"
    ],
    "table": null
  },
  "series_sort": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "series_sort",
    "name": "Series sort",
    "rec_index": 24,
    "search_terms": [
      "series_sort"
    ],
    "table": null
  },
  "size": {
    "column": null,
    "datatype": "float",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "size",
    "name": "Size",
    "rec_index": 4,
    "search_terms": [
      "size"
    ],
    "table": null
  },
  "sort": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "sort",
    "name": "Title sort",
    "rec_index": 11,
    "search_terms": [
      "title_sort"
    ],
    "table": null
  },
  "tags": {
    "category_sort": "name",
    "column": "name",
    "datatype": "text",
    "display": {},
    "is_category": true,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {
      "cache_to_list": ",",
      "list_to_ui": ", ",
      "ui_to_list": ","
    },
    "kind": "field",
    "label": "tags",
    "link_column": "tag",
    "name": "Tags",
    "rec_index": 6,
    "search_terms": [
      "tags",
      "tag"
    ],
    "table": "tags"
  },
  "timestamp": {
    "column": null,
    "datatype": "datetime",
    "display": {
      "date_format": "dd MMM yyyy"
    },
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "timestamp",
    "name": "Date",
    "rec_index": 3,
    "search_terms": [
      "date"
    ],
    "table": null
  },
  "title": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "title",
    "name": "Title",
    "rec_index": 1,
    "search_terms": [
      "title"
    ],
    "table": null
  },
  "uuid": {
    "column": null,
    "datatype": "text",
    "display": {},
    "is_category": false,
    "is_csp": false,
    "is_custom": false,
    "is_editable": true,
    "is_multiple": {},
    "kind": "field",
    "label": "uuid",
    "name": null,
    "rec_index": 16,
    "search_terms": [
      "uuid"
    ],
    "table": null
  }
}');
INSERT INTO "preferences" VALUES (7,'library_view books view state','{
  "column_alignment": {
    "pubdate": "center",
    "size": "center",
    "timestamp": "center"
  },
  "column_positions": {
    "authors": 2,
    "languages": 11,
    "last_modified": 10,
    "ondevice": 0,
    "pubdate": 9,
    "publisher": 8,
    "rating": 5,
    "series": 7,
    "size": 4,
    "tags": 6,
    "timestamp": 3,
    "title": 1
  },
  "column_sizes": {
    "authors": 134,
    "languages": 0,
    "last_modified": 0,
    "pubdate": 100,
    "publisher": 98,
    "rating": 78,
    "series": 72,
    "size": 97,
    "tags": 64,
    "timestamp": 76,
    "title": 461
  },
  "hidden_columns": [
    "last_modified",
    "languages"
  ],
  "languages_injected": true,
  "last_modified_injected": true,
  "sort_history": [
    [
      "timestamp",
      false
    ],
    [
      "title",
      true
    ],
    [
      "timestamp",
      false
    ]
  ]
}');
INSERT INTO "preferences" VALUES (8,'books view split pane state','{
  "column_positions": {
    "authors": 2,
    "languages": 11,
    "last_modified": 10,
    "ondevice": 0,
    "pubdate": 9,
    "publisher": 8,
    "rating": 5,
    "series": 7,
    "size": 4,
    "tags": 6,
    "timestamp": 3,
    "title": 1
  },
  "column_sizes": {
    "authors": 125,
    "languages": 125,
    "last_modified": 125,
    "pubdate": 125,
    "publisher": 125,
    "rating": 125,
    "series": 125,
    "size": 125,
    "tags": 125,
    "timestamp": 125,
    "title": 125
  },
  "hidden_columns": []
}');
INSERT INTO "publishers" VALUES (1,'Standard Ebooks',NULL);
INSERT INTO "series" VALUES (1,'Arsène Lupin','Arsène Lupin');
INSERT INTO "tags" VALUES (1,'Short stories');
INSERT INTO "tags" VALUES (16,'Comedies');
INSERT INTO "tags" VALUES (18,'Identity (Psychology) -- Drama');
INSERT INTO "tags" VALUES (24,'Adventure stories');
INSERT INTO "tags" VALUES (26,'Mystery and detective stories');
INSERT INTO "tags" VALUES (27,'Fiction');
-- INSERT INTO "annotations_fts_data" VALUES (1,'');
-- INSERT INTO "annotations_fts_data" VALUES (10,X'00000000000000');
-- INSERT INTO "annotations_fts_config" VALUES ('version',4);
-- INSERT INTO "annotations_fts_stemmed_data" VALUES (1,'');
-- INSERT INTO "annotations_fts_stemmed_data" VALUES (10,X'00000000000000');
-- INSERT INTO "annotations_fts_stemmed_config" VALUES ('version',4);
CREATE INDEX IF NOT EXISTS "authors_idx" ON "books" (
	"author_sort" COLLATE NOCASE
);
CREATE INDEX IF NOT EXISTS "books_authors_link_aidx" ON "books_authors_link" (
	"author"
);
CREATE INDEX IF NOT EXISTS "books_authors_link_bidx" ON "books_authors_link" (
	"book"
);
CREATE INDEX IF NOT EXISTS "books_idx" ON "books" (
	"sort" COLLATE NOCASE
);
CREATE INDEX IF NOT EXISTS "books_languages_link_aidx" ON "books_languages_link" (
	"lang_code"
);
CREATE INDEX IF NOT EXISTS "books_languages_link_bidx" ON "books_languages_link" (
	"book"
);
CREATE INDEX IF NOT EXISTS "books_publishers_link_aidx" ON "books_publishers_link" (
	"publisher"
);
CREATE INDEX IF NOT EXISTS "books_publishers_link_bidx" ON "books_publishers_link" (
	"book"
);
CREATE INDEX IF NOT EXISTS "books_ratings_link_aidx" ON "books_ratings_link" (
	"rating"
);
CREATE INDEX IF NOT EXISTS "books_ratings_link_bidx" ON "books_ratings_link" (
	"book"
);
CREATE INDEX IF NOT EXISTS "books_series_link_aidx" ON "books_series_link" (
	"series"
);
CREATE INDEX IF NOT EXISTS "books_series_link_bidx" ON "books_series_link" (
	"book"
);
CREATE INDEX IF NOT EXISTS "books_tags_link_aidx" ON "books_tags_link" (
	"tag"
);
CREATE INDEX IF NOT EXISTS "books_tags_link_bidx" ON "books_tags_link" (
	"book"
);
CREATE INDEX IF NOT EXISTS "comments_idx" ON "comments" (
	"book"
);
CREATE INDEX IF NOT EXISTS "conversion_options_idx_a" ON "conversion_options" (
	"format" COLLATE NOCASE
);
CREATE INDEX IF NOT EXISTS "conversion_options_idx_b" ON "conversion_options" (
	"book"
);
CREATE INDEX IF NOT EXISTS "custom_columns_idx" ON "custom_columns" (
	"label"
);
CREATE INDEX IF NOT EXISTS "data_idx" ON "data" (
	"book"
);
CREATE INDEX IF NOT EXISTS "lrp_idx" ON "last_read_positions" (
	"book"
);
CREATE INDEX IF NOT EXISTS "annot_idx" ON "annotations" (
	"book"
);
CREATE INDEX IF NOT EXISTS "formats_idx" ON "data" (
	"format"
);
CREATE INDEX IF NOT EXISTS "languages_idx" ON "languages" (
	"lang_code" COLLATE NOCASE
);
CREATE INDEX IF NOT EXISTS "publishers_idx" ON "publishers" (
	"name" COLLATE NOCASE
);
CREATE INDEX IF NOT EXISTS "series_idx" ON "series" (
	"name" COLLATE NOCASE
);
CREATE INDEX IF NOT EXISTS "tags_idx" ON "tags" (
	"name" COLLATE NOCASE
);
CREATE TRIGGER annotations_fts_insert_trg AFTER INSERT ON annotations 
BEGIN
    INSERT INTO annotations_fts(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
    INSERT INTO annotations_fts_stemmed(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
END;
CREATE TRIGGER annotations_fts_delete_trg AFTER DELETE ON annotations 
BEGIN
    INSERT INTO annotations_fts(annotations_fts, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
    INSERT INTO annotations_fts_stemmed(annotations_fts_stemmed, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
END;
CREATE TRIGGER annotations_fts_update_trg AFTER UPDATE ON annotations 
BEGIN
    INSERT INTO annotations_fts(annotations_fts, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
    INSERT INTO annotations_fts(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
    INSERT INTO annotations_fts_stemmed(annotations_fts_stemmed, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
    INSERT INTO annotations_fts_stemmed(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
END;
CREATE TRIGGER books_delete_trg
            AFTER DELETE ON books
            BEGIN
                DELETE FROM books_authors_link WHERE book=OLD.id;
                DELETE FROM books_publishers_link WHERE book=OLD.id;
                DELETE FROM books_ratings_link WHERE book=OLD.id;
                DELETE FROM books_series_link WHERE book=OLD.id;
                DELETE FROM books_tags_link WHERE book=OLD.id;
                DELETE FROM books_languages_link WHERE book=OLD.id;
                DELETE FROM data WHERE book=OLD.id;
                DELETE FROM last_read_positions WHERE book=OLD.id;
                DELETE FROM annotations WHERE book=OLD.id;
                DELETE FROM comments WHERE book=OLD.id;
                DELETE FROM conversion_options WHERE book=OLD.id;
                DELETE FROM books_plugin_data WHERE book=OLD.id;
                DELETE FROM identifiers WHERE book=OLD.id;
        END;
CREATE TRIGGER books_insert_trg AFTER INSERT ON books
        BEGIN
            UPDATE books SET sort=title_sort(NEW.title),uuid=uuid4() WHERE id=NEW.id;
        END;
CREATE TRIGGER books_update_trg
            AFTER UPDATE ON books
            BEGIN
            UPDATE books SET sort=title_sort(NEW.title)
                         WHERE id=NEW.id AND OLD.title <> NEW.title;
            END;
CREATE TRIGGER fkc_comments_insert
        BEFORE INSERT ON comments
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_comments_update
        BEFORE UPDATE OF book ON comments
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_data_insert
        BEFORE INSERT ON data
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_data_update
        BEFORE UPDATE OF book ON data
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_lrp_insert
        BEFORE INSERT ON last_read_positions
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_lrp_update
        BEFORE UPDATE OF book ON last_read_positions
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_annot_insert
        BEFORE INSERT ON annotations
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_annot_update
        BEFORE UPDATE OF book ON annotations
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_delete_on_authors
        BEFORE DELETE ON authors
        BEGIN
            SELECT CASE
                WHEN (SELECT COUNT(id) FROM books_authors_link WHERE author=OLD.id) > 0
                THEN RAISE(ABORT, 'Foreign key violation: authors is still referenced')
            END;
        END;
CREATE TRIGGER fkc_delete_on_languages
        BEFORE DELETE ON languages
        BEGIN
            SELECT CASE
                WHEN (SELECT COUNT(id) FROM books_languages_link WHERE lang_code=OLD.id) > 0
                THEN RAISE(ABORT, 'Foreign key violation: language is still referenced')
            END;
        END;
CREATE TRIGGER fkc_delete_on_languages_link
        BEFORE INSERT ON books_languages_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from languages WHERE id=NEW.lang_code) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: lang_code not in languages')
          END;
        END;
CREATE TRIGGER fkc_delete_on_publishers
        BEFORE DELETE ON publishers
        BEGIN
            SELECT CASE
                WHEN (SELECT COUNT(id) FROM books_publishers_link WHERE publisher=OLD.id) > 0
                THEN RAISE(ABORT, 'Foreign key violation: publishers is still referenced')
            END;
        END;
CREATE TRIGGER fkc_delete_on_series
        BEFORE DELETE ON series
        BEGIN
            SELECT CASE
                WHEN (SELECT COUNT(id) FROM books_series_link WHERE series=OLD.id) > 0
                THEN RAISE(ABORT, 'Foreign key violation: series is still referenced')
            END;
        END;
CREATE TRIGGER fkc_delete_on_tags
        BEFORE DELETE ON tags
        BEGIN
            SELECT CASE
                WHEN (SELECT COUNT(id) FROM books_tags_link WHERE tag=OLD.id) > 0
                THEN RAISE(ABORT, 'Foreign key violation: tags is still referenced')
            END;
        END;
CREATE TRIGGER fkc_insert_books_authors_link
        BEFORE INSERT ON books_authors_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from authors WHERE id=NEW.author) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: author not in authors')
          END;
        END;
CREATE TRIGGER fkc_insert_books_publishers_link
        BEFORE INSERT ON books_publishers_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from publishers WHERE id=NEW.publisher) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: publisher not in publishers')
          END;
        END;
CREATE TRIGGER fkc_insert_books_ratings_link
        BEFORE INSERT ON books_ratings_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from ratings WHERE id=NEW.rating) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: rating not in ratings')
          END;
        END;
CREATE TRIGGER fkc_insert_books_series_link
        BEFORE INSERT ON books_series_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from series WHERE id=NEW.series) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: series not in series')
          END;
        END;
CREATE TRIGGER fkc_insert_books_tags_link
        BEFORE INSERT ON books_tags_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from tags WHERE id=NEW.tag) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: tag not in tags')
          END;
        END;
CREATE TRIGGER fkc_update_books_authors_link_a
        BEFORE UPDATE OF book ON books_authors_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_authors_link_b
        BEFORE UPDATE OF author ON books_authors_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from authors WHERE id=NEW.author) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: author not in authors')
            END;
        END;
CREATE TRIGGER fkc_update_books_languages_link_a
        BEFORE UPDATE OF book ON books_languages_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_languages_link_b
        BEFORE UPDATE OF lang_code ON books_languages_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from languages WHERE id=NEW.lang_code) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: lang_code not in languages')
            END;
        END;
CREATE TRIGGER fkc_update_books_publishers_link_a
        BEFORE UPDATE OF book ON books_publishers_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_publishers_link_b
        BEFORE UPDATE OF publisher ON books_publishers_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from publishers WHERE id=NEW.publisher) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: publisher not in publishers')
            END;
        END;
CREATE TRIGGER fkc_update_books_ratings_link_a
        BEFORE UPDATE OF book ON books_ratings_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_ratings_link_b
        BEFORE UPDATE OF rating ON books_ratings_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from ratings WHERE id=NEW.rating) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: rating not in ratings')
            END;
        END;
CREATE TRIGGER fkc_update_books_series_link_a
        BEFORE UPDATE OF book ON books_series_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_series_link_b
        BEFORE UPDATE OF series ON books_series_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from series WHERE id=NEW.series) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: series not in series')
            END;
        END;
CREATE TRIGGER fkc_update_books_tags_link_a
        BEFORE UPDATE OF book ON books_tags_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_tags_link_b
        BEFORE UPDATE OF tag ON books_tags_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from tags WHERE id=NEW.tag) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: tag not in tags')
            END;
        END;
CREATE TRIGGER series_insert_trg
        AFTER INSERT ON series
        BEGIN
          UPDATE series SET sort=title_sort(NEW.name) WHERE id=NEW.id;
        END;
CREATE TRIGGER series_update_trg
        AFTER UPDATE ON series
        BEGIN
          UPDATE series SET sort=title_sort(NEW.name) WHERE id=NEW.id;
        END;
CREATE VIEW meta AS
        SELECT id, title,
               (SELECT sortconcat(bal.id, name) FROM books_authors_link AS bal JOIN authors ON(author = authors.id) WHERE book = books.id) authors,
               (SELECT name FROM publishers WHERE publishers.id IN (SELECT publisher from books_publishers_link WHERE book=books.id)) publisher,
               (SELECT rating FROM ratings WHERE ratings.id IN (SELECT rating from books_ratings_link WHERE book=books.id)) rating,
               timestamp,
               (SELECT MAX(uncompressed_size) FROM data WHERE book=books.id) size,
               (SELECT concat(name) FROM tags WHERE tags.id IN (SELECT tag from books_tags_link WHERE book=books.id)) tags,
               (SELECT text FROM comments WHERE book=books.id) comments,
               (SELECT name FROM series WHERE series.id IN (SELECT series FROM books_series_link WHERE book=books.id)) series,
               series_index,
               sort,
               author_sort,
               (SELECT concat(format) FROM data WHERE data.book=books.id) formats,
               isbn,
               path,
               lccn,
               pubdate,
               flags,
               uuid
        FROM books;
CREATE VIEW tag_browser_authors AS SELECT
                    id,
                    name,
                    (SELECT COUNT(id) FROM books_authors_link WHERE author=authors.id) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_authors_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.author=authors.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0) avg_rating,
                     sort AS sort
                FROM authors;
CREATE VIEW tag_browser_filtered_authors AS SELECT
                    id,
                    name,
                    (SELECT COUNT(books_authors_link.id) FROM books_authors_link WHERE
                        author=authors.id AND books_list_filter(book)) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_authors_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.author=authors.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0 AND
                     books_list_filter(bl.book)) avg_rating,
                     sort AS sort
                FROM authors;
CREATE VIEW tag_browser_filtered_publishers AS SELECT
                    id,
                    name,
                    (SELECT COUNT(books_publishers_link.id) FROM books_publishers_link WHERE
                        publisher=publishers.id AND books_list_filter(book)) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_publishers_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.publisher=publishers.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0 AND
                     books_list_filter(bl.book)) avg_rating,
                     name AS sort
                FROM publishers;
CREATE VIEW tag_browser_filtered_ratings AS SELECT
                    id,
                    rating,
                    (SELECT COUNT(books_ratings_link.id) FROM books_ratings_link WHERE
                        rating=ratings.id AND books_list_filter(book)) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_ratings_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.rating=ratings.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0 AND
                     books_list_filter(bl.book)) avg_rating,
                     rating AS sort
                FROM ratings;
CREATE VIEW tag_browser_filtered_series AS SELECT
                    id,
                    name,
                    (SELECT COUNT(books_series_link.id) FROM books_series_link WHERE
                        series=series.id AND books_list_filter(book)) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_series_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.series=series.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0 AND
                     books_list_filter(bl.book)) avg_rating,
                     (title_sort(name)) AS sort
                FROM series;
CREATE VIEW tag_browser_filtered_tags AS SELECT
                    id,
                    name,
                    (SELECT COUNT(books_tags_link.id) FROM books_tags_link WHERE
                        tag=tags.id AND books_list_filter(book)) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_tags_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.tag=tags.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0 AND
                     books_list_filter(bl.book)) avg_rating,
                     name AS sort
                FROM tags;
CREATE VIEW tag_browser_publishers AS SELECT
                    id,
                    name,
                    (SELECT COUNT(id) FROM books_publishers_link WHERE publisher=publishers.id) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_publishers_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.publisher=publishers.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0) avg_rating,
                     name AS sort
                FROM publishers;
CREATE VIEW tag_browser_ratings AS SELECT
                    id,
                    rating,
                    (SELECT COUNT(id) FROM books_ratings_link WHERE rating=ratings.id) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_ratings_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.rating=ratings.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0) avg_rating,
                     rating AS sort
                FROM ratings;
CREATE VIEW tag_browser_series AS SELECT
                    id,
                    name,
                    (SELECT COUNT(id) FROM books_series_link WHERE series=series.id) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_series_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.series=series.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0) avg_rating,
                     (title_sort(name)) AS sort
                FROM series;
CREATE VIEW tag_browser_tags AS SELECT
                    id,
                    name,
                    (SELECT COUNT(id) FROM books_tags_link WHERE tag=tags.id) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_tags_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.tag=tags.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0) avg_rating,
                     name AS sort
                FROM tags;
COMMIT;
