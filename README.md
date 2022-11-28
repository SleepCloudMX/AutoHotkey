# 说明文档

## 前言

我写快捷键主要是想替换掉那几个很小容易按错的上下左右键 (尤其是容易按到 PgUp 和 PgDn), 使打字更方便一点. 之后也逐渐增加了一些其它的功能.

想要使用的话, 先去 [官网](https://www.autohotkey.com/) 下载 AutoHotkey (软件自带教程), 双击 AHK.ahk 文件即可运行程序. 更新: 发现了 [中文教程](https://wyagd001.github.io/zh-cn/docs/AutoHotkey.htm).

电脑每次开机时都需要运行才能使用, 如需设置开机自启, 在如下文件夹中放入 AHK.ahk 文件的快捷方式即可:
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp

如果与已有快捷键冲突, 请去 AHK.ahk 文件中用分号注释掉相应代码.
右键可用记事本等软件编辑; 想要语法高亮的话, 直接在 Sublime 或 VS code 里安装相应的包就可以了.

电脑延迟较高的话 (比如向 typora 单个文件里塞几千个行内公式), 快捷键可能会出问题. 热字串可以先在其它文件里使用后复制到目标文件里.

对于同时按下三个键的快捷键, 一般不可以连续使用, 不喜欢也可以注释掉.

有个 bug: 长按 Alt 与 J, 一段时间后可能会跳到文档最下侧, 类似于 Ctrl + J 的功能, 不过好像是 typora 的锅.

如需使用仅能在 typora 和 sublime 中使用的快捷键, 请去 AHK.ahk 修改对应路径 (在 `#IfWinActive ahk_exe` 后面修改).
另外, 我不会在 sublime 写 markdown, 所以也不会设置相应的快捷键, 而且本身也有冲突.

之后发现有的功能 sublime 已经有了, 而且自带快捷键更好... (比如注释可以用 Ctrl + /) 算了写都写了.

如果想自己编写代码的话, 有一些建议:
1. 仅输入字符时, 不建议使用自带的 Send 等命令, 因为在中文输入法下有 bug. 可以自定义函数绕开输入法 (见源文件);
2. 有多种方式切换输入法 (见源文件), 但在某些情况下都会有点 bug (误删字符), 可以自定义快捷键调用函数切换输入法, 并在需要切换输入法的快捷键中调用这些快捷键. 我也不知道这样为什么就没有 bug 了, 但是它能跑;
3. 一定, 一定, 请系统地学习 AutoHotkey 后再写代码, 不然写的过程中会很痛苦.
4. AutoHotkey 的快捷键响应时间略长于系统或其它软件自带的快捷键, 但绝大多数情况下不影响使用. 通过自定义函数输入较多字符时可能有明显的延迟, 我的评价是: ~~比手敲的快~~, 可以把内容存到剪切板里, 复制粘贴后记得恢复使用快捷键前的剪切板内容.

**注**

- Self-Introduction 文件夹里的程序用于介绍 (整活) 的场合.
- Excel-Hotkeys 文件夹里是我不会用 Excel 或不想给 WPS 充会员然后写的一点代码.




## 快捷键说明

### 一、通用快捷键

1. 按键: Alt + I/J/K/L

   功能: 上下左右

2. 按键: Alt + H/;

   功能: 行首行尾

3. 按键: Alt + Shift + I/J/K/L

   功能: 选中字符

4. 按键: Alt + Shift + H/;

   功能: 选中这一行之前或之后的字符

5. 按键: Alt + Ctrl + J/L

   功能: 跨词移动

6. 按键: Alt + Ctrl + H/;

   功能: 文档的开始或结尾

   注: 等价于原来的 PgUp 和 PgDn

7. 按键: PgUp / PgDn

   功能: 无

   注: 因为容易误触，就禁了这两个烦人的键.

8. 按键: LShift + 滚轮上下滚动

   功能: 页面向左向右滚动

   注: Ctrl + 滚轮上下滚动, 一般用于放大或缩小页面.

9. 按键: RShift + w/a/s/d

   功能: 页面向上/左/下/右滚动

   注: 因为我触控板经常失灵, 就用这个快捷键了

10. 按键: Esc + LShift

   功能: 最小化任意页面.

   注: 建议按下 Esc 后按 LShift, 不过先按 LShift 也是可以的. 在一些软件中, Esc 用于关闭应用内小窗, 所以这里加上了 LShift.



### 二、Typora 快捷键

1. 按键: "emos"

   功能: 替换为 `:star:`

2. 按键: "emoc"

   功能: 替换为 `:crescent_moon:`

   注: 以上是为了方便在 typora 中输入常用 emoji 而设置的热字符串.

   别问, 问就是我喜欢星星和月亮.

3. 按键: Ctrl + Alt + 1~7

   功能: 修改为 HTML 样式的小标题, 其中 7 为正文

   注: 由于 HTML 输入环境的影响, 只能用了一个奇怪的顺序了.

4. 按键: Alt + M 和 Alt + Shift + M

   功能: 分别为行内公式和取消行内公式

   注: 需要在设置里启用行内公式 (LaTeX 语法)

5. 按键: "\img" + Enter / Tab / Space

   功能: 替换为 `<img src='image\.png' width=450>` 并将光标移至 .png 前

   注: ~~需要等待约半秒, 期间请勿输入其它字符~~. 已解决延迟的问题, 但如果电脑本身运行慢, 则会替换为原剪切板里的内容.

6. 按键: "\att" + Enter / Tab / Space

   功能: 替换为

   ```html
   <span style='background-color: #eeeeee; color: #777777'></span>
   ```

   并将光标移至 `</span>` 前

   注: ~~需要等待约半秒, 期间请勿输入其它字符~~. 已解决延迟的问题, 但如果电脑本身运行慢, 则会替换为原剪切板里的内容.

7. 按键: "\ggb" + Enter / Tab / Space

   功能:

   1. 在 Geogebra 网页中复制分享链接后, 在 typora 中输入 `\ggb` 并回车 (或按 tab 或空格), 则可以自动生成 HTML 代码, 显示按钮.
   2. 转为 HTML 后, 按下按钮即可在页面内显示 Geogebra 绘制的图像 (第一次打开需要双击), 再次按下可以关闭图像. 也可以点击旁边的链接直接打开网页.

   注意:

   1. 同一文件中如果想多次使用同一图像, 请使用 `\ggbdef` 自定义编号, 否则只有第一个有效.
   2. 该快捷键有数据检查与异常处理.
      1. 如果剪切板中没有合法的图像链接, 则会跳出输入框, 获取用户输入.
      2. 如果输入的链接也不是图像链接的话, 则会在提示后清空热字串输入命令并返回.
   3. 如果使用获取输入的功能, 注意 HTML 代码会输出到当前窗口, 而不一定是在 typora 中.

8. 按键: "\ggbdef" + Enter / Tab / Space

   功能: 在 `\ggb` 的基础上自定义图像的编号.

   注意:

   1. 如果想在同一文件中多次使用同一图像, 请使用这个快捷键并自定义不同编号. 编号的要求见使用时跳出的对话框.
   2. 该快捷键有数据检查与异常处理.
      1. 如果剪切板中无合法的图像链接, 则会执行与 `\ggb` 相同的异常处理程序.
      2. 如果自定义编号不符合要求, 则会在提示后清空热字串输入命令并返回.

9. 按键: CapsLock + C

   功能:

   1. 选中文字内容后按 CapsLock + C, 弹出输入框.

      - 也可以先设置颜色, 再输入文字.

      - 输入框的默认输入为蓝色 (blue).

   2. 输入颜色后确定, 即可通过 HTML 修改文字颜色.

      - 其中输入内容可以是颜色英文名或十六进制颜色码.

      - 如果你愿意的话, 直接关掉输入框或按 Esc 也是可以的.

   3. 修改完颜色后, 会将文本光标移至 HTML 标签的内容处.

      - 光标移动的过程大概需要等待 0 - 0.3 s (没测过不确定).

   备注: 

   1. 本快捷键不会检查输入的颜色是否合法, 毕竟格式错误的颜色代码在 HTML 也能显示确定的颜色 (不懂是什么机制).
   2. 如果输入为空, 或为空格字符, 则取消 HTML 格式, 恢复为默认字体.
   3. 如果选中的文字本身就是 HTML 格式, 则会在取消格式后重新执行上述操作.

10. 按键: CapsLock + V

    功能: 取消选中文字的 HTML 格式.

    备注:

    1. 如果选中文字没有设置颜色, 或未选中文字, 则不作处理.
    2. 上一个快捷键的 'C' 表示 color, 这里的 'v' 表示 'void'.
    3. 也可以通过上一个快捷键输入为空或空格字符, 来实现这个功能, 不过不太方便.



### 二'、Typora 快捷键 \(软件内定义\)

文件 - 偏好设置 - 打开高级设置 - conf.user.json 文件:

```json
"keyBinding": {
    "Always on Top": "Alt + Ctrl + T",             // 保持顶端 (默认)
    "Refresh All Math Expressions": "Ctrl + M",    // 刷新数学公式
    "Toggle Task Status": "Alt + C",               // 切换任务状态
}
```



### 三、Sublime 快捷键

1. 按键: Alt + Ctrl + I/K

   功能: 页面上 (下) 移一行

   注: 等价于 Ctrl + Alt + 上/下

2. 按键: Ctrl + Shift + I/K

   功能: 上下两行互换位置

   注:

   1. 等价于 Ctrl + Shift + 上/下. 在 sublime text 里原为 indent 和 reindent 的效果, 不过它们可以用 Tab 和 Shift + Tab 替代.
   2. 为方便起见, 这里的上下左右不用再按 Alt.

3. 按键: Alt + Ctrl + 1~7

   功能: 修改为 HTML 样式的小标题, 其中 7 为正文

   注: 在 sublime 中为正常的输入顺序.

4. 按键: RAlt + ;/,

   功能: 选中多行后同时注释或取消注释

   注: RAlt 表示在右边的 Alt.

5. 按键: LShift + 滚轮上下滚动

   功能: 页面向左向右滚动

   注: 在 sublime (文本编辑器) 中移动的速度与浏览器中不同



### 四、Arduino 快捷键

1. 按键: Ctrl + L

   功能: 选中整行 (原功能为搜索行)

   注: 如果你也想写 Arduino 的快捷键, 注意编辑器输入页面的程序是 java\bin\javaw.exe, 而非 arduino.exe
