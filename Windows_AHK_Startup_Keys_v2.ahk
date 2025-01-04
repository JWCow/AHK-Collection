#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory

; Global variables
global width := 400
global height := 600
global htmlPath := A_ScriptDir "\giphy_picker.html"
global iniFile := A_ScriptDir "\giphy_settings.ini"
global Holding := false  ; Declare Holding as global
global CustomMenuGui := ""  ; For our custom menu
global closeButton := ""  ; Store reference to close button

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
Up:: Send("{WheelUp}")
Down:: Send("{WheelDown}")
Tab:: Send("{Tab}")
^Enter:: Send("^c")
#HotIf

; Global Escape key handler
Escape:: {
    ; Check if Quick Launch Menu is open
    if WinExist("ahk_id " CustomMenuGui.Hwnd) {
        CustomMenuGui.Hide()
        return
    }
    
    ; Check if GIPHY Picker is active
    if WinActive("GIPHY Picker") {
        WinMinimize("GIPHY Picker")
        WinHide("GIPHY Picker")
        return
    }
    
    ; Check mouse holding state
    global Holding
    if (Holding) {
        Click("up")
        Holding := false
        return
    }
}

SaveWindowPosition() {
    pos := WinGetPos("GIPHY Picker")
    IniWrite(pos.X, iniFile, "Window", "X")
    IniWrite(pos.Y, iniFile, "Y")
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

GetActiveMonitorCenter() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    monCount := MonitorGetCount()
    
    Loop monCount {
        MonitorGet(A_Index, &monLeft, &monTop, &monRight, &monBottom)
        if (mouseX >= monLeft && mouseX <= monRight && mouseY >= monTop && mouseY <= monBottom) {
            x := monLeft + (monRight - monLeft - width) / 2
            y := monTop + (monBottom - monTop - height) / 2
            return [x, y]
        }
    }
    ; Fallback to primary monitor
    return [(A_ScreenWidth - width) / 2, (A_ScreenHeight - height) / 2]
}

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

; Volume controls using mouse wheel + Win + Shift
#+WheelUp:: Send("{Volume_Up}")    ; Win + Shift + Mouse Wheel Up = Volume Up
#+WheelDown:: Send("{Volume_Down}") ; Win + Shift + Mouse Wheel Down = Volume Down
#+MButton:: Send("{Volume_Mute}")   ; Win + Shift + Middle Mouse Button = Mute Toggle

; Custom Start Menu Implementation
~LShift:: {  ; Left Shift double-tap
    static keyPressCount := 0
    static lastPressTime := 0
    
    currentTime := A_TickCount
    
    ; If menu is already open, close it
    if (CustomMenuGui && WinExist("ahk_id " CustomMenuGui.Hwnd)) {
        CustomMenuGui.Hide()
        return
    }
    
    ; Check if this is a second press within 400ms
    if (currentTime - lastPressTime <= 400) {
        keyPressCount++
        if (keyPressCount = 2) {
            ShowCustomMenu()
            keyPressCount := 0
        }
    } else {
        keyPressCount := 1
    }
    
    lastPressTime := currentTime
}

~RShift:: {  ; Right Shift double-tap
    static keyPressCount := 0
    static lastPressTime := 0
    
    currentTime := A_TickCount
    
    ; If menu is already open, close it
    if (CustomMenuGui && WinExist("ahk_id " CustomMenuGui.Hwnd)) {
        CustomMenuGui.Hide()
        return
    }
    
    ; Check if this is a second press within 400ms
    if (currentTime - lastPressTime <= 400) {
        keyPressCount++
        if (keyPressCount = 2) {
            ShowCustomMenu()
            keyPressCount := 0
        }
    } else {
        keyPressCount := 1
    }
    
    lastPressTime := currentTime
}

; Hover effect functions
HoverOn(control, *) {
    control.Opt("cWhite")
    control.Gui.BackColor := "880000"
}

HoverOff(control, *) {
    control.Opt("cRed")
    control.Gui.BackColor := "202020"
}

ShowCustomMenu() {
    global CustomMenuGui, closeButton
    
    ; Destroy existing GUI if it exists
    if (CustomMenuGui != "") {
        CustomMenuGui.Destroy()
    }
    
    ; Create new GUI
    CustomMenuGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    CustomMenuGui.SetFont("s10", "Segoe UI")
    CustomMenuGui.BackColor := "202020"  ; Dark background
    
    ; Add title bar with drag functionality
    titleBar := CustomMenuGui.Add("Text", "x0 y0 w300 h30 +BackgroundTrans", "")  ; Invisible drag handle
    titleBar.OnEvent("Click", GuiDrag)
    
    ; Add close button and store reference
    closeButton := CustomMenuGui.Add("Text", "x275 y5 w20 h20 +BackgroundTrans Center cRed", "×")
    closeButton.OnEvent("Click", CloseMenu)
    OnMessage(0x200, HoverCheck)  ; WM_MOUSEMOVE
    
    CustomMenuGui.SetFont("s12 w700 cWhite", "Segoe UI")
    CustomMenuGui.Add("Text", "x10 y5 w260 h30", "Quick Launch Menu")
    
    ; Add system info
    CustomMenuGui.SetFont("s9 cWhite", "Segoe UI")
    battery := GetBatteryStatus()
    cpu := GetCPULoad()
    memory := GetMemoryStatus()
    
    CustomMenuGui.Add("Text", "x10 y40 w280", "System Status:")
    CustomMenuGui.Add("Text", "x20 y60 w270", "CPU: " cpu "% | RAM: " memory "% | Battery: " battery "%")
    
    ; Add buttons with icons
    CustomMenuGui.SetFont("s10 w400", "Segoe UI")
    y := 100
    
    ; AHK Scripts Section
    CustomMenuGui.Add("Text", "x10 y" y " w280 h20 cWhite", "AHK Scripts:")
    y += 25
    
    ; Get list of AHK scripts
    scriptPath := "E:\OneDrive\Documents\Adobe\Python\AutoHotKey AHK\individual_scripts"
    Loop Files, scriptPath "\*.ahk" {
        scriptName := StrReplace(A_LoopFileName, ".ahk")
        AddScriptButton("🔄 " scriptName, A_LoopFilePath, y)
        y += 35
    }
    y += 10
    
    ; Quick Actions Section
    CustomMenuGui.Add("Text", "x10 y" y " w280 h20 cWhite", "Quick Actions:")
    y += 25
    
    AddMenuButton("🔊 Sound Mixer", "SndVol", y)
    y += 35
    AddMenuButton("⚙️ Settings", "ms-settings:", y)
    y += 35
    AddMenuButton("📝 Notepad", "notepad.exe", y)
    y += 35
    AddMenuButton("🌐 Browser", "chrome.exe", y)
    y += 35
    AddMenuButton("📂 File Explorer", "explorer.exe", y)
    y += 35
    AddMenuButton("⌨️ Terminal", "wt.exe", y)
    y += 45
    
    ; System Controls
    CustomMenuGui.Add("Text", "x10 y" y " w280 h20 cWhite", "System Controls:")
    y += 25
    
    AddMenuButton("🔒 Lock PC", "LockWorkStation", y)
    y += 35
    AddMenuButton("💤 Sleep", "Sleep", y)
    y += 35
    
    ; Calculate position (use saved position or center on monitor)
    guiWidth := 300
    guiHeight := y + 10
    
    ; Try to load saved position
    try {
        IniRead(&savedX, "menu_settings.ini", "Position", "X")
        IniRead(&savedY, "menu_settings.ini", "Position", "Y")
        xPos := savedX
        yPos := savedY
    } catch {
        ; Center on monitor if no saved position
        MonitorGetWorkArea(MonitorGetPrimary(), &mLeft, &mTop, &mRight, &mBottom)
        xPos := mLeft + (mRight - mLeft - guiWidth) / 2
        yPos := mTop + (mBottom - mTop - guiHeight) / 2
    }
    
    ; Show the GUI
    CustomMenuGui.Show("x" xPos " y" yPos " w" guiWidth " h" guiHeight)
    
    ; Add click handler to close menu when clicking outside
    OnMessage(0x201, WM_LBUTTONDOWN)
}

; Function to handle GUI dragging
GuiDrag(GuiCtrl, *) {
    try {
        PostMessage(0xA1, 2,,, GuiCtrl.Gui)
    }
    ; Save position after drag
    SetTimer(SaveGuiPosition, -500)
}

SaveGuiPosition() {
    global CustomMenuGui
    try {
        pos := CustomMenuGui.GetPos()
        IniWrite(pos.X, "menu_settings.ini", "Position", "X")
        IniWrite(pos.Y, "menu_settings.ini", "Position", "Y")
    }
}

; Add button specifically for AHK scripts
AddScriptButton(text, scriptPath, y) {
    global CustomMenuGui
    btn := CustomMenuGui.Add("Button", "x20 y" y " w260 h30", text)
    btn.OnEvent("Click", (*) => RunScript(scriptPath))
}

; Add button for regular applications and commands
AddMenuButton(text, command, y) {
    global CustomMenuGui
    btn := CustomMenuGui.Add("Button", "x20 y" y " w260 h30", text)
    btn.OnEvent("Click", (*) => RunCommand(command))
}

; Function to run regular commands
RunCommand(command) {
    global CustomMenuGui
    CustomMenuGui.Hide()
    
    if (command = "LockWorkStation")
        DllCall("LockWorkStation")
    else if (command = "Sleep")
        DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
    else
        Run(command)
}

; Function to run AHK scripts
RunScript(scriptPath) {
    global CustomMenuGui
    CustomMenuGui.Hide()
    
    ; Check if script is already running
    SplitPath(scriptPath, &scriptName)
    if ProcessExist(scriptName) {
        result := MsgBox("Script is already running. Restart it?",
            "Script Manager",
            "YesNo")
        if (result = "Yes") {
            ProcessClose(scriptName)
            Sleep(100)  ; Give it time to close
        } else {
            return
        }
    }
    
    ; Run the script
    Run(scriptPath)
}

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global CustomMenuGui
    if (CustomMenuGui && !WinActive(CustomMenuGui))
        CustomMenuGui.Hide()
}

; Helper functions for system information
GetBatteryStatus() {
    battery := ComObject("WbemScripting.SWbemLocator").ConnectServer().ExecQuery("Select EstimatedChargeRemaining from Win32_Battery")
    for item in battery
        return item.EstimatedChargeRemaining
    return "N/A"
}

GetCPULoad() {
    try {
        wmi := ComObject("WbemScripting.SWbemLocator").ConnectServer()
        queryEnum := wmi.ExecQuery("SELECT PercentProcessorTime FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name='_Total'")
        for item in queryEnum
            return item.PercentProcessorTime
    } catch {
        return "0"
    }
    return "0"
}

GetMemoryStatus() {
    static memoryStatus := Buffer(64)
    NumPut("UInt", 64, memoryStatus)
    DllCall("Kernel32.dll\GlobalMemoryStatusEx", "Ptr", memoryStatus)
    return NumGet(memoryStatus, 4, "UInt")
}

; Mouse hover detection for close button
HoverCheck(wParam, lParam, msg, hwnd) {
    static lastHover := 0
    global CustomMenuGui, closeButton
    
    if (!CustomMenuGui || !closeButton)
        return
        
    ; Get mouse position
    CoordMode("Mouse", "Window")
    MouseGetPos(&mouseX, &mouseY, &hWnd, &control)
    
    ; Check if mouse is over close button area
    if (mouseX >= 275 && mouseX <= 295 && mouseY >= 5 && mouseY <= 25 && hWnd = CustomMenuGui.Hwnd) {
        if (lastHover != 1) {
            HoverOn(closeButton, "")
            lastHover := 1
        }
    } else if (lastHover = 1) {
        HoverOff(closeButton, "")
        lastHover := 0
    }
}

; Function to close the menu
CloseMenu(*) {
    global CustomMenuGui
    if CustomMenuGui
        CustomMenuGui.Hide()
}
 