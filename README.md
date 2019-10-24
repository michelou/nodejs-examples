# <span id="top">Playing with Node.js</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.png" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://nodejs.org/en/">Node.js</a> examples coming from various websites and books.<br/>
  It also includes several batch commands for experimenting with <a href="https://nodejs.org/en/">Node.js</a> on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

## Project dependencies

This project depends on two external software for the **Microsoft Windows** plaform:

- [Node.js 12.x LTS](https://nodejs.org/en/download/) <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> ([*release notes*](https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V12.md#12.13.0))
- [MongoDB 3.6](https://www.mongodb.org/dl/win32/x86_64-2008plus-ssl) ([*release notes*](https://docs.mongodb.com/manual/release-notes/3.6/))

Optionally one may also install the following software:

- [Git 2.23](https://git-scm.com/download/win) ([*release notes*](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.23.0.txt))

> **:mag_right:** Git for Windows provides a BASH emulation used to run [**`git`**](https://git-scm.com/docs/git) from the command line (as well as over 250 Unix commands like [**`awk`**](https://www.linux.org/docs/man1/awk.html), [**`diff`**](https://www.linux.org/docs/man1/diff.html), [**`file`**](https://www.linux.org/docs/man1/file.html), [**`grep`**](https://www.linux.org/docs/man1/grep.html), [**`more`**](https://www.linux.org/docs/man1/more.html), [**`mv`**](https://www.linux.org/docs/man1/mv.html), [**`rmdir`**](https://www.linux.org/docs/man1/rmdir.html), [**`sed`**](https://www.linux.org/docs/man1/sed.html) and [**`wc`**](https://www.linux.org/docs/man1/wc.html)).

For instance our development environment looks as follows (*October 2019*):

<pre style="font-size:80%;">
C:\opt\node-v12.13.0-win-x64\                     <i>( 44 MB)</i>
C:\opt\Git-2.23.0\                                <i>(271 MB)</i>
C:\opt\mongodb-win32-x86_64-2008plus-ssl-3.6.14\  <i>(1.1 GB)</i>
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive](https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/) rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

We further recommand using an advanced console emulator such as [ComEmu](https://conemu.github.io/) (or [Cmdr](http://cmder.net/)) which features [Unicode support](https://conemu.github.io/en/UnicodeSupport.html).

## Directory structure

This project is organized as follows:
<pre style="font-size:80%;">
bin\check-outdated.bat
docs
samples\{auth-passport, ..}
samples_Bojinov\{contacts-1-JSON, ..}
samples_Cook\{basic_auth, ..}
samples_Duuna\{chp-3-networking, ..}
samples_Lambert\
samples_Pillora\
samples_Visual_Studio\
README.md
setenv.bat
</pre>

where

- directory [**`bin\`**](bin/) contains utility batch scripts.
- directory [**`docs\`**](docs/) contains several Node.js related papers/articles.
- directory [**`samples\`**](samples/) contains Node.js examples grabbed from various websites.
- directory [**`samples_Bojinov\`**](samples_Bojinov/) contains Node.js examples from [Bojinov's book](https://www.amazon.com/RESTful-Web-API-Design-Node-JS/dp/1786469138).
- directory [**`samples_Cook\`**](samples_Cook/) contains Node.js examples from [Cook's book](https://www.amazon.com/Node-js-Essentials-Fabian-Cook/dp/1785284924).
- directory [**`samples_Duuna\`**](samples_Duuna/) contains Node.js examples from [Düüna's book](https://pragprog.com/book/kdnodesec/secure-your-node-js-web-application).
- directory [**`samples_Lambert\`**](samples_Lambert/) contains Node.js examples from [Lambert's book](https://www.editions-eni.fr/livre/node-js-exploitez-la-puissance-de-javascript-cote-serveur-9782746089785).
- directory [**`samples_Pillora\`**](samples_Pillora/) contains Node.js examples from [Pillora's book](https://www.packtpub.com/web-development/getting-started-grunt-javascript-task-runner).
- file [**`README.md`**](README.md) is the Markdown document for this page.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive **`N:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"](https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation) from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst) to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; subst N: %USERPROFILE%\workspace\nodejs-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## Batch commands

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes the external tools such as [**`node.exe`**](https://nodejs.org/api/cli.html#cli_command_line_options), [**`npm.cmd`**](https://docs.npmjs.com/cli/npm) directly available from the command prompt.

    <pre style="font-size:80%;">
    <b>&gt; setenv help</b>
    Usage: setenv { options | subcommands }
      Options:
        -debug      show commands executed by this script
        -verbose    display environment settings
      Subcommands:
        help        display this help message
    <b>&gt; where node npm</b>
    C:\opt\node-v12.13.0-win-x64\node.exe
    C:\opt\node-v12.13.0-win-x64\npm
    C:\opt\node-v12.13.0-win-x64\npm.cmd
    </pre>

2. [**`bin\check-outdated.bat`**](bin/check-outdated.bat) prints out outdated package dependencies for all project directories (i.e. directories containing file **`package.json`**).

    <pre style="font-size:80%;">
    <b>&gt; bin\check-outdated.bat help</b>
    Usage: check-outdated { options | subcommands }
      Options:
        -debug      show commands executed by this script
        -install    install latest package (if outdated)
        -timer      display total elapsed time
        -verbose    display progress messages
      Subcommands:
        help        display this help message
    </pre>

3. [**`samples\setenv.bat`**](samples/setenv.bat) - This batch command works the same way as in project root directory (point 1) with possibly additional tools (eg. [**`mongod.exe`**](https://docs.mongodb.com/manual/reference/program/mongod/) or [**`siege.exe`**](https://www.joedog.org/siege-manual/)).

## Usage examples

#### `setenv.bat`

Command [**`setenv`**](setenv.bat) is executed once to setup your development environment:

<pre style="font-size:80%;">
<b>&gt; setenv</b>
Tool versions:
   node v12.13.0, npm 6.12.0
   git 2.23.0.windows.1, diff 3.7
<b>&gt; where npm</b>
C:\opt\node-v12.13.0-win-x64\npm
C:\opt\node-v12.13.0-win-x64\npm.cmd
</pre>

Command [**`setenv -verbose`**](setenv.bat) also displays the tool paths:

<pre style="font-size:80%;">
<b>&gt; setenv.bat -verbose</b>
Your environment has been set up for using Node.js 12.13.0 (x64) and npm.
Tool versions:
   node v12.13.0, npm 6.12.0
   git 2.23.0.windows.1, diff 3.7
Tool paths:
   C:\opt\node-v12.13.0-win-x64\node.exe
   C:\opt\node-v12.13.0-win-x64\npm.cmd
   C:\opt\Git-2.23.0\bin\git.exe
   C:\opt\Git-2.23.0\usr\bin\diff.exe
</pre>

#### `bin\check-outdated`

Command [**`bin\check-outdated`**](bin/check-outdated.bat) visits all project directories and prints out outdated package dependencies. For instance package we see in the following output that package **`eslint-plugin-node`** is outdated in several projects:

<pre style="font-size:80%;">
<b>&gt; bin\check-outdated</b>
directory samples\auth-passport\
directory samples\locales-1\
directory samples\locales-2\
directory samples\mongoose-default-connection\
directory samples\webaudio-sample\
   <b>outdated package eslint-plugin-node: wanted=9.2.0, latest=10.0.0</b>
directory samples_Bojinov\contacts-1-JSON\
directory samples_Bojinov\contacts-2-LevelDB\
directory samples_Bojinov\contacts-3-LevelDB2\
directory samples_Bojinov\contacts-4-Mongoose\
directory samples_Bojinov\contacts-5-MongoDB\
   <b>outdated package eslint-plugin-node: wanted=9.2.0, latest=10.0.0</b>
directory samples_Bojinov\contacts-6-Image\
[...]
</pre>

Command [**`bin\check-outdated -install`**](bin/check-outdated.bat) also updates the outdated package dependencies (and file **`package.json`**).

#### `samples\setenv.bat`

Command [**`samples\setenv -verbose`**](samples/setenv.bat) inside project directory [**`samples\`**](samples/) also adds the [**`mongod`**](https://docs.mongodb.com/manual/reference/program/mongod/) tool to the path:

<pre style="font-size:80%;">
<b>&gt; cd</b>
N:\samples
<b>&gt; setenv -verbose</b>
Tool versions:
   node v12.13.0, npm 6.12.0
   git 2.23.0.windows.1, diff 3.7, mongod v3.6.14
Tool paths:
   C:\opt\node-v12.13.0-win-x64\node.exe
   C:\opt\node-v12.13.0-win-x64\npm.cmd
   C:\opt\Git-2.23.0\bin\git.exe
   C:\opt\Git-2.23.0\mingw64\bin\git.exe
   C:\opt\Git-2.23.0\usr\bin\diff.exe
   C:\opt\mongodb-win32-x86_64-2008plus-ssl-3.6.14\bin\mongod.exe
</pre>

#### `npm.cmd`

Command **`npm`** works as expected inside every project directory; for instance in project [**`samples\webaudio-sample\`**](samples/webaudio-sample/).

<pre style="font-size:80%;">
<b>&gt; cd</b>
N:\samples\webaudio-sample

<b>&gt; npm install -audit</b>
audited 406 packages in 2.527s
found 0 vulnerabilities

<b>&gt; npm start</b>

> webaudio-example@1.0.0 start N:\samples\webaudio-sample
> node ./npm_scripts/start_browser.js && node .

Module search path: N:\samples_Bojinov\\node_modules
Express server listening on port 8180
Returning Paradise.m4a for request /music
[...]
</pre>

> **:mag_right:** From time to time we also run one of the following command to search for <a href="https://eslint.org/docs/rules/">possible syntax or logic errors</a> in our JavaScript code:
> <pre style="margin-left:18px; font-size:80%;">
> <b>&gt; npm run lint</b>
> &nbsp;
> > async-downloads@0.0.1 lint N:\samples\webaudio-sample
> > eslint app
> </pre></li>

## Footnotes

<a name="footnote_01">[1]</a> ***Node.js LTS*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
We make the choice to work with the latest <a href="https://github.com/nodejs/Release">LTS version</a> of <a href="https://nodejs.org/en/">Node.js</a>. We started this project with version 8 LTS and successively upgraded it to version 10 LTS and version 12 LTS.
<table style="margin:0 0 1em 20px;">
<tr><th>Release</th><th>LTS Start</th><th>End-of-life</th></tr>
<tr><td>8.x</td><td>October 2017</td><td>December 2019</td></tr>
<tr><td>10.x</td><td>October 2018</td><td>April 2021</td></tr>
<tr><td>12.x</td><td>October 2019</td><td>April 2022</td></tr>
</table>
</p>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/October 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>
