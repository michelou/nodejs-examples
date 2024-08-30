# <span id="top">Node.js examples from Düüna's book</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://nodejs.org/" rel="external"><img src="../docs/images/nodejs.svg" width="120" alt="Node.js project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <strong><code>samples_Duuna\</code></strong> 
 contains <a href="https://nodejs.org/" rel="external" title="Node.js">Node.js</a> examples presented in <a href="https://pragprog.com/book/kdnodesec/secure-your-node-js-web-application">Düüna's book</a> "<i>Secure Your Node.js Web Application</i>" (<a href="https://pragprog.com/" rel="external">The Pragmatic Programmers</a>, 2016).</td>
  </tr>
</table>


## <span id="networking">`chp-3-networking` Example</span>

Executing command **`npm start`** in directory [**`samples_Duuna\chp-3-networking\`**](./chp-3-networking/) performs two tasks:

- it starts the server application which listen to client requests on port **`3000`** (defined in file [**`config.json`**](./chp-3-networking/config_TEMPLATE.json) <sup id="anchor_01">[1](#footnote_01)</sup>).
- it opens the **`http:/127.0.0.1:3000`** URL in your default web browser.

First we start the server application in a new console:

<pre style="font-size:80%;">
<b>&gt; start <a href="https://docs.npmjs.com/cli-documentation/start.html" rel="external">npm start</a></b>

> cluster-main@1.0.0 start N:\samples_Duuna\chp-3-networking
> node ./npm_scripts/start_browser.js && node .


Node runtime: <a href="https://nodejs.org/fr/blog/release/v16.20.2">v16.20.2</a> (x64)
Module search path: (none)
Server listening on port 3000
</pre>

Then we start the client application in the current console:

<pre style="font-size:80%;">
<b>&gt; npm run client</b> 
                              
> cluster-main@1.0.0 client N:\samples_Duuna\chp-3-networking
> node ./npm_scripts/start_client.js   

en
hello world

de
hello world

fr
hello world
</pre>


## <span id="code-injection">`chp-4-code-injection` Example</span> [**&#x25B4;**](#top)

Executing command **`npm start`** in directory [**`samples_Duuna\chp-4-code-injection\`**](./chp-4-code-injection/) performs two tasks:

- it starts the server application which listen to client requests on port **`3000`** (defined in file [**`config.json`**](./chp-4-code-injection/config_TEMPLATE.json) <sup id="anchor_01">[1](#footnote_01)</sup>).
- it opens the **`http:/127.0.0.1:3000`** URL in your default web browser.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-documentation/start.html">npm start</a></b>

> calculator@0.0.1 start N:\samples_Duuna\chp-4-code-injection
> node ./npm_scripts/start_browser.js && node .


Node runtime: <a href="https://nodejs.org/fr/blog/release/v18.20.4">v18.20.4</a> (x64)
Module search path: (none)
Server listening on port 3000
</pre>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> **`config.json`** [↩](#anchor_01)

<dl><dd>
Only the template file <a href="./03_basic_auth/config_TEMPLATE.json"><code>config_TEMPLATE.json</code></a> is stored in our GitHub repository. The user has to copy it to <code>config.json</code> and update the two JSON fields <code>host</code> and <code>port</code> as desired <i>before</i> running the above code examples.
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/September 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->
