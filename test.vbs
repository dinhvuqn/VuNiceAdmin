regsvr32 c:\windows\syswow64\msscript.ocx

Dim jsonStr
Dim jsonObj
Dim jsonConverter

' Your JSON string
jsonStr = "{ ""name"": ""John"", ""age"": 30, ""city"": ""New York"" }"

' Create a Scripting.Dictionary object
Set jsonConverter = CreateObject("Scripting.Dictionary")

' Add a reference to Microsoft Scripting Runtime for Dictionary usage
Set jsonObj = jsonConverter("json") ' This will be the resulting object

' Load the JSON string into the Dictionary
jsonConverter("json") = jsonStr

' Use the eval method to parse the JSON string
Execute "Set " & jsonObj & " = (" & jsonConverter("json") & ")"

' Access the properties of the resulting object
WScript.Echo "Name: " & jsonObj("name")
WScript.Echo "Age: " & jsonObj("age")
WScript.Echo "City: " & jsonObj("city")
