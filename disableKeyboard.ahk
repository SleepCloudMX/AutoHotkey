#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MsgBox, 已禁用键盘！`n按 Esc 可重新启用键盘。
Send, {sc163}

SC163::

Tab::
CapsLock::
LShift::
RShift::
LCtrl::
RCtrl::
Lwin::
Rwin::
LAlt::
RAlt::
Space::
PrintScreen::
PgUp::
PgDn::
Left::
Right::
Down::
Up::
Enter::
BackSpace::
Delete::
Insert::
End::
Home::
ScrollLock::

a::
b::
c::
d::
e::
f::
g::
h::
i::
j::
k::
l::
m::
n::
o::
p::
q::
r::
s::
t::
u::
v::
w::
x::
y::
z::

F1::
F2::
F3::
F4::
F5::
F6::
F7::
F8::
F9::
F10::
F11::
F12::
; 有的电脑还有 F13 - 24
F13::
F14::
F15::
F16::
F17::
F18::
F19::
F20::
F21::
F22::
F23::
F24::

Browser_Back::	;后退
Browser_Forward::	;前进
Browser_Refresh::	;刷新
Browser_Stop::	;停止
Browser_Search::	;搜索
Browser_Favorites::	;收藏夹
Browser_Home::	;主页
Volume_Mute::	;静音
Volume_Down::	;调低音量
Volume_Up::	;增加音量
Media_Next::	;下一首
Media_Prev::	;上一首
Media_Stop::	;停止
Media_Play_Pause::	;播放/暂停
Launch_Mail::	;打开默认的电子邮件程序
Launch_Media::	;打开默认的媒体播放器
Launch_App1::	;打开我的电脑
Launch_App2::	;打开计算器

AppsKey::
CtrlBreak::
Pause::
Help::
Sleep::

SC03F::

Numpad0::
NumpadIns::
Numpad1::
NumpadEnd::
Numpad2::
NumpadDown::
Numpad3::
NumpadPgDn::
Numpad4::
NumpadLeft::
Numpad5::
NumpadClear::
Numpad6::
NumpadRight::
Numpad7::
NumpadHome::
Numpad8::
NumpadUp::
Numpad9::
NumpadPgUp::
NumpadDot::
NumpadDel::
NumLock::
NumpadDiv::
NumpadMult::
NumpadSub::
NumpadAdd::
NumpadEnter::

`::	; 转义转义符
~::
1::
!::
2::
@::
3::
#::
4::
$::
5::
%::
6::
^::
7::
&::
8::
*::
9::
(::
0::
)::
-::
_::
=::
+::
[::
{::
]::
}::
\::
|::
`;::	; 转义分号
:::		; 冒号无需转义
'::		; 这是单引号
"::		; 这是双引号
,::
<::		; 无需转义
.::
>::		; 无需转义
/::
?::

return

~Esc::
MsgBox, 已启用键盘！`n按 RAlt + RCtrl + L 可禁用键盘。
ExitApp
return
