# <span id="top">Node.js examples from Cook's book</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://nodejs.org/" rel="external" title="Node.js"><img src="../docs/images/nodejs.svg" width="120" alt="Node.js project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <strong><code>samples_Cook\</code></strong> contains <a href="https://nodejs.org/" rel="external" title="Node.js">Node.js</a> examples presented in <a href="https://www.amazon.com/Node-js-Essentials-Fabian-Cook/dp/1785284924" rel="external">Fabian Cook's book</a> "<i>Node.js Essentials</i>" (Packt, 2015).</td>
  </tr>
</table>

> **:mag_right:** The numbering used below &ndash; eg. `03` in example `03_basic_auth` &ndash; refers to the chapter where the example belongs to.

## <span id="03_basic_auth">`03_basic_auth` Example</span>

Command **`npm.cmd start`** starts the server application [`app\app.js`](./03_basic_auth/app/app.js) which listen to our requests on port **`8180`** (defined in file [**`config.json`**](./03_basic_auth/config_TEMPLATE.json) <sup id="anchor_01">[1](#footnote_01)</sup>):

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
N:\samples_Cook\<a href="./03_basic_auth/">03_basic_auth</a>
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/start">start</a> "basic_auth" npm start</b>

> basic_auth@1.0.0 start N:\samples_Cook\03_basic_auth
> node app/app.js

[2018-05-10 19:43:17 INFO] (app.js) Listening on port 8180
[2018-05-10 19:43:33 INFO] (app.js) Requested URL: /
[2018-05-10 19:43:33 INFO] (app.js) Requested URL: /
[2018-05-10 19:43:33 INFO] (app.js) Requested URL: /
</pre>

Command **`npm.cmd run client`** sends several requests to the server: 

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli/v6/commands/npm-run-script">npm run</a> client</b>

> basic_auth@1.0.0 client N:\samples_Cook\03_basic_auth
> node npm_scripts/start_client.js

en /
fr /
de /
</pre>

## <span id="03_bearer_token">`03_bearer_token` Example</span> [**&#x25B4;**](#top)

Command [**`npm.cmd start`**](https://docs.npmjs.com/cli/v6/commands/npm-start) starts the server application [`app\app.js`](./03_bearer_token/app/app.js) which listen to our requests on port **`8180`** (defined in file [**`config.json`**](./03_bearer_token/config_TEMPLATE.json) <sup id="anchor_01">[1](#footnote_01)</sup>):

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/start">start</a> "bear_token" <a href="https://docs.npmjs.com/cli/v6/commands/npm-start">npm start</a></b>

> bearer_token@1.0.0 start N:\samples_Cook\03_bearer_token
> node .

[2020-07-14 19:06:21 INFO] (app.js) Listening on port 8180
</pre>

Command **`npm.cmd run client`** sends a `POST` request to the server (endpoint `/login`): 

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli/v6/commands/npm-run-script">npm run</a> client</b>

> bearer_token@1.0.0 client N:\samples_Cook\03_bearer_token
> node npm_scripts/start_client.js

[2020-07-14 19:08:02 INFO] (start_client.js) login: username=foo
[2020-07-14 19:08:02 INFO] (start_client.js) curl -H "User-Agent: Mozilla/5.0" -H "Content-Type: application/json" -X POST -d "{\"username\": \"foo\", \"password\":\"bar\"}" http://127.0.0.1:8180/login
token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJmb28iLCJpYXQiOjE1OTQ3NDY0ODJ9.xCpqkBxRTZ-JfC_HpB15GKur4tjJNuHEWFqhkXkCqtM
</pre>

## <span id="03_bearer_token2">`03_bearer_token2` Example</span>

Command [**`npm start`**](https://docs.npmjs.com/cli/v6/commands/npm-start) starts the server application [`app\app.js`](./03_bearer_token2/app/app.js) which listen to our requests on port **`8180`** (defined in file [**`config.json`**](./03_bearer_token2/config_TEMPLATE.json) <sup id="anchor_01">[1](#footnote_01)</sup>):

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/start">start</a> "bear_token2" <a href="https://docs.npmjs.com/cli/v6/commands/npm-start">npm start</a></b>

> bearer_token2@1.0.0 start N:\samples_Cook\03_bearer_token2
> node .

[2021-06-02 12:34:21 INFO] (app.js) Listening on port 8180
</pre>


Command **`npm run client`** sends a `POST` request to the server (endpoint `/login`): 

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli/v6/commands/npm-run-script">npm run</a> client</b>

> bearer_token@1.0.0 client N:\samples_Cook\03_bearer_token2
> node npm_scripts/start_client.js

[2021-06-02 12:36:18 INFO] (start_client.js) login: username=foo
[2021-06-02 12:36:18 INFO] (start_client.js) curl -H "User-Agent: Mozilla/5.0" -H "Content-Type: application/json" -X POST -d "{\"username\": \"foo\", \"password\":\"bar\"}" http://127.0.0.1:8180/login
token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJmb28iLCJpYXQiOjE2MjI2MzAxNzl9.-vkWn3KQVZdvZh4Eboe1AA7g3vINa7g71c-_uZcQ1j0
[2021-06-02 12:36:19 INFO] (start_client.js) curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJmb28iLCJpYXQiOjE2MjI2MzAxNzl9.-vkWn3KQVZdvZh4Eboe1AA7g3vINa7g71c-_uZcQ1j0" -X GET http://127.0.0.1:8180/userinfo
[2021-06-02 12:36:19 INFO] (start_client.js) json={"id":1,"username":"foo"}
</pre>

<!--
## <span id="03_oauth">`03_oauth`</span>


## <span id="04_logging_bunyan">`04_logging_bunyan`</span>
-->

## <span id="04_logging_morgan">`04_logging_morgan` Example</span>

Command [**`npm.cmd start`**](https://docs.npmjs.com/cli/v6/commands/npm-start) starts the server application [`app\app.js`](./04_logging_morgan/app/app.js) which listen to our requests on port **`8180`** (defined in file [**`config.json`**](./04_logging_morgan/config_TEMPLATE.json) <sup id="anchor_01">[1](#footnote_01)</sup>):

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/start">start</a> "logging_morgan" <a href="https://docs.npmjs.com/cli/v6/commands/npm-start">npm start</a></b>

> logging_morgan@1.0.0 start N:\samples_Cook\04_logging_morgan
> node .

Server running on port 8180
GET /info 200 - - 1.651 ms
</pre>

Command **`npm.cmd run client`** sends a `GE` request to the server (endpoint `/info`): 

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.npmjs.com/cli/v6/commands/npm-run-script">npm run</a> client</b>

> bearer_token@1.0.0 client N:\samples_Cook\03_bearer_token2
> node npm_scripts/start_client.js

[2022-05-27 09:54:46 INFO] (start_client.js) curl -H "User-Agent: Mozilla/5.0" -X GET http://127.0.0.1:8180/info
[2022-05-27 09:54:46 INFO] (start_client.js) json={"node":"14.20.0","v8":"8.4.371.23-node.87","uv":"1.42.0","zlib":"1.2.11","brotli":"1.0.9","ares":"1.18.1","modules":"83","nghttp2":"1.42.0","napi":"8","llhttp":"2.1.4","openssl":"1.1.1o","cldr":"40.0","icu":"70.1","tz":"2021a3","unicode":"14.0"}
</pre>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> **`config.json`** [↩](#anchor_01)

<dl><dd>
Only the template file <a href="./03_basic_auth/config_TEMPLATE.json"><code>config_TEMPLATE.json</code></a> is stored in our GitHub repository. The user has to copy it to <code>config.json</code> and update the two JSON fields <code>host</code> and <code>port</code> as desired <i>before</i> running the above code examples.
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->
