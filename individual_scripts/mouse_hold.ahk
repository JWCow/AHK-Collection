#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory

; Global variables
global Holding := false

; Mouse holding functionality
^!+`:: {  ; Ctrl + Alt + Shift + ` to start holding down the left mouse button
    global Holding  ; Reference global inside the hotkey
    Click("down")  ; Hold down the left mouse button
    Holding := true  ; Set a flag to indicate it's holding
}

~LButton Up:: {  ; Left Mouse Button release checks if the left button is held down
    global Holding  ; Reference global inside the hotkey
    if (Holding) {
        Click("up")  ; Release the left mouse button
        Holding := false  ; Reset the flag
    }
}

Escape:: {  ; Add escape key as emergency stop
    global Holding  ; Reference global inside the hotkey
    if (Holding) {
        Click("up")
        Holding := false
    }
} 