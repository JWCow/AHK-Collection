#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory

; Global variables
global Holding := false

; Mouse holding functionality
^!+`:: {  ; Ctrl + Alt + Shift + ` to start holding down the left mouse button
    global Holding
    if (!Holding) {
        SendInput("{LButton Down}")  ; Use SendInput for more direct control
        Holding := true
    }
}

$LButton:: {  ; Intercept left click
    global Holding
    if (!Holding) {  ; If not holding, pass through normal clicks
        SendInput("{LButton Down}")
        KeyWait("LButton")
        SendInput("{LButton Up}")
    }
}

$LButton Up:: {  ; Handle button release separately
    global Holding
    if (Holding) {
        SendInput("{LButton Up}")  ; Just release the button
        Holding := false
    }
}

Escape:: {  ; Add escape key as emergency stop
    global Holding
    if (Holding) {
        SendInput("{LButton Up}")  ; Use SendInput for more direct control
        Holding := false
    }
} 