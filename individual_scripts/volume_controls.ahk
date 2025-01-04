#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory

; Volume controls using mouse wheel + Win + Shift
#+WheelUp:: Send("{Volume_Up}")    ; Win + Shift + Mouse Wheel Up = Volume Up
#+WheelDown:: Send("{Volume_Down}") ; Win + Shift + Mouse Wheel Down = Volume Down
#+MButton:: Send("{Volume_Mute}")   ; Win + Shift + Middle Mouse Button = Mute Toggle 