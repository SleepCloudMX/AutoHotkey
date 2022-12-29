#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MsgBox, 已禁用鼠标右键！`n按 Esc 可重新启用鼠标右键。

RButton::return

~Esc::
MsgBox, 已启用鼠标右键！`n按 RAlt + RCtrl + M 可禁用鼠标右键
ExitApp
