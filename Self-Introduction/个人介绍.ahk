;函数定义
;绕过输入法直接输入字符
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



;开始定义快捷键与热字符串
;个人介绍
::gerenjieshao::
ascinput("### ")
Send, 个人介绍{Enter}
Send, 1. 昵称：米线.{Enter}性格{Enter}爱好{Enter}喜好
Send, {Up}{Up}{Up}{Right}
return

;性格 (Alt + 2)
!2::
Send, {Enter}{Tab}害羞 (线下){Enter}开朗 (线上){Enter}热心{Enter}乐观
return

;爱好 (Alt + 3)
!3::
Send, {Enter}{Tab}[魔方]
ascinput("(https://cubing.com/results/person/)")    ;直接在 person/ 后加上 WCA id 即可.
Send, {Enter}[数学]
ascinput("(https://sleepcloudmx.github.io/)")
Send, {Down}
return

;喜好 (Alt + 4)
!4::
;Send, {Enter}{Tab}事物：云 {Shift}:cloud:{Shift}、星 {Shift}:star:{Shift}、雨 {Shift}:cloud_with_rain:{Shift}、雪 {Shift}:cloud_with_snow:{Shift}.
Send, {Enter}{Tab}事物：云、星、雨、雪.
Send, {Enter}视频
return

;科普
::kepu::
Send, 科普：真理元素、李永乐老师、两颗熟李子、毕导、兔叭咯、思维实验室、妈咪说...
return

;数学
::shuxue::
Send, 数学：三蓝一棕、乐正垂星、风竹云墨、{Shift}Castelu、Solara{Shift}、一碗星空咕、凡人忆拾、数心、{Shift}Cigar{Shift} 666、证毕 {Shift}QED{Shift}、鹤翔万里、无懈可击 99、修陈...
return

;开心
::kaixin::
Send, 开心：{Shift}Warma{Shift}、怒九笑、拉宏桑、四迹、三无 {Shift}Marblue{Shift}、{Shift}ilem{Shift}、翠花不太脆...
return

;可爱
::keai::
Send, 可爱：劲小郑、超级小树、奶糕成精档案社、罗小黑、小豆泥...
return

;好看
::haokan::
Send, 好看：子牧说、{Shift}oooooohmygosh{Shift}、开乐设计、设计师深海、良我叫什么、{Shift}MEspace{Shift} 天植、才浅、何同学、{Shift}Cat-God{Shift} 猫神教主...
Send, {Enter}......
return

;结束语 1 (Alt + 5)
!5::
Send, {Enter}{Shift down}
loop, 3 {
	Send, {Tab}
}
Send, {Shift up}---{Enter}
Send, 科协是一个快乐的大家庭，希望大家快快融入大学的生活、适应大学的学习，探索未来的一切可能.
ascinput(" :star: ")
;下面两个循环是为了增加多余的空行, 阅读舒服一点
loop, 5 {
	Send, {Enter}
}
loop, 4 {
	Send, {Up}
}
ascinput("<center class='half'>")
Send, {Enter}
ascinput("<img src='image\99_1.png' width=300 align='left'>")	;注意这里不会调用 img 的热字符串
Send, {Up}{Up}{End}
return

;结束语 2 (Alt + 6)
!6::
Send, {Enter}最后，如果大家有什么问题，无论是工作上的，还是学习上的，都可以来问问我们，我们会尽力为大家解答的
ascinput(" $\sim$ ")
Send, {Down}{Down}{End}{Enter}
ascinput("<img src='image\99_2.png' width=300 align='right'>")	;同上, 实践没有出错.
loop, 3 {
	Send, {Up}
}
Send, {End}
return
