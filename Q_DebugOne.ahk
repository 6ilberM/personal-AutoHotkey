#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\Lib\AutoHotInterception.ahk

global AHI := AutoHotInterception()
keyboardId := AHI.GetKeyboardId(0x046D, 0xC545)

if (keyboardId != "") {
  ; Assuming GetKeySC is a function provided by the library that gets the scan code for a key
  qSC := GetKeySC("q") ; Replace with your method of getting the scan code if needed
  AHI.SubscribeKey(keyboardId, qSC, true, Func("OnQ").Bind(true))
  AHI.SubscribeKey(keyboardId, qSC, false, Func("OnQ").Bind(false))
} else {
  MsgBox("Could not find the keyboard. Please check the vendor and product IDs.")
}

return

OnQ(state) {
  ; State will be true when the 'q' key is pressed, and false when it's released
  if (state) {
    MsgBox("You pressed the 'q' key on your keyboard with ID 0x046D:0xC545!")
  } else {
    MsgBox("You released the 'q' key on your keyboard with ID 0x046D:0xC545!")
  }
}