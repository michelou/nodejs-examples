# <span id="top">Node.js examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.svg" width="120" alt="Node.js logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>samples\</code></strong> directory contains <a href="https://nodejs.org/" rel="external" title="Node.js">Node.js</a> examples coming from various websites - mostly from the <a href="https://nodejs.org/" rel="external" title="Node.js">Node.js</a> project.</td>
  </tr>
</table>

## `auth-passport`

Command [**`npm start`**](auth-passport/package.json) executes application [**`app\app.js`**](./auth-passport/app/app.js) which prints the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-documentation/start.html">npm start</a></b>

> auth-passport@0.0.1 start N:\samples\auth-passport
> node app/app.js

Module search path: (none)
Express server listening on port 8180
[ { _id: 56f866add85f33503232ad41,
    firstName: 'John',
    lastName: 'Smith',
    username: 'john',
    password: '$2a$10$1t4NF.43jzLs51DfZYh9E.CahXkLHIsLChYUcDRwGRYCRumCjcwNC',
    email: 'john.smith@gmail.com',
    gender: 'Male',
    address: 'NY city',
    __v: 0 } ]
</pre>


## `locales-1`

Command [**`npm start`**](./locales-1/package.json) executes application [**`app\app.js`**](./locales-1/app/app.js) which performs two tasks:

- it starts the server application which listen to your requests on port **`8180`** (defined in file [**`config.json`**](./locales-1/config_TEMPLATE.json)).
- it opens the **`http:/127.0.0.1:8180`** URL in your default web browser:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-documentation/start.html">npm start</a></b>

> locales-1-app@0.0.1 start N:\samples\locales-1
> node ./npm_scripts/start_browser.js && node .


Node runtime: 14.16.0 (x64)
Module search path: (none)
Server listening on port 8180
</pre>

The following text is displayed in your default web browser:

<pre style="font-size:80%;">
Salut
</pre>


## `locales-2`

Command [**`npm start`**](./locales-2/package.json) executes application  [**`app\app.js`**](./locales-2/app/app.js) which performs two tasks:

- it starts the server application which listen to your requests on port **`8180`** (defined in file [**`config.json`**](./locales-2/config_TEMPLATE.json)).
- it opens the **`http:/127.0.0.1:8180`** URL in your default web browser:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-documentation/start.html">npm start</a></b>

> locales-2-app@0.0.1 start N:\samples\locales-2
> node ./npm_scripts/start_browser.js && node .


Node runtime: 14.16.0 (x64)
Module search path: (none)
Server listening on port 8180
fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3
en
fr
de
</pre>

Command **`npm run client`** displays the following output in a separate Windows console:

<pre style="font-size:80%;">
<b>&gt; npm run client</b>

> locales-2-app@0.0.1 client N:\samples\locales-2
> node ./npm_scripts/start_client.js

en
&lt;!DOCTYPE html&gt;
<b>&lt;html</b> lang="en" dir="ltr"&gt;
<b>&lt;head&gt;</b>
 &lt;meta charset="utf-8">
  <b>&lt;title&gt;</b>Hello World<b>&lt;/title&gt;</b>
<b>&lt;/head&gt;</b>
<b>&lt;body&gt;</b>
  <b>&lt;h1&gt;</b>Hello<b>&lt;/h1&gt;</b>
<b>&lt;/body&gt;</b>
<b>&lt;/html&gt;</b>  

fr 
&lt;!DOCTYPE html&gt;
<b>&lt;html</b> lang="fr" dir="ltr"&gt;
<b>&lt;head&gt;</b>
  <b>&lt;meta</b> charset="utf-8"&gt;
  <b>&lt;title&gt;</b>Salut le monde<b>&lt;/title&gt;</b>
<b>&lt;/head&gt;</b>
<b>&lt;body&gt;</b>
  <b>&lt;h1&gt;</b>Salut<b>&lt;/h1&gt;</b>
<b>&lt;/body&gt;</b>
<b>&lt;/html&gt;</b>

de
&lt;!DOCTYPE html&gt;
<b>&lt;html</b> lang="de" dir="ltr"&gt;
<b>&lt;head&gt;</b>
  <b>&lt;meta</b> charset="utf-8"&gt;
  <b>&lt;title&gt;</b>Hallo Welt<b>&lt;/title&gt;</b>
<b>&lt;/head&gt;</b>
<b>&lt;body&gt;</b>
  <b>&lt;h1&gt;</b>Hallo<b>&lt;/h1&gt;</b>
<b>&lt;/body&gt;</b>
<b>&lt;/html></b>
</pre>


## `webaudio-sample`

Executing command **`npm start`** in directory [**`samples\webaudio-sample\`**](./webaudio-sample/) plays the audio file [**`Paradise.m4a`**](./webaudio-sample/Paradise.m4a) in your default web browser:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli-documentation/start.html">npm start</a></b>

> music-engine@1.0.0 start N:\samples\webaudio-sample
> node ./npm_scripts/start_browser.js && node .


Module search path: (none)
Express server listening on port 8180
Returning Paradise.m4a for request /music
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/April 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>
