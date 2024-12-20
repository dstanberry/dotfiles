#SingleInstance Force

SetTitleMatchMode 3
DetectHiddenWindows true

; INFO: Legend
; # Left Win
; ^ Ctrl
; ! Alt
; + Shift

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

; NOTE: ALT
; Manage active window
!q::Komorebic("close")
; !m::Komorebic("minimize")

; NOTE: LWIN + CTRL

; Reload Configuration
#^r::Komorebic("reload-configuration")

; Resize windows
#^=::Komorebic("resize-axis horizontal increase")
#^-::Komorebic("resize-axis horizontal decrease")
#^+=::Komorebic("resize-axis vertical increase")
#^+-::Komorebic("resize-axis vertical decrease")

; NOTE: LWIN + CTRL + ALT

; Restart Komorebi
#^!`:: {
  try Komorebic("stop")
  Komorebic("start")
}

; Manipulate windows
#^!1::Komorebic("retile")
#^!2::Komorebic("toggle-float")
#^!3::Komorebic("toggle-monocle")

; Load 'quicksave' file for current monitor
#^!LShift::Komorebic("quick-load")

; Manage window focus
#^!a::Komorebic("focus left")
#^!g::Komorebic("focus right")
#^!w::Komorebic("focus up")
#^!s::Komorebic("focus down")

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
#^!Left::Komorebic("move left")
#^!Right::Komorebic("move right")
#^!Down::Komorebic("move down")
#^!Up::Komorebic("move up")

; Manage workspace focus
#^!e::Komorebic("focus-workspace 0")
#^!r::Komorebic("focus-workspace 1")

; Move windows between workspaces
#^!q::Komorebic("move-to-workspace 0")
#^!t::Komorebic("move-to-workspace 1")
