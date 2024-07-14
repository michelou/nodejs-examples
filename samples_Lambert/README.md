# <span id="top">Node.js examples from Lambert's book</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://nodejs.org/" rel="external"><img src="../docs/images/nodejs.svg" width="120" alt="Node.js project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <strong><code>samples_Lambert\</code></strong> contains <a href="https://nodejs.org/" alt="Node.js">Node.js</a> examples presented in <a href="https://www.editions-eni.fr/livre/node-js-exploitez-la-puissance-de-javascript-cote-serveur-9782746089785">Lambert's book</a> "<i>Node.js - Exploitez la puissance de JavaScript côté serveur</i>" (<a href="https://www.editions-eni.fr/">ENI</a>, 2015).<br/>
  Github repository: <a href="https://github.com/vatesfr/eni-nodejs" rel="external">https://github.com/vatesfr/eni-nodejs</a></td>
  </tr>
</table>

## <span id="04_concepts">`04-concepts` Example</span>

Command [**`npm.cmd start`**](./04-concepts/async-downloads/package.json) executes application [**`app\async-downloads.js`**](./04-concepts/async-downloads/app/async-downloads.js) which produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-commands/start.html">npm start</a></b>

> async-downloads@0.0.1 start N:\samples_Lambert\04-concepts\async-downloads
> node app/async-downloads.js

Tout s'est bien passé
</pre>

## <span id="06_files">`06-files` Example</span>

Command [**`npm.cmd run`**](./06-files/package.json) displays the available [**`npm`** scripts][npm_scripts].

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-commands/run-script.html">npm run</a></b>
Scripts available in files via `npm run-script`:
  dirs
    node app/directories.js
  files
    node app/files.js
  lint
    eslint app
  paths
    node app/paths.js
  watch
    node app/watch.js
</pre>

Command [**`npm.cmd run dirs`**](./06-files/package.json) executes application [**`app/directories.js`**](./06-files/app/directories.js):

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-commands/run-script.html">npm run</a> dirs</b>

> files@0.0.1 dirs N:\samples_Lambert\06-files
> node app/directories.js

fichiers trouvés : [ 'directories.js', 'files.js', 'paths.js', 'watch.js' ]
répertoire créé
répertoire supprimé
arborescence créée
arborescence supprimée
</pre>

## <span id="07_promises">`07-promises` Example</span> [**&#x25B4;**](#top)

Command [**`npm.cmd run`**](./07-promises/package.json) displays the available [**`npm`** scripts][npm_scripts]:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-commands/run-script.html">npm run</a></b>
Scripts available in promises via `npm run-script`:
  creation
    node src/creation.js
  dl-two-files
    node src/dl-two-files.js
  generator
    babel src -d app & babel-node app/generator.js
</pre>

## <span id="10_databases">`10-databases` Example</span>

Command [**`npm run`**](./10-promises/package.json) displays the available [**`npm`** scripts][npm_scripts]:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-commands/run-script.html">npm run</a></b>
Lifecycle scripts included in databases:
  start
    node app/mongoose.js
  test
    echo "Error: no test specified" && exit 1

available via `npm run-script`:
  clean
    node ./npm_scripts/clean.js
  lint
    eslint app
  reinstall
    npm run clean && npm install -audit
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[npm_scripts]: https://docs.npmjs.com/misc/scripts
