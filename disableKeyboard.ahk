#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MsgBox, 已禁用键盘！`n按 Esc 可重新启用键盘。

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
