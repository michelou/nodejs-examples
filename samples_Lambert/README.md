# <span id="top">Node.js examples from Lambert's book</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.svg" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>samples_Lambert\</code></strong> directory contains <a href="http://nodejs.org/" alt="Node.js">Node.js</a> examples presented in <a href="https://www.editions-eni.fr/livre/node-js-exploitez-la-puissance-de-javascript-cote-serveur-9782746089785">Lambert's book</a> "<i>Node.js - Exploitez la puissance de JavaScript côté serveur</i>" (<a href="https://www.editions-eni.fr/">ENI</a>, 2015).<br/>
  Github: <a href="https://github.com/vatesfr/eni-nodejs">https://github.com/vatesfr/eni-nodejs</a></td>
  </tr>
</table>

### `04-concepts`

Command [**`npm start`**](./04-concepts/async-downloads/package.json) executes application [**`app\async-downloads.js`**](./04-concepts/async-downloads/app/async-downloads.js) which produces the following output:

<pre style="font-size:80%;">
<b>&gt; npm start</b>

> async-downloads@0.0.1 start N:\samples_Lambert\04-concepts\async-downloads
> node app/async-downloads.js

Tout s'est bien passé
</pre>

### `06_files`

Command [**`npm run`**](./06_files/package.json) displays the available [**`npm`** scripts][npm_scripts].

<pre style="font-size:80%;">
<b>&gt; npm run</b>
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

Command [**`npm run dirs`**](./06_files/package.json) executes application [**`app/directories.js`**](./06_files/app/directories.js):

<pre style="font-size:80%;">
<b>&gt; npm run dirs</b>

> files@0.0.1 dirs N:\samples_Lambert\06-files
> node app/directories.js

fichiers trouvés : [ 'directories.js', 'files.js', 'paths.js', 'watch.js' ]
répertoire créé
répertoire supprimé
arborescence créée
arborescence supprimée
</pre>

### `07_promises`

Command [**`npm run`**](./07_promises/package.json) displays the available [**`npm`** scripts][npm_scripts]:

<pre style="font-size:80%;">
<b>&gt; npm run</b>
Scripts available in promises via `npm run-script`:
  creation
    node src/creation.js
  dl-two-files
    node src/dl-two-files.js
  generator
    babel src -d app & babel-node app/generator.js
</pre>

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[npm_scripts]: https://docs.npmjs.com/misc/scripts
