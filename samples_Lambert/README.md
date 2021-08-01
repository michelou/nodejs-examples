# <span id="top">Node.js examples from Lambert's book</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.svg" width="120" alt="Node.js logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>samples_Lambert\</code></strong> directory contains <a href="https://nodejs.org/" alt="Node.js">Node.js</a> examples presented in <a href="https://www.editions-eni.fr/livre/node-js-exploitez-la-puissance-de-javascript-cote-serveur-9782746089785">Lambert's book</a> "<i>Node.js - Exploitez la puissance de JavaScript côté serveur</i>" (<a href="https://www.editions-eni.fr/">ENI</a>, 2015).<br/>
  Github repository: <a href="https://github.com/vatesfr/eni-nodejs">https://github.com/vatesfr/eni-nodejs</a></td>
  </tr>
</table>

## `04-concepts`

Command [**`npm start`**](./04-concepts/async-downloads/package.json) executes application [**`app\async-downloads.js`**](./04-concepts/async-downloads/app/async-downloads.js) which produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-commands/start.html">npm start</a></b>

> async-downloads@0.0.1 start N:\samples_Lambert\04-concepts\async-downloads
> node app/async-downloads.js

Tout s'est bien passé
</pre>

## `06-files`

Command [**`npm run`**](./06-files/package.json) displays the available [**`npm`** scripts][npm_scripts].

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

Command [**`npm run dirs`**](./06-files/package.json) executes application [**`app/directories.js`**](./06-files/app/directories.js):

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

## `07-promises`

Command [**`npm run`**](./07-promises/package.json) displays the available [**`npm`** scripts][npm_scripts]:

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

## `10-databases`

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

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[npm_scripts]: https://docs.npmjs.com/misc/scripts
