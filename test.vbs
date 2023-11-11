Function ParseJson(json)
    On Error Resume Next
    
    Dim objJSON
    Set objJSON = CreateObject("MSXML2.DOMDocument.6.0")
    
    If Err.Number = 0 Then
        objJSON.LoadXml json
        If Err.Number = 0 Then
            Set ParseJson = objJSON
        Else
            Set ParseJson = Nothing
        End If
    Else
        Set ParseJson = Nothing
    End If
    
    On Error GoTo 0
End Function

' Example usage
Dim jsonStr
Dim jsonObj

jsonStr = "{""name"": ""John"", ""age"": 30, ""city"": ""New York""}"
Set jsonObj = ParseJson(jsonStr)

If Not jsonObj Is Nothing Then
    ' Access the properties of the resulting object
    WScript.Echo "Name: " & jsonObj.SelectSingleNode("//name").Text
    WScript.Echo "Age: " & jsonObj.SelectSingleNode("//age").Text
    WScript.Echo "City: " & jsonObj.SelectSingleNode("//city").Text
Else
    WScript.Echo "Error parsing JSON."
End If
