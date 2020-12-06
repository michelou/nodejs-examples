var Bluebird = require('bluebird');

function foo(callback) {
  return new Bluebird(function (resolve) {
    resolve(['foo', 'bar', 'baz']);
  })
    .then(JSON.stringify)

    // La méthode `nodeify()` permet de rendre compatible une chaîne
    // de promesses avec une callback respectant la convention Node.
    .nodeify(callback)
  ;
}

// `foo()` peut toujours être utilisée avec les promesses.
foo().then(function (result) {
  console.log('promesse :', result);
});

// `foo()` peut maintenant être utilisée avec une callback à la Node.
foo(function (error, result) {
  console.log('callback :', result);
});
