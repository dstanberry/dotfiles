#SingleInstance Force

SetTitleMatchMode 3
DetectHiddenWindows true

; Legend
; # Left Win
; ^ Ctrl
; ! Alt
; + Shift

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}
; Reload Configuration
^!r::Komorebic("reload-configuration")
#^r:: {
  try Komorebic("stop")
  Komorebic("start")
}

; Manage active window
!q::Komorebic("close")
!m::Komorebic("minimize")

; Manage window focus
#^!a::Komorebic("focus left")
#^!g::Komorebic("focus right")
#^!Up::Komorebic("focus up")
#^!Down::Komorebic("focus down")

; Manage window stacks
#^!z::Komorebic("stack left")
#^!b::Komorebic("stack right")
#^!v::Komorebic("stack up")
#^!c::Komorebic("stack down")
#^!BackSpace::Komorebic("unstack")
; Manage window focus within a stack
#^!d::Komorebic("cycle-stack previous")
#^!f::Komorebic("cycle-stack next")

; Move windows
#^h::Komorebic("move left")
#^j::Komorebic("move down")
#^k::Komorebic("move up")
#^l::Komorebic("move right")

; Resize windows
#^=::Komorebic("resize-axis horizontal increase")
#^-::Komorebic("resize-axis horizontal decrease")
#^+=::Komorebic("resize-axis vertical increase")
#^+-::Komorebic("resize-axis vertical decrease")

; Manipulate windows
^!f::Komorebic("toggle-float")
^!m::Komorebic("toggle-monocle")
^!t::Komorebic("retile")

; Manage workspace focus
#^!1::Komorebic("focus-workspace 0")
#^!2::Komorebic("focus-workspace 1")

; Move windows between workspaces
#^!q::Komorebic("move-to-workspace 0")
#^!t::Komorebic("move-to-workspace 1")
