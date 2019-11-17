# <span id="top">Node.js examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.png" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>samples\</code></strong> directory contains <a href="http://nodejs.org/" alt="Node.js">Node.js</a> examples coming from various websites - mostly from the <a href="http://nodejs.org/">Node.js</a> project.</td>
  </tr>
</table>

### `auth-passport`

Executing command **`npm start`** in directory [**`samples\auth-passport\`**](./auth-passpor/) prints the following output:

<pre style="font-size:80%;">
<b>&gt; npm start</b>

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


### `locales-1`

Executing the **`npm start`** command in directory [**`samples\locales-1\`**](./locales-1/) performs two task:

- it starts the server application which listen to your requests on port **`8180`** (defined in file [**`config.json`**](./locales-1/config_TEMPLATE.json)).
- it opens the **`http:/127.0.0.1:8180`** URL in your default web browser:

<pre style="font-size:80%;">
<b>&gt; npm start</b>

> locales-1-app@0.0.1 start N:\samples\locales-1
> node ./npm_scripts/start_browser.js && node .


Node runtime: 10.16.3 (x64)
Module search path: (none)
Server listening on port 8180
</pre>

The following text is displayed in your default web browser:

<pre style="font-size:80%;">
Salut
</pre>


### `locales-2`

Executing command **`npm start`** in directory [**`samples\locales-2\`**](./locales-2/) performs two task:

- it starts the server application which listen to your requests on port **`8180`** (defined in file [**`config.json`**](./locales-2/config_TEMPLATE.json)).
- it opens the **`http:/127.0.0.1:8180`** URL in your default web browser:

<pre style="font-size:80%;">
<b>&gt; npm start</b>

> locales-2-app@0.0.1 start N:\samples\locales-2
> node ./npm_scripts/start_browser.js && node .


Node runtime: 12.13.0 (x64)
Module search path: (none)
Server listening on port 8180
fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3
en
fr
de
</pre>

Executing the **`npm run client`** command in directory [**`samples\locales-2\`**](./locales-2/) displays the following outut in the Windows console:

<pre style="font-size:80%;">
<b>&gt; npm run client</b>

> locales-2-app@0.0.1 client N:\samples\locales-2
> node ./npm_scripts/start_client.js

en
&lt;!DOCTYPE html>
&lt;html lang="en" dir="ltr"&gt;
<b>&lt;head&gt;</b>
 &lt;meta charset="utf-8">
  &lt;title&gt;Hello World&lt;/title&gt;
&lt;/head>
&lt;body&gt;
  &lt;h1&gt;Hello&lt;/h1&gt;
<b>&lt;/body&gt;</b>
<b>&lt;/html&gt;</b>  

fr 
&lt;!DOCTYPE html&gt;
&lt;html lang="fr" dir="ltr"&gt;
<b>&lt;head&gt;</b>
 &lt;meta charset="utf-8"&gt;
  &lt;title>Salut le monde&lt;/title&gt;
&lt;/head>
&lt;body>
  &lt;h1&gt;Salut&lt;/h1&gt;
<b>&lt;/body&gt;</b>
<b>&lt;/html&gt;</b>

de
&lt;!DOCTYPE html&gt;
&lt;html lang="de" dir="ltr"&gt;
<b>&lt;head&gt;</b>
 &lt;meta charset="utf-8"&gt;
  &lt;title>Hallo Welt&lt;/title&gt;
<b>&lt;/head&gt;</b>
<b>&lt;body&gt;</b>
  &lt;h1&gt;Hallo&lt;/h1&gt;   
<b>&lt;/body&gt;</b>
<b>&lt;/html></b>
</pre>


### `webaudio-sample`

Executing command **`npm start`** in directory [**`samples\webaudio-sample\`**](./webaudio-sample/) plays the audio file [**`Paradise.m4a`**](./webaudio-sample/Paradise.m4a) in your default web browser:

<pre style="font-size:80%;">
<b>&gt; npm start</b>

> music-engine@1.0.0 start N:\samples\webaudio-sample
> node ./npm_scripts/start_browser.js && node .


Module search path: (none)
Express server listening on port 8180
Returning Paradise.m4a for request /music
</pre>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/November 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>
