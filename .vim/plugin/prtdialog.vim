"*****************************************************************************
"** Name:      prtdialog.vim - simplifies printing of text                  **
"**                                                                         **
"** Type:      global VIM plugin                                            **
"**                                                                         **
"** Author:    Christian Habermann                                          **
"**            christian (at) habermann-net (point) de                      **
"**                                                                         **
"** Copyright: (c) 2002 by Christian Habermann                              **
"**                                                                         **
"** License:   GNU General Public License 2 (GPL 2) or later                **
"**                                                                         **
"**            This program is free software; you can redistribute it       **
"**            and/or modify it under the terms of the GNU General Public   **
"**            License as published by the Free Software Foundation; either **
"**            version 2 of the License, or (at your option) any later      **
"**            version.                                                     **
"**                                                                         **
"**            This program is distributed in the hope that it will be      **
"**            useful, but WITHOUT ANY WARRANTY; without even the implied   **
"**            warrenty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      **
"**            PURPOSE.                                                     **
"**            See the GNU General Public License for more details.         **
"**                                                                         **
"** Version:   1.0.0                                                        **
"**            tested under Linux (vim 6.1, gvim 6.1) and Win32 (gvim 6.1)  **
"**                                                                         **
"** History:   1.0.0  12. Dez. 2002                                         **
"**              identical to 0.1.0, but first release                      **
"**                                                                         **
"**            0.1.0  1. Dez. 2002 - 12. Dez. 2002                          **
"**              initial version, not released                              **
"**                                                                         **
"**                                                                         **
"*****************************************************************************
"** Description:                                                            **
"**   This script's intention is to simplify printing of text. It provides  **
"**   a dialog to make many many printer settings before starting to print. **
"**   To invoke this dialog, press <Leader>pd.                              **
"**                                                                         **
"**   For futher informations see prtdialog.txt or do :help prtdialog       **
"**                                                                         **
"**                                                                         **
"**   Happy viming...                                                       **
"*****************************************************************************

" allow user to avoid loading this plugin and prevent loading twice
if exists ("loaded_prtdialog")
    finish
endif

let loaded_prtdialog = 1




"*****************************************************************************
"************************** C O N F I G U R A T I O N ************************
"*****************************************************************************

" the mappings:
if !hasmapto('<Plug>PRD_PrinterDialogVisual')
    vmap <silent> <unique> <Leader>pd <Plug>PRD_PrinterDialogVisual
endif

if !hasmapto('<Plug>PRD_PrinterDialogNormal')
    nmap <silent> <unique> <Leader>pd <Plug>PRD_PrinterDialogNormal
endif

vmap <silent> <unique> <script> <Plug>PRD_PrinterDialogVisual <ESC>:call <SID>PRD_StartPrinterDialog(0)<CR>
nmap <silent> <unique> <script> <Plug>PRD_PrinterDialogNormal      :call <SID>PRD_StartPrinterDialog(1)<CR>


if !exists('g:prd_prtDeviceList')
    let g:prd_prtDeviceList = "standard"
endif
if !exists('g:prd_prtDeviceIdx')
    let g:prd_prtDeviceIdx  = 1
endif

if !exists('g:prd_fontList')
    let g:prd_fontList      = "courier:h6,courier:h8,courier:h10,courier:h12,courier:h14"
endif
if !exists('g:prd_fontIdx')
    let g:prd_fontIdx       = 2
endif

if !exists('g:prd_paperList')
    let g:prd_paperList     = "A3,A4,A5,B4,B5,legal,letter"
endif
if !exists('g:prd_paperIdx')
    let g:prd_paperIdx      = 2
endif

if !exists('g:prd_portraitList')
    let g:prd_portraitList  = "yes,no"
endif
if !exists('g:prd_portraitIdx')
    let g:prd_portraitIdx   = 1
endif

if !exists('g:prd_headerList')
    let g:prd_headerList    = "0,1,2,3,4,5,6"
endif
if !exists('g:prd_headerIdx')
    let g:prd_headerIdx     = 3
endif

if !exists('g:prd_lineNrList')
    let g:prd_lineNrList    = "yes,no"
endif
if !exists('g:prd_lineNrIdx')
    let g:prd_lineNrIdx     = 1
endif

if !exists('g:prd_syntaxList')
    let g:prd_syntaxList    = "no,current,default,print_bw,zellner"
endif
if !exists('g:prd_syntaxIdx')
    let g:prd_syntaxIdx     = 3
endif

if !exists('g:prd_wrapList')
    let g:prd_wrapList      = "yes,no"
endif
if !exists('g:prd_wrapIdx')
    let g:prd_wrapIdx       = 1
endif

if !exists('g:prd_duplexList')
    let g:prd_duplexList    = "off,long,short"
endif
if !exists('g:prd_duplexIdx')
    let g:prd_duplexIdx     = 2
endif

if !exists('g:prd_collateList')
    let g:prd_collateList   = "yes,no"
endif
if !exists('g:prd_collateIdx')
    let g:prd_collateIdx    = 1
endif

if !exists('g:prd_jobSplitList')
    let g:prd_jobSplitList  = "yes,no"
endif
if !exists('g:prd_jobSplitIdx')
    let g:prd_jobSplitIdx   = 2
endif

if !exists('g:prd_leftList')
    let g:prd_leftList      = "5mm,10mm,15mm,20mm,25mm"
endif
if !exists('g:prd_leftIdx')
    let g:prd_leftIdx       = 3
endif

if !exists('g:prd_rightList')
    let g:prd_rightList     = "5mm,10mm,15mm,20mm,25mm"
endif
if !exists('g:prd_rightIdx')
    let g:prd_rightIdx      = 3
endif

if !exists('g:prd_topList')
    let g:prd_topList       = "5mm,10mm,15mm,20mm,25mm"
endif
if !exists('g:prd_topIdx')
    let g:prd_topIdx        = 2
endif

if !exists('g:prd_bottomList')
    let g:prd_bottomList    = "5mm,10mm,15mm,20mm,25mm"
endif
if !exists('g:prd_bottomIdx')
    let g:prd_bottomIdx     = 2
endif

if !exists('g:prd_dialogList')
    let g:prd_dialogList    = "yes,no"
endif
if !exists('g:prd_dialogIdx')
    let g:prd_dialogIdx     = 2
endif


" allow user to set a script specific printheader
if !exists('g:prd_printheader')
    let g:prd_printheader = &printheader
endif



"*****************************************************************************
"************************* I N I T I A L I S A T I O N ***********************
"*****************************************************************************

  " used to print/echo name of script
let s:scriptName   = "PrtDialog"

  " delimiter for list-elements (g:prd_...List)
let s:chrDelimiter = ","

  " colorscheme loaded for printing?
let s:flagColorschemeDone = 0



"*****************************************************************************
"****************** I N T E R F A C E  T O  C O R E **************************
"*****************************************************************************

"*****************************************************************************
"** input:   whatToPrint: 0:    selected range                              **
"**                       else: whole buffer                                **
"** output:   0: ok                                                         **
"**          <0: error                                                      **
"*****************************************************************************
"** remarks:                                                                **
"**   Get range to be printed and buffer. Then start user-interface.        **
"*****************************************************************************
function <SID>PRD_StartPrinterDialog(whatToPrint)

    if (!has('printer'))         " is this VIM compiled with printing enabled?
        call s:Error(3)
        return
    endif

    let s:whatToPrint = a:whatToPrint

    if (s:whatToPrint == 0)             " get range to be printed
        let s:startLine = line("'<")
        let s:endLine   = line("'>")
    else
        let s:startLine = 1
        let s:endLine   = line("$")
    endif

    let s:bufferUser = -1               " up to now no buffer for user-interface
    let s:bufferSrc  = winbufnr(0)      " get buffer to be printed

    call s:GetNumberOfListElements()    " count for each g:prd_...List number of elements

                                        " setup user-interface
    if (s:OpenNewBuffer() != -1)           " get buffer for user-interface
        call s:UpdateDialog()              " show the dialog
        call s:SetLocalKeyMappings()       " and set keys for user (lokal to buffer)
    endif

endfunction





"*****************************************************************************
"************************ C O R E  F U N C T I O N S *************************
"*****************************************************************************


"*****************************************************************************
"** input:   none                                                           **
"** output:   0: ok                                                         **
"**          <0: error                                                      **
"*****************************************************************************
"** remarks:                                                                **
"**   Open a new buffer for user interaction.                               **
"**                                                                         **
"*****************************************************************************
function s:OpenNewBuffer()

    execute "enew"

    let s:bufferUser = winbufnr(0)

    " if new buffer is the same as source buffer for printing then
    " we have no buffer to be printed
    if (s:bufferUser == s:bufferSrc)
        call s:prd_Exit()
        call s:Error(1)
        return -1
    endif

    " buffer specific settings:
    "   - nomodifiable:     don't allow to edit this buffer
    "   - noswapfile:       we don't need a swapfile
    "   - buftype=nowrite:  buffer will not be written
    "   - bufhidden=delete: delete this buffer if it will be hidden
    "   - nowrap:           don't wrap around long lines
    "   - iabclear:         no abbreviations in insert mode
    setlocal nomodifiable
    setlocal noswapfile
    setlocal buftype=nowrite
    setlocal bufhidden=delete
    setlocal nowrap
    iabclear <buffer>

    return 0
endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**                                                                         **
"*****************************************************************************
function s:UpdateDialog()

    " get name of buffer to be printed
    let strFilename = bufname(s:bufferSrc)
    if (strFilename == "")
        let strFilename = "[noname]"
    endif

    " get range of buffer to be printed
    if  (s:whatToPrint == 0)
        let strRange = "lines " . s:startLine . " - " . s:endLine
    else
        let strRange = "whole file"
    endif


    " init syntax-highlighting of user-interface
    call s:SetupSyntax()


    setlocal modifiable


    " delete all lines
    %delete

    " column of parameter
    let s:colPara = 14
    let s:lnNr    =  0

    let s:txt  =              "\"     Printer Dialog\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "\"    ================\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "\"\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "\"      p : start printing\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "\"      q : cancel\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "\"    Tab : toggle to next\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "\"  S-Tab : toggle to previous\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "\"      ? : help on parameter\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "\"          :help printer-dialog  for detailed help\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      ">File-Info:\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "   Name:      " . strFilename . "\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "   Range:     " . strRange    . "\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      ">Printer:    <" . s:GetElementOutOfList(g:prd_prtDeviceList, g:prd_prtDeviceIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnPrtDev = s:lnNr
    let s:txt  = s:txt .      "\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      ">Options:\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "   Font:     <" . s:GetElementOutOfList(g:prd_fontList, g:prd_fontIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnFont = s:lnNr
    let s:txt  = s:txt .      "   Paper:    <" . s:GetElementOutOfList(g:prd_paperList, g:prd_paperIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnPaper = s:lnNr
    let s:txt  = s:txt .      "   Portrait: <" . s:GetElementOutOfList(g:prd_portraitList, g:prd_portraitIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnPortrait = s:lnNr
    let s:txt  = s:txt .      "\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "   Header:   <" . s:GetElementOutOfList(g:prd_headerList, g:prd_headerIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnHeader = s:lnNr
    let s:txt  = s:txt .      "   Line-Nr:  <" . s:GetElementOutOfList(g:prd_lineNrList, g:prd_lineNrIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnLineNr = s:lnNr
    let s:txt  = s:txt .      "   Syntax:   <" . s:GetElementOutOfList(g:prd_syntaxList, g:prd_syntaxIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnSyntax = s:lnNr
    let s:txt  = s:txt .      "\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "   Wrap:     <" . s:GetElementOutOfList(g:prd_wrapList, g:prd_wrapIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnWrap = s:lnNr
    let s:txt  = s:txt .      "   Duplex:   <" . s:GetElementOutOfList(g:prd_duplexList, g:prd_duplexIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnDuplex = s:lnNr
    let s:txt  = s:txt .      "   Collate:  <" . s:GetElementOutOfList(g:prd_collateList, g:prd_collateIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnCollate = s:lnNr
    let s:txt  = s:txt .      "   JobSplit: <" . s:GetElementOutOfList(g:prd_jobSplitList, g:prd_jobSplitIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnJobSplit = s:lnNr
    let s:txt  = s:txt .      "\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "   Left:     <" . s:GetElementOutOfList(g:prd_leftList, g:prd_leftIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnLeft = s:lnNr
    let s:txt  = s:txt .      "   Right:    <" . s:GetElementOutOfList(g:prd_rightList, g:prd_rightIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnRight = s:lnNr
    let s:txt  = s:txt .      "   Top:      <" . s:GetElementOutOfList(g:prd_topList, g:prd_topIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnTop = s:lnNr
    let s:txt  = s:txt .      "   Bottom:   <" . s:GetElementOutOfList(g:prd_bottomList, g:prd_bottomIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnBottom = s:lnNr
    let s:txt  = s:txt .      "\n"
    let s:lnNr = s:lnNr + 1
    let s:txt  = s:txt .      "   Dialog:   <" . s:GetElementOutOfList(g:prd_dialogList, g:prd_dialogIdx) . ">\n"
    let s:lnNr = s:lnNr + 1
    let s:lnDialog = s:lnNr

    put! = s:txt

    setlocal nomodifiable

endfunction




"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   set syntax-highlighting for user-interface (if VIM has 'syntax')      **
"*****************************************************************************
function s:SetupSyntax()

    " don't continue, if this version of VIM does not support syntax-highlighting
    if !has('syntax')
        return
    endif

    syntax match prdHeadline ">.*:"
    syntax match prdParameter "<.*>"
    syntax match prdComment   "^\".*"

    if !exists('g:prd_syntaxUIinit')
        let g:prd_syntaxUIinit = 0

        hi def link prdParameter Special
        hi def link prdHeadline  String
        hi def link prdComment   Comment
    endif

endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   set local/temporally key-mappings valid for this buffer only          **
"*****************************************************************************
function s:SetLocalKeyMappings()

    nnoremap <buffer> <silent> q       :call <SID>prd_Exit()<cr>
    nnoremap <buffer> <silent> p       :call <SID>prd_StartPrinting()<cr>
    nnoremap <buffer> <silent> <Tab>   :call <SID>prd_ToggleParameter(1)<cr>
    nnoremap <buffer> <silent> <S-Tab> :call <SID>prd_ToggleParameter(-1)<cr>
    nnoremap <buffer> <silent> ?       :call <SID>prd_ShowHelpOnParameter()<cr>

endfunction



"*****************************************************************************
"** input:   strList: list of elements separated with 'chrDilimiter'        **
"**          nIdx:    which element in list (1...number of elements)        **
"** output:  element of list                                                **
"*****************************************************************************
"** remarks:                                                                **
"**   This function returns the n-th element out of a list in which         **
"**   the elements a separatet with a charachter 'chrDilimiter'.            **
"**                                                                         **
"**   Return empty string, if either list is empty, of index does not       **
"**   exist.                                                                **
"**                                                                         **
"*****************************************************************************
function s:GetElementOutOfList(strList, nIdx)
    let idx = 1

    let posStart = 0      " position and lenght of element-string
    let posEnd   = 0

    " search start of element
    while (idx < a:nIdx)          " loop forever
        let posMatch = match(a:strList, s:chrDelimiter, posStart)
        if (posMatch < 0)         " delimiter found? no, then we have only one element
            break
        endif
        let posStart = posMatch + 1
        let idx      = idx + 1
    endwhile

    " get end of element
    let posEnd = match(a:strList, s:chrDelimiter, posStart)

    if (posEnd >= 0)             " are there further elements in list?
        let posEnd = posEnd - 1  " yes, then end of element is position of delimiter - 1
    else                         " no further elements in list
        let posEnd = strlen(a:strList) - 1
    endif

    let element = strpart(a:strList, posStart, posEnd - posStart + 1)

    return element
endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   For each list (sgr_xyzList) get the number of elements. With this     **
"**   information it is easier to handle wrap around when toggling to       **
"**   next/previous element.                                                **
"*****************************************************************************
function s:GetNumberOfListElements()

    let s:prtDeviceMaxIdx = s:GetMaxIdxOfList (g:prd_prtDeviceList)

    let s:fontMaxIdx      = s:GetMaxIdxOfList (g:prd_fontList)

    let s:paperMaxIdx     = s:GetMaxIdxOfList(g:prd_paperList)

    let s:portraitMaxIdx  = s:GetMaxIdxOfList(g:prd_portraitList)

    let s:headerMaxIdx    = s:GetMaxIdxOfList(g:prd_headerList)

    let s:lineNrMaxIdx    = s:GetMaxIdxOfList(g:prd_lineNrList)

    let s:syntaxMaxIdx    = s:GetMaxIdxOfList(g:prd_syntaxList)

    let s:wrapMaxIdx      = s:GetMaxIdxOfList(g:prd_wrapList)

    let s:duplexMaxIdx    = s:GetMaxIdxOfList(g:prd_duplexList)

    let s:collateMaxIdx   = s:GetMaxIdxOfList(g:prd_collateList)

    let s:jobSplitMaxIdx  = s:GetMaxIdxOfList(g:prd_jobSplitList)

    let s:leftMaxIdx      = s:GetMaxIdxOfList(g:prd_leftList)

    let s:rightMaxIdx     = s:GetMaxIdxOfList(g:prd_rightList)

    let s:topMaxIdx       = s:GetMaxIdxOfList(g:prd_topList)

    let s:bottomMaxIdx    = s:GetMaxIdxOfList(g:prd_bottomList)

    let s:dialogMaxIdx    = s:GetMaxIdxOfList(g:prd_dialogList)

endfunction



"*****************************************************************************
"** input:   list: string with elements                                     **
"** output:  >0: number of elements in this list                            **
"**                                                                         **
"*****************************************************************************
"** remarks:                                                                **
"**   Get the number of elements. The elements in the string must be        **
"**   separated with character 'chrDelimiter'.                              **
"**   If string is empty, 1 will be returned.                               **
"*****************************************************************************
function s:GetMaxIdxOfList(strList)

    let numOfElements = 1     " we always have at least one element
    let pos = 0

    " search string for delimiter
    while (1 == 1)            " loop forever
        let pos = match(a:strList, s:chrDelimiter, pos)

        if (pos >= 0)         " delimiter found? yes, then we have a new element
            let numOfElements = numOfElements + 1
        else
            break             " no further delimiter, so we finished
        endif

        let pos = pos + 1     " start searching at next charachter of string
    endwhile

    return numOfElements
endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   set 'printdevice' according to user's selection                       **
"**   standard means empty string ""                                        **
"*****************************************************************************
function s:SetPrintdevice()
    let element = s:GetElementOutOfList(g:prd_prtDeviceList, g:prd_prtDeviceIdx)

    if (tolower(element) == "standard")
        let &printdevice = ""
    else
        let &printdevice = element
    endif
endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   set 'printoptions' according to user's selections                     **
"**                                                                         **
"*****************************************************************************
function s:SetPrintoptions()

    let &printoptions =   "left:"     .         s:GetElementOutOfList(g:prd_leftList,     g:prd_leftIdx    )        . ","
                        \."right:"    .         s:GetElementOutOfList(g:prd_rightList,    g:prd_rightIdx   )        . ","
                        \."top:"      .         s:GetElementOutOfList(g:prd_topList,      g:prd_topIdx     )        . ","
                        \."bottom:"   .         s:GetElementOutOfList(g:prd_bottomList,   g:prd_bottomIdx  )        . ","
                        \."header:"   .         s:GetElementOutOfList(g:prd_headerList,   g:prd_headerIdx  )        . ","
                        \."duplex:"   .         s:GetElementOutOfList(g:prd_duplexList,   g:prd_duplexIdx  )        . ","
                        \."paper:"    .         s:GetElementOutOfList(g:prd_paperList,    g:prd_paperIdx   )        . ","
                        \."number:"   . strpart(s:GetElementOutOfList(g:prd_lineNrList,   g:prd_lineNrIdx  ), 0, 1) . ","
                        \."wrap:"     . strpart(s:GetElementOutOfList(g:prd_wrapList,     g:prd_wrapIdx    ), 0, 1) . ","
                        \."collate:"  . strpart(s:GetElementOutOfList(g:prd_collateList,  g:prd_collateIdx ), 0, 1) . ","
                        \."jobSplit:" . strpart(s:GetElementOutOfList(g:prd_jobSplitList, g:prd_jobSplitIdx), 0, 1) . ","
                        \."portrait:" . strpart(s:GetElementOutOfList(g:prd_portraitList, g:prd_portraitIdx), 0, 1)

    if has('syntax')
        if (s:GetElementOutOfList(g:prd_syntaxList, g:prd_syntaxIdx) == "no")
            let &printoptions = &printoptions . ",syntax:n"
        else
            let &printoptions = &printoptions . ",syntax:y"
        endif
    endif

endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   set printfont                                                         **
"*****************************************************************************
function s:SetPrintfont()

    let &printfont = s:GetElementOutOfList(g:prd_fontList, g:prd_fontIdx)

endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   set printheader                                                       **
"*****************************************************************************
function s:SetPrintheader()

    let &printheader = g:prd_printheader

endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   Set colorscheme used for printing according to user's selections      **
"**   done for this print job.                                              **
"**   Possible values:                                                      **
"**     "no":      don't use syntax-highlighting for printing               **
"**     "current": don't change colorscheme, take acutal one for printing   **
"**     else:      name of colorscheme to be used                           **
"**   If "no" or "current" don't change colorscheme, else load selected     **
"**   one.                                                                  **
"**                                                                         **
"*****************************************************************************
function s:SetColorschemeForPrinting()

    let s:flagColorschemeDone = 0

    if has('syntax')
        let element = s:GetElementOutOfList(g:prd_syntaxList, g:prd_syntaxIdx)

        if ( (tolower(element) != "no") && (tolower(element) != "current") )
            let s:flagColorschemeDone = 1

            let cmdSetColorScheme = "colorscheme ".element
            execute(cmdSetColorScheme)
        endif
    endif

endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   backup:                                                               **
"**     - printer configuration                                             **
"**     - currently used colorscheme                                        **
"*****************************************************************************
function s:BackupSettings()

    let s:backupPrintdevice  = &printdevice
    let s:backupPrintoptions = &printoptions
    let s:backupPrintfont    = &printfont
    let s:backupPrintheader  = &printheader

    if has('syntax')
        if exists('g:colors_name')
            let s:backupColorscheme = g:colors_name
        else
            let s:backupColorscheme = "default"
        endif
    endif

endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   restore:                                                              **
"**     - printer configuration                                             **
"**     - colorscheme for syntax-highlighting                               **
"*****************************************************************************
function s:RestoreSettings()

    let &printdevice  = s:backupPrintdevice
    let &printoptions = s:backupPrintoptions
    let &printfont    = s:backupPrintfont
    let &printheader  = s:backupPrintheader

    if has('syntax')
        " did we load a colorscheme within this script?
        " then we have to restore
        if (s:flagColorschemeDone == 1)
            execute("colorscheme " . s:backupColorscheme)
        endif
    endif

endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   exit this script:                                                     **
"**     - close buffer of user-interface if there is one                    **
"*****************************************************************************
function <SID>prd_Exit()

    execute("buffer " . s:bufferSrc)

endfunction



"*****************************************************************************
"** input:   step: direction to toggle                                      **
"**                 1: next element                                         **
"**                -1: previous element                                     **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   Toggle parameter under cursor to next/previous value.                 **
"**   This is done by inc./decreasing the actual index.                     **
"*****************************************************************************
function <SID>prd_ToggleParameter(step)
    let list = ""
    let idx  = 0

    let lineNr = line(".")


    " switch parameter under cursor to next/previous element in list
    " handle wrap around
    if (lineNr == s:lnPrtDev)
        let g:prd_prtDeviceIdx = g:prd_prtDeviceIdx + a:step
        if (g:prd_prtDeviceIdx > s:prtDeviceMaxIdx)
            let g:prd_prtDeviceIdx = 1
        elseif (g:prd_prtDeviceIdx < 1)
            let g:prd_prtDeviceIdx = s:prtDeviceMaxIdx
        endif
        let list = g:prd_prtDeviceList
        let idx  = g:prd_prtDeviceIdx
    elseif (lineNr == s:lnFont)
        let g:prd_fontIdx = g:prd_fontIdx + a:step
        if (g:prd_fontIdx > s:fontMaxIdx)
            let g:prd_fontIdx = 1
        elseif (g:prd_fontIdx < 1)
            let g:prd_fontIdx = s:fontMaxIdx
        endif
        let list = g:prd_fontList
        let idx  = g:prd_fontIdx
    elseif (lineNr == s:lnPaper)
        let g:prd_paperIdx = g:prd_paperIdx + a:step
        if (g:prd_paperIdx > s:paperMaxIdx)
            let g:prd_paperIdx = 1
        elseif (g:prd_paperIdx < 1)
            let g:prd_paperIdx = s:paperMaxIdx
        endif
        let list = g:prd_paperList
        let idx  = g:prd_paperIdx
    elseif (lineNr == s:lnPortrait)
        let g:prd_portraitIdx = g:prd_portraitIdx + a:step
        if (g:prd_portraitIdx > s:portraitMaxIdx)
            let g:prd_portraitIdx = 1
        elseif (g:prd_portraitIdx < 1)
            let g:prd_portraitIdx = s:portraitMaxIdx
        endif
        let list = g:prd_portraitList
        let idx  = g:prd_portraitIdx
    elseif (lineNr == s:lnHeader)
        let g:prd_headerIdx = g:prd_headerIdx + a:step
        if (g:prd_headerIdx > s:headerMaxIdx)
            let g:prd_headerIdx = 1
        elseif (g:prd_headerIdx < 1)
            let g:prd_headerIdx = s:headerMaxIdx
        endif
        let list = g:prd_headerList
        let idx  = g:prd_headerIdx
    elseif (lineNr == s:lnLineNr)
        let g:prd_lineNrIdx = g:prd_lineNrIdx + a:step
        if (g:prd_lineNrIdx > s:lineNrMaxIdx)
            let g:prd_lineNrIdx = 1
        elseif (g:prd_lineNrIdx < 1)
            let g:prd_lineNrIdx = s:lineNrMaxIdx
        endif
        let list = g:prd_lineNrList
        let idx  = g:prd_lineNrIdx
    elseif (lineNr == s:lnSyntax)
        let g:prd_syntaxIdx = g:prd_syntaxIdx + a:step
        if (g:prd_syntaxIdx > s:syntaxMaxIdx)
            let g:prd_syntaxIdx = 1
        elseif (g:prd_syntaxIdx < 1)
            let g:prd_syntaxIdx = s:syntaxMaxIdx
        endif
        let list = g:prd_syntaxList
        let idx  = g:prd_syntaxIdx
    elseif (lineNr == s:lnWrap)
        let g:prd_wrapIdx = g:prd_wrapIdx + a:step
        if (g:prd_wrapIdx > s:wrapMaxIdx)
            let g:prd_wrapIdx = 1
        elseif (g:prd_wrapIdx < 1)
            let g:prd_wrapIdx = s:wrapMaxIdx
        endif
        let list = g:prd_wrapList
        let idx  = g:prd_wrapIdx
    elseif (lineNr == s:lnDuplex)
        let g:prd_duplexIdx = g:prd_duplexIdx + a:step
        if (g:prd_duplexIdx > s:duplexMaxIdx)
            let g:prd_duplexIdx = 1
        elseif (g:prd_duplexIdx < 1)
            let g:prd_duplexIdx = s:duplexMaxIdx
        endif
        let list = g:prd_duplexList
        let idx  = g:prd_duplexIdx
    elseif (lineNr == s:lnCollate)
        let g:prd_collateIdx = g:prd_collateIdx + a:step
        if (g:prd_collateIdx > s:collateMaxIdx)
            let g:prd_collateIdx = 1
        elseif (g:prd_collateIdx < 1)
            let g:prd_collateIdx = s:collateMaxIdx
        endif
        let list = g:prd_collateList
        let idx  = g:prd_collateIdx
    elseif (lineNr == s:lnJobSplit)
        let g:prd_jobSplitIdx = g:prd_jobSplitIdx + a:step
        if (g:prd_jobSplitIdx > s:jobSplitMaxIdx)
            let g:prd_jobSplitIdx = 1
        elseif (g:prd_jobSplitIdx < 1)
            let g:prd_jobSplitIdx = s:jobSplitMaxIdx
        endif
        let list = g:prd_jobSplitList
        let idx  = g:prd_jobSplitIdx
    elseif (lineNr == s:lnLeft)
        let g:prd_leftIdx = g:prd_leftIdx + a:step
        if (g:prd_leftIdx > s:leftMaxIdx)
            let g:prd_leftIdx = 1
        elseif (g:prd_leftIdx < 1)
            let g:prd_leftIdx = s:leftMaxIdx
        endif
        let list = g:prd_leftList
        let idx  = g:prd_leftIdx
    elseif (lineNr == s:lnRight)
        let g:prd_rightIdx = g:prd_rightIdx + a:step
        if (g:prd_rightIdx > s:rightMaxIdx)
            let g:prd_rightIdx = 1
        elseif (g:prd_rightIdx < 1)
            let g:prd_rightIdx = s:rightMaxIdx
        endif
        let list = g:prd_rightList
        let idx  = g:prd_rightIdx
    elseif (lineNr == s:lnTop)
        let g:prd_topIdx = g:prd_topIdx + a:step
        if (g:prd_topIdx > s:topMaxIdx)
            let g:prd_topIdx = 1
        elseif (g:prd_topIdx < 1)
            let g:prd_topIdx = s:topMaxIdx
        endif
        let list = g:prd_topList
        let idx  = g:prd_topIdx
    elseif (lineNr == s:lnBottom)
        let g:prd_bottomIdx = g:prd_bottomIdx + a:step
        if (g:prd_bottomIdx > s:bottomMaxIdx)
            let g:prd_bottomIdx = 1
        elseif (g:prd_bottomIdx < 1)
            let g:prd_bottomIdx = s:bottomMaxIdx
        endif
        let list = g:prd_bottomList
        let idx  = g:prd_bottomIdx
    elseif (lineNr == s:lnDialog)
        let g:prd_dialogIdx = g:prd_dialogIdx + a:step
        if (g:prd_dialogIdx > s:dialogMaxIdx)
            let g:prd_dialogIdx = 1
        elseif (g:prd_dialogIdx < 1)
            let g:prd_dialogIdx = s:dialogMaxIdx
        endif
        let list = g:prd_dialogList
        let idx  = g:prd_dialogIdx
    else
        echo "no parameter under cursor..."
        return
    endif


    if (idx != 0)     " is cursor in a parameter line?
        setlocal modifiable

        let lineNr = line(".")           " set cursor to start of parameter <...>
        let colNr  = col(".")
        call cursor(lineNr, s:colPara)

                    " delete line from start of parameter to end of line
                    " and add new element from element-list with index 'idx'
        execute("normal d$i" . "<" . s:GetElementOutOfList(list, idx) . ">")

        call cursor(lineNr, colNr)       " reset cursor to start position

        setlocal nomodifiable
    endif

endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   show some help on parameter under cursor                              **
"*****************************************************************************
function <SID>prd_ShowHelpOnParameter()
    let lineNr = line(".")

    if (lineNr == s:lnPrtDev)
        echo "printer device to be used for printing"
    elseif (lineNr == s:lnFont)
        echo "font and it's size used for printing"
    elseif (lineNr == s:lnPaper)
        echo "format of paper"
    elseif (lineNr == s:lnPortrait)
        echo "orientation of paper; <yes> portrait, <no> landscape"
    elseif (lineNr == s:lnHeader)
        echo "number of lines for header; <0> no header"
    elseif (lineNr == s:lnLineNr)
        echo "print line-numbers"
    elseif (lineNr == s:lnSyntax)
        echo "use syntax-highlighting; <no> off, else use colorscheme"
    elseif (lineNr == s:lnWrap)
        echo "<yes> wrap long lines, <no> truncate long lines"
    elseif (lineNr == s:lnDuplex)
        echo "<off> print on one side, <long>/<short> print on both sides"
    elseif (lineNr == s:lnCollate)
        echo "<yes> collating 123, 123, 123, <no> no collating 111, 222, 333"
    elseif (lineNr == s:lnJobSplit)
        echo "<yes> each copy separate job, <no> all copies one job"
    elseif (lineNr == s:lnLeft)
        echo "left margin"
    elseif (lineNr == s:lnRight)
        echo "right margin"
    elseif (lineNr == s:lnTop)
        echo "top margin"
    elseif (lineNr == s:lnBottom)
        echo "bottom margin"
    elseif (lineNr == s:lnDialog)
        echo "MS-Windows only: show printer dialog"
    else
        echo "to get help move cursor on parameter"
    endif

endfunction



"*****************************************************************************
"** input:   none                                                           **
"** output:   0: ok                                                         **
"**          <0: error                                                      **
"*****************************************************************************
"** remarks:                                                                **
"**   start printing...                                                     **
"**                                                                         **
"*****************************************************************************
function <SID>prd_StartPrinting()

    if (bufexists(s:bufferSrc))          " is buffer to be printed still there?

        " switch to buffer to be printed (current dialog buffer will
        " be deleted automaticall by doing this)
        execute("buffer ".s:bufferSrc)

        " backup VIM settings we will change
        call s:BackupSettings()

        "*** setup hardcopy arguments
           " printdevice
        call s:SetPrintdevice()

           " printoptions
        call s:SetPrintoptions()

           " printfont
        call s:SetPrintfont()

           " printheader
        call s:SetPrintheader()

        " syntax: set colorscheme according to user setting
        " for this print-job
        call s:SetColorschemeForPrinting()

        "*** setup command string
        let cmdStr = s:startLine . "," . s:endLine . "hardcopy"

        if (tolower(s:GetElementOutOfList(g:prd_dialogList, g:prd_dialogIdx)) == "no")
            let cmdStr = cmdStr . "!"
        endif

        execute(cmdStr)

        " restore VIM settings we have changed
        call s:RestoreSettings()
    else                                 "*** buffer to be printed does not exist
        execute("dbuffer ".s:bufferUser)
        call s:Error(2)
        return -1
    endif

    return 0
endfunction



"*****************************************************************************
"** input:   errNr: number which defines an error (> 0)                     **
"** output:  none                                                           **
"*****************************************************************************
"** remarks:                                                                **
"**   this function prints an error-msg                                     **
"*****************************************************************************
function s:Error(errNr)

    if (a:errNr == 1)
        echo s:scriptName.": no buffer to be printed"
    elseif (a:errNr == 2)
        echo s:scriptName.": buffer to be printed does not exist"
    elseif (a:errNr == 3)
        echo s:scriptName.": this version of VIM does not support printing"
    else
        echo s:scriptName.": unknown error occured"
    endif

endfunction



"*** EOF ***
