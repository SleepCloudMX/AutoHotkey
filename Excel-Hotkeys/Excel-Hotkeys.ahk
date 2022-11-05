; Excel 的快捷键
; 下载 AutoHotkey 软件后, 双击运行这个文件.
; 同时按下 Ctrl 和 0 后会自动向下填充列.
; 同时按下 Ctrl 和 - 后会自动向右填充行.
; 其中单元格的行或列的大小可以不相同.
; 每次修改下面三个值后, 需要重新运行这个文件.
; 不想用了关掉这个程序就行.

numStart := 3		; 第一个数字
numEnd := 10		; 最后一个数字
increment := 1		; 相邻两个数的间隔

^0::
num := numStart
times := numEnd - numStart + 1
loop, %times% {
	Send, %num%{Enter}
	num := num + increment
}
return

^-::
num := numStart
times := numEnd - numStart + 1
loop, %times% {
	Send, %num%{Tab}
	num := num + increment
}
return
