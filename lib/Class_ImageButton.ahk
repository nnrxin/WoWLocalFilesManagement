; ======================================================================================================================
; Namespace:         ImageButton
; Function:          Create images and assign them to pushbuttons.
; Tested with:       AHK 1.1.14.03 (A32/U32/U64)
; Tested on:         Win 7 (x64)
; Change history:    1.4.00.00/2014-06-07/just me - fixed bug for button caption = "0", "000", etc.
;                    1.3.00.00/2014-02-28/just me - added support for ARGB colors
;                    1.2.00.00/2014-02-23/just me - added borders
;                    1.1.00.00/2013-12-26/just me - added rounded and bicolored buttons       
;                    1.0.00.00/2013-12-21/just me - initial release
; 用法:
;     1.创建一个按钮 (例如 "Gui, Add, Button, vMyButton hwndHwndButton, Caption") 使用"Hwnd"来获取按钮的句柄HWND
;     2.调用 ImageButton.Create() 需要2个参数:
;        HWND        -  按钮的句柄.
;        Options*    -  包含6个参数.
;        ---------------------------------------------------------------------------------------------------------------
;       1 代表普通状态下
;       2 代表鼠标悬停在按钮上(不按下)
;       3 代表鼠标按住按钮
;       4 代表按钮在 disable 状态下(按钮无效化)
;       5 代表按钮在 Default 状态下(按钮默认)
;       6 估计用不上,直接上老外的原文吧:<- used only on tablet computers
;    其中数组的第一个必须有(也就是上边的BT1Options),  后边的根据需要添加
;        ---------------------------------------------------------------------------------------------------------------
;        每一个Options里包含下列数值
;          序号 数值
;           1     Mode 模式        必须的参数:
;                             0  -  单色 或 位图bitmap
;                             1  -  垂直双色
;                             2  -  水平双色
;                             3  -  垂直梯度
;                             4  -  水平梯度
;                             5  -  垂直梯度 using StartColor at both borders and TargetColor at the center
;                             6  -  水平梯度 using StartColor at both borders and TargetColor at the center
;                             7  -  凸起？浮雕 样式
;           2     StartColor(起始颜色)  Option[1]中必须的参数, 后面的Option中若忽略此参数，则继承[1]的该参数:
;                             -  ARGB 颜色数值 (0xAARRGGBB) 或 HTML的颜色名称("Red").
;                             -  图像的路径 或 mode模式0的hbitmap的句柄
;           3     TargetColor(目标颜色)  mode>0时，为Option[1]的必须参数；mode=0时忽略。后面的Option中若忽略此参数，则继承[1]的该参数。
;                             -  ARGB 颜色数值 (0xAARRGGBB) 或 HTML的颜色名称("Red").
;           4     TextColor(文字颜色)  可选参数, 忽略时Option[1]会使用默认的文字颜色，后面的Option会使用Option[1]的参数
;                             -  ARGB 颜色数值 (0xAARRGGBB) 或 HTML的颜色名称("Red").
;                                默认颜色: 0xFF000000 (黑色)
;           5     Rounded(圆形的)      可选参数:
;                             -  圆角的半径（单位：像素）;
;                             -  "H"使用高的一半作为圆角半径
;                             -  "W"使用宽的一半作为圆角半径
;                                默认: 0 - 没有圆角
;           6     GuiColor(Gui颜色)   可选参数: 当你改变了Gui的背景颜色时，圆形的按钮的必要参数
;                             -  ARGB 颜色数值 (0xAARRGGBB) 或 HTML的颜色名称("Red").
;                                默认: AHK默认的GUI背景颜色
;           7     BorderColor(边框颜色) 可选参数, mode0 和 7 时忽略
;                             -  ARGB 颜色数值 (0xAARRGGBB) 或 HTML的颜色名称("Red").
;           8     BorderWidth(宽度颜色) 可选参数, mode0 和 7 时忽略，单位：像素
;                             -  默认: 1
;        ---------------------------------------------------------------------------------------------------------------
; ======================================================================================================================
; CLASS ImageButton()
; ======================================================================================================================
Class ImageButton {
   ; ===================================================================================================================
   ; PUBLIC PROPERTIES =================================================================================================
   ; ===================================================================================================================
   Static DefGuiColor  := ""        ; 默认 GUI 颜色                           (read/write)
   Static DefTxtColor := "Black"    ; 默认 caption 颜色                (read/write)
   Static LastError := ""           ; 包含上次的错误信息                      (readonly)
   ; ===================================================================================================================
   ; PRIVATE PROPERTIES ================================================================================================
   ; ===================================================================================================================
   Static BitMaps := []
   Static GDIPDll := 0
   Static GDIPToken := 0
   Static MaxOptions := 8
   ; HTML colors
   Static HTML := {BLACK: 0x000000, GRAY: 0x808080, SILVER: 0xC0C0C0, WHITE: 0xFFFFFF, MAROON: 0x800000
                 , PURPLE: 0x800080, FUCHSIA: 0xFF00FF, RED: 0xFF0000, GREEN: 0x008000, OLIVE: 0x808000
                 , YELLOW: 0xFFFF00, LIME: 0x00FF00, NAVY: 0x000080, TEAL: 0x008080, AQUA: 0x00FFFF, BLUE: 0x0000FF}
   ; Initialize
   Static ClassInit := ImageButton.InitClass()
   ; ===================================================================================================================
   ; PRIVATE METHODS ===================================================================================================
   ; ===================================================================================================================
   __New(P*) {
      Return False
   }
   ; ===================================================================================================================
   InitClass() {
      ; ----------------------------------------------------------------------------------------------------------------
      ; Get AHK's default GUI background color
      GuiColor := DllCall("User32.dll\GetSysColor", "Int", 15, "UInt") ; COLOR_3DFACE is used by AHK as default
      This.DefGuiColor := ((GuiColor >> 16) & 0xFF) | (GuiColor & 0x00FF00) | ((GuiColor & 0xFF) << 16)
      Return True
   }
   ; ===================================================================================================================
   GdiplusStartup() {
      This.GDIPDll := This.GDIPToken := 0
      If (This.GDIPDll := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "Ptr")) {
         VarSetCapacity(SI, 24, 0)
         Numput(1, SI, 0, "Int")
         If !DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", GDIPToken, "Ptr", &SI, "Ptr", 0)
            This.GDIPToken := GDIPToken
         Else
            This.GdiplusShutdown()
      }
      Return This.GDIPToken
   }
   ; ===================================================================================================================
   GdiplusShutdown() {
      If This.GDIPToken
         DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", This.GDIPToken)
      If This.GDIPDll
         DllCall("Kernel32.dll\FreeLibrary", "Ptr", This.GDIPDll)
      This.GDIPDll := This.GDIPToken := 0
   }
   ; ===================================================================================================================
   FreeBitmaps() {
      For I, HBITMAP In This.BitMaps
         DllCall("Gdi32.dll\DeleteObject", "Ptr", HBITMAP)
      This.BitMaps := []
   }
   ; ===================================================================================================================
   GetARGB(RGB) {
      ARGB := This.HTML.HasKey(RGB) ? This.HTML[RGB] : RGB
      Return (ARGB & 0xFF000000) = 0 ? 0xFF000000 | ARGB : ARGB
   }
   ; ===================================================================================================================
   PathAddRectangle(Path, X, Y, W, H) {
      Return DllCall("Gdiplus.dll\GdipAddPathRectangle", "Ptr", Path, "Float", X, "Float", Y, "Float", W, "Float", H)
   }
   ; ===================================================================================================================
   PathAddRoundedRect(Path, X1, Y1, X2, Y2, R) {
      D := (R * 2), X2 -= D, Y2 -= D
      DllCall("Gdiplus.dll\GdipAddPathArc"
            , "Ptr", Path, "Float", X1, "Float", Y1, "Float", D, "Float", D, "Float", 180, "Float", 90)
      DllCall("Gdiplus.dll\GdipAddPathArc"
            , "Ptr", Path, "Float", X2, "Float", Y1, "Float", D, "Float", D, "Float", 270, "Float", 90)
      DllCall("Gdiplus.dll\GdipAddPathArc"
            , "Ptr", Path, "Float", X2, "Float", Y2, "Float", D, "Float", D, "Float", 0, "Float", 90)
      DllCall("Gdiplus.dll\GdipAddPathArc"
            , "Ptr", Path, "Float", X1, "Float", Y2, "Float", D, "Float", D, "Float", 90, "Float", 90)
      Return DllCall("Gdiplus.dll\GdipClosePathFigure", "Ptr", Path)
   }
   ; ===================================================================================================================
   SetRect(ByRef Rect, X1, Y1, X2, Y2) {
      VarSetCapacity(Rect, 16, 0)
      NumPut(X1, Rect, 0, "Int"), NumPut(Y1, Rect, 4, "Int")
      NumPut(X2, Rect, 8, "Int"), NumPut(Y2, Rect, 12, "Int")
      Return True
   }
   ; ===================================================================================================================
   SetRectF(ByRef Rect, X, Y, W, H) {
      VarSetCapacity(Rect, 16, 0)
      NumPut(X, Rect, 0, "Float"), NumPut(Y, Rect, 4, "Float")
      NumPut(W, Rect, 8, "Float"), NumPut(H, Rect, 12, "Float")
      Return True
   }
   ; ===================================================================================================================
   SetError(Msg) {
      This.FreeBitmaps()
      This.GdiplusShutdown()
      This.LastError := Msg
      Return False
   }
   ; ===================================================================================================================
   ; PUBLIC METHODS ====================================================================================================
   ; ===================================================================================================================
   Create(HWND, Options*) {
      ; Windows constants
      Static BCM_SETIMAGELIST := 0x1602
           , BS_CHECKBOX := 0x02, BS_RADIOBUTTON := 0x04, BS_GROUPBOX := 0x07, BS_AUTORADIOBUTTON := 0x09
           , BS_LEFT := 0x0100, BS_RIGHT := 0x0200, BS_CENTER := 0x0300, BS_TOP := 0x0400, BS_BOTTOM := 0x0800
           , BS_VCENTER := 0x0C00, BS_BITMAP := 0x0080
           , BUTTON_IMAGELIST_ALIGN_LEFT := 0, BUTTON_IMAGELIST_ALIGN_RIGHT := 1, BUTTON_IMAGELIST_ALIGN_CENTER := 4
           , ILC_COLOR32 := 0x20
           , OBJ_BITMAP := 7
           , RCBUTTONS := BS_CHECKBOX | BS_RADIOBUTTON | BS_AUTORADIOBUTTON
           , SA_LEFT := 0x00, SA_CENTER := 0x01, SA_RIGHT := 0x02
           , WM_GETFONT := 0x31
      ; ----------------------------------------------------------------------------------------------------------------
      This.LastError := ""
      ; ----------------------------------------------------------------------------------------------------------------
      ; Check HWND
      If !DllCall("User32.dll\IsWindow", "Ptr", HWND)
         Return This.SetError("Invalid parameter HWND!")
      ; ----------------------------------------------------------------------------------------------------------------
      ; Check Options
      If !(IsObject(Options)) || (Options.MinIndex() <> 1) || (Options.MaxIndex() > This.MaxOptions)
         Return This.SetError("Invalid parameter Options!")
      ; ----------------------------------------------------------------------------------------------------------------
      ; Get and check control's class and styles
      WinGetClass, BtnClass, ahk_id %HWND%
      ControlGet, BtnStyle, Style, , , ahk_id %HWND%
      If (BtnClass != "Button") || ((BtnStyle & 0xF ^ BS_GROUPBOX) = 0) || ((BtnStyle & RCBUTTONS) > 1)
         Return This.SetError("The control must be a pushbutton!")
      ; ----------------------------------------------------------------------------------------------------------------
      ; Load GdiPlus
      If !This.GdiplusStartup()
         Return This.SetError("GDIPlus could not be started!")
      ; ----------------------------------------------------------------------------------------------------------------
      ; Get the button's font
      GDIPFont := 0
      HFONT := DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", WM_GETFONT, "Ptr", 0, "Ptr", 0, "Ptr")
      DC := DllCall("User32.dll\GetDC", "Ptr", HWND, "Ptr")
      DllCall("Gdi32.dll\SelectObject", "Ptr", DC, "Ptr", HFONT)
      DllCall("Gdiplus.dll\GdipCreateFontFromDC", "Ptr", DC, "PtrP", PFONT)
      DllCall("User32.dll\ReleaseDC", "Ptr", HWND, "Ptr", DC)
      If !(PFONT)
         Return This.SetError("Couldn't get button's font!")
      ; ----------------------------------------------------------------------------------------------------------------
      ; Get the button's rectangle
      VarSetCapacity(RECT, 16, 0)
      If !DllCall("User32.dll\GetWindowRect", "Ptr", HWND, "Ptr", &RECT)
         Return This.SetError("Couldn't get button's rectangle!")
      BtnW := NumGet(RECT,  8, "Int") - NumGet(RECT, 0, "Int")
      BtnH := NumGet(RECT, 12, "Int") - NumGet(RECT, 4, "Int")
      ; ----------------------------------------------------------------------------------------------------------------
      ; Get the button's caption
      ControlGetText, BtnCaption, , ahk_id %HWND%
      If (ErrorLevel)
         Return This.SetError("Couldn't get button's caption!")
      ; ----------------------------------------------------------------------------------------------------------------
      ; Create the bitmap(s)
      This.BitMaps := []
      For Index, Option In Options {
         If !IsObject(Option)
            Continue
         BkgColor1 := BkgColor2 := TxtColor := Mode := Rounded := GuiColor := Image := ""
         ; Replace omitted options with the values of Options.1
         Loop, % This.MaxOptions {
            If (Option[A_Index] = "")
               Option[A_Index] := Options.1[A_Index]
         }
         ; -------------------------------------------------------------------------------------------------------------
         ; Check option values
         ; Mode
         Mode := SubStr(Option.1, 1 ,1)
         If !InStr("0123456789", Mode)
            Return This.SetError("Invalid value for Mode in Options[" . Index . "]!")
         ; StartColor & TargetColor
         If (Mode = 0)
         && (FileExist(Option.2) || (DllCall("Gdi32.dll\GetObjectType", "Ptr", Option.2, "UInt") = OBJ_BITMAP))
            Image := Option.2
         Else {
            If !(Option.2 + 0) && !This.HTML.HasKey(Option.2)
               Return This.SetError("Invalid value for StartColor in Options[" . Index . "]!")
            BkgColor1 := This.GetARGB(Option.2)
            If (Option.3 = "")
               Option.3 := Option.2
            If !(Option.3 + 0) && !This.HTML.HasKey(Option.3)
               Return This.SetError("Invalid value for TargetColor in Options[" . Index . "]!")
            BkgColor2 := This.GetARGB(Option.3)
         }
         ; TextColor
         If (Option.4 = "")
            Option.4 := This.DefTxtColor
         If !(Option.4 + 0) && !This.HTML.HasKey(Option.4)
            Return This.SetError("Invalid value for TxtColor in Options[" . Index . "]!")
         TxtColor := This.GetARGB(Option.4)
         ; Rounded
         Rounded := Option.5
         If (Rounded = "H")
            Rounded := BtnH * 0.5
         If (Rounded = "W")
            Rounded := BtnW * 0.5
         If !(Rounded + 0)
            Rounded := 0
         ; GuiColor
         If (Option.6 = "")
            Option.6 := This.DefGuiColor
         If !(Option.6 + 0) && !This.HTML.HasKey(Option.6)
            Return This.SetError("Invalid value for GuiColor in Options[" . Index . "]!")
         GuiColor := This.GetARGB(Option.6)
         ; BorderColor
         BorderColor := ""
         If (Option.7 <> "") {
            If !(Option.7 + 0) && !This.HTML.HasKey(Option.7)
               Return This.SetError("Invalid value for BorderColor in Options[" . Index . "]!")
            BorderColor := 0xFF000000 | This.GetARGB(Option.7) ; BorderColor must be always opaque
         }
         ; BorderWidth
         BorderWidth := Option.8 ? Option.8 : 1
         ; -------------------------------------------------------------------------------------------------------------
         ; Create a GDI+ bitmap
         DllCall("Gdiplus.dll\GdipCreateBitmapFromScan0", "Int", BtnW, "Int", BtnH, "Int", 0
               , "UInt", 0x26200A, "Ptr", 0, "PtrP", PBITMAP)
         ; Get the pointer to its graphics
         DllCall("Gdiplus.dll\GdipGetImageGraphicsContext", "Ptr", PBITMAP, "PtrP", PGRAPHICS)
         ; Quality settings
         DllCall("Gdiplus.dll\GdipSetSmoothingMode", "Ptr", PGRAPHICS, "UInt", 4)
         DllCall("Gdiplus.dll\GdipSetInterpolationMode", "Ptr", PGRAPHICS, "Int", 7)
         DllCall("Gdiplus.dll\GdipSetCompositingQuality", "Ptr", PGRAPHICS, "UInt", 4)
         DllCall("Gdiplus.dll\GdipSetRenderingOrigin", "Ptr", PGRAPHICS, "Int", 0, "Int", 0)
         DllCall("Gdiplus.dll\GdipSetPixelOffsetMode", "Ptr", PGRAPHICS, "UInt", 4)
         ; Clear the background
         DllCall("Gdiplus.dll\GdipGraphicsClear", "Ptr", PGRAPHICS, "UInt", GuiColor)
         ; Create the image
         If (Image = "") { ; Create a BitMap based on the specified colors
            PathX := PathY := 0, PathW := BtnW, PathH := BtnH
            ; Create a GraphicsPath
            DllCall("Gdiplus.dll\GdipCreatePath", "UInt", 0, "PtrP", PPATH)
            If (Rounded < 1) ; the path is a rectangular rectangle
               This.PathAddRectangle(PPATH, PathX, PathY, PathW, PathH)
            Else ; the path is a rounded rectangle
               This.PathAddRoundedRect(PPATH, PathX, PathY, PathW, PathH, Rounded)
            ; If BorderColor and BorderWidth are specified, 'draw' the border (not for Mode 7)
            If (BorderColor <> "") && (BorderWidth > 0) && (Mode <> 7) {
               ; Create a SolidBrush
               DllCall("Gdiplus.dll\GdipCreateSolidFill", "UInt", BorderColor, "PtrP", PBRUSH)
               ; Fill the path
               DllCall("Gdiplus.dll\GdipFillPath", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Ptr", PPATH)
               ; Free the brush
               DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
               ; Reset the path
               DllCall("Gdiplus.dll\GdipResetPath", "Ptr", PPATH)
               ; Add a new 'inner' path
               PathX := PathY := BorderWidth, PathW -= BorderWidth, PathH -= BorderWidth, Rounded -= BorderWidth
               If (Rounded < 1) ; the path is a rectangular rectangle
                  This.PathAddRectangle(PPATH, PathX, PathY, PathW - PathX, PathH - PathY)
               Else ; the path is a rounded rectangle
                  This.PathAddRoundedRect(PPATH, PathX, PathY, PathW, PathH, Rounded)
               ; If a BorderColor has been drawn, BkgColors must be opaque
               BkgColor1 := 0xFF000000 | BkgColor1
               BkgColor2 := 0xFF000000 | BkgColor2               
            }
            PathW -= PathX
            PathH -= PathY
            If (Mode = 0) { ; the background is unicolored
               ; Create a SolidBrush
               DllCall("Gdiplus.dll\GdipCreateSolidFill", "UInt", BkgColor1, "PtrP", PBRUSH)
               ; Fill the path
               DllCall("Gdiplus.dll\GdipFillPath", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Ptr", PPATH)
            }
            Else If (Mode = 1) || (Mode = 2) { ; the background is bicolored
               ; Create a LineGradientBrush
               This.SetRectF(RECTF, PathX, PathY, PathW, PathH)
               DllCall("Gdiplus.dll\GdipCreateLineBrushFromRect", "Ptr", &RECTF
                     , "UInt", BkgColor1, "UInt", BkgColor2, "Int", Mode & 1, "Int", 3, "PtrP", PBRUSH)
               DllCall("Gdiplus.dll\GdipSetLineGammaCorrection", "Ptr", PBRUSH, "Int", 1)
               ; Set up colors and positions
               This.SetRect(COLORS, BkgColor1, BkgColor1, BkgColor2, BkgColor2) ; sorry for function misuse
               This.SetRectF(POSITIONS, 0, 0.5, 0.5, 1) ; sorry for function misuse
               DllCall("Gdiplus.dll\GdipSetLinePresetBlend", "Ptr", PBRUSH
                     , "Ptr", &COLORS, "Ptr", &POSITIONS, "Int", 4)
               ; Fill the path
               DllCall("Gdiplus.dll\GdipFillPath", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Ptr", PPATH)
            }
            Else If (Mode >= 3) && (Mode <= 6) { ; the background is a gradient
               ; Determine the brush's width/height
               W := Mode = 6 ? PathW / 2 : PathW  ; horizontal
               H := Mode = 5 ? PathH / 2 : PathH  ; vertical
               ; Create a LineGradientBrush
               This.SetRectF(RECTF, PathX, PathY, W, H)
               DllCall("Gdiplus.dll\GdipCreateLineBrushFromRect", "Ptr", &RECTF
                     , "UInt", BkgColor1, "UInt", BkgColor2, "Int", Mode & 1, "Int", 3, "PtrP", PBRUSH)
               DllCall("Gdiplus.dll\GdipSetLineGammaCorrection", "Ptr", PBRUSH, "Int", 1)
               ; Fill the path
               DllCall("Gdiplus.dll\GdipFillPath", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Ptr", PPATH)
            }
            Else { ; raised mode
               DllCall("Gdiplus.dll\GdipCreatePathGradientFromPath", "Ptr", PPATH, "PtrP", PBRUSH)
               ; Set Gamma Correction
               DllCall("Gdiplus.dll\GdipSetPathGradientGammaCorrection", "Ptr", PBRUSH, "UInt", 1)
               ; Set surround and center colors
               VarSetCapacity(ColorArray, 4, 0)
               NumPut(BkgColor1, ColorArray, 0, "UInt")
               DllCall("Gdiplus.dll\GdipSetPathGradientSurroundColorsWithCount", "Ptr", PBRUSH, "Ptr", &ColorArray
                   , "IntP", 1)
               DllCall("Gdiplus.dll\GdipSetPathGradientCenterColor", "Ptr", PBRUSH, "UInt", BkgColor2)
               ; Set the FocusScales
               FS := (BtnH < BtnW ? BtnH : BtnW) / 3
               XScale := (BtnW - FS) / BtnW
               YScale := (BtnH - FS) / BtnH
               DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", PBRUSH, "Float", XScale, "Float", YScale)
               ; Fill the path
               DllCall("Gdiplus.dll\GdipFillPath", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Ptr", PPATH)
            }
            ; Free resources
            DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
            DllCall("Gdiplus.dll\GdipDeletePath", "Ptr", PPATH)
         } Else { ; Create a bitmap from HBITMAP or file
            If (Image + 0)
               DllCall("Gdiplus.dll\GdipCreateBitmapFromHBITMAP", "Ptr", Image, "Ptr", 0, "PtrP", PBM)
            Else
               DllCall("Gdiplus.dll\GdipCreateBitmapFromFile", "WStr", Image, "PtrP", PBM)
            ; Draw the bitmap
            DllCall("Gdiplus.dll\GdipDrawImageRectI", "Ptr", PGRAPHICS, "Ptr", PBM, "Int", 0, "Int", 0
                  , "Int", BtnW, "Int", BtnH)
            ; Free the bitmap
            DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", PBM)
         }
         ; -------------------------------------------------------------------------------------------------------------
         ; Draw the caption
         If (BtnCaption <> "") {
            ; Create a StringFormat object
            DllCall("Gdiplus.dll\GdipStringFormatGetGenericTypographic", "PtrP", HFORMAT)
            ; Text color
            DllCall("Gdiplus.dll\GdipCreateSolidFill", "UInt", TxtColor, "PtrP", PBRUSH)
            ; Horizontal alignment
            HALIGN := (BtnStyle & BS_CENTER) = BS_CENTER ? SA_CENTER
                    : (BtnStyle & BS_CENTER) = BS_RIGHT  ? SA_RIGHT
                    : (BtnStyle & BS_CENTER) = BS_Left   ? SA_LEFT
                    : SA_CENTER
            DllCall("Gdiplus.dll\GdipSetStringFormatAlign", "Ptr", HFORMAT, "Int", HALIGN)
            ; Vertical alignment
            VALIGN := (BtnStyle & BS_VCENTER) = BS_TOP ? 0
                    : (BtnStyle & BS_VCENTER) = BS_BOTTOM ? 2
                    : 1
            DllCall("Gdiplus.dll\GdipSetStringFormatLineAlign", "Ptr", HFORMAT, "Int", VALIGN)
            ; Set render quality to system default
            DllCall("Gdiplus.dll\GdipSetTextRenderingHint", "Ptr", PGRAPHICS, "Int", 0)
            ; Set the text's rectangle
            VarSetCapacity(RECT, 16, 0)
            NumPut(BtnW, RECT,  8, "Float")
            NumPut(BtnH, RECT, 12, "Float")
            ; Draw the text
            DllCall("Gdiplus.dll\GdipDrawString", "Ptr", PGRAPHICS, "WStr", BtnCaption, "Int", -1
                  , "Ptr", PFONT, "Ptr", &RECT, "Ptr", HFORMAT, "Ptr", PBRUSH)
         }
         ; -------------------------------------------------------------------------------------------------------------
         ; Create a HBITMAP handle from the bitmap and add it to the array
         DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", PBITMAP, "PtrP", HBITMAP, "UInt", 0X00FFFFFF)
         This.BitMaps[Index] := HBITMAP
         ; Free resources
         DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", PBITMAP)
         DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
         DllCall("Gdiplus.dll\GdipDeleteStringFormat", "Ptr", HFORMAT)
         DllCall("Gdiplus.dll\GdipDeleteGraphics", "Ptr", PGRAPHICS)
         ; Add the bitmap to the array
      }
      ; Now free the font object
      DllCall("Gdiplus.dll\GdipDeleteFont", "Ptr", PFONT)
      ; ----------------------------------------------------------------------------------------------------------------
      ; Create the ImageList
      HIL := DllCall("Comctl32.dll\ImageList_Create"
                   , "UInt", BtnW, "UInt", BtnH, "UInt", ILC_COLOR32, "Int", 6, "Int", 0, "Ptr")
      Loop, % (This.BitMaps.MaxIndex() > 1 ? 6 : 1) {
         HBITMAP := This.BitMaps.HasKey(A_Index) ? This.BitMaps[A_Index] : This.BitMaps.1
         DllCall("Comctl32.dll\ImageList_Add", "Ptr", HIL, "Ptr", HBITMAP, "Ptr", 0)
      }
      ; Create a BUTTON_IMAGELIST structure
      VarSetCapacity(BIL, 20 + A_PtrSize, 0)
      NumPut(HIL, BIL, 0, "Ptr")
      Numput(BUTTON_IMAGELIST_ALIGN_CENTER, BIL, A_PtrSize + 16, "UInt")
      ; Hide buttons's caption
      ControlSetText, , , ahk_id %HWND%
      Control, Style, +%BS_BITMAP%, , ahk_id %HWND%
      ; Assign the ImageList to the button
      SendMessage, %BCM_SETIMAGELIST%, 0, 0, , ahk_id %HWND%
      SendMessage, %BCM_SETIMAGELIST%, 0, % &BIL, , ahk_id %HWND%
      ; Free the bitmaps
      This.FreeBitmaps()
      ; ----------------------------------------------------------------------------------------------------------------
      ; All done successfully
      This.GdiplusShutdown()
      Return True
   }
   ; ===================================================================================================================
   ; Set the default GUI color
   SetGuiColor(GuiColor) {
      ; GuiColor     -  RGB integer value (0xRRGGBB) or HTML color name ("Red").
      If !(GuiColor + 0) && !This.HTML.HasKey(GuiColor)
         Return False
      This.DefGuiColor := (This.HTML.HasKey(GuiColor) ? This.HTML[GuiColor] : GuiColor) & 0xFFFFFF
      Return True
   }
   ; ===================================================================================================================
   ; Set the default text color
   SetTxtColor(TxtColor) {
      ; TxtColor     -  RGB integer value (0xRRGGBB) or HTML color name ("Red").
      If !(TxtColor + 0) && !This.HTML.HasKey(TxtColor)
         Return False
      This.DefTxtColor := (This.HTML.HasKey(TxtColor) ? This.HTML[TxtColor] : TxtColor) & 0xFFFFFF
      Return True
   }
}