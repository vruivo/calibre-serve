var assert = require('assert');
const sqlite3 = require('sqlite3').verbose();
const open = require('sqlite').open;
const fs = require("fs");
const { cwd } = require('process');
const Statement = require('../src/database/Statement');
const DB1 = require('../src/database/DB');
const DB2 = require('../src/database/DB2');


async function importSQLFile(path, db) {
  const dataSql = fs.readFileSync(path).toString();
  const dataArr = dataSql.toString().split(/^(?=CREATE|INSERT|BEGIN TR|COMMIT)/m);
  // console.log('-- dataArr --', dataArr.length);
  // console.log(dataArr);
  // console.log('-- Length:', dataArr.length);

  // db.serialize( async () => {
    // db.run("PRAGMA foreign_keys=OFF;");
    // db.run("BEGIN TRANSACTION;");
    // dataArr.forEach(async query => {
    //   .....
    // });
    // db.run("COMMIT;");
  // });

  for (const query of dataArr) {
    if (query) {
      // console.log('> Running query:\n', query);
      await runQuery(db, query);
      // await db.run(query);
    }
  }
}


describe('DB.js', function() {
  let db;

  // ---- OLD ----
  before(async function loadDB() {
    db = new sqlite3.Database(':memory:');
    await importSQLFile(cwd() +"/test/test-db.sql", db);
  })

  // ---- NEW ----
  // before(async function loadDB() {
  //   db = await open({
  //     filename: ':memory:',
  //     driver: sqlite3.Database
  //   });

  //   await importSQLFile(cwd() +"/test/test-db.sql", db);
  // })


  describe('getBook()', function() {

    it('get all books', async function() {
      const expected_result = [
        {
          "book_id": 7,
          "book_title": "Short Fiction",
          "book_sort": "Short Fiction",
          "book_has_cover": 1,
          "book_date": "2021-04-27 00:44:58+00:00",
          "book_path": "Leo Tolstoy/Short Fiction (7)",
          "book_isbn": "",
          "book_series_index": 1,
          "comment": "A collection of all of the short stories and novellas written by Leo Tolstoy.",
          "tags": [
            {
              "tag_id": "1",
              "tag_name": "Short stories"
            },
            {
              "tag_id": "27",
              "tag_name": "Fiction"
            }
          ],
          "authors": [
            {
              "author_sort": "Tolstoy, Leo",
              "author_id": "1",
              "author_name": "Leo Tolstoy"
            }
          ],
          "series": [],
          "data": [
            {
              "data_id": "7",
              "data_format": "EPUB",
              "data_size": "2395917",
              "data_name": "Short Fiction - Leo Tolstoy"
            }
          ]
        },
        {
          "book_id": 8,
          "book_title": "The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar",
          "book_sort": "Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The",
          "book_has_cover": 1,
          "book_date": "2018-03-27 23:44:46+00:00",
          "book_path": "Maurice Leblanc/The Extraordinary Adventures of Arse (8)",
          "book_isbn": "",
          "book_series_index": 1,
          "comment": "An infamous French thief plans intricate ways of stealing precious paintings and jewellery in this first collection of Arsène Lupin short stories.",
          "tags": [
            {
              "tag_id": "1",
              "tag_name": "Short stories"
            },
            {
              "tag_id": "24",
              "tag_name": "Adventure stories"
            },
            {
              "tag_id": "26",
              "tag_name": "Mystery and detective stories"
            },
            {
              "tag_id": "27",
              "tag_name": "Fiction"
            }
          ],
          "authors": [
            {
              "author_id": "1",
              "author_name": "Leo Tolstoy",
              "author_sort": "Tolstoy, Leo"
            },
            {
              "author_sort": "Leblanc, Maurice",
              "author_id": "5",
              "author_name": "Maurice Leblanc"
            }
          ],
          "series": [
            {
              "series_id": "1",
              "series_name": "Arsène Lupin",
              "series_sort": "Arsène Lupin"
            }
          ],
          "data": [
            {
              "data_id": "9",
              "data_format": "EPUB",
              "data_size": "565962",
              "data_name": "The Extraordinary Adventures of - Maurice Leblanc"
            },
            {
              "data_id": "10",
              "data_format": "KEPUB",
              "data_size": "593076",
              "data_name": "The Extraordinary Adventures of - Maurice Leblanc"
            }
          ]
        },
        {
          "book_id": 4,
          "book_title": "The Importance of Being Earnest",
          "book_sort": "Importance of Being Earnest, The",
          "book_has_cover": 1,
          "book_date": "2014-05-25 00:00:00+00:00",
          "book_path": "Oscar Wilde/The Importance of Being Earnest (4)",
          "book_isbn": "",
          "book_series_index": 1,
          "comment": "A comedy skewering Victorian high society.",
          "tags": [
            {
              "tag_id": "16",
              "tag_name": "Comedies"
            },
            {
              "tag_id": "18",
              "tag_name": "Identity (Psychology) -- Drama"
            }
          ],
          "authors": [
            {
              "author_sort": "Wilde, Oscar",
              "author_id": "4",
              "author_name": "Oscar Wilde"
            }
          ],
          "series": [],
          "data": [
            {
              "data_id": "4",
              "data_format": "EPUB",
              "data_size": "375170",
              "data_name": "The Importance of Being Earnest - Oscar Wilde"
            }
          ]
        }
      ];

      const database1 = await DB1('test-db', ':memory:');
      database1._db = db;
      const result = await database1.getBook();

      // const database2 = await DB2('test-db', ':memory:');
      // database2._db = db;
      // const result = await database2.getBook();

      // console.log(JSON.stringify(result, null, 2));

      // assert.deepStrictEqual(JSON.stringify(result, null, 2), JSON.stringify(expected_result, null,2));
      assert.deepStrictEqual(result, expected_result);
    });

    it('get a specific book', async function() {
      const expected_result = [
        {
          "book_id": 4,
          "book_title": "The Importance of Being Earnest",
          "book_sort": "Importance of Being Earnest, The",
          "book_has_cover": 1,
          "book_date": "2014-05-25 00:00:00+00:00",
          "book_path": "Oscar Wilde/The Importance of Being Earnest (4)",
          "book_isbn": "",
          "book_series_index": 1,
          "comment": "A comedy skewering Victorian high society.",
          "tags": [
            {
              "tag_id": "16",
              "tag_name": "Comedies"
            },
            {
              "tag_id": "18",
              "tag_name": "Identity (Psychology) -- Drama"
            }
          ],
          "authors": [
            {
              "author_sort": "Wilde, Oscar",
              "author_id": "4",
              "author_name": "Oscar Wilde"
            }
          ],
          "series": [],
          "data": [
            {
              "data_id": "4",
              "data_format": "EPUB",
              "data_size": "375170",
              "data_name": "The Importance of Being Earnest - Oscar Wilde"
            }
          ]
        }
      ];

      const database1 = await DB1('test-db', ':memory:');
      database1._db = db;
      const result = await database1.getBook(4);

      // const database2 = await DB2('test-db', ':memory:');
      // database2._db = db;
      // const result = await database2.getBook(4);

      // console.log(JSON.stringify(result, null, 2));

      assert.deepStrictEqual(result, expected_result);
    });

  });


  describe('getTag()', function() {

    it('get all tags', async function() {
      const expected_result = [
        {
          "tag_name": "Adventure stories",
          "tag_id": 24,
          "tag_books_count": 1,
          "books": [
            {
              "book_id": "8",
              "book_title": "The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar",
              "book_sort": "Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The",
              "book_has_cover": "1",
              "book_pubdate": "2018-03-27 23:44:46+00:00",
              "book_path": "Maurice Leblanc/The Extraordinary Adventures of Arse (8)",
              book_series_index: "1.0"
            }
          ]
        },
        {
          "tag_name": "Comedies",
          "tag_id": 16,
          "tag_books_count": 1,
          "books": [
            {
              "book_id": "4",
              "book_title": "The Importance of Being Earnest",
              "book_sort": "Importance of Being Earnest, The",
              "book_has_cover": "1",
              "book_pubdate": "2014-05-25 00:00:00+00:00",
              "book_path": "Oscar Wilde/The Importance of Being Earnest (4)",
              book_series_index: "1.0"
            }
          ]
        },
        {
          "tag_name": "Fiction",
          "tag_id": 27,
          "tag_books_count": 2,
          "books": [
            {
              "book_id": "7",
              "book_title": "Short Fiction",
              "book_sort": "Short Fiction",
              "book_has_cover": "1",
              "book_pubdate": "2021-04-27 00:44:58+00:00",
              "book_path": "Leo Tolstoy/Short Fiction (7)",
              book_series_index: "1.0"
            },
            {
              "book_id": "8",
              "book_title": "The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar",
              "book_sort": "Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The",
              "book_has_cover": undefined,
              "book_pubdate": "2018-03-27 23:44:46+00:00",
              "book_path": "Maurice Leblanc/The Extraordinary Adventures of Arse (8)",
              book_series_index: undefined
            }
          ]
        },
        {
          "tag_name": "Identity (Psychology) -- Drama",
          "tag_id": 18,
          "tag_books_count": 1,
          "books": [
            {
              "book_id": "4",
              "book_title": "The Importance of Being Earnest",
              "book_sort": "Importance of Being Earnest, The",
              "book_has_cover": "1",
              "book_pubdate": "2014-05-25 00:00:00+00:00",
              "book_path": "Oscar Wilde/The Importance of Being Earnest (4)",
              book_series_index: "1.0"
            }
          ]
        },
        {
          "tag_name": "Mystery and detective stories",
          "tag_id": 26,
          "tag_books_count": 1,
          "books": [
            {
              "book_id": "8",
              "book_title": "The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar",
              "book_sort": "Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The",
              "book_has_cover": "1",
              "book_pubdate": "2018-03-27 23:44:46+00:00",
              "book_path": "Maurice Leblanc/The Extraordinary Adventures of Arse (8)",
              book_series_index: "1.0"
            }
          ]
        },
        {
          "tag_name": "Short stories",
          "tag_id": 1,
          "tag_books_count": 2,
          "books": [
            {
              "book_id": "7",
              "book_title": "Short Fiction",
              "book_sort": "Short Fiction",
              "book_has_cover": "1",
              "book_pubdate": "2021-04-27 00:44:58+00:00",
              "book_path": "Leo Tolstoy/Short Fiction (7)",
              book_series_index: "1.0"
            },
            {
              "book_id": "8",
              "book_title": "The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar",
              "book_sort": "Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The",
              "book_has_cover": undefined,
              "book_pubdate": "2018-03-27 23:44:46+00:00",
              "book_path": "Maurice Leblanc/The Extraordinary Adventures of Arse (8)",
              book_series_index: undefined
            }
          ]
        }
      ];

      const database1 = await DB1('test-db', ':memory:');
      database1._db = db;
      const result = await database1.getTag();

      // const database2 = await DB2('test-db', ':memory:');
      // database2._db = db;
      // const result = await database2.getTag();

      // console.log(JSON.stringify(result, null, 2));
      // assert.deepStrictEqual(JSON.stringify(result, null, 2), JSON.stringify(expected_result, null,2));
      assert.deepStrictEqual(result, expected_result);
    });

    it('get a specific tag', async function() {
      const expected_result = [
        {
          books: [
            {
              book_has_cover: '1',
              book_id: '7',
              book_path: 'Leo Tolstoy/Short Fiction (7)',
              book_pubdate: '2021-04-27 00:44:58+00:00',
              book_series_index: '1.0',
              book_sort: 'Short Fiction',
              book_title: 'Short Fiction'
            },
            {
              book_has_cover: undefined,
              book_id: '8',
              book_path: 'Maurice Leblanc/The Extraordinary Adventures of Arse (8)',
              book_pubdate: '2018-03-27 23:44:46+00:00',
              book_series_index: undefined,
              book_sort: 'Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The',
              book_title: 'The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar'
            }
          ],
          tag_books_count: 2,
          tag_id: 1,
          tag_name: 'Short stories'
        }
      ];

      const database1 = await DB1('test-db', ':memory:');
      database1._db = db;
      const result = await database1.getTag(1);

      // console.log(JSON.stringify(result, null, 2));

      assert.deepStrictEqual(result, expected_result);
    });

  });


  describe('getSeries()', function() {

    it('get all series', async function() {
      const expected_result = [
        {
          "series_id": 1,
          "series_name": "Arsène Lupin",
          "series_sort": "Arsène Lupin",
          "books": [
            {
              "book_id": "8",
              "book_title": "The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar",
              "book_sort": "Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The",
              "book_has_cover": "1",
              "book_pubdate": "2018-03-27 23:44:46+00:00",
              "book_path": "Maurice Leblanc/The Extraordinary Adventures of Arse (8)",
              "book_series_index": "1.0"
            }
          ]
        }
      ];

      const database1 = await DB1('test-db', ':memory:');
      database1._db = db;
      const result = await database1.getSeries();

      // const database2 = await DB2('test-db', ':memory:');
      // database2._db = db;
      // const result = await database2.getTag();

      // console.log(JSON.stringify(result, null, 2));

      // assert.deepStrictEqual(JSON.stringify(result, null, 2), JSON.stringify(expected_result, null,2));
      assert.deepStrictEqual(result, expected_result);
    });

    it('get a specific series', async function() {
      const expected_result = [
        {
          "series_id": 1,
          "series_name": "Arsène Lupin",
          "series_sort": "Arsène Lupin",
          "books": [
            {
              "book_id": "8",
              "book_title": "The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar",
              "book_sort": "Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The",
              "book_has_cover": "1",
              "book_pubdate": "2018-03-27 23:44:46+00:00",
              "book_path": "Maurice Leblanc/The Extraordinary Adventures of Arse (8)",
              "book_series_index": "1.0"
            }
          ]
        }
      ];

      const database1 = await DB1('test-db', ':memory:');
      database1._db = db;
      const result = await database1.getSeries(1);

      // console.log(JSON.stringify(result, null, 2));

      assert.deepStrictEqual(result, expected_result);
    });

  });


  describe('getAuthor()', function() {

    it('get all authors', async function() {
      const expected_result = [
        {
          "authors_books_count": 2,
          "author_id": 1,
          "author_name": "Leo Tolstoy",
          "author_sort": "Tolstoy, Leo",
          "books": [
            {
              "book_id": "7",
              "book_title": "Short Fiction",
              "book_sort": "Short Fiction",
              "book_has_cover": "1",
              "book_pubdate": "2021-04-27 00:44:58+00:00",
              "book_path": "Leo Tolstoy/Short Fiction (7)",
              "book_series_index": "1.0"
            },
            {
              "book_id": "8",
              "book_title": "The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar",
              "book_sort": "Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The",
              "book_has_cover": undefined,
              "book_pubdate": "2018-03-27 23:44:46+00:00",
              "book_path": "Maurice Leblanc/The Extraordinary Adventures of Arse (8)",
              "book_series_index": undefined
            }
          ],
          "series": []
        },
        {
          "authors_books_count": 1,
          "author_id": 5,
          "author_name": "Maurice Leblanc",
          "author_sort": "Leblanc, Maurice",
          "books": [
            {
              "book_id": "8",
              "book_title": "The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar",
              "book_sort": "Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The",
              "book_has_cover": "1",
              "book_pubdate": "2018-03-27 23:44:46+00:00",
              "book_path": "Maurice Leblanc/The Extraordinary Adventures of Arse (8)",
              "book_series_index": "1.0"
            }
          ],
          "series": [
            {
              "series_id": "1",
              "series_name": "Arsène Lupin",
              "series_sort": "Arsène Lupin"
            }
          ]
        },
        {
          "authors_books_count": 1,
          "author_id": 4,
          "author_name": "Oscar Wilde",
          "author_sort": "Wilde, Oscar",
          "books": [
            {
              "book_id": "4",
              "book_title": "The Importance of Being Earnest",
              "book_sort": "Importance of Being Earnest, The",
              "book_has_cover": "1",
              "book_pubdate": "2014-05-25 00:00:00+00:00",
              "book_path": "Oscar Wilde/The Importance of Being Earnest (4)",
              "book_series_index": "1.0"
            }
          ],
          "series": []
        }
      ];

      const database1 = await DB1('test-db', ':memory:');
      database1._db = db;
      const result = await database1.getAuthor();

      // const database2 = await DB2('test-db', ':memory:');
      // database2._db = db;
      // const result = await database2.getTag();

      // console.log(JSON.stringify(result, null, 2));

      // assert.deepStrictEqual(JSON.stringify(result, null, 2), JSON.stringify(expected_result, null,2));
      assert.deepStrictEqual(result, expected_result);
    });

    it('get a specific author', async function() {
      const expected_result = [
        {
          "authors_books_count": 1,
          "author_id": 5,
          "author_name": "Maurice Leblanc",
          "author_sort": "Leblanc, Maurice",
          "books": [
            {
              "book_id": "8",
              "book_title": "The Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar",
              "book_sort": "Extraordinary Adventures of Arsène Lupin, Gentleman-Burglar, The",
              "book_has_cover": "1",
              "book_pubdate": "2018-03-27 23:44:46+00:00",
              "book_path": "Maurice Leblanc/The Extraordinary Adventures of Arse (8)",
              "book_series_index": "1.0"
            }
          ],
          "series": [
            {
              "series_id": "1",
              "series_name": "Arsène Lupin",
              "series_sort": "Arsène Lupin"
            }
          ]
        }
      ];

      const database1 = await DB1('test-db', ':memory:');
      database1._db = db;
      const result = await database1.getAuthor(5);

      // console.log(JSON.stringify(result, null, 2));

      assert.deepStrictEqual(result, expected_result);
    });

  });

});


function runQuery(db, query) {
  return new Promise((resolve, reject) => {
    db.run(query, (err) => {
      if (err) {
        console.log('  xxx-> Failed: ', err);
        // throw err;
        reject();
      }
      else {
        // console.log('  > Success');
        resolve();
      }
    });
  })
}
