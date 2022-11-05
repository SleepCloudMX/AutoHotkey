; 按键: Alt + Ctrl + m
; 功能: 合并单元格

mergeLineCells(numM) {
	times := numM - 1
	Send, {Shift down}
	loop, %times% {
		Send, {Up}
	}
	Send, {Shift up}{Ctrl down}m{Ctrl up}
	loop, 8 {
		Send, {Right}
	}
	loop, 4 {
		Send, {Shift down}
		loop, %times% {
			Send, {Down}
		}
		Send, {Shift up}{Ctrl down}m{Ctrl up}{Right}
	}
	loop, 12 {
		Send, {Left}
	}
	Send, {Down}
}



!^m::
tempClipboard := Clipboard

numM := 0
maxM := 3

Sleep, 200	; 缓冲时间, 用于松开按键
loop {
	loop {
		Send, {Down}{Ctrl down}c{Ctrl up}
		numM := numM + 1
		teamID := Clipboard
		if (numM >= maxM) {
			Send, {Right}{Right}
			loop {
				Send, {Ctrl down}c{Ctrl up}
				member := Clipboard
				if (member != "`r`n") {
					break
				} else {
					Send, {Up}
					numM := numM - 1
				}
			}
			Send, {Left}{Left}
			numM := numM + 1
			mergeLineCells(numM)
			return
		}
		if (teamID != "`r`n") {
			Send, {Up}
			mergeLineCells(numM)
			break
		}
	}
	numM := 0
}

Clipboard := tempClipboard
return
