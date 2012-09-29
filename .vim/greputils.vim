" greputils.vim -- Interface with grep and id-utils.
" Author: Hari Krishna (hari_vim at yahoo dot com)
" Last Change: 14-Jul-2005 @ 18:18
" Created:     10-Jun-2004 from idutils.vim
" Requires: Vim-6.3, genutils.vim(1.18), multvals.vim(3.6)
" Depends On: cmdalias.vim(1.0)
" Version: 2.8.0
" Acknowledgements:
"   - gumnos (Tim Chase) (gumnos at hotmail dot com) for the idea of
"     capturing the g/re/p output and using it as a simple grep. The
"     ArgGrep/BufGrep/WinGrep commands are based on this idea.
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt 
" Download From:
"     http://www.vim.org/script.php?script_id=1062
" Description:
"   - There are many plugins that wrap the Vim built-in :grep command and try
"     to simplify the usage. However this plugin aims at providing two
"     specific features:
"         - Escape the arguments such that the arguments can be passed to the
"           external grep/lid/find literally. This avoids unwanted
"           interpretations by the shell, thus allowing you to concentrate on
"           the regular expression patterns rather than how to escape them.
"           This has been tested well on both windows and UNIX with
"           sh/bash/cmd as command shells.
"         - Allow you to preview the results before letting Vim handle them as
"           part of quickfix. This, besides allowing you to further filter the
"           results, also prevents Vim from adding buffers for files that are
"           uninteresting and thus help reduce the number of buffers. It also
"           supports basic quickfix commands that can be used to open a buffer 
"           without needing to convert it to a quickfix window. You can
"           consider it as a lightweight quickfix window. The preview window
"           is also great if you just want to take a peak at the results, not
"           really navigate them (such as to get an estimate of where all a
"           reference is found).
"     - Also provides commands to run the Vim built-in :g/re/p on multiple
"       buffers using :argdo, :bufdo and :windo commands and redirect the
"       output to the grep-results preview window. You can then convert the
"       results to a quickfix window, or use the preview window to navigate.
"     - As a bonus, the plugin also works around Vim problem with creating a
"       number of unnamed buffers as you close and open quickfix window
"       several times. This helps keep buffer list uncluttered.
"
"   - The command merely wraps the built-in :grep, :grepadd, :cfile and
"     :cgetfile commands to create the quickfix list. The rest of the quickfix
"     commands work just like they do on the quickfix results created by using
"     only the built-in functionality. This also means that the plugin assume
"     that you have the options such as 'grepprg', 'shellpipe' are properly
"     set. Read the help on quickfix for the full list of commands and options
"     that you have.
"
"       :h quickfix 
"
"   - Other than the preview functionality which enables filtering, the plugin
"     also provides an easy way to specify a number of filter commands that
"     you can chain on the output of the grep/lid/find, each prefixed with
"     "+f". The arguments to the filter command are themselves escaped, the
"     same way as the grep command arguments as described above.
"   - Supports GNU "grep" and MS Windows "findstr" for running "find-in-file"
"     kind of searches, id-utils "lid" for running index searches, and GNU
"     "find" to search for file names. If you need to add support for a new
"     grep command or a grep-like tool, it is just a matter of modifying a few
"     internal variables and possibly adding a new set of commands.
"   - On windows, setting multiple ID files for IDPATH doesn't work, so the
"     plugin provides a workaround by running "lid" separately on each ID file
"     if there are multiple ID files separated by ";" in the IDPATH.
"   - Make sure that the 'grepprg' and 'shellpipe' options are properly set
"     and that the built-in :grep itself works. For GNU id-utils, make sure
"     IDPATH environmental variable is set or path to the ID file is specified
"     with the "-f" argument in the g:greputilsLidcmd setting. You can also
"     specify the "-f ID" arguments to the :IDGrep command.
"   - Uses EscapeCommand() function from genutils.vim plugin that supports
"     Cygwin "bash", MS Windows "cmd" and Unix "sh" for shell escaping. Other
"     environments are untested.
"   - Defines the following commands:
"
"       Grep, GrepAdd, IDGrep, IDGrepAdd, Find, FindAdd
"       Grepp, GreppAdd, IDGrepp, IDGreppAdd, Findp, FindpAdd
"
"     The second set of commands are used to open the results in a preview
"     window instead of directly in the quickfix window. And those that have a
"     suffix of "Add" add the new list of results to the existing list,
"     instead of replacing them (just like in :grepadd). This can be very
"     useful in combination with the preview commands.
"
"     You can open the preview window at anytime using GrepPreview command.
"     Once you are in the preview window, you can filter the results using the
"     regular Vim commands, and when you would like to browse the results
"     using Vim quickfix commands, just use Cfile and Cgetfile commands, which
"     are functionally equivalent to the built-in cfile and cgetfile commands
"     respectively, except that they don't take a filename as argument use the
"     current preview window contents to create the error-list. There are
"     also, GOpen, GClose and GWindow commands defined on the lines of copen,
"     cclose and cwindow respectively.
"
"     Use the GrepPreviewSetup command to convert an arbitrary buffer
"     containing :grep output as a preview window. This is useful to take
"     advantage of the quickfix like functionality that the plugin provides on
"     grep results generated by your own commands.
"
"     If cmdalias.vim is installed, it also creates aliases for the Grep,
"     GrepAdd, Cfile and Cgetfile commands to the corresponding built-in
"     commands, i.e., grep, grepadd, cfile and cgetfile respectively.
"
"     The preview window supports the following commands:
"       preview command     quickfix command ~
"       GG [count]          cc [count]
"       [count]GNext        [count]cnext
"       [count]GPrev        [count]cNext, cprevious
"       <CR>                <CR>
"       <2-LeftMouse>       <2-LeftMouse>
"
"     The commands supports [count] argument just like the corresponding
"     quickfix command.
"
"   General Syntax:
"       <grep command> [<grep/lid/find options> ...] <regex/keyword>
"                      [<filename patterns>/<more options>]
"                      [+f <filter arguments> ...]
"
"     Note that typically you have to pass in at least one filename pattern to
"     grep/findstr where as you don't pass in any for lid.
"   - Also defines the following commands:
"
"       ArgGrep, ArgGrepAdd, BufGrep, BufGrepAdd, WinGrep, WinGrepAdd
"
"     You can use the above commands to run Vim's built-in g/re/p command to
"     find matches across buffers loaded in the current session, without
"     needing any external tools. Each of the above commands (and their "Add"
"     variants), run g/re/p command on a bunch of buffers loaded using one of
"     :argdo, :bufdo and :windo commands respectively. These commands are
"     designed to always open the results in the preview window. If you like,
"     you can convert it to a quickfix result, by using :Cfile or :Cgetfile
"     command.
"
"   General Syntax:
"       [range]<Arg|Buf|Win>Grep[Add] [<pattern>]
"
"     If you don't specify a pattern, the current value in search register
"     (@/) will be used, which essentially means that the last search pattern
"     will be used. See also g:greputilsVimGrepSepChar setting under
"     installation section.
"
"     The range, if not specified, defaults to all the lines in all the
"     applicable buffers. If you explicitly specify a range, please note that
"     a range such as "%" or "1,$" is translated to the absolute line numbers
"     with reference to the current buffer by Vim itself, so it is not the
"     same as not specifying at all. This means, if there are 100 lines in the
"     current buffer, specifying "%" or "1,$" is equivalent to specifying
"     "1,100" as the range. The range is more useful with the "GrepBufs"
"     command mentioned below.
"   - Also defines "GrepBufs" command that can be used to grep for a Vim
"     regular expression pattern in the specified set of buffers (or the
"     current buffer). If no pattern is specified it will default to the
"     current search pattern. Buffers can be specified by name (see :h
"     bufname()) or by their number using the #<bufno> notation. You can also
"     complete the buffer names by using the completion character (<Tab>).
"
"   General Syntax:
"       [range]GrepBufs[Add] [pattern] [buffer ...]
"
"     This by syntax is very close to the Unix grep command. The main
"     difference being that it uses Vim regex and it searches the buffers
"     already loaded instead of those on the file system.
"
"     The range has same semantics as for any of the "arg", "buf" or "win" grep
"     commands, but it is more useful here while limiting the grep for one
"     buffer alone.
"
" Examples:
"   The following examples assume that you are using GNU grep for both the
"   'grepprg' and as the g:greputilsFiltercmd.
"
"   - Run GNU grep from the directory of the current file recursively while
"     limiting the search only for Java files.
"       Grep -r --include=*.java \<main\> %:h
"   - Run lid while filtering the lines that are not from Java source.
"       IDGrep main +f \.java
"   - Run lid while filtering the lines that contain src.
"       IDGrep main +f -v src
"   - Find Java files starting with A and ending with z under src.
"       Find src -iname A*z.java
"
"   - To search for the current word in all the files and filter the results
"     not containing \.java in the grepped output. This will potentially
"     return all the occurences in the java files only. 
"       IDGrep <cword> +f \.java 
"
"   - If any argument contains spaces, then you need to protect them by
"     prefixing them with a backslash.  The following will filter those lines
"     that don't contain "public static".
"       IDGrep <cword> +f public\ static
"
"   - Run ":bufdo g/public static/p" and show output in preview window:
"       BufGrep public\ static
"
" Installation:
"   - Drop the file in your plugin directory or source it from your vimrc.
"   - Requires genutils (vimscript#197) and multvals (vimscript #171) plugins
"     also to be installed.
"
"   Optional Settings:
"       g:greputilsLidcmd, g:greputilsFindcmd, g:greputilsFiltercmd,
"       g:greputilsFindMsgFmt, g:greputilsAutoCopen, g:greputilsVimGrepCmd,
"       g:greputilsVimGrepAddCmd, g:greputilsGrepCompMode,
"       g:greputilsLidCompMode, g:greputilsFindCompMode,
"       g:greputilsExpandCurWord, g:greputilsVimGrepSepChar,
"       g:greputilsPreserveLastResults, g:greputilsPreserveAllResults,
"       g:greputilsPreviewCreateFolds
"
"     - Use g:greputilsLidcmd and g:greputilsFiltercmd to set the path/name to
"       the lid and GNU or compatible find executable (defaults to "lid").
"     - Use g:greputilsFiltercmd to set the path/name of the command that you
"       would like to use as the filter when "+f" option is used (defaults to
"       "grep").
"     - Set g:greputilsFindMsgFmt to change the message (%m) part of the find
"       results. You can specify anything that is accepted in the argument for
"       "-printf" find option.
"     - Use g:greputilsAutoCopen to specify if the error list window should
"       automatically be opened or closed based on whether there are any
"       results or not (runs :cwindow command at the end).
"     - Use g:greputilsVimGrepCmd and g:greputilsVimGrepAddCmd to have the
"       plugin run a different command than the built-in :grep command to
"       generate the results. This is mainly useful to use the plugin as a
"       wrapper to finally invoke another plugin after the arguments are
"       escaped and 'shellpipe' is properly set. The callee typically can just
"       run the :grep command on the arguments and do additional setup.
"     - Use g:greputilsGrepCompMode, g:greputilsLidCompMode and
"       g:greputilsFindCompMode to change the completion mode for Grep, IDGrep
"       and Find commands respectively. The default completion mode for Grep
"       and Find are "file" to match that of the built-in commands, where as
"       it is set to "tag" for IDGrep (except the -f argument to specify an ID
"       file, you never need to pass filenam to lid). When completion mode is
"       "file", Vim automatically expands filename meta-characters such as "%"
"       and "#" on the command-line, so you still need to escape then. If this
"       is an issue for you, then you should switch to "tag" or a different
"       completion mode. When completion mode is not "file", the plugin
"       expands the filename meta characters in the file arguments anyway, and
"       this can be considered as an advantage (think about passing patterns
"       to the command literally). However it is still useful to have
"       "<cword>" and "<cWORD>" expand inside the patterns, in which case you
"       can set g:greputilsExpandCurWord setting.  Changing this option at
"       runtime requires you to reload the plugin.
"     - When completion mode is not set to "file", you can set
"       g:greputilsExpandCurWord to have the plugin expand "<cword>" and
"       "<cWORD>" tokens. This essentially gives you all the goodness of file
"       completion while still being able to do tag completions.
"     - For Vim built-in grep operations such as :BufGrep, if you want to
"       change the character sorrounding the pattern from the default '/' to
"       something else (see |E146|), you can use the
"       g:greputilsVimGrepSepChar. This is useful if you have a lot of "/"
"       characters in your pattern.
"     - The plugin normally preserves the previous results in the preview
"       window, which you can retrieve by doing an undo immediately after
"       generating the new results, inside the preview window. If you don't
"       like this, you can disable this feature by resetting
"       g:greputilsPreserveLastResults setting. You can instead set the
"       g:greputilsPreserveAllResults to preserve all the changes done in the
"       preview window, by user and the plugin itself.
"     - While using the *pAdd commands (that add results to preview window),
"       the individual set of results are folded together to be able to
"       identify them better. You can disable this feature by resetting the
"       g:greputilsPreviewCreateFolds setting.
" TODO:
"   - Is it useful to accept a range for GrepBufs command?
"   - Restoring the unnamed and 0 registers doesn't work cleanly.
"   - Can we implement custom completion to support both tag and filenames?
"   - Is it possible that I am setting 'winfixheight' on a wrong window?
"   - Can I use python to execute a grep in the background and fill up preview
"     buffer while the output is being generated?

if exists('loaded_greputils')
  finish
endif
if v:version < 603
  echomsg 'greputils: You need at least Vim 6.3'
  finish
endif
if !exists('loaded_multvals')
  runtime plugin/multvals.vim
endif
if !exists('loaded_multvals') || loaded_multvals < 306
  echomsg 'greputils: You need a newer version of multvals.vim plugin'
  finish
endif
if !exists('loaded_genutils')
  runtime plugin/genutils.vim
endif
if !exists('loaded_genutils') || loaded_genutils < 118
  echomsg 'greputils: You need a newer version of genutils.vim plugin'
  finish
endif
let loaded_greputils=1

" No error if not found, but we need it during the initialization itself.
if !exists('loaded_cmdalias')
  runtime plugin/cmdalias.vim
endif

" Make sure line-continuations won't cause any problem. This will be restored
"   at the end
let s:save_cpo = &cpo
set cpo&vim

if !exists('g:greputilsLidcmd')
  let g:greputilsLidcmd = 'lid'
endif

if !exists('g:greputilsFindcmd')
  let g:greputilsFindcmd = 'find'
endif

if !exists('g:greputilsFiltercmd')
  let g:greputilsFiltercmd = 'grep'
endif

if !exists('g:greputilsFindMsgFmt')
  let g:greputilsFindMsgFmt = '\ Size(%s)\ Modified(%Tb\ %Td\ %TH:%TM)\ Mode(%m)\ Links(%n)\n'
endif

if !exists('g:greputilsAutoCopen')
  let g:greputilsAutoCopen = 1
endif

if !exists('g:greputilsVimGrepCmd')
  let g:greputilsVimGrepCmd = 'grep'
endif

if !exists('g:greputilsVimGrepAddCmd')
  let g:greputilsVimGrepAddCmd = 'grepadd'
endif

if !exists('g:greputilsGrepCompMode')
  let g:greputilsGrepCompMode = 'file'
endif

if !exists('g:greputilsLidCompMode')
  let g:greputilsLidCompMode = 'tag'
endif

if !exists('g:greputilsFindCompMode')
  let g:greputilsFindCompMode = 'file'
endif

if !exists('g:greputilsExpandCurWord')
  let g:greputilsExpandCurWord = 1
endif

if !exists('g:greputilsVimGrepSepChar')
  let g:greputilsVimGrepSepChar = '/'
endif

if !exists("g:greputilsPreserveLastResults")
  let g:greputilsPreserveLastResults = 1
endif

if !exists("g:greputilsPreserveAllResults")
  let g:greputilsPreserveAllResults = 0
endif

if !exists("g:greputilsPreviewCreateFolds")
  let g:greputilsPreviewCreateFolds = 1
endif

" Add the "lid -R grep" and "find -printf" format to grep formats.
set gfm+=%f:%l:%m

exec 'command! -nargs=+ -complete='.g:greputilsGrepCompMode
      \ 'Grep call <SID>Grep("grep", 0, 0, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsGrepCompMode
      \ 'GrepAdd call <SID>Grep("grep", 0, 1, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsGrepCompMode
      \ 'Grepp call <SID>Grep("grep", 1, 0, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsGrepCompMode
      \ 'GreppAdd call <SID>Grep("grep", 1, 1, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsLidCompMode
      \ 'IDGrep call <SID>Grep("lid", 0, 0, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsLidCompMode
      \ 'IDGrepAdd call <SID>Grep("lid", 0, 1, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsLidCompMode
      \ 'IDGrepp call <SID>Grep("lid", 1, 0, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsLidCompMode
      \ 'IDGreppAdd call <SID>Grep("lid", 1, 1, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsFindCompMode
      \ 'Find call <SID>Grep("find", 0, 0, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsFindCompMode
      \ 'FindAdd call <SID>Grep("find", 0, 1, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsFindCompMode
      \ 'Findp call <SID>Grep("find", 1, 0, <f-args>)'
exec 'command! -nargs=+ -complete='.g:greputilsFindCompMode
      \ 'FindpAdd call <SID>Grep("find", 1, 1, <f-args>)'

" We translate the default range to mean '%', otherwise, the range will get
" fixed to the current buffer's range.
command! -range -bang -nargs=? -complete=tag WinGrep
      \ :call <SID>VimGrep(<line1>, <line2>, '<bang>', 0, 'windo', <q-args>)
command! -range -bang -nargs=? -complete=tag WinGrepAdd
      \ :call <SID>VimGrep(<line1>, <line2>, '<bang>', 1, 'windo', <q-args>)
command! -range -bang -nargs=? -complete=tag BufGrep
      \ :call <SID>VimGrep(<line1>, <line2>, '<bang>', 0, 'bufdo', <q-args>)
command! -range -bang -nargs=? -complete=tag BufGrepAdd
      \ :call <SID>VimGrep(<line1>, <line2>, '<bang>', 1, 'bufdo', <q-args>)
command! -range -bang -nargs=? -complete=tag ArgGrep
      \ :call <SID>VimGrep(<line1>, <line2>, '<bang>', 0, 'argdo', <q-args>)
command! -range -bang -nargs=? -complete=tag ArgGrepAdd
      \ :call <SID>VimGrep(<line1>, <line2>, '<bang>', 1, 'argdo', <q-args>)
command! -range -bang -nargs=* -complete=buffer GrepBufs
      \ :call <SID>GrepBuffers(<line1>, <line2>, '<bang>', 0, <f-args>)
command! -range -bang -nargs=* -complete=buffer GrepBufsAdd
      \ :call <SID>GrepBuffers(<line1>, <line2>, '<bang>', 1, <f-args>)

if (! exists("no_plugin_maps") || ! no_plugin_maps) &&
      \ (! exists("no_greputils_maps") || ! no_greputils_maps)
  if !hasmapto('\gwin', 'n')
    nnoremap <silent> \gwin :GWindow<CR>
  endif
endif

if exists('*CmdAlias')
  call CmdAlias('grep', 'Grep')
  call CmdAlias('grepadd', 'GrepAdd')
endif


command! -range=% GNext :call s:GNextImpl(1, <line1>)
command! -range=% GPrev :call s:GNextImpl(-1, <line1>)
command! -count=0 GG :call s:GNextImpl(0, <count>)
command! -count=0 GClose :call <SID>GWindow(0, <count>)
command! -count=0 GOpen :call <SID>GWindow(1, <count>)
command! -count=0 GWindow :call <SID>GWindow(-1, <count>)
command! -count=0 GrepPreview :call <SID>OpenGrepPreview(1, 0, <count>)
command! -nargs=0 GrepPreviewSetup :call s:SetupPreviewWindow(<f-args>)

if !exists('s:myBufNum')
let s:myBufNum = -1
let s:title = '[Grep Preview]'

let s:savedGrepprg = ''
let s:savedShellpipe = ''

let s:prevCwd = ''
let s:prevCurHit = 1
endif

let s:curQuickFixBufs = ''
aug GrepUtilsAutoQFBufWipeout
  au!
  au BufReadPost quickfix :call s:RegisterQuickfixBuf(bufnr('%'))
aug END

let s:supportedCmds = 'grep,lid,find,'

let s:gnuGrepCmdExpr = '' " Just depend on the default settings.
let s:findstrCmdExpr = '' " Just depend on the default settings.
let s:lidCmdExpr = 'g:greputilsLidcmd'
let s:findCmdExpr = 'g:greputilsFindcmd'

" These arguments are appended at the end of user supplied files.
let s:gnuGrepAddOptsExpr = ''
let s:findstrAddOptsExpr = ''
let s:lidAddOptsExpr = '"-R grep"'
let s:findAddOptsExpr = '"-printf %h/%f:1:".g:greputilsFindMsgFmt'

" These options are appended at the end of user supplied options.
let s:gnuGrepAddArgsExpr = ''
let s:findstrAddArgsExpr = '"nul"'
let s:lidAddArgsExpr = ''
let s:findAddArgsExpr = ''

" Options for GNU grep that require an argument.
let s:gnuGrepArgOpts = 'A,B,C,D,d,e,f,m,'
let s:gnuGrepOptPrfx = '-'
let s:gnuGrepNumPatterns = 1
let s:findstrArgOpts = 'D'
let s:findstrOptPrfx = '/'
let s:findstrNumPatterns = 1
let s:lidNumPatterns = -1 " Unlimited (no file args).
let s:findNumPatterns = -1

" Pass an optional filter pattern as a second argument.
function! s:Grep(cmdType, preview, grepAdd, ...)
  if a:0 == 0
    echohl ERROR | echo "Missing arguments." | echohl None
    return
  endif

  let grepOpts = ''
  let fileArgs = ''
  let filterArgs = ''
  let filterArgsStarted = 0
  let patternsCollected = 0
  let arg = ''
  let prevArg = ''
  let i = 1
  let cmdType = s:SubCmdType(a:cmdType)
  let grepAdd = a:grepAdd
  while i <= a:0
    try
      let arg = a:{i}
      if !filterArgsStarted && arg ==# '+f'
        let filterArgsStarted = 1
        continue
      endif

      if !filterArgsStarted
        let argIsFilePat = 1
        if s:{cmdType}NumPatterns < 0
          let argIsFilePat = 0
        else
          if fileArgs == ''
            if s:IsOpt(arg, cmdType)
              let argIsFilePat = 0
            elseif s:IsOpt(prevArg, cmdType) &&
                  \ MvContainsElement(s:{cmdType}ArgOpts, ',',
                  \   strpart(prevArg, 1))
              " If the previous option required an argument.
              let argIsFilePat = 0
            elseif patternsCollected < s:{cmdType}NumPatterns
              let argIsFilePat = 0
              let patternsCollected = patternsCollected + 1
            endif
          endif
        endif
        if argIsFilePat
          let fileArgs = fileArgs . ' ' . arg
        else
          let grepOpts = grepOpts . ' ' . escape(arg, ' ')
        endif
      else
        let filterArgs = filterArgs . ' ' . escape(arg, ' ')
      endif
    finally
      let prevArg = arg
      let i = i + 1
    endtry
  endwhile

  try
    " When completion mode is not file, let us manually do the Vim filename
    "   special character expansions (like %, # etc.)
    if (g:greputils{substitute(a:cmdType, '.', '\U&', '')}CompMode != 'file')
      if (fileArgs !~ '^\s*$')
        let fileArgs = UserFileExpand(fileArgs)
      endif
      if g:greputilsExpandCurWord
        " Also expand <cword> and <cWORD> in other arguments.
        let grepOpts = substitute(grepOpts, '<cword>\|<cWORD>',
              \ '\=expand(submatch(0))', 'g')
        let filterArgs = substitute(filterArgs, '<cword>\|<cWORD>',
              \ '\=expand(submatch(0))', 'g')
      endif
    endif
    call s:GrepSet(cmdType, a:preview, filterArgs)
    if s:{cmdType}AddOptsExpr != ''
      let grepOpts = grepOpts.' '.s:EvalExpr(s:{cmdType}AddOptsExpr)
    endif
    if s:{cmdType}AddArgsExpr != ''
      let fileArgs = fileArgs.' '.s:EvalExpr(s:{cmdType}AddArgsExpr)
    endif

    let _grepOpts = EscapeCommand('', grepOpts, fileArgs)
    let handleMultipleID = 0
    " On windows, we need to manually handle multiple ID files.
    if cmdType ==# 'lid' && OnMS()
      if GetShellEnvType() == g:ST_WIN_CMD
        let _grepOpts = grepOpts.' '.fileArgs
      endif

      if MvNumberOfElements($IDPATH, ';') > 1
        if !MvContainsPattern(grepOpts, MvCrUnProtectedCharsPattern(' '), '-f')
          let handleMultipleID = 1
          call MvIterCreate($IDPATH, ';', 'GrepUtils')
        endif
      endif
    endif

    let grepOpts = Escape(_grepOpts, '%#!')

    while 1
      let addOpts = ''
      if handleMultipleID
        if GetShellEnvType() == g:ST_WIN_CMD
          let addOpts = '-f '.MvIterNext('GrepUtils')
        else
          let addOpts = EscapeCommand('', '-f '.MvIterNext('GrepUtils'), ' ')
        endif
      endif

      if !a:preview
        if grepAdd == 1
          exec g:greputilsVimGrepAddCmd addOpts grepOpts
        else
          exec g:greputilsVimGrepCmd addOpts grepOpts
        endif
        if g:greputilsAutoCopen
          cwindow
        endif
      else
        let cmd = &grepprg.' '.addOpts.grepOpts
        call s:OpenGrepPreview(0, grepAdd, 0)
        " Just to make it look more authentic.
        let pathsep = exists('+shellslash')?(&shellslash?'/':'\'):'/'
        echo '!'.cmd.' '.&shellredir.' '.$TMP.pathsep.'<temp file>'
        silent! exec 'read !'.cmd
        silent! 1delete _
        if v:shell_error
          " Mimic the Vim message for the built-in :grep command.
          echomsg 'shell returned '.v:shell_error
          return
        endif
        exec MakeArgumentList('argumentList', ' ')
        call s:InitPreviewWindow(grepAdd, a:cmdType, argumentList)
      endif

      if !handleMultipleID || (handleMultipleID && !MvIterHasNext('GrepUtils'))
        break
      else
        " Make the rest of the ID lookups add to the previous results.
        let grepAdd = 1
      endif
    endwhile
  finally
    call s:GrepReset()
  endtry
endfunction

function! s:SetupPreviewWindow(...)
  if a:0 < 2
    echohl ErrorMsg | echo 'Usage: GrepPreviewSetup <cmd> <args>' | echohl None
    return
  endif
  call s:SetupBuf()
  call s:InitPreviewWindow(0, a:1, a:2)
endfunction

function! s:InitPreviewWindow(grepAdd, cmd, args)
  if a:grepAdd && g:greputilsPreviewCreateFolds
    if IsPositionSet('GrepUtils')
      call RestoreHardPosition('GrepUtils')
    endif
    if (line('$') - line('.') > 2) && (foldlevel('.') == 0)
      silent! .,$fold
    endif
  endif

  let s:prevCwd = getcwd()
  let s:prevCurHit = 1
  call SilentSubstitute("\<CR>$", "%s///e")
  call SilentSubstitute('^\(\%(\f\| \)\+\):\(\d\+\):', '%s//\1|\2|/e')
  1put! ='Last grep command: '.a:cmd.' '.a:args
  setl ft=qf
  1
endfunction

function! s:VimGrep(fline, lline, bang, grepAdd, vimWild, ...)
  exec MakeArgumentString()
  exec 'call s:_VimGrep(a:fline, a:lline, a:bang == "!", a:grepAdd, a:vimWild, '
        \ argumentString.')'
endfunction

function! s:GrepBuffers(fline, lline, bang, grepAdd, ...)
  let pat = (a:0 && a:1 != ' ' ? a:1 : '')
  let patArg = pat
  if pat != ''
    let patArg = QuoteStr(pat)
  endif
  let i = 2
  let firstCall = 1
  while 1
    " Break if arguments were given, and we reached the end of the arguments.
    " Don't break if no arguments were given, we need to loop at least once on
    " the current buffer.
    if ! exists('a:{i}') && a:0 > 1
      break
    endif

    let cmd = ''
    if exists('a:{i}')
      let bufNr = (a:{i} =~ '^#\d\+') ? strpart(a:{i}, 1) : bufnr(a:{i})
      if bufNr != -1
        let cmd = 'buf ' . bufNr . '| '
      endif
    endif

    " Doing an exec to avoid passing an empty pattern
    " Do init for the last 
    let lastCall = (a:0 <= 1 || i == a:0)
    exec 'call s:_VimGrep(a:fline, a:lline, a:bang == "!",'.
          \' !firstCall || a:grepAdd, cmd, '.patArg.')'

    let firstCall = 0
    let i = i + 1
    if i > a:0
      break
    endif
  endwhile
  exec MakeArgumentList('argumentList', ' ')
  keepjumps call setline(1, substitute(getline(1), ':.*$', ': GrepBufs ' .
        \ argumentList, ''))
endfunction

function! s:_VimGrep(fline, lline, inverse, grepAdd, vimWild, ...)
  if a:fline == a:lline && a:fline == line('.')
    let fline = '1'
    let lline = '$'
  else
    let fline = a:fline
    let lline = a:lline
  endif
  let prvWinnr = bufwinnr(s:myBufNum)
  let curWinnr = winnr()
  let previewWinSize = 0 " Default
  if a:vimWild ==# 'windo' && prvWinnr != -1
    " We should first close the preview window to avoid getting double
    " counted.
    let previewWinSize = winheight(prvWinnr)
    call CloseWindow(prvWinnr, 1)
  else
    " For bufdo and argdo, it is better to run the command in the preview
    " window, just to avoid dealing with issues such as unsaved buffers.
    call s:OpenGrepPreview(1, 0, previewWinSize)
  endif
  let arg = (a:0 > 0 ? a:1 : '')
  if g:greputilsExpandCurWord
    " Expand <cword> and <cWORD>.
    let arg = substitute(arg, '<cword>\|<cWORD>', '\=expand(submatch(0))', 'g')
  endif
  let cmd = a:vimWild.' '.fline.','.lline.(a:inverse ? 'v' : 'g').
        \ g:greputilsVimGrepSepChar.arg.g:greputilsVimGrepSepChar
  echo cmd
  let _eventignore = &eventignore
  let _hidden = &hidden
  " If selectbuf is installed, then disable MRU list, as otherwise the list
  " would make no sense after running a grep command.
  if exists('g:loaded_selectbuf') && exists('*SBGet')
    " CAUTION: We are accessing the internal state of selectbuf here, and so
    " is very fragile.
    let curMRUoption = SBGet('s:disableMRUlisting')
    call SBSet('s:disableMRUlisting', 1)
    let curDynUpdate = SBGet('s:enableDynUpdate')
    " Optimizes the buffer switching.
    call SBSet('s:enableDynUpdate', 0)
  endif
  try
    set eventignore=all
    set hidden
    call MarkActiveWindow()
    let result = GetVimCmdOutput(cmd.
          \ 'echo (expand("%")==""?"[No File]#".bufnr("%"):expand("%")).'.
          \'":".line(".").": ".getline(".")')
    if v:errmsg != ''
      echohl ErrorMsg | echomsg v:errmsg | echohl None
      return
    endif
  finally
    if exists('g:loaded_selectbuf') && exists('*SBGet')
      call SBSet('s:enableDynUpdate', curDynUpdate )
      call SBSet('s:disableMRUlisting', curMRUoption )
    endif
    call RestoreActiveWindow()
    let &hidden = _hidden
    let &eventignore = _eventignore
    " Switch back to the preview buffer.
    exec 'buffer' s:myBufNum
  endtry
  call s:OpenGrepPreview(0, a:grepAdd, previewWinSize)
  keepjumps silent! $put =result
  keepjumps silent! delete _
  call SilentDelete(',$', '^E486:')
  call SilentDelete(',$', '\d\+ lines, \d\+ characters$')
  call SilentDelete(',$', '\d\+ lines --\d\+%--')
  call SilentDelete(',$', '^$')
  " This either deletes the header or the empty line(first time).
  keepjumps silent! 1delete _
  call s:InitPreviewWindow(a:grepAdd, '', cmd)
endfunction

function! s:IsOpt(arg, cmdType)
  " A short option.
  return a:arg[0] == s:{a:cmdType}OptPrfx && a:arg[1] != s:{a:cmdType}OptPrfx
endfunction

function! s:SubCmdType(cmdType)
  if a:cmdType ==# 'grep'
    if OnMS() && &grepprg =~? '\<findstr\>'
      return 'findstr'
    else
      return 'gnuGrep'
    endif
  else
    return a:cmdType
  endif
endfunction

function! s:GrepCfile(cmd, useBang, ...)
  let curWinNr = winnr()
  if a:0 > 0 && a:1 != '' " Happens for <q-args>
    exec a:cmd.(a:useBang?'!':'') a:1
  else
    let tempFile = tempname()
    let _errorfile = &errorfile
    let _undolevels = &undolevels
    let _cpo = &cpo
    try
      set undolevels=2 " Make sure we can at least undo the below change.
      call SilentSubstitute('^\(\%(\f\| \)\+\)|\(\d\+\)|', '%s//\1:\2:/e')
      silent! 1delete _
      if line('$') == 1 && getline(1) =~ '^\s*$'
        undo | undo
        echo 'Cfile: No results to read'
        return | " No hits.
      endif
      set cpo-=A
      let restoreCwd = 0
      if getcwd() !=# s:prevCwd
        let restoreCwd = 1
        exec 'lcd' s:prevCwd
      endif
      silent! exec 'write' tempFile
      if restoreCwd
        lcd -
      endif
      undo

      if NumberOfWindows() > 1
        wincmd p
      endif
      exec a:cmd.(a:useBang?'!':'') tempFile
    finally
      let &cpo = _cpo
      let &undolevels = _undolevels
      let &errorfile = _errorfile
      call delete(tempFile)
    endtry
  endif
  if winnr() != curWinNr
    wincmd p
    silent! quit
  endif
  if g:greputilsAutoCopen
    cwindow
  endif
endfunction

" type: 0: close, 1: open, -1: toggle
function! s:GWindow(type, size)
  let previewWinNr = bufwinnr(s:myBufNum)
  if previewWinNr != -1 && a:type == 1
    return
  elseif previewWinNr == -1 && a:type == 0
    return
  endif
  let orgBufNr = bufnr('%')
  let orgWinNr = winnr()
  call s:OpenGrepPreview(1, 0, a:size)
  let open = ((a:type == -1) ? (previewWinNr == -1) : a:type)
  if ! open
    call CloseWinNoEa(winnr(), 1)
    if winbufnr(orgWinNr) != orgBufNr
      let orgWinNr = bufwinnr(orgBufNr)
    endif
    if orgWinNr != -1
      exec orgWinNr 'wincmd w'
    endif
  endif
endfunction

function! s:OpenGrepPreview(reopen, grepAdd, size)
  let wasVisible = 0
  let _isf = &isfname
  let _splitbelow = &splitbelow
  set splitbelow
  try
    if s:myBufNum == -1
      " Temporarily modify isfname to avoid treating the name as a pattern.
      set isfname-=\
      set isfname-=[
      if exists('+shellslash')
        call OpenWinNoEa("sp \\\\". escape(s:title, ' '))
      else
        call OpenWinNoEa("sp \\". escape(s:title, ' '))
      endif
      let s:myBufNum = bufnr('%')
    else
      let previewWinNr = bufwinnr(s:myBufNum)
      if previewWinNr == -1
        call OpenWinNoEa('sb '. s:myBufNum)
      else
        let wasVisible = 1
        exec previewWinNr 'wincmd w'
      endif
    endif
  finally
    let &isfname = _isf
    let &splitbelow = _splitbelow
  endtry
  call s:SetupBuf()

  " Resize only if this is not the only window vertically.
  if !IsOnlyVerticalWindow() && !wasVisible
    exec 'resize' ((a:size > 0) ? a:size : 10)
  endif

  if !a:reopen
    if a:grepAdd
      $
      call SaveHardPosition('GrepUtils')
      if g:greputilsPreviewCreateFolds && line('.') > 2 && foldlevel('.') == 0
        " Create fold for the first results.
        silent! 2,.fold
      endif
    elseif ! g:greputilsPreserveAllResults
      let _curText = ''
      if g:greputilsPreserveLastResults
        " FIXME: We need to really save and restore both unnamed and 0
        "   registers, but I didn't find a way to do this, as assigning to
        "   either register modifies both.
        let _unnamed = @"
        let _z = @z
        try
          silent! normal! gg"zyG
          let _curText = @z
        finally
          let @z = _z
          let @" = _unnamed
        endtry
      endif
      call OptClearBuffer()
      if _curText !~ '^\_s*$'
        silent! $put =_curText
        silent! 1delete _
        exec "normal! i\<C-G>u\<Esc>"
        silent! 1,$delete _
      endif
    else
      silent! 1,$delete _
    endif
  endif
endfunction

function! s:SetupBuf()
  call SetupScratchBuffer()
  "setlocal nowrap " It is difficult to see the full line otherwise.
  setlocal bufhidden=hide

  setlocal winfixheight

  command! -buffer -bang -nargs=? Cfile
        \ :call <SID>GrepCfile('cfile', '<bang>' == '!' ? 1 : 0, <q-args>)
  command! -buffer -bang -nargs=? Cgetfile
        \ :call <SID>GrepCfile('cgetfile', '<bang>' == '!' ? 1 : 0, <q-args>)

  if exists('*CmdAlias') && g:loaded_cmdalias >= 101
    call CmdAlias('cfile', 'Cfile', '<buffer>')
    call CmdAlias('cgetfile', 'Cgetfile', '<buffer>')
  endif

  nnoremap <buffer> <silent> <CR> :GG<CR>
  nnoremap <buffer> <silent> <2-LeftMouse> :GG<CR>
  nnoremap <buffer> <silent> <C-N> :GNext<CR>
  nnoremap <buffer> <silent> <C-P> :GPrev<CR>

  hi! def link GrepUtilsPreviewPosition Search
  call s:MarkCcLine()
endfunction

function! s:MarkCcLine()
  silent! syn clear GrepUtilsPreviewPosition
  if s:prevCurHit > 1
    exec 'syn match GrepUtilsPreviewPosition "\%'.s:prevCurHit.'l.*"'
  endif
endfunction

function! s:GNextImpl(forward, cnt)
  let previewWinNr = bufwinnr(s:myBufNum)
  let previewWasVisible = 1
  if previewWinNr == -1
    let previewWasVisible = 0
    call s:OpenGrepPreview(1, 0, 0)
    let previewWinNr = bufwinnr(s:myBufNum)
  elseif winnr() != previewWinNr
    exec previewWinNr 'wincmd w'
  endif
  if a:forward == 0
    " Calculate absolute error.
    let newHit = (a:cnt> 0) ? (a:cnt+1) : line('.')
  else
    " Calculate relative error.
    let newHit = s:prevCurHit + (a:forward * a:cnt)
  endif
  if newHit < 2
    let newHit = 2
  elseif newHit > line('$')
    let newHit = line('$')
  endif
  exec newHit
  let fileName = ''
  let lineNr = 1
  silent! exec substitute(getline('.'), '^\(\%(\f\| \)\+\)|\(\d\+\)|.*',
        \ "let fileName='\\1' | let lineNr='\\2'", '')
  if fileName != ''
    if !filereadable(fileName)
      let fileName = s:prevCwd.((exists('+shellslash') && !&shellslash)?'\':'/')
            \ . fileName
      if !filereadable(fileName)
        if fileName =~# '\[No File\]#\d\+$'
          " Buffer number in this case.
          let fileName = matchstr(fileName, '\d\+$') + 0
        else
          echohl ErrorMsg | echo "Can't read file: " . fileName | echohl NONE
          return
        endif
      endif
    endif

    let s:prevCurHit = newHit
    call s:MarkCcLine()
    if NumberOfWindows() == 1
      if !type(fileName) " If buffer number
        split
        exec 'buffer' fileName
        exec lineNr
      else
        exec 'split +'.lineNr fileName
      endif
    else
      let winnr = bufwinnr(fileName)
      let v:errmsg = ''
      if winnr != -1
        exec winnr.'wincmd w'
      else
        if &switchbuf ==# 'split'
          split
        else
          wincmd p
          if winnr() == previewWinNr
            split
          endif
        endif
        if !type(fileName) " If buffer number
          exec 'buffer' fileName
        else
          exec 'edit' fileName
        endif
      endif
      if v:errmsg == ''
        exec lineNr
      endif
    endif
  endif
  if ! previewWasVisible
    call CloseWindow(previewWinNr, 1)
  endif
endfunction

" You can pass an optional filter.
function! s:GrepSet(cmdType, preview, filterArgs)
  " So that they can be restored later.
  let s:savedGrepprg = &grepprg
  let s:savedShellpipe = &shellpipe
  let s:savedShellredir = &shellredir

  if s:{a:cmdType}CmdExpr != ''
    let &grepprg = s:EvalExpr(s:{a:cmdType}CmdExpr)
  endif
  let filterCmd = ''
  if a:filterArgs != ''
    call MvIterCreate(a:filterArgs, '+f', 'GrepSet')
    while MvIterHasNext('GrepSet')
      let filterCmd = filterCmd . '| ' .
            \ EscapeCommand(g:greputilsFiltercmd, MvIterNext('GrepSet'), '')
      let filterCmd = Escape(filterCmd, '%#!')
    endwhile
    call MvIterDestroy('GrepSet')
  endif
  " We assume that the existing value of these settings is set such that the
  "   redirection happens for both stdout and stderr.
  if a:preview
    let &shellredir = filterCmd . ' ' . &shellredir
  else
    let &shellpipe = filterCmd . ' ' . &shellpipe
  endif
endfunction

function! s:EvalExpr(expr)
  exec 'let result = '.a:expr
  return result
endfunction

function! s:GrepReset()
  if exists("s:savedGrepprg")
    let &grepprg=s:savedGrepprg
    "unlet s:savedGrepprg
  endif
  if exists("s:savedShellpipe")
    let &shellpipe=s:savedShellpipe
    "unlet s:savedShellpipe
  endif
  if exists("s:savedShellredir")
    let &shellredir=s:savedShellredir
    "unlet s:savedShellredir
  endif
endfunction

function! s:RegisterQuickfixBuf(bufNr)
  " First wipeout any already registered buffers, if they are not visible
  "   anywhere.
  if s:curQuickFixBufs != ''
    " A simple optimization for detecting :colder and :cnewer cases.
    if s:curQuickFixBufs =~ '^\d\+\s*$' && a:bufNr == (s:curQuickFixBufs + 0)
      return
    endif
    let s:undeletedBufs = ''
    call MvIterCreate(s:curQuickFixBufs, ' ', 'RegisterQuickfixBuf')
    while MvIterHasNext('RegisterQuickfixBuf')
      let bufNr = MvIterNext('RegisterQuickfixBuf') + 0
      if bufwinnr(bufNr) == -1
        silent! exec 'bwipeout' bufNr
      else
        let s:undeletedBufs = MvAddElement(s:undeletedBufs, ' ', bufNr)
      endif
    endwhile
    call MvIterDestroy('RegisterQuickfixBuf')
    let s:curQuickFixBufs = s:undeletedBufs
  endif

  let s:curQuickFixBufs = MvAddElement(s:curQuickFixBufs, ' ', a:bufNr)
endfunction

" Restore cpo.
let &cpo = s:save_cpo
unlet s:save_cpo

" vim6:fdm=marker sw=2 et
