; SB_SetProgress
; (w) by DerRaphael / Released under the Terms of EUPL 1.0 
; see http://ec.europa.eu/idabc/en/document/7330 for details

SB_SetProgress(Value=0,Seg=1,Ops="")
{
   ; Definition of Constants   
   Static SB_GETRECT      := 0x40a      ; (WM_USER:=0x400) + 10
        , SB_GETPARTS     := 0x406
        , SB_PROGRESS                   ; Container for all used hwndBar:Seg:hProgress
        , PBM_SETPOS      := 0x402      ; (WM_USER:=0x400) + 2
        , PBM_SETRANGE32  := 0x406
        , PBM_SETBARCOLOR := 0x409
        , PBM_SETBKCOLOR  := 0x2001 
        , dwStyle         := 0x50000001 ; forced dwStyle WS_CHILD|WS_VISIBLE|PBS_SMOOTH

   ; Find the hWnd of the currentGui's StatusbarControl
   Gui,+LastFound
   ControlGet,hwndBar,hWnd,,msctls_statusbar321

   if (!StrLen(hwndBar)) { 
      rErrorLevel := "FAIL: No StatusBar Control"     ; Drop ErrorLevel on Error
   } else If (Seg<=0) {
      rErrorLevel := "FAIL: Wrong Segment Parameter"  ; Drop ErrorLevel on Error
   } else if (Seg>0) {
      ; Segment count
      SendMessage, SB_GETPARTS, 0, 0,, ahk_id %hwndBar%
      SB_Parts :=  ErrorLevel - 1
      If ((SB_Parts!=0) && (SB_Parts<Seg)) {
         rErrorLevel := "FAIL: Wrong Segment Count"  ; Drop ErrorLevel on Error
      } else {
         ; Get Segment Dimensions in any case, so that the progress control
         ; can be readjusted in position if neccessary
         if (SB_Parts) {
            VarSetCapacity(RECT,16,0)     ; RECT = 4*4 Bytes / 4 Byte <=> Int
            ; Segment Size :: 0-base Index => 1. Element -> #0
            SendMessage,SB_GETRECT,Seg-1,&RECT,,ahk_id %hwndBar%
            If ErrorLevel
               Loop,4
                  n%A_index% := NumGet(RECT,(a_index-1)*4,"Int")
            else
               rErrorLevel := "FAIL: Segmentdimensions" ; Drop ErrorLevel on Error
         } else { ; We dont have any parts, so use the entire statusbar for our progress
            n1 := n2 := 0
            ControlGetPos,,,n3,n4,,ahk_id %hwndBar%
         } ; if SB_Parts

         If (InStr(SB_Progress,":" Seg ":")) {

            hWndProg := (RegExMatch(SB_Progress, hwndBar "\:" seg "\:(?P<hWnd>([^,]+|.+))",p)) ? phWnd :

         } else {

            If (RegExMatch(Ops,"i)-smooth"))
               dwStyle ^= 0x1

            hWndProg := DllCall("CreateWindowEx","uint",0,"str","msctls_progress32"
               ,"uint",0,"uint", dwStyle
               ,"int",0,"int",0,"int",0,"int",0 ; segment-progress :: X/Y/W/H
               ,"uint",DllCall("GetAncestor","uInt",hwndBar,"uInt",1) ; gui hwnd
               ,"uint",0,"uint",0,"uint",0)

            SB_Progress .= (StrLen(SB_Progress) ? "," : "") hwndBar ":" Seg ":" hWndProg

         } ; If InStr Prog <-> Seg

         ; HTML Colors
         Black:=0x000000,Green:=0x008000,Silver:=0xC0C0C0,Lime:=0x00FF00,Gray:=0x808080
         Olive:=0x808000,White:=0xFFFFFF,Yellow:=0xFFFF00,Maroon:=0x800000,Navy:=0x000080
         Red:=0xFF0000,Blue:=0x0000FF,Fuchsia:=0xFF00FF,Aqua:=0x00FFFF

         If (RegExMatch(ops,"i)\bBackground(?P<C>[a-z0-9]+)\b",bg)) {
              if ((strlen(bgC)=6)&&(RegExMatch(bgC,"i)([0-9a-f]{6})")))
                  bgC := "0x" bgC
              else if !(RegExMatch(bgC,"i)^0x([0-9a-f]{1,6})"))
                  bgC := %bgC%
              if (bgC+0!="")
                  SendMessage, PBM_SETBKCOLOR, 0
                      , ((bgC&255)<<16)+(((bgC>>8)&255)<<8)+(bgC>>16) ; BGR
                      ,, ahk_id %hwndProg%
         } ; If RegEx BGC
         If (RegExMatch(ops,"i)\bc(?P<C>[a-z0-9]+)\b",fg)) {
              if ((strlen(fgC)=6)&&(RegExMatch(fgC,"i)([0-9a-f]{6})")))
                  fgC := "0x" fgC
              else if !(RegExMatch(fgC,"i)^0x([0-9a-f]{1,6})"))
                  fgC := %fgC%
              if (fgC+0!="")
                  SendMessage, PBM_SETBARCOLOR, 0
                      , ((fgC&255)<<16)+(((fgC>>8)&255)<<8)+(fgC>>16) ; BGR
                      ,, ahk_id %hwndProg%
         } ; If RegEx FGC

         If ((RegExMatch(ops,"i)(?P<In>[^ ])?range((?P<Lo>\-?\d+)\-(?P<Hi>\-?\d+))?",r)) 
              && (rIn!="-") && (rHi>rLo)) {    ; Set new LowRange and HighRange
              SendMessage,0x406,rLo,rHi,,ahk_id %hWndProg%
         } else if ((rIn="-") || (rLo>rHi)) {  ; restore defaults on remove or invalid values
              SendMessage,0x406,0,100,,ahk_id %hWndProg%
         } ; If RegEx Range
      
         If (RegExMatch(ops,"i)\bEnable\b"))
            Control, Enable,,, ahk_id %hWndProg%
         If (RegExMatch(ops,"i)\bDisable\b"))
            Control, Disable,,, ahk_id %hWndProg%
         If (RegExMatch(ops,"i)\bHide\b"))
            Control, Hide,,, ahk_id %hWndProg%
         If (RegExMatch(ops,"i)\bShow\b"))
            Control, Show,,, ahk_id %hWndProg%

         ControlGetPos,xb,yb,,,,ahk_id %hwndBar%
         ControlMove,,xb+n1,yb+n2,n3-n1,n4-n2,ahk_id %hwndProg%
         SendMessage,PBM_SETPOS,value,0,,ahk_id %hWndProg%

      } ; if Seg greater than count
   } ; if Seg greater zero

   If (regExMatch(rErrorLevel,"^FAIL")) {
      ErrorLevel := rErrorLevel
      Return -1
   } else 
      Return hWndProg

}




/*

SB_SetProgress([参数1 [, segment [, options]]])
全部参数:
   参数1
      一个在范围以内的数值，进度条会改变到这个位置。
      默认范围可以通过下面描述的方法来改变。默认从0到100。

   Segment
      状态栏进度条附着到的状态栏的哪个分段上。如果你仅仅想用options来改变外观，同时没有给出segments，使用默认值：1 

   Options
      一个含有一个或多个下列选项的字符串

___________________________________________________________________

Usable Options

   +/-Smooth: Displays a length of segments，而不是一个光滑连续的进度条。Specifying -Smooth is also one of the requirements to show a themed progress bar on Windows XP or later. 另一个要求是进度调不能有任何自定义颜色,也就是说,颜色和背景颜色选项被省略。

   +/-Range: 设置进度条的范围（默认0-100）. 例子： Range0-1000 表示从 0 到 1000； Range-50-50 表示从 -50 到 50; and Range-10--5 表示从 -10 到 -5. 使用 -Range 来恢复默认范围

   Cn: 改变进度条颜色. Specify for n one of the 16 primary HTML color names or a 6-digit RGB color value. Examples: cRed, cFFFF33, cDefault. If the C option is never used (or cDefault is specified), the system's default bar color will be used.

   BackgroundN: 改变进度条背景颜色. Specify for n one of the 16 primary HTML color names or a 6-digit RGB color value. Examples: BackgroundGreen, BackgroundFFFF33, BackgroundDefault. If the Background option is never used (or BackgroundDefault is specified), the background color will be that of the window or tab control behind it.

   Enable: Enables a control if it was previously disabled. On by default.

   Disable: Disables or "grays out" a control. 

   Show: Shows a control if it was previously hidden. 

   Hide: Hides the progressbar control.

___________________________________________________________________

ErrorLevel

   In case an error happens, The ErrorLevel will contain informations about what went wrong. All Descriptions start with the word "FAIL:" written in caps. Possible contents and a brief explanation:

   No StatusBar Control
   Obvious.

   Wrong Segment Parameter
   Will be set when Segment parameter is smaller or equal zero.

   Wrong Segment Count
   Will be set when higher Segment number is given than actual segements exist. Exception: When operating with just a standard statusbarcontrol and no segments at all, a given Segment parameter can be used to have more than just one Progressbar of which only the latest according to its z-Order will be displayed.

   Segmentdimensions
   The function was unable to determine given Segment's dimensions (x/y of upper left corner and x/y of lower right corner)

   On success the ErrorLevel will contain 1

___________________________________________________________________

Returnvalue

   When an Error of the pervious described occurs, the returnvalue will be set to -1. On success to the progressbar's WindowHandle (hWnd).
___________________________________________________________________

Performance

   Allthough it works, it is better not to supply options directly at a loop which will permanently update the statusbar. This may result in flickering of the progressbar due to parsing all comments on each run. Better is to use Seperate commands, and have just passed Param1 and Segemt to update the progressbar. See the example below how to use this properly.

___________________________________________________________________

Remarks

   Currently the so called marqueestyle (that is no given size, but a contantly moving part of the bar) is not functional.
   The -Smooth/+Smooth parameter will only be evaluated upon Progressbar creation and cannot be changed from within the function lateron.

   Using the PBM_DELTAPOS message to increment the Bar by a given step and not by an absolute number is not implemented yet.
   So something comparable to 
   GuiControl,, MyProgress, +20  ; Increase the current position by 20.won't work at the moment.

   To get the current's Progressbar value (if ever needed) a SendMessage must be used like this:
   hwnd := SB_SetProgress(50,3,"BackgroundYellow cBlue") ; This is the way to obtain the handle to the control
   SendMessage, PBM_GETPOS:=0x408, wParam:=0, lParam:=0,,ahk_id %hWnd% ; wParam, and lParam needs to be zero in this case
   MsgBox %ErrorLevel% ; The ErrorLevel contains the current position