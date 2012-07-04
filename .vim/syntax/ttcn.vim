" Vim syntax file
"
" Language:     TTCN-3
" Maintainer:   Stefan Karlsson <stefan.74@comhem.se>
" Last Change:  10 August 2005
"
" This file is based on the ETSI standard ES201873-1 v2.2.1. Please let me know
" of any bugs or other problems you run across.


if exists("b:current_syntax")
  finish
endif

if exists("g:ttcn_minlines")
  exec "syn sync minlines=" . g:ttcn_minlines
else
  syn sync fromstart
endif

" Automatically define folds. You enable this feature with :let ttcn_fold=1. 
if exists("g:ttcn_fold") && g:ttcn_fold == 1
  syn region ttcnFold start="{" end="}" transparent fold
endif

" Built-in types
syn keyword ttcnType    address anytype boolean char default float integer
syn keyword ttcnType    objid verdicttype timer set record union
syn keyword ttcnType    enumerated component port of
syn match   ttcnType    "\<\(char\|bit\|hex\|octet\)string\>"
syn match   ttcnError   "\<universal\>"
syn match   ttcnType    "\<universal\s\+char\(string\)\?\>"

" Type definitions
syn keyword ttcnTypDef  type message procedure mixed 

" Storage classes
syn keyword ttcnStore   var const external

" Module, import and group stuff
syn keyword ttcnModule  module modulepar group
syn match   ttcnError   "\<import\>"
syn match   ttcnModule  "\<import\s\+from\>"

" Attributes
syn keyword ttcnAttrib  with display encode extension variant 

" Operators
syn keyword ttcnOper    mod rem not and or xor not4b and4b or4b xor4b
syn keyword ttcnOper    complement pattern match valueof self mtc read
syn keyword ttcnOper    activate create running system subset superset  
syn keyword ttcnOper    getverdict
syn match   ttcnOper    "[-+*/?]"
syn match   ttcnOper    "[<>]"
syn match   ttcnError   "="
syn match   ttcnoper    "[=!><]="
syn match   ttcnOper    "\(<[<@]\)\|\([>@]>\)"
syn match   ttcnOper    "&"
syn match   ttcnError   "&&\+"hs=s+1
syn match   ttcnOper    "\.\."
syn match   ttcnError   "\.\.\.\+"hs=s+2

" Statements
syn keyword ttcnCond    if else
syn keyword ttcnRepeat  for while do repeat
syn keyword ttcnStat    log stop alt interleave deactivate connect
syn keyword ttcnStat    disconnect map unmap start done send call reply
syn keyword ttcnStat    receive trigger getcall getreply check clear
syn keyword ttcnStat    timeout setverdict
syn keyword ttcnStat    action execute return goto
syn keyword ttcnLabel   label
syn keyword ttcnExcept  raise catch
syn match   ttcnstat    "->"
syn match   ttcnStat    ":="
syn keyword ttcnContr   control
syn match   ttcnError   "\<verdict.\(set\|get\)"
syn keyword ttcnStat    function testcase signature noblock exception
syn keyword ttcnStat    altstep template
syn match   ttcnError   "\<runs\>"
syn match   ttcnError   "\<on\>"
syn match   ttcnStat    "\<runs\s\+on\>"

" Predefined functions
syn keyword ttcnFunc    int2char int2unichar int2bit int2hex int2oct
syn keyword ttcnFunc    int2str int2float float2int char2int unichar2int
syn keyword ttcnFunc    bit2int bit2hex bit2oct bit2str hex2int hex2bit
syn keyword ttcnFunc    hex2oct hex2str oct2int oct2bit oct2str str2int
syn keyword ttcnFunc    str2oct lengthof sizeof ispresent ischosen regexp
syn keyword ttcnFunc    substr rnd

" Various keywords
syn keyword ttcnKeyw    in out inout any all sender to value modifies
syn keyword ttcnKeyw    nowait param length recursive except optional 
syn keyword ttcnKeyw    ifpresent language override
syn match   ttcnKeyw    "\<from\>"

" Literals
syn match   ttcnError   "\_^0\d\+"he=s+1
syn match   ttcnError   "\(\s\|\t\)0\d\+"hs=s+1,he=s+2
syn match   ttcnNumber  "\<\(0\|\([1-9]\d*\)\)\>"
syn match   ttcnNumber  "\<\(0\|\([1-9]\d*\)\)\.\d\+\>"
syn match   ttcnNumber  "\<\(0\|\([1-9]\d*\)\)\(\.\d\+\)\?E-\?[1-9]\d*\>"
syn match   ttcnNumber  "[^a-zA-Z0-9_]\@<=[+-]\d"hs=e-1,he=e-1,me=e-1
syn match   ttcnNumber  "\<infinity\>"
syn match   ttcnNumber  "-infinity\>"
syn keyword ttcnBool    true false
syn keyword ttcnConst   omit null pass fail inconc none error
syn region  ttcnString  start=/"/ end=/"/ skip=/""/ oneline
syn match   ttcnString  /'[01]\+'B/
syn match   ttcnString  /'\x\+'H/
syn match   ttcnString  /'\(\x\x\)\+'O/

" Comments 
if version < 700 
  syn match   ttcnCmnt    "//.*" contains=ttcnTodo
  syn region  ttcnCmnt    start="/\*" end="\*/" contains=ttcnTodo
else
  syn match   ttcnCmnt    "//.*" contains=ttcnTodo,@Spell
  syn region  ttcnCmnt    start="/\*" end="\*/" contains=ttcnTodo,@Spell
endif

syn case ignore
syn keyword ttcnTodo    xxx todo fixme contained
syn case match


" Link our groups to Vim's predefined groups
if version >= 508 || !exists("g:did_ttcn_syn_inits")

  if version < 508
    let g:did_ttcn_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink ttcnAttrib PreProc
  HiLink ttcnBool   Boolean
  HiLink ttcnConst  Constant
  HiLink ttcnCmnt   Comment
  HiLink ttcnCond   Conditional
  HiLink ttcnContr  Special
  HiLink ttcnDecl   Statement
  HiLink ttcnError  Error
  HiLink ttcnExcept Exception
  HiLink ttcnFunc   Function
  HiLink ttcnKeyw   Keyword
  HiLink ttcnLabel  Label
  HiLink ttcnModule PreProc
  HiLink ttcnNumber Number
  HiLink ttcnOper   Operator
  HiLink ttcnRepeat Repeat
  HiLink ttcnStat   Statement
  HiLink ttcnStore  StorageClass
  HiLink ttcnString String
  HiLink ttcnTodo   Todo
  HiLink ttcnType   Type
  HiLink ttcnTypDef TypeDef

  delcommand HiLink

endif


let b:current_syntax = "ttcn"

