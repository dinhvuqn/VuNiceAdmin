Dim jsonFile
Dim jsonStr
Dim jsonObj

' Specify the path to your JSON file
jsonFile = "D:\Kbatch\a.json"

' Read the contents of the JSON file
jsonStr = ReadFile(jsonFile)

' Check if the file was read successfully
If Not IsEmpty(jsonStr) Then
    ' Parse the JSON string
    Set jsonObj = JsonConverter(jsonStr)

    ' Access the properties of the resulting object
	WScript.Echo "isOpening: " & jsonObj("isOpening")
    WScript.Echo "Name: " & jsonObj("name")
    WScript.Echo "Age: " & jsonObj("age")
    WScript.Echo "City: " & jsonObj("city")

		jsonObj("age") = 33
	jsonObj("isOpening") = True
	

    ' Write the updated JSON back to the file
    UpdateJsonFile jsonFile, jsonObj
Else
    WScript.Echo "Error reading the JSON file."
End If

Function ReadFile(filePath)
    ' Function to read the contents of a file
    Dim objFSO, objFile

    Set objFSO = CreateObject("Scripting.FileSystemObject")

    ' Check if the file exists
    If objFSO.FileExists(filePath) Then
        ' Open the file and read its entire contents
        Set objFile = objFSO.OpenTextFile(filePath)
        ReadFile = objFile.ReadAll
        objFile.Close
    Else
        ' Return an empty string if the file doesn't exist
        ReadFile = ""
    End If
End Function

Function JsonConverter(json)
    ' Create a Scripting.Dictionary object
    Set dict = CreateObject("Scripting.Dictionary")

    ' Remove leading and trailing spaces
    json = Trim(json)

    ' Remove newlines and carriage returns
    json = Replace(json, vbCrLf, "")
    json = Replace(json, vbLf, "")
    json = Replace(json, vbCr, "")
    ' Check if the JSON string is an object
    If Left(json, 1) = "{" And Right(json, 1) = "}" Then
        ' Remove curly braces
        json = Mid(json, 2, Len(json) - 2)

        ' Split properties
        properties = Split(json, ",")

        ' Iterate through properties
        For Each prop In properties
            ' Split key and value
            keyValue = Split(Trim(prop), ":")

            ' Remove leading and trailing spaces from key and value
            key = Trim(Replace(Replace(keyValue(0), """", ""), " ", ""))
            value = Trim(Replace(keyValue(1), """", ""))

            ' Add key-value pair to the dictionary
            dict(key) = value
        Next
    End If

    ' Return the dictionary
    Set JsonConverter = dict
End Function
Function UpdateJsonFile(filePath, jsonDict)
    ' Function to update a JSON file with a given dictionary while preserving structure
    Dim objFSO, objFile

    Set objFSO = CreateObject("Scripting.FileSystemObject")

    ' Check if the file exists
    If objFSO.FileExists(filePath) Then
        ' Open the file for writing
        Set objFile = objFSO.OpenTextFile(filePath, 2) ' 2 means open for writing

        ' Convert the dictionary back to a formatted JSON string
        Dim updatedJsonStr
        updatedJsonStr = JsonToFormattedString(jsonDict, 0)

        ' Write the updated JSON string to the file
        objFile.Write updatedJsonStr

        ' Close the file
        objFile.Close
    Else
        WScript.Echo "Error: File does not exist."
    End If
End Function

Function JsonToFormattedString(jsonDict, indentLevel)
    ' Function to convert a JSON dictionary to a formatted string
    Dim jsonString
    jsonString = "{"

    For Each key In jsonDict.Keys
        jsonString = jsonString & vbCrLf & Space(indentLevel + 2) & """" & key & """: "

        If IsObject(jsonDict(key)) Then
            jsonString = jsonString & JsonToFormattedString(jsonDict(key), indentLevel + 2) & ","
        Else
		msgbox jsonDict(key)
            jsonString = jsonString & JsonValueToString(jsonDict(key)) & ","
        End If
    Next

    ' Remove the trailing comma and add line break and indentation
    If Right(jsonString, 1) = "," Then
        jsonString = Left(jsonString, Len(jsonString) - 1) & vbCrLf & Space(indentLevel)
    End If

    jsonString = jsonString & "}" & vbCrLf

    JsonToFormattedString = jsonString
End Function

Function JsonValueToString(value)
	msgbox value & "--" & TypeName(value)
    ' Function to convert a JSON value to its string representation
    If IsNumeric(value) Or VarType(value) = 11 Then
        JsonValueToString = CStr(value)
    Else
        JsonValueToString = """" & Replace(CStr(value), """", "\""") & """"
    End If
End Function
