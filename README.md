# Playing with Node.js

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.png" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://nodejs.org/en/">Node.js</a> examples coming from various websites and books.<br/>
  It also includes several batch scripts for experimenting with Node.js on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

## Project dependencies

This project repository relies on a small set of software installations for the **Microsoft Windows** plaform:

- [Node.js 10.x LTS](https://nodejs.org/en/download/) ([*release notes*](https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V10.md#10.15.1))
- [MongoDB 3.x](https://www.mongodb.org/dl/win32/x86_64-2008plus-ssl)

Optionally one may also install the following software:

- [Git 2.20](https://git-scm.com/download/win) ([*release notes*](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.20.1.txt))

> ***Software installation policy***<br/>
> Whenever possible software is installed via a Zip archive rather than via a Windows installer.

For instance our development environment looks as follows (*February 2019*):

<pre style="font-size:80%;">
C:\opt\node-v10.15.1-win-x64\node.exe
C:\opt\node-v10.15.1-win-x64\npm.cmd
C:\opt\Git-2.20.1\bin\git.exe
C:\opt\mongodb-win32-x86_64-2008plus-ssl-3.6.2\bin\mongod.exe
</pre>

We further recommand using an advanced console emulator such as [ComEmu](https://conemu.github.io/) (or [Cmdr](http://cmder.net/)) which features [Unicode support](https://conemu.github.io/en/UnicodeSupport.html).

## Directory structure

This repository is organized as follows:
<pre style="font-size:80%;">
docs
README.md
samples
samples_Bojinov
samples_Cook
samples_Duuna
samples_Lambert
samples_Pillora
samples_Visual_Studio
setenv.bat
</pre>

where

- directory [**`docs\`**](docs/) contains several Node.js related papers/articles.
- directory [**`samples\`**](samples/) contains Node.js examples grabbed from various websites.
- directory [**`samples_Bojinov\`**](samples_Bojinov/) contains Node.js examples from [Bojinov's book](https://www.amazon.com/RESTful-Web-API-Design-Node-JS/dp/1786469138).
- directory [**`samples_Cook\`**](samples_Cook/) contains Node.js examples from [Cook's book](https://www.amazon.com/Node-js-Essentials-Fabian-Cook/dp/1785284924).
- file [**`README.md`**](README.md) is the Markdown document for this page.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

## Batch scripts

We distinguish different sets of batch scripts:

1. [**`setenv.bat`**](setenv.bat) - This batch script makes the external tools such as [**`node.exe`**](https://nodejs.org/api/cli.html#cli_command_line_options), [**`npm.cmd`**](https://docs.npmjs.com/cli/npm) directly available from the command prompt.

    <pre style="font-size:80%;">
    <b>&gt; node -v</b>
    v10.15.1

    <b> &gt; npm -v</b>
    6.4.1
    </pre>


## Session examples

#### `setenv.bat`

The **`setenv`** command is executed once to setup your development environment:

<pre style="margin:10px 0 0 30px;font-size:80%;">
<b>&gt; setenv</b>

<b>&gt; where npm</b>
C:\opt\node-v10.15.1-win-x64\npm
C:\opt\node-v10.15.1-win-x64\npm.cmd
</pre>

With option **`-verbose`** the **`setenv`** command displays the version/path of the tools:

<pre style="margin:10px 0 0 30px;font-size:80%;">
<b>&gt; setenv.bat -verbose</b>
Your environment has been set up for using Node.js 10.15.1 (x64) and npm.
NODE_VERSION=v10.15.1
NPM_VERSION=6.4.1
GIT_VERSION=2.20.1.windows.1
C:\opt\node-v10.15.1-win-x64\node.exe
C:\opt\node-v10.15.1-win-x64\npm.cmd
C:\opt\Git-2.20.1\bin\git.exe
</pre>


*[mics](http://lampwww.epfl.ch/~michelou/)/February 2019*

