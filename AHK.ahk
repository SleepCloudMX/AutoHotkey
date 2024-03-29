﻿;------------------全局设置与函数定义------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; 注意换行 `n 和 `t 间还有一个原义空格
#Hotstring EndChars `n `t

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
    if ((str == "") || (StrLen(str) > maxLen)) {
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
        } ; 数字开头是允许的

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

;-------------------------------------------------
;取消字符串的 HTML 格式
; clearHTML(str) {
;     num := 0
;     Loop, parse, str, >     ; 此时大括号不能放在这一行
;     {
;         if (num = 1) {
;             str := A_LoopField
;             break
;         }
;         num := num + 1
;     }
;     Loop, parse, str, <
;     {
;         str := A_LoopField
;         return str
;     }
; }

clearHTML(str) {
    ; InStr(Haystack, Needle [, CaseSensitive?, StartingPos])
    sttPos := InStr(str, ">", false, 1) + 1     ; 从左开始
    endPos := InStr(str, "</", false, -1)       ; 从右开始, 这里的 -1 表示从倒数第二位, 如果是 0 则为倒数第一位
    len := endPos - sttPos                      ; [endPos, sttPos)
    return SubStr(str, sttPos, len)
}

;-------------------------------------------------
; 粘贴字符串
PasteStr(content) {
    SendMode Event  ; 防止剪切板修改错误
    temp := Clipboard
    Clipboard := content
    Send, {Ctrl down}v{Ctrl up}
    Clipboard := temp
}





;------------------热键与热字符串-------------------

;------------------一、通用快捷键--------------------
;按键: Alt + Ctrl + R
;功能: 重新运行脚本
#SingleInstance, force  ; 跳过对话框
!^r::
Run, AHK.ahk
return

;按键: Alt + I/J/K/L
;功能: 上下左右
!i::Send, {Up}
!j::Send, {Left}
!k::Send, {Down}
!l::Send, {Right}

;按键: Alt + H/;
;功能: 行首行尾
!h::Send, {home}
!;::Send, {end}

;按键: Alt + Shift + I/J/K/L
;功能: 选中字符
!+i::Send, {Shift down}{Up}{Shift up}
!+j::Send, {Shift down}{Left}{Shift up}
!+k::Send, {Shift down}{Down}{Shift up}
!+l::Send, {Shift down}{Right}{Shift up}

;按键: Alt + Shift + H/;
;功能: 选中这一行之前或之后的字符
!+h::Send, {Shift down}{Home}{Shift up}
!+;::Send, {Shift down}{End}{Shift up}

;按键: Alt + Ctrl + J/L
;功能: 跨词移动
!^j::Send, {Ctrl down}{Left}{Ctrl up}
!^l::Send, {Ctrl down}{Right}{Ctrl up}

;按键: Ctrl + Alt + H/;
;功能: 文件开始或结尾
!^h::Send, {Ctrl down}{Home}{Ctrl up}
!^;::Send, {Ctrl down}{End}{Ctrl up}

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
>+w::Send, {WheelUp}
>+s::Send, {WheelDown}
>+a::Send, {WheelLeft}
>+d::Send, {WheelRight}

;-------------------------------------------------
;按键: Esc + LShift
;功能: 最小化任意页面
;注: 建议按下 Esc 后按 LShift, 不过先按 LShift 也是可以的

~LShift & Esc::
~Esc & LShift::
Send, {Shift up}{Alt down}{Space}n{Alt up}
return

;-------------------------------------------------
;按键: Shift + NumLock
;功能: 只有这样才能关闭或启用数字锁
;注: 因为我经常误触, 就这样设置了

NumLock::
; 判断按键是否按下的函数
if GetKeyState(Shift, "F") {
    return
}
return

;-------------------------------------------------
;按键: CapsLock + D
;功能: 打开我的 To Do List & Diary
~CapsLock & D::Run E:\Notes\To Do List\%A_YYYY%.%A_MM%.md
; 以下代码时为了跳转至对应小标题, 但效果不是很好.
; filePath := "E:\Notes\To Do List\" A_YYYY "." A_MM ".md"
; Process, Exist, %filePath%
; if (ErrorLevel = 0) {
;     Run %filePath%
;     Sleep, 1500
;     Send, {Left}{Ctrl down}lc{Ctrl up}
;     if (SubStr(Clipboard, 1, 10) != "[Today](# ") {
;         Send, {Ctrl down}{Alt down};{Alt up}{Ctrl up}{Down}
;     }
;     Clipboard := "[Today](# " A_MM "." A_DD ")"
;     Send, {Ctrl down}vo{Ctrl up}
; } else {
;     Run %filePath%
; }
; return

;-------------------------------------------------
;按键: CapsLock + T
;功能: 打开 Notepad (text)
~CapsLock & T::Run notepad

;-------------------------------------------------
;按键: CapsLock + N
;功能: 打开 Mathematica 的 Notebook
~CapsLock & N::
mmaFolder := "D:\AppData\Mathematica\draft\"
mmaFolder := mmaFolder A_YYYY "." A_MM

if (FileExist(mmaFolder) != "D") {
    FileCreateDir, %mmaFolder%
} ; 如果文件夹不存在, 则创建文件夹
mmaFile := mmaFolder "\" A_MM "." A_DD ".nb"

if (!FileExist(mmaFile)) {
    FileAppend, Notebook[{}], %mmaFile%
} ; 如果 nb 文件不存在, 则创建 nb 文件

Run, %mmaFile%
return

;-------------------------------------------------
;按键: CapsLock + S
;功能: 打开网页进行搜索

~CapsLock & s::
clipTemp := Clipboard
Clipboard := ""
Send, {Ctrl down}c{Ctrl up}
if (Clipboard = "") {
    Clipboard := clipTemp
} ; 如果无选中内容, 则搜索复制内容

; 将所有回车替换成空格.
; 注意在 sublime 中不选中内容按复制, 会复制整行 (包括回车).
Clipboard := StrReplace(Clipboard, "`r`n", " ")
Clipboard := StrReplace(Clipboard, "`n", " ")
Clipboard := StrReplace(Clipboard, "`r", " ")

; outputFile 是暂存 HTML 的文件路径.
outputFile := "D:\AppData\AutoHotkey\Output\Search.html"
href := "https://cn.bing.com/search?q=" Clipboard
html =
(
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>必应</title>
</head>
<body>
    <Script>
        window.location.href = "%href%"
    </Script>
</body>
</html>
)

FileDelete, %outputFile%
FileAppend, %html%, %outputFile%
Run, %outputFile%

Clipboard := clipTemp
return



;-------------------------------------------------
;按键: RAlt + RCtrl + L
;功能: 禁用键盘
>!>^l::run utility\disableKeyboard.ahk

;按键: RAlt + RCtrl + M
;功能: 禁用鼠标
>!>^m::run utility\disableMouse.ahk

;-------------------------------------------------
;按键: Shift + Space
;功能: Shift, Space
~Shift & Space::Send, {Space}{Shift down}{Shift up}
;~Space & ~Shift::Send, {Shift down}{Shift up}
;~Space::Shift

;-------------------------------------------------
;触发: mma
;替换: mathematica
; Typora 中代码环境有 JavaScript 也有 js, 有 mathematica 但是没有 mma...
:C?*:``````mma::``````mathematica
:C?*:\mma`n::``````mathematica`n
:C?*:\mma ::``````mathematica`n

;-------------------------------------------------
;触发: (**
;替换: (*  *)

; B0 表示保留触发字符串, X 表示执行函数而非替换文本
:B0*:(**::
SendMode Input
Send, {Left}{Space 2}{Left}
return

;-------------------------------------------------
;按键: Alt + /
;功能: 输出顿号
;注: 因为我一般使用英文标点, 但是顿号又很常用, 就写了这个.
!/::Send 、
!,::Send 《》{Left}
!.::Send 。

;-------------------------------------------------
;触发: ~ + 1/2/3/4
;功能: 分别输出 -, –, —, ⸺
;注: 分别对于 hyphen, en hyphen, em hyphen, 中文破折号
~~ & 1::Send {Backspace}`-
~~ & 2::Send {Backspace}–
~~ & 3::Send {Backspace}—
~~ & 4::Send {Backspace}⸺

;-------------------------------------------------
;触发: `omega` 等
;功能: 输出希腊字母
;注: 在 mathematica 也可以用哦~

; 小写希腊字母
:*C0:``alpha``::α
:*C0:``beta``::β
:*C0:``gamma``::γ
:*C0:``deleta``::δ
:*C0:``epsilon``::ϵ
:*C0:``zeta``::ζ
:*C0:``eta``::η
:*C0:``theta``::θ
:*C0:``iota``::ι
:*C0:``kappa``::κ
:*C0:``lambda``::λ
:*C0:``mu``::μ
:*C0:``nu``::ν
:*C0:``xi``::ξ
:*C0:``omicron``::ο
:*C0:``pi``::π
:*C0:``rho``::ρ
:*C0:``sigma``::σ
:*C0:``tau``::τ
:*C0:``upsilon``::υ
:*C0:``phi``::ϕ     ; it's not curl phi!!! What a terrible font
:*C0:``chi``::χ
:*C0:``psi``::ψ
:*C0:``omega``::ω

:*C0:``varepsilon``::ε
:*C0:``varsigma``::ς
:*C0:``varphi``::φ   ; it's curl phi!!!
:*C0:``vartheta``::ϑ

; 大写希腊字母
:*C0:``Alpha``::Α
:*C0:``Beta``::Β
:*C0:``Gamma``::Γ
:*C0:``Deleta``::Δ
:*C0:``Epsilon``::Ε
:*C0:``Zeta``::Ζ
:*C0:``Eta``::Η
:*C0:``Theta``::Θ
:*C0:``Iota``::Ι
:*C0:``Kappa``::Κ
:*C0:``Lambda``::Λ
:*C0:``Mu``::Μ
:*C0:``Nu``::Ν
:*C0:``Xi``::Ξ
:*C0:``Omicron``::Ο
:*C0:``Pi``::Π
:*C0:``Rho``::Ρ
:*C0:``Sigma``::Σ
:*C0:``Tau``::Τ
:*C0:``Upsilon``::Υ
:*C0:``Phi``::Φ
:*C0:``Chi``::Χ
:*C0:``Psi``::Ψ
:*C0:``Omega``::Ω




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

; 思路 1
:X*:emos::ascinput(":star:")
; 思路 2
;:X*:emos::PasteStr(":star:")

; 思路 1
:X*:emoc::ascinput(":crescent_moon:")
; 思路 2
;:X*:emos::PasteStr(":crescent_moon:")

;-------------------------------------------------
;按键: Alt + 1~7
;功能: 修改为 HTML 样式的小标题, 其中 7 为正文

!1::
clipTemp := Clipboard
Clipboard := ""     ; 这是好习惯 (不然电脑卡顿会很难受...)

Send, {Home}{Ctrl down}lc{Ctrl up}  ; 这里的 {home} 是有必要的, 如果用户在使用快捷键前已选中整行, 且从右向左勾选, 则该快捷键无法正常使用.
titlePrefix := "<h"
thisTitlePrefix := "<h1"    ; 注意到用户可能会用 <h1> 或 <h2 align="center">
if (InStr(Clipboard, thisTitlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
} else if (InStr(Clipboard, titlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
    Clipboard := "<h1>" Clipboard "</h1>"
} else {
    Clipboard := "<h1>" Clipboard "</h1>"
}
Send, {Ctrl down}v{Ctrl up}

Clipboard := clipTemp
return



!2::
clipTemp := Clipboard
Clipboard := ""

Send, {Home}{Ctrl down}lc{Ctrl up}
titlePrefix := "<h"
thisTitlePrefix := "<h2"
if (InStr(Clipboard, thisTitlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
} else if (InStr(Clipboard, titlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
    Clipboard := "<h2>" Clipboard "</h2>"
} else {
    Clipboard := "<h2>" Clipboard "</h2>"
}
Send, {Ctrl down}v{Ctrl up}

Clipboard := clipTemp
return



!3::
clipTemp := Clipboard
Clipboard := ""

Send, {Home}{Ctrl down}lc{Ctrl up}
titlePrefix := "<h"
thisTitlePrefix := "<h3"
if (InStr(Clipboard, thisTitlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
} else if (InStr(Clipboard, titlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
    Clipboard := "<h3>" Clipboard "</h3>"
} else {
    Clipboard := "<h3>" Clipboard "</h3>"
}
Send, {Ctrl down}v{Ctrl up}

Clipboard := clipTemp
return



!4::
clipTemp := Clipboard
Clipboard := ""

Send, {Home}{Ctrl down}lc{Ctrl up}
titlePrefix := "<h"
thisTitlePrefix := "<h4"
if (InStr(Clipboard, thisTitlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
} else if (InStr(Clipboard, titlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
    Clipboard := "<h4>" Clipboard "</h4>"
} else {
    Clipboard := "<h4>" Clipboard "</h4>"
}
Send, {Ctrl down}v{Ctrl up}

Clipboard := clipTemp
return



!5::
clipTemp := Clipboard
Clipboard := ""

Send, {Home}{Ctrl down}lc{Ctrl up}
titlePrefix := "<h"
thisTitlePrefix := "<h5"
if (InStr(Clipboard, thisTitlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
} else if (InStr(Clipboard, titlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
    Clipboard := "<h5>" Clipboard "</h5>"
} else {
    Clipboard := "<h5>" Clipboard "</h5>"
}
Send, {Ctrl down}v{Ctrl up}

Clipboard := clipTemp
return



!6::
clipTemp := Clipboard
Clipboard := ""

Send, {Home}{Ctrl down}lc{Ctrl up}
titlePrefix := "<h"
thisTitlePrefix := "<h6"
if (InStr(Clipboard, thisTitlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
} else if (InStr(Clipboard, titlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
    Clipboard := "<h6>" Clipboard "</h6>"
} else {
    Clipboard := "<h6>" Clipboard "</h6>"
}
Send, {Ctrl down}v{Ctrl up}

Clipboard := clipTemp
return



!7::
!0::
clipTemp := Clipboard
Clipboard := ""

Send, {Home}{Ctrl down}lc{Ctrl up}
titlePrefix := "<h"
if (InStr(Clipboard, titlePrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
} else {
    ; no need for HTML
}
Send, {Ctrl down}v{Ctrl up}

Clipboard := clipTemp
return



;-------------------------------------------------
;按键: Alt + =/-
;功能: 修改 HTML 样式的小标题至上一级或下一级

!=::
clipTemp := Clipboard
Clipboard := ""

Send, {Home}{Ctrl down}lc{Ctrl up}
titlePrefix := "<h"
if (InStr(Clipboard, titlePrefix, false) = 1) {
    titleRank := Asc(SubStr(Clipboard, 3, 1)) - 48 - 1  ; 转为整数并减一
    if (1 <= titleRank and titleRank < 6) {
        Clipboard := clearHTML(Clipboard)
        Clipboard := "<h" titleRank ">" Clipboard "</h" titleRank ">"
    } ; 正常情况下为 0-5, 其中 0 不作处理, 即保持为 1
} else {
    Clipboard := "<h6>" Clipboard "</h6>"
} ; 如果为正文, 则设置为六级标题
Send, {Ctrl down}v{Ctrl up}

Clipboard := clipTemp
return



!-::
clipTemp := Clipboard
Clipboard := ""

Send, {Home}{Ctrl down}lc{Ctrl up}
titlePrefix := "<h"
if (InStr(Clipboard, titlePrefix, false) = 1) {
    titleRank := Asc(SubStr(Clipboard, 3, 1)) - 48 + 1  ; 转为整数并减一
    Clipboard := clearHTML(Clipboard)   ; 注意这行代码与前一个快捷键不一样, 因为想要实现的功能的逻辑不同
    if (1 < titleRank and titleRank <= 6) {
        Clipboard := "<h" titleRank ">" Clipboard "</h" titleRank ">"
    } ; 正常情况下为 1-7, 其中 7 直接取消 HTML 格式即可
} ; 否则已处于正文格式, 无需处理
Send, {Ctrl down}v{Ctrl up}

Clipboard := clipTemp
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
;按键: Alt + M
;功能: 分别为行内公式和取消行内公式
;注: 需要在设置里启用行内公式 (LaTeX 语法)

!m::
clipTemp := Clipboard
Clipboard := ""

; 如果有选中文字, 则直接处理选中内容
Send, {Ctrl down}c{Ctrl up}
if (Clipboard != "") {
    isMathMode := false
    if (SubStr(Clipboard, 1, 2) = "$ ") {
        Clipboard := SubStr(Clipboard, 3, StrLen(Clipboard) - 2)
    } else if (SubStr(Clipboard, 1, 1) = "$") {
        Clipboard := SubStr(Clipboard, 2, StrLen(Clipboard) - 1)
    } else {
        Clipboard := "$ " Clipboard
        isMathMode := true
    } ; 处理首位

    if (isMathMode = false) {
        if (SubStr(Clipboard, StrLen(Clipboard) - 1, 2) = " $") {
            Clipboard := SubStr(Clipboard, 1, StrLen(Clipboard) - 2)
        } else if (SubStr(Clipboard, StrLen(Clipboard), 1) = "$") {
            Clipboard := SubStr(Clipboard, 1, StrLen(Clipboard) - 1)
        } ; 其它情况不作处理
    } else {
        if (SubStr(Clipboard, StrLen(Clipboard), 1) != "$") {
            Clipboard := Clipboard " $"
        } else if (SubStr(Clipboard, StrLen(Clipboard) - 1, 1) != " ") {
            Clipboard := SubStr(Clipboard, 1, StrLen(Clipboard) - 1)
            Clipboard := Clipboard " $"
        } ; 是数学模式
    } ; 处理末位, 模式依首位而定

    Send, {Ctrl down}v{Ctrl up}
    return
}

; 获取该行前后信息
Send, {Shift down}{Home}{Shift up}{Ctrl down}c{Ctrl up}
lineBefore := Clipboard
Clipboard := ""     ; 如果电脑高延迟, 则下面的 Ctrl + C 无法成功复制, 所以加上这行代码

Send, {Shift down}{End}{Shift up}{Ctrl down}c{Ctrl up}
lineAfter := CLipboard
Clipboard := ""

; 处理左侧字符串
isEscaped := false  ; 是否转义
leftCharNum := 0    ; 左边的字符数量
leftNum := 0        ; 左边的美元符号数量
leftPos := 0        ; 最右侧美元号的位置
Loop, Parse, lineBefore
{
    leftCharNum := leftCharNum + 1
    if (A_LoopField = "$" and isEscaped = false) {
        leftNum := leftNum + 1
        leftPos := leftCharNum
    } else if (A_LoopField = "\" and isEscaped = false) {
        isEscaped := true   ; 注意反斜杠可以转义反斜杠
    } else if (isEscaped = true) {
        isEscaped := false
    } ; 注意 AHK 使用 ` 而 typora 使用 \ 转义
}

; 处理右侧字符串
isEscaped := false  ; 是否转义
rightCharNum := 0   ; 右边的字符数量
rightNum := 0       ; 右边的美元符号数量
rightPos := 0       ; 最左侧美元号的位置
Loop, Parse, lineAfter
{
    rightCharNum := rightCharNum + 1
    if (A_LoopField = "$" and isEscaped = false) {
        rightNum := rightNum + 1
        if (rightPos = 0) {
            rightPos := rightCharNum
        }
    } else if (A_LoopField = "\" and isEscaped = false) {
        isEscaped := true   ; 注意反斜杠可以转义反斜杠
    } else if (isEscaped = true) {
        isEscaped := false
    } ; 注意 AHK 使用 ` 而 typora 使用 \ 转义
}

if (Mod(leftNum, 2) = 1 and Mod(rightNum, 2) = 1) {
    ; delelte $  $
    ; 处理输出字符串
    lenBefore := leftPos - 1
    lineBefore := SubStr(lineBefore, 1, lenBefore)
    lastChar := SubStr(lineBefore, StrLen(lineBefore), 1)
    if (lastChar = " ") {
        lineBefore := SubStr(lineBefore, 1, lenBefore - 1)
    }

    rightStart := rightPos + 1
    lenAfter := rightCharNum - rightPos
    lineAfter := SubStr(lineAfter, rightStart, lenAfter)
    nextChar := SubStr(lineAfter, 1, 1)
    if (nextChar = " ") {
        lineAfter := SubStr(lineAfter, 2, lenAfter - 1)
    }

    ; 此时前后均必有字符, 放心删就是了
    Send, {Backspace}{Shift down}{Home}{Shift up}{Backspace}
    Clipboard := lineAfter
    Send, {Ctrl down}v{Ctrl up}{Home}
    Clipboard := lineBefore
    Send, {Ctrl down}v{Ctrl up}
} else {
    ; add $  $
    ; 处理输出字符串
    inlineMathStr := "$  $"
    leftMoves := 2

    lastChar := SubStr(lineBefore, StrLen(lineBefore), 1)
    if (lineBefore != "" and lastChar != " " and lastChar != "`t" and lastChar != "(" and lastChar != "（") {
        inlineMathStr := " " inlineMathStr
    }

    nextChar := SubStr(lineAfter, 1, 1)
    if (lineAfter != "" and nextChar != " " and nextChar != "。" and nextChar != ")" and nextChar != "）") {
        if (and nextChar != "," and nextChar != "." and nextChar != "，") {
            inlineMathStr := inlineMathStr " "
            leftMoves := leftMoves + 1
        }
    }

    if (lineAfter != "") {
        Send, {Left}    ; 如果右边有字符, 则取消选中, 防止误删
    }
    if (lineBefore = " ") {
        Send, {Backspace}
    }
    if (lineAfter = " ") {
        Send, {Delete}
    }

    SwitchIME(0x04090409)   ; 切换至英文输入法, 方便输入公式
    Clipboard := inlineMathStr
    Send, {Ctrl down}v{Ctrl up}{Left %leftMoves%}
}

Clipboard := clipTemp
return



; 另一种有不足但更加快速的方法:
; ~Space & m::

; ~RAlt & m::
; clipTemp := Clipboard
; Clipboard := ""

; Send, {Shift down}{End}{Shift up}{Ctrl down}c{Ctrl up}
; if (Clipboard == "") {
;     Clipboard := " $  $"
;     Send, {Ctrl down}v{Ctrl up}{Left 2}
; } else {
;     len := StrLen(Clipboard)
;     mathPos := InStr(Clipboard, "$", false, 0)  ; 注意 0 是从最后一个字符开始向左遍历
;     if ( (1 <= mathPos) and (mathPos <= 5) and (len - mathPos <= 1) ) {
;         num := 6 - mathPos
;         Send, {Backspace %num%}
;     } else {
;         Clipboard := " $  $ "   ; 注意这里多了一个空格
;         Send, {Left}{Ctrl down}v{Ctrl up}{Left 3}
;     } ; 注意这里先 Send 了一个 {Left}
; }

; Clipboard := clipTemp
; return



;-------------------------------------------------
;按键: Alt + Ctrl + M
;功能: 刷新数学公式
;注: 因为这个功能用的频率不太高, 就用了三个键.
;自己写的快捷键大部分含 Alt, 所以就这样设置了.
;目前已使用 typora 自带的方式修改快捷键

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
; 由于不同环境下 typora 的自动补全机制不同, 不能直接输出, 只能采用复制粘贴的方式.

::\img::
imgstr_1 := "<img src='image\"
imgstr_2 := ".png' width=450 />"
temp := Clipboard
Clipboard := imgstr_2
Send, {Ctrl down}v{Ctrl up}{Home}
Clipboard := imgstr_1
Send, {Ctrl down}v{Ctrl up}
Clipboard := temp
return

; ::\img::
; PasteStr("<img src=""image\.png"" width=450 />")
; SendMode Input
; Send, {Left 17}
; return

;-------------------------------------------------
;按键: "\att" + Enter
;功能: 标注格式

::\att::
temp := Clipboard
Clipboard := ""     ; 这一步是有必要的, 因为无法保障下一行被正确的运行 (悲)
Clipboard := "<span style='background-color: #eeeeee; color: #777777'></span>"
; 应减少粘贴的次数, 以降低出错的概率
Send, {Ctrl down}v{Ctrl up}{Left 7}
Clipboard := temp
return

;-------------------------------------------------
;按键: "\quote" + Enter
;功能: 引用格式

::\quote::
temp := Clipboard
Clipboard := ""
Clipboard = <span style="border-left: 4px solid #dfe2e5; padding: 0 15px; color: #777777; padding-right: 0;"></span>
Send, {Ctrl down}v{Ctrl up}{Left 7}
Clipboard := temp
return



;-------------------------------------------------
;按键: "\dquote" + Enter
;功能: 多行引用格式

::\dquote::
temp := Clipboard
Clipboard := ""
Clipboard =
(
<div style="border-left: 4px solid #dfe2e5; padding: 0 15px; color: #777777; padding-right: 0;">
</div>
)
Send, {Ctrl down}v{Ctrl up}{Up}{End} ;{Enter}
Clipboard := temp
return



;-------------------------------------------------
;按键: "\ggb" + Enter / Tab / Space
;功能: 在 Geogebra 网页中复制分享链接后,
;在 typora 中输入 htmlggb 并回车 (或其它按键),
;则可以自动生成 HTML 代码, 显示按钮.
;转为 HTML 后, 按下按钮即可在页面内显示 Geogebra 绘制的图像, 并可以交互.
;注: 同一文件中如果想多次使用同一图像, 请使用 \ggbdef 自定义编号, 否则只有第一个有效.
;具体说明见 README

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
    &emsp;或直接打开<a href="%webstr%">网页链接</a>
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
;具体说明见 README

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
    &emsp;或直接打开<a href="%webstr%">网页链接</a>
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
clearHotStringCMD()
Clipboard = %htmlstr%
Send, {Ctrl down}v{Ctrl up}{Down}
Clipboard = %webstr%    ; 有借有还, 是好文明
return

;-------------------------------------------------
;按键: CapsLock + C
;功能: 修改文字颜色
;具体说明见 README

~CapsLock & c::
temp := Clipboard
Clipboard := ""     ; 这是为了防止用户没有选中文字
Send, {Ctrl down}c{Ctrl up}

colorPrefix1 := "<font color="
colorPrefix2 := "<span style="
if (InStr(Clipboard, colorPrefix1, false) = 1 or InStr(Clipboard, colorPrefix2, false) = 1) {
    Clipboard := clearHTML(Clipboard)
} ; 若已为 HTML 代码, 则取消 HTML 格式

; 恢复剪切板, 因为用户输入颜色时可能直接复制粘贴
temp2 := Clipboard
Clipboard := temp
textColor := ""
; SwitchIME(0x04090409)
InputBox, textColor, 设置颜色, 请输入颜色，可以用颜色的英文名、RGB 或十六进制颜色码.`n若不输入任何内容，则默认为黑色., SHOW, , , , , , , blue
Clipboard := temp2

if (textColor = "" or textColor = " " or textColor = "  " or textColor = "``") {
    ; 若为空字符串, 则不作处理, 并且没有 {Left 7}
    Send, {Ctrl down}v{Ctrl up}
} else {
    Clipboard := "<span style=""color: " textColor """>" Clipboard "</span>"
    Send, {Ctrl down}v{Ctrl up}{Left 7}
}

Clipboard := temp
return

;-------------------------------------------------
;按键: CapsLock + V
;功能: 恢复文字默认颜色
;具体说明见 README

~CapsLock & v::
temp := Clipboard
Clipboard := ""
Send, {Ctrl down}c{Ctrl up}

colorPrefix := "<font color="
if (InStr(Clipboard, colorPrefix, false) = 1) {
    Clipboard := clearHTML(Clipboard)
} ; 若为 HTML 代码, 则取消 HTML 格式
Send, {Ctrl down}v{Ctrl up}

Clipboard := temp
return

;-------------------------------------------------
; 按键: Alt + %
; 功能: 注释

!t::
clipTemp := Clipboard
Clipboard := ""

Send, {Ctrl down}c{Ctrl up}
if (Clipboard = "") {
    Send, {Shift down}{Home}{Shift up}{Ctrl down}c{Ctrl up}
    if (Clipboard != "" and SubStr(Clipboard, 1, 1) = "`%") {
        Clipboard := SubStr(Clipboard, 2, StrLen(Clipboard) - 1)
        if (SubStr(Clipboard, 1, 1) = " ") {
            Clipboard := SubStr(Clipboard, 2, StrLen(Clipboard) - 1)
        } ; 也可以先判断是否为 " `%"
    } else {
        Clipboard := "`% " Clipboard
    }
} else {
    outputStr := ""
    Loop, Parse, Clipboard, "`n"
    {
        temp := ""
        if (SubStr(A_LoopField, 1, 1) = "`%") {
            temp := SubStr(A_LoopField, 2, StrLen(A_LoopField) - 1)
            if (SubStr(temp, 1, 1) = " ") {
                temp := SubStr(temp, 2, StrLen(temp) - 1)
            }
        } else {
            temp := "`% " A_LoopField "`n"
        }
        outputStr := outputStr temp
    }
    if (SubStr(outputStr, StrLen(outputStr), 1) = "`n") {
        outputStr := SubStr(outputStr, 1, StrLen(outputStr) - 1)
    }
    Clipboard := outputStr
}
Send, {Ctrl down}v{Ctrl up}{End}    ; 一定要加 End, typora 有点 bug.

Clipboard := clipTemp
return



;-------------------------------------------------
;按键: Ctrl + w
;功能: 保存后关闭
^w::Send, {Ctrl down}sw{Ctrl up}
; temp := Clipboard
; Clipboard := ""
; Send, {Ctrl down}swc{Ctrl up}
; if (SubStr(Clipboard, StrLen(Clipboard) - 2, 3) = ".md") {
;     Send, {Esc}{Tab 2}{Enter}
; }
; Clipboard := temp
; return

;-------------------------------------------------
;按键: Ctrl + q
;功能: 不保存直接关闭
;除了 Ctrl + W, 还可以使用 Alt + F4 (Fn Lock)
^q::Send, {Alt down}{F4}{Alt up}{Tab 2}{Enter}


;-------------------------------------------------
;按键: $$
;功能: 替换为 `$  $` 并左移两格.
:?Z*:$$::
Send, $  ${Left 2}
return

;-------------------------------------------------
;按键: "\[" + Enter / Tab / Space
;功能: 进入数学模式; 这个是真的方便.
;问号 ? 是有必要的
:?:\[::
Send, $$`n  ; 我不理解, 但是放在一行里写就会多输出一个空格.
return

;-------------------------------------------------
;触发: __
;功能: 替换为 `~~` 并左移一格.
;备注: 还是这样写下标方便.
:Z*?X:__::Send ~~{Left}

;-------------------------------------------------
;触发: ^^
;功能: 不替换, 左移一格.
;备注: 上标
:Z*?B0X:^^::Send {Left}

;-------------------------------------------------
;触发: **
;功能: 替换为 **** 并左移两格
;备注: 粗体
:Z*?B0X:**::Send **{Left 2}


;-------------------------------------------------
;按键: "\details" + Enter / Tab / Space
;功能: HTML 点击展开内容.

::\details::
temp := Clipboard
Clipboard := ""     ; 这一步是有必要的
Clipboard =
(
<div style="background-color: #f3f2ee">
    <details>
        <summary><b>
        </b></summary>
        <iframe src="ifsrc\.html" height=600></iframe>
    </details>
</div>
)
; SendMode Input
Send, {Ctrl down}v{Ctrl up}{Up 4}{End}
Clipboard := temp
return

;-------------------------------------------------
;按键: "\proof" + Enter / Tab / Space
;功能: HTML 点击展开证明.

::\proof::
temp := Clipboard
Clipboard := ""     ; 这一步是有必要的
Clipboard =
(
<div style="background-color: #f3f2ee">
    <details>
        <summary><b>证明</b>
        </summary>
        <iframe src="ifsrc\.html" height=600></iframe>
    </details>
</div>
)
; SendMode Input
Send, {Ctrl down}v{Ctrl up}{Up 4}{End}{Left}{Down 2}{Right}
Clipboard := temp
return

#IfWinActive ; typora
;-------------------------------------------------




;-----------Typora 与 Sublime 共用快捷键------------
; 这里不再使用 #IfWinActive

; 用于补全 LaTeX 环境的代码
; env 是环境名, isTab 指是否缩进, opt 是环境的可选项
SendLaTeXEnv(env, isTab:=true, opt:="") {
    if !WinActive("ahk_exe D:\Software\Typora\Typora.exe")
    ; and !WinActive("ahk_exe D:\Program Files (x86)\Tencent\TeXstudio\texstudio.exe")
    and !WinActive("ahk_exe D:\Software\Sublime Text\sublime_text.exe") {
        return
    } ; 仅 Typora 和 Sublime 使用
    SendMode Input  ; 提高输出字符的速度与稳定性
    #LTrim, On      ; 允许多行字符串缩进, 即自动删除行首缩进与空格
    SendRaw,
    (
        \begin{%env%}%opt%

        \end{%env%}
    )
    Send, {Up}
    if (isTab) {
        Send, {Tab}
    }
}

; 大部分情况下都不删除首行缩进与空格
#Ltrim, Off

; 选项 X 用于执行函数, 而非取代文本 (否则一个热字串要三行代码)
; 选项 C 用于区分大小写
; 选项 ? 用于保证每一次输入触发字符串时都能触发,
; 没有 ? 的话, 反斜杠 \ 有时会被认为在另一个单词里而无法触发.
:CX?:\align::SendLaTeXEnv("align", false)
:CX?:\aligned::SendLaTeXEnv("aligned")
:CX?:\cases::SendLaTeXEnv("cases")
:CX?:\array::SendLaTeXEnv("array", false, "{c}")
:CX?:\equation::SendLaTeXEnv("equation", false)
:CX?:\gather::SendLaTeXEnv("gather", false)
:CX?:\eqnarray::SendLaTeXEnv("eqnarray")   ; 别用 eqnarray
:CX?:\matrix::SendLaTeXEnv("matrix")
:CX?:\pmatrix::SendLaTeXEnv("pmatrix")
:CX?:\bmatrix::SendLaTeXEnv("bmatrix")
:CX?:\Bmatrix::SendLaTeXEnv("Bmatrix")
:CX?:\vmatrix::SendLaTeXEnv("vmatrix")
:CX?:\Vmatrix::SendLaTeXEnv("Vmatrix")

:CX?:\mat::SendLaTeXEnv("mat", true, "{c}")
:CX?:\pmat::SendLaTeXEnv("pmat", true, "{c}")
:CX?:\bmat::SendLaTeXEnv("bmat", true, "{c}")
:CX?:\Bmat::SendLaTeXEnv("Bmat", true, "{c}")
:CX?:\vmat::SendLaTeXEnv("vmat", true, "{c}")
:CX?:\Vmat::SendLaTeXEnv("Vmat", true, "{c}")



; 星号表示无需终止符来触发热字串
; B0 表示不进行自动退格来擦除输入的缩写
; {}} 用于转义 }
; {{} 用于转义 { (好奇怪的转义方式...)
; 注: 不要通过调用函数输出, 虽然方便, 但是在 SendMode 不是 Input 的情况下很慢,
; 使用复制粘贴的方式不稳定, 也不建议使用.

; 两对括号
:*B0C?:\frac{::{}}{{}{}}{Left 3}
:*B0C?:\dfrac{::{}}{{}{}}{Left 3}
:*B0C?:\tfrac{::{}}{{}{}}{Left 3}
:*B0C?:\cfrac{::{}}{{}{}}{Left 3}

:*B0C?:\binom{::{}}{{}{}}{Left 3}
:*B0C?:\dbinom{::{}}{{}{}}{Left 3}
:*B0C?:\overset{::{}}{{}{}}{Left 3}

:*B0C?:\soneto{::{}}{{}{}}{Left 3}
:*B0C?:\splus{::{}}{{}{}}{Left 3}
:*B0C?:\ddf{::{}}{{}{}}{Left 3}
:*B0C?:\pvcn{::{}}{{}{}}{Left 3}
:*B0C?:\DV{::{}}{{}{}}{Left 3}

; 三对括号
:*B0C?:\ssto{::{}}{{}{}}{{}{}}{Left 5}
:*B0C?:\ssup{::{}}{{}{}}{{}{}}{Left 5}
:*B0C?:\dddf{::{}}{{}{}}{{}{}}{Left 5}
:*B0C?:\pmcmn{::{}}{{}{}}{{}{}}{Left 5}
:*B0C?:\nDV{::{}}{{}{}}{{}{}}{Left 5}



;----------------sublime 专用快捷键-----------------
;以下快捷键只在 sublime text 中生效.
;之所以分开写, 是因为大部分软件没有选中多行同时输入的功能.
#IfWinActive ahk_exe D:\Software\Sublime Text\sublime_text.exe

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



;----------------Arduino 专用快捷键-----------------
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



;----------------Edge 专用快捷键-----------------
;以下快捷键只在 Microsoft Edge 中生效.
#IfWinActive ahk_exe C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe

;按键: Alt + 数字
;功能: 切换标签页, 功能同 Ctrl + 数字
!1::Send, {Ctrl down}1{Ctrl up}
!2::Send, {Ctrl down}2{Ctrl up}
!3::Send, {Ctrl down}3{Ctrl up}
!4::Send, {Ctrl down}4{Ctrl up}
!5::Send, {Ctrl down}5{Ctrl up}
!6::Send, {Ctrl down}6{Ctrl up}
!7::Send, {Ctrl down}7{Ctrl up}
!8::Send, {Ctrl down}8{Ctrl up}
!9::Send, {Ctrl down}9{Ctrl up}
!0::Send, {Ctrl down}0{Ctrl up}

;按键: Alt + -/+
;功能: 切换至上一标签页或下一标签页
!=::Send, {Ctrl down}{Tab}{Ctrl up}
!-::Send, {Ctrl down}{Shift down}{Tab}{Shift up}{Ctrl up}

#IfWinActive ; Microsoft Edge


;----------------TeXstudio 专用快捷键-----------------
;以下快捷键只在 TeXstudio 中生效.
#IfWinActive ahk_exe D:\Program Files (x86)\Tencent\TeXstudio\texstudio.exe

;触发: \figure
;功能: 生成 LaTeX 插入图片的代码.

::\figure::
content =
(
\begin{figure}[!htbp]
    \centering
    \includegraphics[width=\textwidth]{figure/}
    \caption{}
\end{figure}
)
PasteStr(content)
Send, {Up 2}{End}{Left}
return

#IfWinActive ; TeXStudio
