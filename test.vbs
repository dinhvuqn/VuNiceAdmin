regsvr32 c:\windows\syswow64\msscript.ocx

Dim jsonStr
Dim jsonObj

' Your JSON string
jsonStr = "{""name"": ""John"", ""age"": 30, ""city"": ""New York""}"

' Create a ScriptControl object
Set scriptControl = CreateObject("MSScriptControl.ScriptControl")
scriptControl.Language = "JScript"  ' Use JScript to handle JSON

' Use eval to parse the JSON string and create a JavaScript object
Set jsonObj = scriptControl.Eval("(" & jsonStr & ")")

' Access the properties of the resulting object
WScript.Echo "Name: " & jsonObj.name
WScript.Echo "Age: " & jsonObj.age
WScript.Echo "City: " & jsonObj.city

