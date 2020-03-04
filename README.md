# <span id="top">Playing with Node.js</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://nodejs.org/"><img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.svg" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://nodejs.org/en/">Node.js</a> code examples coming from various websites and books.<br/>
  It also includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a> for experimenting with <a href="https://nodejs.org/en/">Node.js</a> on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

[Dotty][dotty_examples], [GraalSqueak][graalsqueak_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples] and [LLVM][llvm_examples] are other trending topics we are currently monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on two external software for the **Microsoft Windows** plaform:

- [Node.js 12.x LTS][nodejs_downloads] <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> ([*release notes*][nodejs_relnotes])
- [MongoDB 3.6][mongodb_downloads] ([*release notes*][mongodb_relnotes])

Optionally one may also install the following software:

- [Git 2.25][git_downloads] ([*release notes*][git_relnotes])

> **:mag_right:** Git for Windows provides a BASH emulation used to run [**`git`**][git_docs] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

For instance our development environment looks as follows (*February 2020*) <sup id="anchor_02"><a href="#footnote_02">[2]</a></sup>:

<pre style="font-size:80%;">
C:\opt\Git-2.25.1\                                <i>(271 MB)</i>
C:\opt\mongodb-win32-x86_64-2008plus-ssl-3.6.17\  <i>(1.1 GB)</i>
C:\opt\node-v12.16.1-win-x64\                     <i>( 49 MB)</i>
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][linux_opt] directory on Unix).

## <span id="structure">Directory structure</span>

This project is organized as follows:
<pre style="font-size:80%;">
bin\
docs\
samples\{auth-passport, ..}
samples_Bojinov\{contacts-1-JSON, ..}
samples_Cook\{basic_auth, ..}
samples_Duuna\{chp-3-networking, ..}
samples_Lambert\
samples_Pillora\
README.md
setenv.bat
</pre>

where

- directory [**`bin\`**](bin/) contains utility batch scripts.
- directory [**`docs\`**](docs/) contains [Node.js][nodejs] related papers/articles.
- directory [**`samples\`**](samples/) contains [Node.js][nodejs] code examples grabbed from various websites.
- directory [**`samples_Bojinov\`**](samples_Bojinov/) contains [Node.js][nodejs] code examples from [Bojinov's book][book_bojinov].
- directory [**`samples_Cook\`**](samples_Cook/) contains [Node.js][nodejs] code examples from [Cook's book][book_cook].
- directory [**`samples_Duuna\`**](samples_Duuna/) contains [Node.js][nodejs] code examples from [Düüna's book][book_duuna].
- directory [**`samples_Lambert\`**](samples_Lambert/) contains [Node.js][nodejs] code examples from [Lambert's book][book_lambert].
- directory [**`samples_Pillora\`**](samples_Pillora/) contains [Node.js][nodejs] code examples from [Pillora's book][book_pillora].
- file [**`README.md`**](README.md) is the [Markdown][github_markdown] document for this page.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive **`N:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; subst N: %USERPROFILE%\workspace\nodejs-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## <span id="batch_commands">Batch commands</span>

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes the external tools such as [**`node.exe`**][nodejs_node], [**`npm.cmd`**][nodejs_npm] directly available from the command prompt.

    <pre style="font-size:80%;">
    <b>&gt; setenv help</b>
    Usage: setenv { &lt;option&gt; | &lt;subcommand&gt; }
    &nbsp;
      Options:
        -debug      show commands executed by this script
        -verbose    display environment settings
    &nbsp;
      Subcommands:
        help        display this help message
    &nbsp;
    <b>&gt; where node npm</b>
    C:\opt\node-v12.16.1-win-x64\node.exe
    C:\opt\node-v12.16.1-win-x64\npm
    C:\opt\node-v12.16.1-win-x64\npm.cmd</pre>

2. [**`bin\check-outdated.bat`**](bin/check-outdated.bat) prints out outdated package dependencies for all project directories (i.e. directories containing file **`package.json`**).

   <pre style="font-size:80%;">
   <b>&gt; bin\check-outdated.bat help</b>
   Usage: check-outdated { &lt;option&gt; | &lt;subcommand&gt; }
   &nbsp;
     Options:
       -debug      show commands executed by this script
       -install    install latest package (if outdated)
       -timer      display total elapsed time
       -verbose    display progress messages
   &nbsp;
     Subcommands:
       help        display this help message</pre>

3. [**`samples\setenv.bat`**](samples/setenv.bat) - This batch command works the same way as in project root directory (point 1) with possibly additional tools (e.g. [**`mongod.exe`**][mongodb_mongod] or [**`siege.exe`**][siege_refman]).

## <span id="usage_examples">Usage examples</span>

#### `setenv.bat`

Command [**`setenv`**](setenv.bat) is executed once to setup your development environment:

<pre style="font-size:80%;">
<b>&gt; setenv</b>
Tool versions:
   node v12.16.1, npm 6.13.4
   git 2.25.1.windows.1, diff 3.7
&nbsp;
<b>&gt; where npm</b>
C:\opt\node-v12.16.1-win-x64\npm
C:\opt\node-v12.16.1-win-x64\npm.cmd
</pre>

Command [**`setenv -verbose`**](setenv.bat) also displays the tool paths:

<pre style="font-size:80%;">
<b>&gt; setenv.bat -verbose</b>
Your environment has been set up for using Node.js 12.16.1 (x64) and npm.
Tool versions:
   node v12.16.1, npm 6.13.4
   git 2.25.1.windows.1, diff 3.7
Tool paths:
   C:\opt\node-v12.16.1-win-x64\node.exe
   C:\opt\node-v12.16.1-win-x64\npm.cmd
   C:\opt\Git-2.25.1\bin\git.exe
   C:\opt\Git-2.25.1\usr\bin\diff.exe
</pre>

#### `bin\check-outdated.bat`

Command [**`bin\check-outdated`**](bin/check-outdated.bat) visits all project directories and prints out outdated package dependencies. For instance package we see in the following output that package **`eslint-plugin-node`** is outdated in several projects:

<pre style="font-size:80%;">
<b>&gt; bin\check-outdated</b>
directory samples\auth-passport\
directory samples\locales-1\
directory samples\locales-2\
directory samples\mongoose-default-connection\
directory samples\webaudio-sample\
   <b>outdated package eslint-plugin-node: current=9.2.0, latest=10.0.0</b>
directory samples_Bojinov\contacts-1-JSON\
directory samples_Bojinov\contacts-2-LevelDB\
directory samples_Bojinov\contacts-3-LevelDB2\
directory samples_Bojinov\contacts-4-Mongoose\
directory samples_Bojinov\contacts-5-MongoDB\
   <b>outdated package eslint-plugin-node: current=9.2.0, latest=10.0.0</b>
directory samples_Bojinov\contacts-6-Image\
[...]
</pre>

Command [**`bin\check-outdated -install`**](bin/check-outdated.bat) also updates the outdated package dependencies (and file **`package.json`**).

#### `samples\setenv.bat`

Command [**`samples\setenv -verbose`**](samples/setenv.bat) inside project directory [**`samples\`**](samples/) also adds the [**`mongod`**][mongodb_mongod] tool to the path:

<pre style="font-size:80%;">
<b>&gt; cd</b>
N:\samples
<b>&gt; setenv -verbose</b>
Tool versions:
   node v12.16.1, npm 6.13.4
   git 2.25.1.windows.1, diff 3.7, mongod v3.6.17
Tool paths:
   C:\opt\node-v12.16.1-win-x64\node.exe
   C:\opt\node-v12.16.1-win-x64\npm.cmd
   C:\opt\Git-2.25.1\bin\git.exe
   C:\opt\Git-2.25.1\mingw64\bin\git.exe
   C:\opt\Git-2.25.1\usr\bin\diff.exe
   C:\opt\mongodb-win32-x86_64-2008plus-ssl-3.6.17\bin\mongod.exe
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
> <pre style="margin-left:10px; font-size:80%;">
> <b>&gt; npm run lint</b>
> &nbsp;
> > async-downloads@0.0.1 lint N:\samples\webaudio-sample
> > eslint app
> </pre></li>

## Footnotes

<a name="footnote_01">[1]</a> ***Node.js LTS** (Long Term Support)* [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
We make the choice to work with the latest <a href="https://github.com/nodejs/Release">LTS version</a> of <a href="https://nodejs.org/en/">Node.js</a>. We started this project with version 8 LTS and successively upgraded it to version 10 LTS and version 12 LTS.
<table style="margin:0 0 1em 20px;">
<tr><th>Release</th><th>LTS Start</th><th>End-of-life</th></tr>
<tr><td><a href="https://nodejs.org/dist/latest-v8.x/">8.x</a></td><td>October 2017</td><td>December 2019</td></tr>
<tr><td><a href="https://nodejs.org/dist/latest-v10.x/">10.x</a></td><td>October 2018</td><td>April 2021</td></tr>
<tr><td><a href="https://nodejs.org/dist/latest-v12.x/">12.x</a></td><td>October 2019</td><td>April 2022</td></tr>
</table>
</p>

<a name="footnote_02">[2]</a> ***Downloads*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://www.mongodb.org/dl/win32/x86_64-2008plus-ssl">mongodb-win32-x86_64-2008plus-ssl-3.6.17.zip</a>  <i>(317 MB)</i>
<a href="https://nodejs.org/dist/latest-v12.x/">node-v12.16.1-win-x64.zip</a>                     <i>( 17 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.25.1-64-bit.7z.exe</a>              <i>( 42 MB)</i>
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/February 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[book_bojinov]: https://www.amazon.com/RESTful-Web-API-Design-Node-JS/dp/1786469138
[book_cook]: https://www.amazon.com/Node-js-Essentials-Fabian-Cook/dp/1785284924
[book_duuna]: https://pragprog.com/book/kdnodesec/secure-your-node-js-web-application
[book_lambert]: https://www.editions-eni.fr/livre/node-js-exploitez-la-puissance-de-javascript-cote-serveur-9782746089785
[book_pillora]: https://www.packtpub.com/web-development/getting-started-grunt-javascript-task-runner
[dotty_examples]: https://github.com/michelou/dotty-examples
[git_docs]: https://git-scm.com/docs/git
[git_downloads]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.25.1.txt
[github_markdown]: https://github.github.com/gfm/
[graalsqueak_examples]: https://github.com/michelou/graalsqueak-examples
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[haskell_examples]: https://github.com/michelou/haskell-examples
[kotlin_examples]: https://github.com/michelou/kotlin-examples
[linux_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[llvm_examples]: https://github.com/michelou/llvm-examples
[man1_awk]: https://www.linux.org/docs/man1/awk.html
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[man1_file]: https://www.linux.org/docs/man1/file.html
[man1_grep]: https://www.linux.org/docs/man1/grep.html
[man1_more]: https://www.linux.org/docs/man1/more.html
[man1_mv]: https://www.linux.org/docs/man1/mv.html
[man1_rmdir]: https://www.linux.org/docs/man1/rmdir.html
[man1_sed]: https://www.linux.org/docs/man1/sed.html
[man1_wc]: https://www.linux.org/docs/man1/wc.html
[mongodb_downloads]: https://www.mongodb.org/dl/win32/x86_64-2008plus-ssl
[mongodb_mongod]: https://docs.mongodb.com/manual/reference/program/mongod/
[mongodb_relnotes]: https://docs.mongodb.com/manual/release-notes/3.6/
[nodejs]: https://nodejs.org/
[nodejs_downloads]: https://nodejs.org/en/download/
[nodejs_node]: https://nodejs.org/api/cli.html#cli_command_line_options
[nodejs_npm]: https://docs.npmjs.com/cli/npm
[nodejs_relnotes]: https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V12.md#12.16.1
[siege_refman]: https://www.joedog.org/siege-manual/
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
