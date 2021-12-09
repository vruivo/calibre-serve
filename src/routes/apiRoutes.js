var express = require('express')
var router = express.Router()

// const makeManager = require('./Manager');
// const Manager = makeManager.Manager;

module.exports = function build(dbAccess) {

  this.dbAccess = dbAccess;

  function onError(err){
    // if(onErrorNext){ next(err) }
    // else{
    //   self.error(req,res,templates,dbName,command,argument,err,options);
    // }
    // return err;
    console.log(err);
  }
  
  function onSuccess(rows){
    // self.render(req,res,templates,dbName,command,argument,rows,options);
    // return rows;
    console.log(rows);
  }

// middleware that is specific to this router
router.use(function timeLog (req, res, next) {
  console.log('Time: ', Date.now())
  next()
})

router.use(express.json());

router.get('/', function (req, res) {
  res.send('Hello API!')
})

router.get('/books', function (req, res) {
  console.log('/books', req.body);
  const abc = dbAccess.getBook(req.body.library, req.body.book_id)
    .then(onSuccess).catch(onError);
  console.log('>', abc);
  res.send('About birds')
})

router.get('/:library/books/:book?', function (req, res) {
  console.log(`/:library/books/:book? '${req.params.library}' '${req.params.book}'`);
  const abc = dbAccess.getBook(req.params.library, req.params.book)
    .then((rows)=>{
      res.send(rows);
    }).catch(onError);
})

router.get('/:library/tags/:tag?', function (req, res) {
  console.log(`/:library/tags/:tag? '${req.params.library}' '${req.params.tag}'`);
  const abc = dbAccess.getTag(req.params.library, req.params.tag)
    .then((rows)=>{
      res.send(rows);
    }).catch(onError);
})

return router;
}
// module.exports = router;
