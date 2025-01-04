#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory

; Global variables
global CustomMenuGui := ""  ; For our custom menu
global closeButton := ""  ; Store reference to close button

; Custom Start Menu Implementation - Double Shift trigger
~LShift:: {
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

~RShift:: {  ; Also allow right shift for the same functionality
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

AddMenuButton(text, command, y) {
    global CustomMenuGui
    btn := CustomMenuGui.Add("Button", "x20 y" y " w260 h30", text)
    btn.OnEvent("Click", (*) => RunCommand(command))
}

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

; Global Escape key handler
Escape:: {
    ; Check if Quick Launch Menu is open
    if (CustomMenuGui && WinExist("ahk_id " CustomMenuGui.Hwnd)) {
        CustomMenuGui.Hide()
        return
    }
}

; Add click handler to close menu when clicking outside
OnMessage(0x201, WM_LBUTTONDOWN)

; Function to handle clicks outside the menu
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global CustomMenuGui
    if (CustomMenuGui && !WinActive("ahk_id " CustomMenuGui.Hwnd))
        CustomMenuGui.Hide()
} 