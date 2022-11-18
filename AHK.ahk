;------------------全局变量与函数定义------------------
;切换输入法的函数
;切换为英文输入法: SwitchIME(0x04090409)
;切换为中文输入法: SwitchIME(00000804)
SwitchIME(dwLayout) {
    HKL := DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus, ctl, A
    SendMessage, 0x50, 0, HKL, %ctl%, A
}

;或者直接使用以下命令也可以切换输入法
;PostMessage, 0x50, 0, 0x4090409, , A
;PostMessage, 0x50, 0, 00000804, , A

;-------------------------------------------------
;绕过输入法直接输入字符
;说明: 在 QQ 聊天窗口中是乱码，需要发送 UTF-16BE 编码
ascinput(string) {
    u :=  A_IsUnicode ? 2 : 1 ;Unicode 版 ahk 字符长度是 2
    length := StrPut(string, "CP0")
    if (A_IsUnicode){
        VarSetCapacity(address, length), StrPut(string, &address, "CP0")
    }
    else{
        address := string
    }
    VarSetCapacity(out, 2*length*u)
    index = 0
    Loop{
        index += 1
        if (index > length-1){
            Break
        }
        asc := NumGet(address, index-1, "UChar")
        if (asc > 126){
            index += 1
            asc2 := NumGet(address, index-1, "UChar")
            asc := asc*256 + asc2
        }
        Send, % "{ASC " asc "}"
    }
}
 


ascaltinput(string) {
    u :=  A_IsUnicode ? 2 : 1 ;Unicode 版 ahk 字符长度是 2
    length := StrPut(string, "CP0")
    if (A_IsUnicode){
        VarSetCapacity(address, length), StrPut(string, &address, "CP0")
    }
    else{
        address := string
    }
    VarSetCapacity(out, 2*length*u)
    index = 0
    Loop{
        index += 1
        if (index > length-1){
            Break
        }
        asc := NumGet(address, index-1, "UChar")
        if (asc > 126){
            index += 1
            asc2 := NumGet(address, index-1, "UChar")
            asc := asc*256 + asc2
        }
        StringSplit, var, asc,
        Loop % var0 {
            str .= "{Numpad" var%A_index% "}"
        }
        send, {AltDown}%str%{Altup}
        str =
    }
}

;-------------------------------------------------
; 检查变量名是否合法的函数
; 允许使用字母、数字、非 ASCII 字符和 # $ @ _
; 可以以数字开头, 不区分大小写, 不超过 253 个字符
isValidVarName(str, maxLen := 253) {
    if ((str == "") || (strlen(str) > maxLen)) {
        return false
    }
    Loop, Parse, str
    {   ; 这个花括号不能放在上一行
        ch := Asc(A_LoopField)
        isCharValid := false
        if (48 <= ch && ch <= 57) {
            isCharValid := true     ; 数字
        } else if (65 <= ch && ch <= 90) {
            isCharValid := true     ; 大写字母
        } else if (97 <= ch && ch <= 122) {
            isCharValid := true     ; 小写字母
        } else if (ch == 35 || ch == 36 || ch == 64 || ch == 95) {
            ifCharValid := true     ; # $ @ _
        } ; 数字开头是云讯的

        if (isCharValid == false) {
            return false
        }
    }
    return true
}

;-------------------------------------------------
; 如果快字符串处理过程中发现数据异常而被迫终止,
; 可以用下面这个函数清空热字串的输入
clearHotStringCMD() {
    temp := Clipboard
    Send, {Ctrl down}lc{Ctrl up}
    if (Clipboard != "") {
        Send, {Backspace}
    }
    Clipboard := temp
}



;------------------热键与热字符串-------------------

;------------------一、通用快捷键--------------------
;按键: Alt + I/J/K/L
;功能: 上下左右

!i::
Send, {Up}
return

!j::
Send, {Left}
return

!k::
Send, {Down}
return

!l::
Send, {Right}
return

;-------------------------------------------------
;按键: Alt + H/;
;功能: 行首行尾

!h::
Send, {home}
return

!;::
Send, {end}
return

;-------------------------------------------------
;按键: Alt + Shift + I/J/K/L
;功能: 选中字符

!+i::
Send, {Shift down}{Up}{Shift up}
return

!+j::
Send, {Shift down}{Left}{Shift up}
return

!+k::
Send, {Shift down}{Down}{Shift up}
return

!+l::
Send, {Shift down}{Right}{Shift up}
return

;-------------------------------------------------
;按键: Alt + Shift + H/;
;功能: 选中这一行之前或之后的字符

!+h::
Send, {Shift down}{Home}{Shift up}
return

!+;::
Send, {Shift down}{End}{Shift up}
return

;-------------------------------------------------
;按键: Alt + Ctrl + J/L
;功能: 跨词移动

!^j::
Send, {Ctrl down}{Left}{Ctrl up}
return

!^l::
Send, {Ctrl down}{Right}{Ctrl up}
return

;-------------------------------------------------
;按键: Ctrl + Alt + H/;
;功能: 文件开始或结尾

!^h::
Send, {Ctrl down}{Home}{Ctrl up}
return

!^;::
Send, {Ctrl down}{End}{Ctrl up}
return

;-------------------------------------------------
;鉴于我不会用到单独的 Alt 键, 并且组合键按到会很烦, 就想把它也 ban 了
;但是双冒号前只有一个感叹号的话, 感叹号不会被转义成 Alt
;并且禁用 LAlt 的话, 组合键也用不了了.

;LAlt::return

;-------------------------------------------------
;按键: PgUp / PgDn
;功能: 无
;因为容易误触，就禁了这两个烦人的键.

PgUp::return
PgDn::return

;-------------------------------------------------
;按键: LShift + 滚轮上下滚动
;功能: 页面向左向右滚动

~LShift & WheelUp::  ; 向左滚动.
ControlGetFocus, fcontrol, A
SendMessage, 0x0114, 0, 0, %fcontrol%, A  ; 0x0114 是 WM_HSCROLL, 它后面的 0 是 SB_LINELEFT.
return

~LShift & WheelDown::  ; 向右滚动.
ControlGetFocus, fcontrol, A
SendMessage, 0x0114, 1, 0, %fcontrol%, A  ; 0x0114 是 WM_HSCROLL, 它后面的 1 是 SB_LINERIGHT.
return

;-------------------------------------------------
;按键: RShift + w/a/s/d
;功能: 页面向上/左/下/右滚动

>+w::
Send, {WheelUp}
return

>+s::
Send, {WheelDown}
return

>+a::
Send, {WheelLeft}
return

>+d::
Send, {WheelRight}
return




;----------------typora 专用快捷键-----------------
;以下按键只在 typora 中生效
;之所以分开写, 一方面是因为 typora 中的 HTML 环境会影响 Send 或 ascinput 的效果.
;另一方面是许多软件 (包括一些 markdown 编辑器) 不支持行内公式等功能.
#IfWinActive ahk_exe D:\Software\Typora\Typora.exe

;-------------------------------------------------
;typora 常用 emoji 表情的快捷键
;如需设置按下回车键后替换内容, 可使用
; ::emos:::star:
;但不建议这样设置后删除多余的回车键,
;因为在 typora 中一次回车键可能要多次 backspace 才能删除.
;原来英文输入法下使用, 中文输入法下有 bug (已解决)
;理论上用下面两行任意一行去切换英文输入法都是可以的, 但是有点 bug
;SwitchIME(0x04090409)
;PostMessage, 0x50, 0, 0x4090409, , A
;不过可以用另一个快捷键辅助, 即
;Send, {Alt down}{Ctrl down}8{Ctrl up}{Alt up}
;Send, :star:
;但之后发现了更好的做法, 即绕开输入法:

:*:emos::
ascinput(":star:")
return

:*:emoc::
ascinput(":crescent_moon:")
return

;-------------------------------------------------
;按键: Ctrl + Alt + 1~7
;功能: 修改为 HTML 样式的小标题, 其中 7 为正文

!^1::
Send, {end}
ascinput("</h1>")
Send, {home}
ascinput("h1>")
Send, {home}
ascinput("<")
Send, {end}
Loop, 5 {
    Send, {Left}
}
return

!^2::
Send, {end}
ascinput("</h2>")
Send, {home}
ascinput("h2>")
Send, {home}
ascinput("<")
Send, {end}
Loop, 5 {
    Send, {Left}
}
return

!^3::
Send, {end}
ascinput("</h3>")
Send, {home}
ascinput("h3>")
Send, {home}
ascinput("<")
Send, {end}
Loop, 5 {
    Send, {Left}
}
return

!^4::
Send, {end}
ascinput("</h4>")
Send, {home}
ascinput("h4>")
Send, {home}
ascinput("<")
Send, {end}
Loop, 5 {
    Send, {Left}
}
return

!^5::
Send, {end}
ascinput("</h5>")
Send, {home}
ascinput("h5>")
Send, {home}
ascinput("<")
Send, {end}
Loop, 5 {
    Send, {Left}
}
return

!^6::
Send, {end}
ascinput("</h6>")
Send, {home}
ascinput("h6>")
Send, {home}
ascinput("<")
Send, {end}
Loop, 5 {
    Send, {Left}
}
return

!^7::
Send, {home}
Loop, 4 {
    Send, {Right}
}
Loop, 4 {
    Send, {Backspace}
}
Send, {end}
Loop, 5 {
    Send, {Backspace}
}
return

;-------------------------------------------------
;以下两个快捷键为权宜之计, 暂时已弃用.
;如仍需在其它快捷键中顺带修改输入法, 并且遇到误删字符的 bug, 可以取消注释
;!^8::
;SwitchIME(0x04090409)
;return

;!^9::
;SwitchIME(00000804)
;return

;-------------------------------------------------
;按键: Alt + M 和 Alt + Shift + M
;功能: 分别为行内公式和取消行内公式
;注: 需要在设置里启用行内公式 (LaTeX 语法)

!m::
ascinput("$  $")
Send, {Left}{Left}
return

!+m::
Send, {Right}{Right}
loop, 4 {
    Send, {Backspace}
}
return

;-------------------------------------------------
;按键: Alt + Ctrl + M
;功能: 刷新数学公式
;注: 因为这个功能用的频率不太高, 就用了三个键.
;自己写的快捷键大部分含 Alt, 所以就这样设置了.

; !^m::
; Send, {Alt down}e{Alt up}
; loop, 7 {
;     Send, {Up}
; }   ; 用 down 的话不仅次数多, 还有可能无法选中数学工具
; Send, {Right}{Enter}
; return


;-------------------------------------------------
;按键: "img" + Enter
;功能: 替换为 "<img src='image\.png' width=450>" 并将光标移至 .png 前
;注: 需要等待约 1.0 秒, 期间请勿输入其它字符. (已修复)

::\img::
imgstr := "<img src='image\.png' width=450>"
temp := Clipboard
Clipboard := imgstr
Send, {Ctrl down}v{Ctrl up}
Clipboard := temp
loop, 16 {
    Send, {Left}
}
return

;-------------------------------------------------
;按键: "\att" + Enter
;功能: 替换为 "<span style='background-color: #eeeeee; color: #777777'></span>"
;并将光标移至 </span> 前
;注: 需要等待一秒多, 期间请勿输入其它字符.

::\att::
attstr := "<span style='background-color: #eeeeee; color: #777777'></span>"
temp := Clipboard
Clipboard := attstr
Send, {Ctrl down}v{Ctrl up}
Clipboard := temp
loop, 7 {
    Send, {Left}
}
return

;-------------------------------------------------
;按键: "\ggb" + Enter / Tab / Space
;功能: 在 Geogebra 网页中复制分享链接后,
;在 typora 中输入 htmlggb 并回车 (或其它按键),
;则可以自动生成 HTML 代码, 显示按钮.
;转为 HTML 后, 按下按钮即可在页面内显示 Geogebra 绘制的图像, 并可以交互.
;注: 同一文件中如果想多次使用同一图像, 请使用 \ggbdef 自定义编号, 否则只有第一个有效.

::\ggb::
webstr := Clipboard
webprefix := "https://www.geogebra.org/calculator"
if (InStr(webstr, webprefix, false) != 1) {
    InputBox, webstr, 输入链接, 剪切板无正确的 Geogebra 图像链接!`n请复制链接后重新使用热字串.`n或者直接输入 Geogebra 绘图链接:`n如 "https://www.geogebra.org/calculator" (无需添加双引号).
}
if (InStr(webstr, webprefix, false) != 1) {
    MsgBox, 输入内容不是正确的链接!
    clearHotStringCMD()
    return
}
webpart := SubStr(webstr, 37)
htmlstr = 
(
<div>
    <button id="btn-%webpart%">
        点击查看 Geogebra 图像
    </button>
    &emsp;或直接打开<a href="%webstr%">
        网页链接
    </a>
    <iframe src="" width="800" height="0" allowfullscreen style="border: 1px solid #e4e4e4;border-radius: 4px;" frameborder="0" id="ifm-%webpart%"></iframe>
    <script>
        var src_%webpart% = "%webstr%";
        var btnId_%webpart% = "#btn-%webpart%";
        var ifmId_%webpart% = "#ifm-%webpart%";
        var btn_%webpart% = document.querySelector(btnId_%webpart%);
        var ifm_%webpart% = document.querySelector(ifmId_%webpart%);
        btn_%webpart%.onclick = () => {
            if (btn_%webpart%.innerHTML == "点击查看 Geogebra 图像") {
                btn_%webpart%.innerHTML = "点击关闭 Geogebra 图像";
                ifm_%webpart%.setAttribute("src", src_%webpart%);
                ifm_%webpart%.setAttribute("height", "600");
            } else {
                btn_%webpart%.innerHTML = "点击查看 Geogebra 图像";
                ifm_%webpart%.setAttribute("src", "");
                ifm_%webpart%.setAttribute("height", "0");
            }
        }
    </script>
</div>
)
Clipboard = %htmlstr%
Send, {Ctrl down}v{Ctrl up}{Down}
Clipboard = %webstr%    ; 有借有还, 是好文明
return

;-------------------------------------------------
;按键: "\ggbdef" + Enter / Tab / Space
;功能: 在 \ggb 的基础上自定义图像的编号.
;注: 如果想在同一文件中多次使用同一图像, 请使用这个快捷键并自定义不同编号.

::\ggbdef::
webstr := Clipboard
if (InStr(webstr, webprefix, false) != 1) {
    InputBox, webstr, 输入链接, 剪切板无正确的 Geogebra 图像链接!`n请复制链接后重新使用热字串.`n或者直接输入 Geogebra 绘图链接:`n如 "https://www.geogebra.org/calculator" (无需添加双引号).
}
if (InStr(webstr, webprefix, false) != 1) {
    MsgBox, 输入内容不是正确的链接!
    clearHotStringCMD()
    return
}
webpart := ""
InputBox, webpart, 自定义编号, 请输入图像的自定义编号.`n允许使用字母、数字、非 ASCII 字符和 '#'、'$'、'@'、'_'.`n可以以数字开头，不区分大小写，不超过 249 个字符.
if (isValidVarName(webpart, 253 - 4) == false) {
    MsgBox, 编号无效!
    clearHotStringCMD()
    return
}
htmlstr = 
(
<div>
    <button id="btn-%webpart%">
        点击查看 Geogebra 图像
    </button>
    &emsp;或直接打开<a href="%webstr%">
        网页链接
    </a>
    <iframe src="" width="800" height="0" allowfullscreen style="border: 1px solid #e4e4e4;border-radius: 4px;" frameborder="0" id="ifm-%webpart%"></iframe>
    <script>
        var src_%webpart% = "%webstr%";
        var btnId_%webpart% = "#btn-%webpart%";
        var ifmId_%webpart% = "#ifm-%webpart%";
        var btn_%webpart% = document.querySelector(btnId_%webpart%);
        var ifm_%webpart% = document.querySelector(ifmId_%webpart%);
        btn_%webpart%.onclick = () => {
            if (btn_%webpart%.innerHTML == "点击查看 Geogebra 图像") {
                btn_%webpart%.innerHTML = "点击关闭 Geogebra 图像";
                ifm_%webpart%.setAttribute("src", src_%webpart%);
                ifm_%webpart%.setAttribute("height", "600");
            } else {
                btn_%webpart%.innerHTML = "点击查看 Geogebra 图像";
                ifm_%webpart%.setAttribute("src", "");
                ifm_%webpart%.setAttribute("height", "0");
            }
        }
    </script>
</div>
)
Clipboard = %htmlstr%
Send, {Ctrl down}v{Ctrl up}{Down}
Clipboard = %webstr%    ; 有借有还, 是好文明
return



#IfWinActive ; typora
;-------------------------------------------------



;----------------sublime 专用快捷键-----------------
;以下快捷键只在 sublime text 中生效.
;之所以分开写, 是因为大部分软件没有选中多行同时输入的功能.
#IfWinActive ahk_exe C:\Program Files\Sublime Text\sublime_text.exe

;-------------------------------------------------
;按键: Alt + Ctrl + I/K
;功能: 页面上 (下) 移一行
;注: 等价于 Ctrl + Alt + 上/下

!^i::
Send, {Ctrl down}{Up}{Ctrl up}
return

!^k::
Send, {Ctrl down}{Down}{Ctrl up}
return

;-------------------------------------------------
;按键: Ctrl + Shift + I / K
;功能: 上下两行互换位置
;注: 等价于 Ctrl + Shift + 上/下.
;在 sublime text 里是 indent 和 reindent 的作用,
;但可以用 Tab 和 Shift + Tab 替代;
;方便起见, 这里的上下左右不用再按 Alt.

+^i::
Send, {Shift down}{Ctrl down}{Up}{Ctrl up}{Shift up}
return

+^k::
Send, {Shift down}{Ctrl down}{Down}{Ctrl up}{Shift up}
return

;按键: Alt + Ctrl + 1~7
;功能: 修改为 HTML 样式的小标题, 其中 7 为正文
;注: 在 sublime 中为正常的输入顺序.
;以下快捷键在 sublime 里用的不多, 删了也行.
!^1::
Send, {home}
ascinput("<h1>")
Send, {end}
ascinput("</h1>")
Loop, 5 {
    Send, {Left}
}
return

!^2::
Send, {home}
ascinput("<h2>")
Send, {end}
ascinput("</h2>")
Loop, 5 {
    Send, {Left}
}
return

!^3::
Send, {home}
ascinput("<h3>")
Send, {end}
ascinput("</h3>")
Loop, 5 {
    Send, {Left}
}
return

!^4::
Send, {home}
ascinput("<h4>")
Send, {end}
ascinput("</h4>")
Loop, 5 {
    Send, {Left}
}
return

!^5::
Send, {home}
ascinput("<h5>")
Send, {end}
ascinput("</h5>")
Loop, 5 {
    Send, {Left}
}
return

!^6::
Send, {home}
ascinput("<h6>")
Send, {end}
ascinput("</h6>")
Loop, 5 {
    Send, {Left}
}
return

!^7::
Send, {home}
Loop, 4 {
    Send, {Right}
}
Loop, 4 {
    Send, {Backspace}
}
Send, {end}
Loop, 5 {
    Send, {Backspace}
}
return

;-------------------------------------------------
;按键: RAlt + ;/,
;功能: 选中多行后同时注释或取消注释
;注: RAlt 表示在右边的 Alt.

>!;::
Send, {Ctrl down}{Shift down}L{Shift up}{Ctrl up}   ; 选中多行
Send, {Left};   ; 注释
return

>!'::
Send, {Ctrl down}{Shift down}L{Shift up}{Ctrl up}   ; 选中多行
Send, {Left}{Right}{Backspace}  ; 取消注释
return

;-------------------------------------------------
;按键: LShift + 滚轮上下滚动
;功能: 页面向左向右滚动
;注: 在 sublime (文本编辑器) 中移动的速度与浏览器中不同

~LShift & WheelUp::  ; 向左滚动.
ControlGetFocus, fcontrol, A
loop, 3 {
    SendMessage, 0x0114, 0, 0, %fcontrol%, A  ; 0x0114 是 WM_HSCROLL, 它后面的 0 是 SB_LINELEFT.
}
return

~LShift & WheelDown::  ; 向右滚动.
ControlGetFocus, fcontrol, A
loop, 3 {
    SendMessage, 0x0114, 1, 0, %fcontrol%, A  ; 0x0114 是 WM_HSCROLL, 它后面的 1 是 SB_LINERIGHT.
}
return

#IfWinActive ; sublime text
;-------------------------------------------------



;----------------arduino 专用快捷键-----------------
;以下快捷键只在 arduino 中生效.
;请先下载 AutoHotkey 后, 修改下方的文件路径, 再运行本程序.
;注意 arduino 的编辑器程序不是 arduino.exe, 而是 java\bin\javaw.exe
#IfWinActive ahk_exe D:\Software\Arduino\java\bin\javaw.exe

;按键: Ctrl + L
;功能: 选中整行 (原功能为搜索行)

^l::
;Send, {Esc}{Home}{Shift down}{End}{Right}{Shift up}            ;不选中行首缩进
Send, {Esc}{End}{Home}{Home}{Shift down}{End}{Right}{Shift up}  ;选中行首缩进
return

#IfWinActive ; arduino
;-------------------------------------------------
