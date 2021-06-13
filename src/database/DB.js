const sqlite3 = require('sqlite3').verbose();
const Statement = require('./Statement');
const commandsMap = require('../commandsMap');
const makeWhere = require('../utils/makeWhere');
const propertiesCollapser = require('../utils/propertiesCollapser');
const defaultLogger = require('../utils/defaultLogger');
const compose = require('../utils/compose');

const endPoints = Object.keys(commandsMap).map(function(url){
	return {
		name:commandsMap[url]
	,	url:`${url}/`
	}
})

class DB{
	constructor(name,path,db){
		this._db = db;
		this._name = name;
		this._path = path;
		this._debug = false;
		this._logger = null;
	}
	debug(doDebug){
		this._debug = doDebug;
	}
	logger(logger){
		this._logger = logger;
	}
	getLogger(){
		return this._logger || defaultLogger
	}
	log(thing){
		if(!this._debug){return;}
		this.getLogger().log(this._name,thing);
	}
	error(thing){
		if(!this._debug){return;}
		this.getLogger().error(this._name,thing);	
	}
	db(){
		return this._db;
	}
	name(){
		return this._name;
	}
	path(){
		return this._path;
	}
	execute(statement){
		const db = this._db;
		const self = this;
		const sql = statement.sql;
		const parameters = statement.parameters;
		this.log(statement.toString());

		if (statement.parameters) {
			return new Promise(function(resolve, reject) {
				db.all(sql, parameters, function(err,rows){
					if(err){return reject(err);}
					if(!rows.length) {
						const err = new Error('no rows');
						self.error(err);
						return reject(err);
					}
					self.log(rows);
					return resolve(rows);
				});
			})
		}
		else {
			return new Promise(function(resolve, reject) {
				db.all(sql, function(err,rows){
					if(err){return reject(err);}
					if(!rows.length) {
						const err = new Error('no rows');
						self.error(err);
						return reject(err);
					}
					self.log(rows);
					return resolve(rows);
				});
			})
		}

		// const rows = (query.parameters) ? await this._db.all(query.sql, query.parameters) : await this._db.all(query.sql);
	}
	getBook(book){
		const query = Statement().getBookQuery(book);

		return this.execute(query).then(function(books){
			const collapse = compose(
				propertiesCollapser(books,'tags',/^tag_/)
			,	propertiesCollapser(books,'authors',/^author_/)
			,	propertiesCollapser(books,'series',/^series_/)
			,	propertiesCollapser(books,'data',/^data_/)
			);
			return books.map(collapse);
		})
	}
	getTag(tag){
		const query = Statement().getTagQuery(tag);

		return this.execute(query).then(function(series){
			const collapse = propertiesCollapser(series,'books',/^book_/);
			const coll = series.map(collapse);
			return coll;
		})
	}
	getSeries(series){
		const query = Statement().getSeriesQuery(series);

		return this.execute(query).then(function(series){
			const collapse = propertiesCollapser(series,'books',/^book_/);
			return series.map(collapse);
		})
	}
	getAuthor(author){
		const query = Statement().getAuthorQuery(author);

		return this.execute(query).then(function(authors){
			const collapse = compose(
				propertiesCollapser(authors,'books',/^book_/)
			,	propertiesCollapser(authors,'series',/^series_/)
			);
			return authors.map(collapse);
		})
	}
	getList(){
		return {
			name:this._name
		,	type:'database'
		,	endPoints
		};
	}
}




module.exports = function getDB(name,path){
	return new Promise(function(resolve,reject){	
		const db = new sqlite3.Database(path,sqlite3.OPEN_READONLY,function(err){
			if(err){return reject(err);}

			const Query = new DB(name,path,db);
			return resolve(Query);

		});
	})
}