Function ParseJson(json)
    Dim objJSON
    Set objJSON = CreateObject("MSXML2.DOMDocument.6.0")
    objJSON.LoadXml json
    Set ParseJson = objJSON
End Function

' Example usage
Dim jsonStr
Dim jsonObj

jsonStr = "{""name"": ""John"", ""age"": 30, ""city"": ""New York""}"
Set jsonObj = ParseJson(jsonStr)

' Access the properties of the resulting object
WScript.Echo "Name: " & jsonObj.SelectSingleNode("//name").Text
WScript.Echo "Age: " & jsonObj.SelectSingleNode("//age").Text
WScript.Echo "City: " & jsonObj.SelectSingleNode("//city").Text
