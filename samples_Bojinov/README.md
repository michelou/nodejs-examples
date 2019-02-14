# Node.js examples from Bojinov's book

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.png" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <a href="."><strong><code>samples_Bojinov\</code></strong></a> directory contains <a href="http://nodejs.org/" alt="Node.js">Node.js</a> examples presented in <a href="https://www.amazon.com/RESTful-Web-API-Design-Node-JS/dp/1786469138">Bojinov's book</a> "<i>RESTful Web API Design with Node.js</i>" (<a href="https://www.packtpub.com/">Packt</a>, 2015).</td>
  </tr>
</table>

### `hello-1`

Executing command **`npm start`** in directory [**`samples_Bojinov\hello-1\`**](./hello-1/) performs two tasks:

- it starts the server application which listen to client requests on port **`8180`** (defined in file [**`config.json`**](./hello-1/config.json)).
- it opens URL **`http:/127.0.0.1:8180`** in your default web browser.

<pre style="font-size:80%;">
<b>&gt; npm start</b>

&gt; hello1-app@0.0.1 start W:\nodejs-examples\samples_Bojinov\hello-1
&gt; node ./npm_scripts/start_browser.js && node .</b>

Node runtime: 10.15.1 (x64)
Module search path: (none)
Started Node.js http server at http://127.0.0.1:8180
requested (GET)
</pre>


### `math`

<pre style="font-size:80%;">
<b>&gt; npm run test</b>

&gt; math@0.0.1 test W:\nodejs-examples\samples_Bojinov\math
&gt; nodeunit test

test-math
√ test_add
√ test_subtract

OK: 2 assertions (16ms)
</pre>


### `mock`

<pre style="font-size:80%;">
<b>&gt; npm run test</b>

> mock-example@0.0.1 test W:\nodejs-examples\samples_Bojinov\mock
> nodeunit test

test-http-module
Request processing by http-module ended
√ test_handle_GET_request

OK: 0 assertions (184ms)
</pre>


### `routes`

Executing command **`npm start`** in directory [**`samples_Bojinov\routes\`**](./routes/) performs two tasks:

- it starts the server application which listen to client requests on port **`8180`** (defined in file [**`config.json`**](./routes/config.json)).
- it opens URL **`http:/127.0.0.1:8180/salut?name=tom`** in your default web browser.

<pre style="font-size:80%;">
<b>&gt; npm start</b>

&gt; routes-app@0.0.1 start W:\nodejs-examples\samples_Bojinov\routes
&gt; node ./npm_scripts/start_browser.js && node .</b>


Node runtime: 10.15.1 (x64)
Module search path: W:\nodejs-examples\samples_Bojinov\\node_modules
Server listening at 127.0.0.1:8180
</pre>


*[mics](http://lampwww.epfl.ch/~michelou/)/February 2019*
