# 说明文档

## 前言

我写快捷键主要是想替换掉那几个很小容易按错的上下左右键 (尤其是容易按到 PgUp 和 PgDn), 使打字更方便一点. 之后也逐渐增加了一些其它的功能.

想要使用的话, 先去 [官网](https://www.autohotkey.com/) 下载 AutoHotkey (软件自带教程), 双击 AHK.ahk 文件即可运行程序. 更新: 发现了 [中文教程](https://wyagd001.github.io/zh-cn/docs/AutoHotkey.htm).

电脑每次开机时都需要运行才能使用, 如需设置开机自启, 在如下文件夹中放入 AHK.ahk 文件的快捷方式即可:
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp

如果与已有快捷键冲突, 请去 AHK.ahk 文件中用分号注释掉相应代码.
右键可用记事本等软件编辑; 想要语法高亮的话, 直接在 Sublime 或 VS code 里安装相应的包就可以了.

对于同时按下三个键的快捷键, 一般不可以连续使用, 不喜欢也可以注释掉.

有个 bug: 长按 Alt 与 J, 一段时间后可能会跳到文档最下侧, 类似于 Ctrl + J 的功能, 不过好像是 typora 的锅.

AutoHotkey 的快捷键响应时间略长于系统或其它软件自带的快捷键, 但绝大多数情况下不影响使用.
通过自定义函数输入较多字符时可能有明显的延迟, 我的评价是: 比手敲的快.

如需使用仅能在 typora 和 sublime 中使用的快捷键, 请去 AHK.ahk 修改对应路径 (在 `#IfWinActive ahk_exe` 后面修改).
另外, 我不会在 sublime 写 markdown, 所以也不会设置相应的快捷键, 而且本身也有冲突.

之后发现有的功能 sublime 已经有了, 而且自带快捷键更好... (比如注释可以用 Ctrl + /) 算了写都写了.

如果想自己编写代码的话, 有一些建议:
1. 仅输入字符时, 不建议使用自带的 Send 等命令, 因为在中文输入法下有 bug. 可以自定义函数绕开输入法 (见源文件);
2. 有多种方式切换输入法 (见源文件), 但在某些情况下都会有点 bug (误删字符), 可以自定义快捷键调用函数切换输入法, 并在需要切换输入法的快捷键中调用这些快捷键. 我也不知道这样为什么就没有 bug 了, 但是它能跑;
3. 最后, 如果你能正常使用字符串变量, 请浇浇我, 我使用官方文档里提供的两种定义方式, 输出结果都是空字符串.

注: Self-Introduction 文件夹里的程序用于介绍 (整活) 的场合.




## 快捷键说明

### 一、通用快捷键

;按键: Alt + I/J/K/L
;功能: 上下左右

;按键: Alt + H/;
;功能: 行首行尾

;按键: Alt + Shift + I/J/K/L
;功能: 选中字符

;按键: Alt + Shift + H/;
;功能: 选中这一行之前或之后的字符

;按键: Alt + Ctrl + J/L
;功能: 跨词移动

;按键: Alt + Ctrl + H/;
;功能: 文档的开始或结尾
;注: 等价于原来的 PgUp 和 PgDn

;按键: PgUp / PgDn
;功能: 无
;因为容易误触，就禁了这两个烦人的键.



### 二、Typora 快捷键

;按键: "emos"
;功能: 替换为 `:star:`
;按键: "emoc"
;功能: 替换为 `:crescent_moon:`
;注: 以上是为了方便在 typora 中输入常用 emoji 而设置的热字符串.
;别问, 问就是我喜欢星星和月亮.

;按键: Ctrl + Alt + 1~7
;功能: 修改为 HTML 样式的小标题, 其中 7 为正文
;注: 由于 HTML 输入环境的影响, 只能用了一个奇怪的顺序了.

;按键: Alt + M 和 Alt + Shift + M
;功能: 分别为行内公式和取消行内公式
;注: 需要在设置里启用行内公式 (LaTeX 语法)

;按键: "img" + Enter
;功能: 替换为 `<img src='image\.png' width=450>` 并将光标移至 .png 前
;注: 需要等待约 1.0 秒, 期间请勿输入其它字符.

;按键: "htmlatt" + Enter
;功能: 替换为 `<span style='background-color: #eeeeee; color: #777777'></span>`
;并将光标移至 `</span>` 前
;注: 需要等待一秒多, 期间请勿输入其它字符.



### 三、Sublime 快捷键

;按键: Alt + Ctrl + I/K
;功能: 页面上 (下) 移一行
;注: 等价于 Ctrl + Alt + 上/下

;按键: Ctrl + Shift + I/K
;功能: 上下两行互换位置
;注: 等价于 Ctrl + Shift + 上/下.
;在 sublime text 里原为 indent 和 reindent 的效果,
;但可以用 Tab 和 Shift + Tab 替代;
;方便起见, 这里的上下左右不用再按 Alt.

;按键: Alt + Ctrl + 1~7
;功能: 修改为 HTML 样式的小标题, 其中 7 为正文
;注: 在 sublime 中为正常的输入顺序.

;按键: RAlt + ;/,
;功能: 选中多行后同时注释或取消注释
;注: RAlt 表示在右边的 Alt.

### 四、Arduino 快捷键

;按键: Ctrl + L
;功能: 选中整行 (原功能为搜索行)
;注: 如果你也想写 Arduino 的快捷键,
;注意编辑器输入页面的程序是 java\bin\javaw.exe, 而非 arduino.exe
