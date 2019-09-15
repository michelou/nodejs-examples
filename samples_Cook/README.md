# Node.js examples from Cook's book

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.png" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>samples_Cook\</code></strong> directory contains <a href="http://nodejs.org/" alt="Node.js">Node.js</a> examples presented in <a href="https://www.amazon.com/Node-js-Essentials-Fabian-Cook/dp/1785284924">Fabian Cook's book</a> "<i>Node.js Essentials</i>" (Packt, 2015).</td>
  </tr>
</table>

### `basic-auth`

Executing command **`npm start`** in directory [**`samples_Cook\basic-auth\`**](./basic-auth/) starts the server application which listen to your requests on port **`8180`** (defined in file [**`config.json`**](./basic-auth/config.json)):

<pre style="font-size:80%;">
<b>&gt; npm start</b>

> basic_auth@1.0.0 start N:\samples_Cook\basic_auth
> node app/app.js

[2018-05-10 19:43:17 INFO] (app.js) Listening on port 8180
[2018-05-10 19:43:33 INFO] (app.js) Requested URL: /
[2018-05-10 19:43:33 INFO] (app.js) Requested URL: /
[2018-05-10 19:43:33 INFO] (app.js) Requested URL: /
</pre>

Executing command **`npm run client`** in directory [**`samples_Cook\basic-auth\`**](./basic-auth/) sends several requests to the server: 

<pre style="font-size:80%;">
<b>&gt; npm run client</b>

> basic_auth@1.0.0 client N:\samples_Cook\basic_auth
> node npm_scripts/start_client.js

en /
fr /
de /
</pre>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/August 2019*