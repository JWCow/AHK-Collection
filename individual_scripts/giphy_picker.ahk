#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory

; Global variables
global width := 400
global height := 600
global htmlPath := A_ScriptDir "\giphy_picker.html"
global iniFile := A_ScriptDir "\giphy_settings.ini"

htmlPath := StrReplace(htmlPath, "\", "/")
htmlPath := StrReplace(htmlPath, " ", "%20")
htmlPath := StrReplace(htmlPath, ":", "%3A")

; Get default browser path
try {
    browserPath := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice", "ProgId")
    browserCmd := RegRead("HKEY_CLASSES_ROOT\" . browserPath . "\shell\open\command")
} catch {
    browserCmd := ""
}

; Extract browser executable path
browserCmd := RegExReplace(browserCmd, '\"([^\"]+)\".*', "$1")
if (!browserCmd) {
    ; Fallback to direct browser paths if registry lookup fails
    if (FileExist("C:\Program Files\Google\Chrome\Application\chrome.exe"))
        browserCmd := "C:\Program Files\Google\Chrome\Application\chrome.exe"
    else if (FileExist("C:\Program Files\Mozilla Firefox\firefox.exe"))
        browserCmd := "C:\Program Files\Mozilla Firefox\firefox.exe"
    else if (FileExist("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"))
        browserCmd := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
}

PreloadBrowser() {
    Run(browserCmd 
        . ' --app="file:///' htmlPath '"'
        . " --window-size=1,1"
        . " --window-position=-9999,-9999"
        . " --disable-extensions"
        . " --disable-plugins"
        . " --disable-sync"
        . " --no-first-run"
        . " --noerrdialogs"
        . " --disable-translate"
        . " --disable-features=TranslateUI"
        . " --disable-save-password-bubble"
        . " --no-default-browser-check"
        . " --hide-scrollbars"
        . " --disable-notifications"
        . " --disable-background-mode"
        . " --disable-backing-store-limit"
        . " --disable-pinch"
        . ' --user-data-dir="' A_Temp '\GiphyPicker"')
    
    WinWait("GIPHY Picker")
    WinHide("GIPHY Picker")
}

PreloadBrowser()

ShowPicker() {
    if WinExist("GIPHY Picker") {
        state := WinGetMinMax("GIPHY Picker")
        if (state = -1) {  ; If window is minimized
            WinRestore("GIPHY Picker")  ; Restore it
            WinActivate("GIPHY Picker")
        } else {  ; If window is normal/visible
            WinMinimize("GIPHY Picker")  ; Minimize it
        }
    } else {
        x := (A_ScreenWidth - width) / 2
        y := (A_ScreenHeight - height) / 2
        
        Run(browserCmd
            . ' --app="file:///' htmlPath '"'
            . " --window-size=" width "," height 
            . " --window-position=" Round(x) "," Round(y)
            . " --disable-extensions"
            . " --disable-plugins"
            . " --disable-sync"
            . " --no-first-run"
            . " --noerrdialogs"
            . " --disable-translate"
            . " --disable-features=TranslateUI"
            . " --disable-save-password-bubble"
            . " --no-default-browser-check"
            . " --hide-scrollbars"
            . " --disable-notifications"
            . " --disable-background-mode"
            . " --disable-backing-store-limit"
            . " --disable-pinch"
            . ' --user-data-dir="' A_Temp '\GiphyPicker"')
        
        WinWait("GIPHY Picker")
        state := WinGetMinMax("GIPHY Picker")
        if (state = -1)
            WinRestore("GIPHY Picker")
        WinShow("GIPHY Picker")
        WinActivate("GIPHY Picker")
        
        ; Ensure proper size and position
        WinMove(x, y, width, height, "GIPHY Picker")
    }
}

; Win + C to toggle GIPHY picker
#c:: ShowPicker()

; Window-specific hotkeys
#HotIf WinActive("GIPHY Picker")
Escape:: {
    WinMinimize("GIPHY Picker")
    WinHide("GIPHY Picker")
}

Up:: Send("{WheelUp}")
Down:: Send("{WheelDown}")
Tab:: Send("{Tab}")
^Enter:: Send("^c")
#HotIf

SaveWindowPosition() {
    pos := WinGetPos("GIPHY Picker")
    IniWrite(pos.X, iniFile, "Window", "X")
    IniWrite(pos.Y, iniFile, "Window", "Y")
}

LoadWindowPosition() {
    try {
        savedX := IniRead(iniFile, "Window", "X")
        savedY := IniRead(iniFile, "Window", "Y")
        return [savedX, savedY]
    } catch {
        return [(A_ScreenWidth - width) / 2, (A_ScreenHeight - height) / 2]
    }
} 