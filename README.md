# <span id="top">Playing with Node.js</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.png" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://nodejs.org/en/">Node.js</a> examples coming from various websites and books.<br/>
  It also includes several batch scripts for experimenting with <a href="https://nodejs.org/en/">Node.js</a> on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

## Project dependencies

This project depends on two external software for the **Microsoft Windows** plaform:

- [Node.js 10.x LTS](https://nodejs.org/en/download/) ([*release notes*](https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V10.md#10.15.1))
- [MongoDB 3.x](https://www.mongodb.org/dl/win32/x86_64-2008plus-ssl) ([*release notes*](https://docs.mongodb.com/manual/release-notes/3.6/))

Optionally one may also install the following software:

- [Git 2.22](https://git-scm.com/download/win) ([*release notes*](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.22.0.txt))

> **:mag_right:** Git for Windows provides a BASH emulation used to run [**`git`**](https://git-scm.com/docs/git) from the command line (as well as over 250 Unix commands like [**`awk`**](https://www.linux.org/docs/man1/awk.html), [**`diff`**](https://www.linux.org/docs/man1/diff.html), [**`file`**](https://www.linux.org/docs/man1/file.html), [**`grep`**](https://www.linux.org/docs/man1/grep.html), [**`more`**](https://www.linux.org/docs/man1/more.html), [**`mv`**](https://www.linux.org/docs/man1/mv.html), [**`rmdir`**](https://www.linux.org/docs/man1/rmdir.html), [**`sed`**](https://www.linux.org/docs/man1/sed.html) and [**`wc`**](https://www.linux.org/docs/man1/wc.html)).

For instance our development environment looks as follows (*August 2019*):

<pre style="font-size:80%;">
C:\opt\node-v10.16.1-win-x64\                    <i>( 44 MB)</i>
C:\opt\Git-2.22.0\                               <i>(271 MB)</i>
C:\opt\mongodb-win32-x86_64-2008plus-ssl-3.6.2\  <i>(1.1 GB)</i>
</pre>

For instance our development environment looks as follows (*June 2019*):

<pre style="font-size:80%;">
C:\opt\node-v10.16.0-win-x64\node.exe
C:\opt\node-v10.16.0-win-x64\npm.cmd
C:\opt\Git-2.22.0\bin\git.exe
C:\opt\mongodb-win32-x86_64-2008plus-ssl-3.6.2\bin\mongod.exe
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive](https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/) rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

We further recommand using an advanced console emulator such as [ComEmu](https://conemu.github.io/) (or [Cmdr](http://cmder.net/)) which features [Unicode support](https://conemu.github.io/en/UnicodeSupport.html).

## Directory structure

This project is organized as follows:
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
- directory [**`samples_Duuna`**](samples_Duuna/) contains Node.js examples from [Duuna's book](https://pragprog.com/book/kdnodesec/secure-your-node-js-web-application).
- directory [**`samples_Lambert`**](samples_Lambert/) contains Node.js examples from [Lambert's book](https://www.editions-eni.fr/livre/node-js-exploitez-la-puissance-de-javascript-cote-serveur-9782746089785).
- file [**`README.md`**](README.md) is the Markdown document for this page.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive **`N:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"](https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation) from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst) to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; subst N: %USERPROFILE%\workspace\nodejs-examples</b>
> </pre>

In the next section we give a brief description of the added batch files.

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
    C:\opt\node-v10.15.1-win-x64\node.exe
    C:\opt\node-v10.15.1-win-x64\npm
    C:\opt\node-v10.15.1-win-x64\npm.cmd
    </pre>


## Usage examples

#### `setenv.bat`

Command **`setenv`** is executed once to setup your development environment:

<pre style="margin:10px 0 0 30px;font-size:80%;">
<b>&gt; setenv</b>
Tool versions:
   node v10.16.1, npm 6.9.0, git 2.22.0.windows.1
<b>&gt; where npm</b>
C:\opt\node-v10.16.1-win-x64\npm
C:\opt\node-v10.16.1-win-x64\npm.cmd
</pre>

Command [**`setenv -verbose`**](setenv.bat) also displays the version/path of the tools:

<pre style="margin:10px 0 0 30px;font-size:80%;">
<b>&gt; setenv.bat -verbose</b>
Your environment has been set up for using Node.js 10.16.1 (x64) and npm.
Tool versions:
   node v10.16.1, npm 6.9.0, git 2.22.0.windows.1
Tool paths:
   C:\opt\node-v10.16.1-win-x64\node.exe
   C:\opt\node-v10.16.1-win-x64\npm.cmd
   C:\opt\Git-2.22.0\bin\git.exe
</pre>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/August 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

