;------------------全局变量与函数定义------------------

;切换输入法的函数
;切换为英文输入法: SwitchIME(0x04090409)
;切换为中文输入法: SwitchIME(00000804)
SwitchIME(dwLayout){
    HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus,ctl,A
    SendMessage,0x50,0,HKL,%ctl%,A
}

;或者直接使用以下命令也可以切换输入法
;PostMessage, 0x50, 0, 0x4090409, , A
;PostMessage, 0x50, 0, 00000804, , A

;绕过输入法直接输入字符
;说明: 在 QQ 聊天窗口中是乱码，需要发送 UTF-16BE 编码
ascinput(string){
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
 
 
ascaltinput(string){
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
;注: 需要等待约 1.0 秒, 期间请勿输入其它字符.

::img::
ascinput("<img src='image\.png' width=450>")
loop, 16 {
    Send, {Left}
}
return

;-------------------------------------------------
;按键: "htmlatt" + Enter
;功能: 替换为 "<span style='background-color: #eeeeee; color: #777777'></span>"
;并将光标移至 </span> 前
;注: 需要等待一秒多, 期间请勿输入其它字符.

::htmlant::
ascinput("<span style='background-color: #eeeeee; color: #777777'></span>")
loop, 7 {
    Send, {Left}
}
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
