# Node.js examples from Bojinov's book

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.png" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>samples_Bojinov\</code></strong> directory contains <a href="http://nodejs.org/" alt="Node.js">Node.js</a> examples presented in <a href="https://www.amazon.com/RESTful-Web-API-Design-Node-JS/dp/1786469138">Bojinov's book</a> "<i>RESTful Web API Design with Node.js</i>" (Packet, 2015).</td>
  </tr>
</table>

### `hello-1`

Executing the **`npm start`** command in directory **`samples_Bojinov\hello-1\`** performs to tasks:

- it starts the server application which listen to client requests on port **`8180`** (defined in file **`config.json`**).
- it opens the **`http:/127.0.0.1:8180`** URL in your default web browser.

<pre style="font-size:80%;">
&gt; npm start

&gt; hello1-app@0.0.1 start C:\nodejs-examples\samples_Bojinov\hello-1
&gt; node ./npm_scripts/start_browser.js && node .

Node runtime: 8.11.1 (x64)
Module search path: (none)
Started Node.js http server at http://127.0.0.1:8180
requested (GET)
</pre>


*[mics](http://lampwww.epfl.ch/~michelou/)/April 2018*
