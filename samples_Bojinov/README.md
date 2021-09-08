# <span id="top">Node.js examples from Bojinov's book</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.svg" width="120" alt="Node.js logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <a href="."><strong><code>samples_Bojinov\</code></strong></a> contains <a href="https://nodejs.org/" alt="Node.js">Node.js</a> examples presented in <a href="https://www.amazon.com/RESTful-Web-API-Design-Node-JS/dp/1786469138">Bojinov's book</a> "<i>RESTful Web API Design with Node.js</i>" (<a href="https://www.packtpub.com/" rel="external" title="Packt Publishing">Packt</a>, 2015).</td>
  </tr>
</table>


## `express`

Command [**`npm start`**](./express/package.json) executes application [**`app\app.js`**](./express/app/app.js) which performs two tasks:

- it starts the server application which listen to client requests on port **`8180`** (defined in file [**`config.json`**](./express/config_TEMPLATE.json)).
- it opens URL **`http:/127.0.0.1:8180`** in our default web browser.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
N:\samples_Bojinov\express
&nbsp;
<b>&gt; <a href="https://docs.npmjs.com/cli/v6/commands/npm-start">npm start</a></b>

> express-app@0.0.1 start N:\samples_Bojinov\express
> node ./npm_scripts/start_browser.js && node .


Module search path: (none)
Server listening on port 8180
</pre>

The default browser displays the following contents in a new tab:

<pre style="font-size:80%;">
2019-12-07T17:53:06+01:00
</pre>


## `hello-1`

Command [**`npm start`**](./hello-1/package.json) executes application [**`app\app.js`**](./hello-1/app/app.js) which performs two tasks:

- it starts the server application which listen to client requests on port **`8180`** (defined in file [**`config.json`**](./hello-1/config_TEMPLATE.json)).
- it opens URL **`http:/127.0.0.1:8180`** in our default web browser.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli/v6/commands/npm-start">npm start</a></b>

&gt; hello1-app@0.0.1 start N:\samples_Bojinov\hello-1
&gt; node ./npm_scripts/start_browser.js && node .</b>

Node runtime: 14.17.6 (x64)
Module search path: (none)
Started Node.js http server at http://127.0.0.1:8180
requested (GET)
</pre>


## `math`

Command **`npm run test`** executes all test functions contained in directory [**`math\test`**](math/test/):

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli/v6/commands/npm-run-script">npm run</a> test</b>

&gt; math@0.0.1 test N:\samples_Bojinov\math
&gt; nodeunit test

test-math
√ test_add
√ test_subtract

OK: 2 assertions (16ms)
</pre>


## `mock`

Command **`npm run test`** executes all test functions contained in directory [**`mock\test`**](mock/test/), in this case [**`test-http-module.js`**](mock/test/test-http-module.js):

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli/v6/commands/npm-run-script">npm run</a> test</b>

> mock-example@0.0.1 test N:\samples_Bojinov\mock
> nodeunit test

test-http-module
Request processing by http-module ended
√ test_handle_GET_request

OK: 0 assertions (184ms)
</pre>


## `routes`

Command [**`npm start`**](./routes/package.json) executes [**`app\app.js`**](./routes/app/app.js) which performs two tasks:

- it starts the server application which listen to client requests on port **`8180`** (defined in file [**`config.json`**](./routes/config_TEMPLATE.json)).
- it opens URL **`http:/127.0.0.1:8180/salut?name=tom`** in our default web browser.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli/v6/commands/npm-start">npm start</a></b>

&gt; routes-app@0.0.1 start N:\samples_Bojinov\routes
&gt; node ./npm_scripts/start_browser.js && node .</b>


Node runtime: 14.17.6 (x64)
Module search path: N:\samples_Bojinov\\node_modules
Server listening at 127.0.0.1:8180
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/September 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>
