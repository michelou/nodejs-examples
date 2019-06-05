<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.png" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>samples_Duuna\</code></strong> directory contains <a href="http://nodejs.org/" alt="Node.js">Node.js</a> examples presented in <a href="https://www.abebooks.fr/edition-originale/Secure-Node.js-Web-Application-Duuna-Karl/18302115900/bd">Düüna's book</a> "<i>Secure Your Node.js Web Application</i>" (<a href="https://pragprog.com/">The Pragmatic Programmers</a>, 2016).</td>
  </tr>
</table>

### `chp-3-networking`

Executing command **`npm start`** in directory [**`samples_Duuna\chp-3-networking\`**](./chp-3-networking/) performs two tasks:

- it starts the server application which listen to client requests on port **`3000`** (defined in file [**`config.json`**](./chp-3-networking/config_TEMPLATE.json)).
- it opens the **`http:/127.0.0.1:3000`** URL in your default web browser.

First we start the server application in a new console:

<pre style="font-size:80%;">
<b>&gt; start npm start</b>

> cluster-main@1.0.0 start W:\nodejs-examples\samples_Duuna\chp-3-networking
> node ./npm_scripts/start_browser.js && node .


Node runtime: 10.16.0 (x64)
Module search path: (none)
Server listening on port 3000
</pre>

Then we start the client application in the current console:

<pre>
<b>&gt; npm run client</b> 
                              
> cluster-main@1.0.0 client W:\nodejs-examples\samples_Duuna\chp-3-networking
> node ./npm_scripts/start_client.js   

en
hello world

de
hello world

fr
hello world
</pre>


### `chp-4-code-injection`

Executing command **`npm start`** in directory [**`samples_Duuna\chp-4-code-injection\`**](./chp-4-code-injection/) performs two tasks:

- it starts the server application which listen to client requests on port **`3000`** (defined in file [**`config.json`**](./chp-4-code-injection/config_TEMPLATE.json)).
- it opens the **`http:/127.0.0.1:3000`** URL in your default web browser.

<pre style="font-size:80%;">
<b>&gt; npm start</b>

> calculator@0.0.1 start W:\nodejs-examples\samples_Duuna\chp-4-code-injection
> node ./npm_scripts/start_browser.js && node .


Node runtime: 10.16.0 (x64)
Module search path: (none)
Server listening on port 3000
</pre>


*[mics](http://lampwww.epfl.ch/~michelou/)/June 2019*

