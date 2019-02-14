# Node.js examples

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.png" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>samples\</code></strong> directory contains <a href="http://nodejs.org/" alt="Node.js">Node.js</a> examples coming from various websites - mostly from the <a href="http://nodejs.org/">Node.js project</a>.</td>
  </tr>
</table>

### `auth-passport`

Executing the **`npm start`** command in directory **`samples\auth-passport\`** prints the following output:

<pre style="font-size:80%;">
<b>&gt; npm start</b>

> auth-passport@0.0.1 start C:\nodejs-examples\samples\auth-passport
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

Executing the **`npm start`** command in directory **`samples\locales-1\`** performs two task:

- it starts the server application which listen to your requests on port **`8180`** (defined in file **`config.json`**).
- it opens the **`http:/127.0.0.1:8180`** URL in your default web browser:

<pre style="font-size:80%;">
<b>&gt; npm start</b>

> locales-1-app@0.0.1 start C:\nodejs-examples\samples\locales-1
> node ./npm_scripts/start_browser.js && node .


Node runtime: 10.15.1 (x64)
Module search path: (none)
Server listening on port 8180
</pre>

The following text is displayed in your default web browser:

<pre style="font-size:80%;">
Salut
</pre>

### `locales-2`

Executing command **`npm start`** in directory **`samples\locales-2\`** performs two task:

- it starts the server application which listen to your requests on port **`8180`** (defined in file **`config.json`**).
- it opens the **`http:/127.0.0.1:8180`** URL in your default web browser:


<pre style="font-size:80%;">
<b>&gt; npm start</b>

> locales-2-app@0.0.1 start C:\nodejs-examples\samples\locales-2
> node ./npm_scripts/start_browser.js && node .


Node runtime: 8.12.0 (x64)
Module search path: (none)
Server listening on port 8180
fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3
en
fr
de
</pre>

Executing the **`npm run client`** command in directory **`samples\locales-2\`** displays the following outut in the Windows console:

<pre style="font-size:80%;">
<b>&gt; npm run client</b>

> locales-2-app@0.0.1 client C:\nodejs-examples\samples\locales-2
> node ./npm_scripts/start_client.js

en
&lt;!DOCTYPE html>
&lt;html lang="en" dir="ltr">
&lt;head>
 &lt;meta charset="utf-8">
  &lt;title>Hello World</title>
&lt;/head>
&lt;body>
  &lt;h1>Hello</h1>
&lt;/body>       
&lt;/html>    

fr 
&lt;!DOCTYPE html>
&lt;html lang="fr" dir="ltr">
&lt;head>
 &lt;meta charset="utf-8">
  &lt;title>Salut le monde</title>
&lt;/head>
&lt;body>
  &lt;h1>Salut</h1> 
&lt;/body>
&lt;/html>

de
&lt;!DOCTYPE html>
&lt;html lang="de" dir="ltr">
&lt;head>
 &lt;meta charset="utf-8">
  &lt;title>Hallo Welt</title>
&lt;/head>
&lt;body>
  &lt;h1>Hallo</h1>   
&lt;/body>
&lt;/html>
</pre>

### `webaudio-sample`


Executing the **`npm start`** command in directory **`samples\webaudio-sample`** plays the audio file **`Paradise.m4a`** in your web browser:

<pre style="font-size:80%;">
<b>&gt; npm start</b>

> music-engine@1.0.0 start C:\nodejs-examples\samples\webaudio-sample
> node ./npm_scripts/start_browser.js && node .


Module search path: (none)
Express server listening on port 8180
Returning Paradise.m4a for request /music
</pre>


*[mics](http://lampwww.epfl.ch/~michelou/)/February 2019*

