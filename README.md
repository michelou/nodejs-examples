# <span id="top">Playing with Node.js on Windows</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://nodejs.org/" rel="external"><img src="docs/images/nodejs.svg" width="120" alt="Node.js project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://nodejs.org/en/" rel="external">Node.js</a> code examples coming from various websites and books.<br/>
  It also includes several build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>) for experimenting with <a href="https://nodejs.org/en/" rel="external">Node.js</a> on a Windows machine.
  </td>
  </tr>
</table>

[Ada][ada_examples], [Akka][akka_examples], [C++][cpp_examples], [COBOL][cobol_examples], [Dart][dart_examples], [Deno][deno_examples], [Docker][docker_examples], [Erlang][erlang_examples], [Flix][flix_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kafka][kafka_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Modula-2][m2_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples], [WiX Toolset][wix_examples] and [Zig][zig_examples] are other topics we are continuously monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [Git 2.46][git_downloads] ([*release notes*][git_relnotes])
- [MongoDB 7.0][mongodb_downloads] ([*release notes*][mongodb7_relnotes])
- [Node.js 18.x LTS][nodejs18_downloads] <sup id="anchor_01"><a href="#footnote_01">1</a></sup> ([*change log*][nodejs18_changelog])

Optionally one may also install the following software:

- [ConEmu 2023][conemu_downloads] ([*release notes*][conemu_relnotes])
- [MongoDB Shell 2.2][mongosh_downloads] ([*change log*][mongosh_changelog])
- [Node.js 16.x LTS][nodejs16_downloads] ([*change log*][nodejs16_changelog])
- [Node.js 20.x LTS][nodejs20_downloads] ([*change log*][nodejs20_changelog])
- [Visual Studio Code 1.92][vscode_downloads] ([*release notes*][vscode_relnotes])

> **:mag_right:** [Git for Windows][git_win] provides a BASH emulation used to run [**`git`**][git_docs] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

For instance our development environment looks as follows (*August 2024*) <sup id="anchor_02"><a href="#footnote_02">2</a></sup>:

<pre style="font-size:80%;">
C:\opt\ConEmu\                   <i>( 26 MB)</i>
C:\opt\Git\                      <i>(315 MB)</i>
C:\opt\mongodb\                  <i>(1.6 GB)</i>
C:\opt\mongosh\                  <i>(133 MB)</i>
C:\opt\node-v16.20.2-win-x64\    <i>( 71 MB)</i>
C:\opt\node-v18.20.4-win-x64\    <i>( 78 MB)</i>
C:\opt\node-v20.15.1-win-x64\    <i>( 77 MB)</i>
C:\opt\VSCode\                   <i>(341 MB)</i>
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [**`/opt/`**][linux_opt] directory on Unix).

## <span id="structure">Directory structure</span>

This project is organized as follows:
<pre style="font-size:80%;">
bin\
docs\
samples\{<a href="samples/README.md">README.md</a>, <a href="samples/auth-passport/">auth-passport</a>, ..}
samples_Bojinov\{<a href="samples_Bojinov/README.md">README.md</a>, <a href="samples_Bojinov/contacts-1-JSON/">contacts-1-JSON</a>, ..}
samples_Cook\{<a href="samples_Cook/README.md">README.md</a>, <a href="samples_Cook/03_basic_auth/">03_basic_auth</a>, ..}
samples_Duuna\{<a href="samples_Duuna/README.md">README.md</a>, <a href="samples_Duuna/chp-3-networking/">chp-3-networking</a>, ..}
samples_Lambert\{<a href="samples_Lambert/README.md">README.md</a>, <a href="samples_Lambert/06-files/">06-files</a>, ..}
samples_Pillora\{<a href="samples_Pillora/README.md">README.md</a>, <a href="samples_Pillora/4-02-project/">4-02-project</a>, ..}
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="setenv.bat">setenv.bat</a>
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
- file [**`RESOURCES.md`**](RESOURCES.md) gathers [Node.js][nodejs] related informations.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive &ndash; e.g. drive **`N:`** &ndash; in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> N: <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\workspace\nodejs-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## <span id="batch_commands">Batch commands</span> [**&#x25B4;**](#top)

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes the external tools such as [**`node.exe`**][nodejs_node], [**`npm.cmd`**][nodejs_npm] directly available from the command prompt.

    <pre style="font-size:80%;">
    <b>&gt; <a href="setenv.bat">setenv</a> help</b>
    Usage: setenv { &lt;option&gt; | &lt;subcommand&gt; }
    &nbsp;
      Options:
        -debug      print commands executed by this script
        -verbose    print progress messages
    &nbsp;
      Subcommands:
        help        print this help message
    &nbsp;
    <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1">where</a> node npm</b>
    C:\opt\node-v18.20.4-win-x64\node.exe
    C:\opt\node-v18.20.4-win-x64\npm
    C:\opt\node-v18.20.4-win-x64\npm.cmd</pre>

2. [**`bin\check-outdated.bat`**](bin/check-outdated.bat) prints out outdated package dependencies for all project directories (i.e. directories containing file **`package.json`**).

   <pre style="font-size:80%;">
   <b>&gt; <a href="bin/check-outdated.bat">bin\check-outdated</a> help</b>
   Usage: check-outdated { &lt;option&gt; | &lt;subcommand&gt; }
   &nbsp;
     Options:
       -debug      print commands executed by this script
       -install    install latest package (if outdated)
       -timer      print total execution time
       -verbose    print progress messages
   &nbsp;
     Subcommands:
       help        print this help message</pre>

3. [**`samples\setenv.bat`**](samples/setenv.bat) - This batch command works the same way as in project root directory (point 1) with possibly additional tools (e.g. [**`mongod.exe`**][mongodb_mongod] or [**`siege.exe`**][siege_refman]).

## <span id="usage_examples">Usage examples</span> [**&#x25B4;**](#top)

### **`setenv.bat`** <sup id="anchor_03">[3](#footnote_03)</sup>

We execute command [**`setenv.bat`**](setenv.bat) once to setup your development environment:

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a></b>
Tool versions:
   node v16.20.2, npm 9.8.1, node v18.20.4, npm 10.8.2
   mongod v7.0.12, mongosh 2.2.12,
   git 2.46.0, diff 3.10, bash 5.2.26(1)
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1">where</a> mongosh npm</b>
C:\opt\mongosh\bin\mongosh.exe
C:\opt\node-v18.20.4-win-x64\npm
C:\opt\node-v18.20.4-win-x64\npm.cmd
</pre>

Command [**`setenv.bat -verbose`**](setenv.bat) also displays the tool paths:

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a> -verbose</b>
Tool versions:
   node v16.20.2, npm 9.8.1, node v18.20.4, npm 10.8.2
   mongod v7.0.12, mongosh 2.2.12,
   git 2.46.0, diff 3.10, bash 5.2.26(1)
Tool paths:
   C:\opt\node-v16.20.2-win-x64\node.exe
   C:\opt\node-v16.20.2-win-x64\npm.cmd
   C:\opt\node-v18.20.4-win-x64\node.exe
   C:\opt\node-v18.20.4-win-x64\npm.cmd
   C:\opt\mongodb\bin\mongod.exe
   C:\opt\mongosh\bin\mongosh.exe
   C:\opt\Git\bin\git.exe
   C:\opt\Git\mingw64\bin\git.exe
   C:\opt\Git\usr\bin\diff.exe
Environment variables:
   "GIT_HOME="C:\opt\Git"
   "MONGODB_HOME=C:\opt\mongodb"
   "MONGOSH_HOME=C:\opt\mongosh"
   "NODE_HOME=C:\opt\node-v18.20.4-win-x64"
   "NODE16_HOME=C:\opt\node-v16.20.2-win-x64"
   "NODE18_HOME=C:\opt\node-v18.20.4-win-x64"
   "NODE20_HOME=C:\opt\node-v20.15.1-win-x64"
Path associations:
   Q:\: => %USERPROFILE%\workspace-perso\nodejs-examples
</pre>

### **`bin\check-outdated.bat`**

Command [**`bin\check-outdated.bat`**](bin/check-outdated.bat) visits all project directories and prints out outdated package dependencies. For instance we see in the following output that package **`eslint-plugin-node`** is outdated in several projects:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/check-outdated.bat">bin\check-outdated</a></b>
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

Command [**`bin\check-outdated.bat -install`**](bin/check-outdated.bat) also updates the outdated package dependencies (and file **`package.json`**).

### **`samples\setenv.bat`**

Command [**`samples\setenv.bat -verbose`**](samples/setenv.bat) inside project directory [**`samples\`**](samples/) also adds the [**`mongod.exe`**][mongodb_mongod] tool to the path:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
N:\samples
&nbsp;
<b>&gt; <a href="samples/setenv.bat">setenv</a> -verbose</b>
Tool versions:
   node v16.20.2, npm 9.8.1, node v18.20.4, npm 10.8.2
   mongod v7.0.12, mongosh 2.2.12,
   git 2.46.0, diff 3.10, bash 5.2.26(1)
Tool paths:
   C:\opt\node-v16.20.2-win-x64\node.exe
   C:\opt\node-v16.20.2-win-x64\npm.cmd
   C:\opt\node-v18.20.4-win-x64\node.exe
   C:\opt\node-v18.20.4-win-x64\npm.cmd
   C:\opt\mongodb\bin\mongod.exe
   C:\opt\mongosh\bin\mongosh.exe
   C:\opt\Git\bin\git.exe
   C:\opt\Git\mingw64\bin\git.exe
   C:\opt\Git\usr\bin\diff.exe
</pre>

### **`npm.cmd`**

Command **`npm.cmd`** works as expected inside every project directory; for instance in project [**`samples\webaudio-sample\`**](samples/webaudio-sample/).

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
N:\samples\webaudio-sample

<b>&gt; <a href="https://docs.npmjs.com/cli-documentation/install.html">npm install</a> -audit</b>
audited 406 packages in 2.527s
found 0 vulnerabilities

<b>&gt; <a href="https://docs.npmjs.com/cli-documentation/start.html">npm start</a></b>

> webaudio-example@1.0.0 start N:\samples\webaudio-sample
> node ./npm_scripts/start_browser.js && node .

Module search path: N:\samples_Bojinov\\node_modules
Express server listening on port 8180
Returning Paradise.m4a for request /music
[...]
</pre>

> **:mag_right:** From time to time we also run one of the following command to search for <a href="https://eslint.org/docs/rules/">possible syntax or logic errors</a> in our JavaScript code:
> <pre style="margin-left:10px; font-size:80%;">
> <b>&gt; <a href="https://docs.npmjs.com/cli-commands/run-script.html">npm run</a> lint</b>
> &nbsp;
> &gt; async-downloads@0.0.1 lint N:\samples\webaudio-sample
> &gt; <a href="https://eslint.org/docs/7.0.0/user-guide/command-line-interface">eslint</a> app
> </pre></li>

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Node.js LTS** (Long Term Support)* [↩](#anchor_01)

<dl><dd>
We make the choice to work with the latest <a href="https://github.com/nodejs/Release">LTS version</a> of <a href="https://nodejs.org/en/">Node.js</a>. We started this project with version 8 LTS and successively upgraded it to version 10, 12, 14, 16 and 18 LTS.
</dd>
<dd>
<table>
<tr><th>LTS version</th><th>Initial&nbsp;Release</th><th>End-of-life</th></tr>
<tr><td><a href="https://nodejs.dev/en/about/releases/">24.x</a></td><td>April 2025</td><td>April 2028</td></tr>
<tr><td><a href="https://nodejs.dev/en/about/releases/">22.x</a></td><td>April 2024</td><td>April 2027</td></tr>
<tr><td><a href="https://nodejs.dev/en/about/releases/">20.x</a></td><td>April 2023</td><td>April 2026</td></tr>
<tr><td><a href="https://nodejs.org/dist/latest-v18.x/">18.x</a></td><td>April 2022</td><td>April 2025</td></tr>
<tr><td><a href="https://nodejs.org/dist/latest-v16.x/">16.x</a></td><td>October 2021</td><td>April 2024</td></tr>
<tr><td><a href="https://nodejs.org/dist/latest-v14.x/">14.x</a></td><td>October 2020</td><td>April 2023</td></tr>
<tr><td><a href="https://nodejs.org/dist/latest-v12.x/">12.x</a></td><td>October 2019</td><td>April 2022</td></tr>
<tr><td><a href="https://nodejs.org/dist/latest-v10.x/">10.x</a></td><td>October 2018</td><td>April 2021</td></tr>
<tr><td><a href="https://nodejs.org/dist/latest-v8.x/">8.x</a></td><td>October 2017</td><td>December 2019</td></tr>
</table>
</dd>
<dd>
Node.js version 14 LTS has been announced in April 2020.
</dd>
<dd>
<ul>
<li><a href="https://developer.ibm.com/">IBM Developer</a>: <a href="https://developer.ibm.com/technologies/node-js/blogs/nodejs-14-ibm-release-blog/">Node.js 14 release</a>,<br/>by Michael Dawson, April 21, 2020.</li>
<li><a href="https://medium.com/">Medium</a>: <a href="https://medium.com/@nodejs/node-js-version-14-available-now-8170d384567e">Node.js version 14 available now</a>, Node.js team, April 21, 2020.</li>
</ul>
</dd></dl>

<span id="footnote_02">[2]</span> ***Downloads*** [↩](#anchor_02)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="https://www.mongodb.com/try/download/community">mongodb-windows-x86_64-7.0.12.zip</a>  <i>(336 MB)</i>
<a href="https://www.mongodb.com/try/download/shell">mongosh-2.2.15-win32-x64.zip</a>       <i>( 33 MB)</i>
<a href="https://nodejs.org/dist/latest-v16.x/">node-v16.20.2-win-x64.zip</a>          <i>( 25 MB)</i>
<a href="https://nodejs.org/dist/latest-v18.x/">node-v18.20.4-win-x64.zip </a>         <i>( 27 MB)</i>
<a href="https://nodejs.org/dist/latest-v20.x/">node-v20.16.0-win-x64.zip</a>          <i>( 28 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.46.0-64-bit.7z.exe</a>   <i>( 42 MB)</i>
</pre>
</dd></dl>

<span id="footnote_03">[3]</span> **`setenv.bat` *usage*** [↩](#anchor_03)

<dl><dd>
Batch file <a href=./setenv.bat><code><b>setenv.bat</b></code></a> has specific environment variables set that enable us to use command-line developer tools more easily.
</dd>
<dd>It is similar to the setup scripts described on the page <a href="https://learn.microsoft.com/en-us/visualstudio/ide/reference/command-prompt-powershell" rel="external">"Visual Studio Developer Command Prompt and Developer PowerShell"</a> of the <a href="https://learn.microsoft.com/en-us/visualstudio/windows" rel="external">Visual Studio</a> online documentation.
</dd>
<dd>
For instance we can quickly check that the two scripts <code><b>Launch-VsDevShell.ps1</b></code> and <code><b>VsDevCmd.bat</b></code> are indeed available in our Visual Studio 2019 installation :
<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/where" rel="external">where</a> /r "C:\Program Files (x86)\Microsoft Visual Studio" *vsdev*</b>
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\Launch-VsDevShell.ps1
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\vsdevcmd\core\vsdevcmd_end.bat
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\vsdevcmd\core\vsdevcmd_start.bat
</pre>
</dd>
<dd>
Concretely, in our GitHub projects which depend on Visual Studio (e.g. <a href="https://github.com/michelou/cpp-examples"><code>michelou/cpp-examples</code></a>), <a href="./setenv.bat"><code><b>setenv.bat</b></code></a> does invoke <code><b>VsDevCmd.bat</b></code> (resp. <code><b>vcvarall.bat</b></code> for older Visual Studio versions) to setup the Visual Studio tools on the command prompt. 
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples#top
[akka_examples]: https://github.com/michelou/akka-examples#top
[book_bojinov]: https://www.amazon.com/RESTful-Web-API-Design-Node-JS/dp/1786469138
[book_cook]: https://www.amazon.com/Node-js-Essentials-Fabian-Cook/dp/1785284924
[book_duuna]: https://pragprog.com/book/kdnodesec/secure-your-node-js-web-application
[book_lambert]: https://www.editions-eni.fr/livre/node-js-exploitez-la-puissance-de-javascript-cote-serveur-9782746089785
[book_pillora]: https://www.packtpub.com/web-development/getting-started-grunt-javascript-task-runner
[cobol_examples]: https://github.com/michelou/cobol-examples#top
[conemu_downloads]: https://github.com/Maximus5/ConEmu/releases
[conemu_relnotes]: https://conemu.github.io/blog/2023/07/24/Build-230724.html
[cpp_examples]: https://github.com/michelou/cpp-examples#top
[dart_examples]: https://github.com/michelou/dart-examples#top
[deno_examples]: https://github.com/michelou/deno-examples#top
[docker_examples]: https://github.com/michelou/docker-examples#top
[erlang_examples]: https://github.com/michelou/erlang-examples#top
[flix_examples]: https://github.com/michelou/flix-examples#top
[git_cli]: https://git-scm.com/docs/git
[git_docs]: https://git-scm.com/docs/git
[git_downloads]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.46.0.txt
[git_win]: https://git-scm.com/download/win
[github_markdown]: https://github.github.com/gfm/
[golang_examples]: https://github.com/michelou/golang-examples#top
[graalvm_examples]: https://github.com/michelou/graalvm-examples#top
[haskell_examples]: https://github.com/michelou/haskell-examples#top
[ibm_developer]: https://developer.ibm.com/
[ibm_nodejs_14]: https://developer.ibm.com/technologies/node-js/blogs/nodejs-14-ibm-release-blog/
[kafka_examples]: https://github.com/michelou/kafka-examples#top
[kotlin_examples]: https://github.com/michelou/kotlin-examples#top
[linux_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[llvm_examples]: https://github.com/michelou/llvm-examples#top
[m2_examples]: https://github.com/michelou/m2-examples#top
[man1_awk]: https://www.linux.org/docs/man1/awk.html
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[man1_file]: https://www.linux.org/docs/man1/file.html
[man1_grep]: https://www.linux.org/docs/man1/grep.html
[man1_more]: https://www.linux.org/docs/man1/more.html
[man1_mv]: https://www.linux.org/docs/man1/mv.html
[man1_rmdir]: https://www.linux.org/docs/man1/rmdir.html
[man1_sed]: https://www.linux.org/docs/man1/sed.html
[man1_wc]: https://www.linux.org/docs/man1/wc.html
[medium_home]: https://medium.com/
[medium_nodejs_14]: https://medium.com/@nodejs/node-js-version-14-available-now-8170d384567e
[mongodb_downloads]: https://www.mongodb.com/try/download/community
[mongodb5_relnotes]: https://docs.mongodb.com/upcoming/release-notes/5.0/
[mongodb6_relnotes]: https://docs.mongodb.com/upcoming/release-notes/6.0/
[mongodb7_relnotes]: https://docs.mongodb.com/upcoming/release-notes/7.0/
[mongodb_mongod]: https://docs.mongodb.com/manual/reference/program/mongod/
[mongosh_changelog]: https://www.mongodb.com/docs/mongodb-shell/changelog/
[mongosh_downloads]: https://github.com/mongodb-js/mongosh/releases
[nodejs]: https://nodejs.org/
[nodejs_node]: https://nodejs.org/api/cli.html#cli_command_line_options
[nodejs_npm]: https://docs.npmjs.com/cli/npm
[nodejs12_changelog]: https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V12.md#12.22.12
[nodejs12_downloads]: https://nodejs.org/dist/latest-v12.x/
[nodejs14_changelog]: https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V14.md#14.21.3
[nodejs14_downloads]: https://nodejs.org/dist/latest-v14.x/
[nodejs16_changelog]: https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V16.md#16.20.2
[nodejs16_downloads]: https://nodejs.org/dist/latest-v16.x/
[nodejs18_changelog]: https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V18.md#18.20.4
[nodejs18_downloads]: https://nodejs.org/dist/latest-v18.x/
[nodejs20_changelog]: https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V20.md#20.15.1
[nodejs20_downloads]: https://nodejs.org/dist/latest-v20.x/
[rust_examples]: https://github.com/michelou/rust-examples#top
[scala3_examples]: https://github.com/michelou/dotty-examples#top
[siege_refman]: https://www.joedog.org/siege-manual/
[spark_examples]: https://github.com/michelou/spark-examples#top
[spring_examples]: https://github.com/michelou/spring-examples#top
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples#top
[vscode_downloads]: https://code.visualstudio.com/#alt-downloads
[vscode_relnotes]: https://code.visualstudio.com/updates
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix_examples]: https://github.com/michelou/wix-examples#top
[zig_examples]: https://github.com/michelou/zig-examples#top
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
