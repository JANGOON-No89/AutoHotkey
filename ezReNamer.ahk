#CommentFlag //
//{ File Install & Gui
FileCreateDir, %A_Temp%\ReNamer
FileInstall, 1.png, %A_Temp%\ReNamer\1.png
FileInstall, 2.png, %A_Temp%\ReNamer\2.png
FileInstall, 3.png, %A_Temp%\ReNamer\3.png
FileInstall, 4.png, %A_Temp%\ReNamer\4.png
FileInstall, 5.png, %A_Temp%\ReNamer\5.png
FileInstall, 6.png, %A_Temp%\ReNamer\6.png
FileInstall, 7.png, %A_Temp%\ReNamer\7.png
FileInstall, 8.png, %A_Temp%\ReNamer\8.png
FileInstall, 9.png, %A_Temp%\ReNamer\9.png

Gui, Add, Button, x370 y20 w100 h20 gSelect_Folder , 폴더 선택
Gui, Add, Edit, x10 y21 w350 h18 ReadOnly vDirectory , 폴더를 드래그 하거나, 우측 버튼을 눌러 경로를 선택해주세요.
Gui, Add, CheckBox, x130 y3 w220 h18 cRed Checked vInclude_Folder gInclude_Folder, 목록을 불러올 때 폴더도 불러옵니다.
Gui, Add, Edit, x10 y101 w350 h430 vFile_List gFile_List -Wrap , 
Gui, Add, GroupBox, x4 y38 w210 h57
Gui, Add, Edit, x10 y50 w105 h18 vFront_Word ,
Gui, Add, Edit, x10 y70 w105 h18 vBack_Word ,
Gui, Add, Button, x119 y49 w90 h20 gInsert_Front, 앞쪽에 추가
Gui, Add, Button, x119 y69 w90 h20 gInsert_Back, 뒤쪽에 추가
Gui, Add, GroupBox, x217 y38 w258 h57
Gui, Add, Edit, x223 y50 w110 h18 vSearch_Word , 
Gui, Add, Edit, x223 y70 w110 h18 vReplace_Word ,
Gui, Add, Text, x334 y53 w35 h18 , (을)를
Gui, Add, Text, x334 y73 w35 h18 , (으)로
Gui, Add, Button, x370 y49 w100 h40 gTemp_Change , 찾아 바꾸기
Gui, Add, Button, x370 y100 w100 h40 vUndo gUndo , 이전으로
Gui, Add, GroupBox, x365 y+5 w110 h70
Gui, Add, Button, x370 y+-60 w100 h25 gRemove_Name , 파일명 제거
Gui, Add, Button, x370 y+5 w100 h25 gRemove_Extension , 확장자 제거
Gui, Add, GroupBox, x365 y+5 w110 h65
Gui, Add, Edit, x371 y+-54 w98 h18 vExtension_Word ,
Gui, Add, Button, x370 y+5 w100 h25 gReplace_Extension , 확장자 변경
Gui, Add, GroupBox, x365 y+10 w110 h103
Gui, Add, DropDownList, x380 y+-91 w80 R4 Choose3 vSet_Digit gSet_Digit, 1 자릿수|2 자릿수|3 자릿수|4 자릿수|5 자릿수|6 자릿수|7 자릿수
Gui, Add, Button, x370 y+10 w100 h25 gFill_Zero , 자릿수 채우기
Gui, Add, Button, x370 y+5 w100 h25 gAdd_Zero , 번호 만들기
Gui, Add, Button, x370 y+15 w100 h30 vTemp_Save gTemp_Save , 임시 저장
Gui, Add, Button, x370 y+10 w100 h50 vFile_Rename gFile_Rename , 이름 바꾸기
Gui, Add, Text, x370 y+10 w100 h15 +Center , version 1.20
Gui, Add, Button, x370 y+0 w100 h20 gHelp , 도움말
Gui, Show, w480 h540, ReNamer
GuiControl, Disable, Undo
GuiControl, Disable, Temp_Save
Amount := 0 , Change_Count = 0
Gui, Submit, Nohide
return

GuiClose:
FileDelete, FileNameChanger
FileDelete, FileNameLog
ExitApp
return //}

Help: //{
Gui, Help: New
Gui, Help: Add, Tab2, x0 y-2 w550 h20 , 도움말|버튼 설명 1|버튼 설명 2|변경 사항
Gui, Help: Add, Picture, x0 y17 w550 h500,  %A_Temp%\ReNamer\1.png
Gui, Help: Add, Text, x420 y480 w150 h50 +BackgroundTrans , 제작자 : 잔군`nleepinut@naver.com
Gui, Help: Tab, 2
Gui, Help: Add, Text, x40 y40 w214 h16 +Center cRed, 앞쪽에 추가
Gui, Help: Add, Text, x40 y230 w214 h16 +Center, "AAA" 를 앞쪽에 추가
Gui, Help: Add, Picture, x40 y60 w214 h164 ,  %A_Temp%\ReNamer\3.png
Gui, Help: Add, Text, x296 y40 w210 h16 +Center cRed, 뒤쪽에 추가
Gui, Help: Add, Text, x296 y230 w214 h16 +Center, "BBB" 를 뒤쪽에 추가
Gui, Help: Add, Picture, x296 y60 w214 h164 ,  %A_Temp%\ReNamer\4.png
Gui, Help: Add, Text, x40 y280 w214 h16 +Center cRed, 찾아 바꾸기
Gui, Help: Add, Text, x40 y470 w214 h16 +Center, "A" 를 "드라마" 로 바꾸기
Gui, Help: Add, Picture, x40 y300 w214 h164 ,  %A_Temp%\ReNamer\2.png
Gui, Help: Add, Text, x296 y280 w210 h16 +Center cRed, 임시 저장
Gui, Help: Add, Text, x296 y470 w214 h40 +Center, 편집 영역에서 직접 변경한 사항을`n임시적으로 저장하여 기록합니다. `n[이전으로] 버튼을 쓸 수 있게 됩니다.
Gui, Help: Add, Picture, x296 y300 w214 h164 ,  %A_Temp%\ReNamer\9.png
Gui, Help: Tab, 3
Gui, Help: Add, Text, x40 y40 w214 h16 +Center cRed, 파일명 제거
Gui, Help: Add, Text, x40 y230 w214 h40 +Center, 모든 파일명을 제거
Gui, Help: Add, Picture, x40 y60 w214 h164 ,  %A_Temp%\ReNamer\5.png
Gui, Help: Add, Text, x296 y40 w210 h16 +Center cRed, 확장자 제거
Gui, Help: Add, Text, x296 y230 w214 h40 +Center, 모든 확장자를 제거
Gui, Help: Add, Picture, x296 y60 w214 h164 ,  %A_Temp%\ReNamer\6.png
Gui, Help: Add, Text, x40 y280 w214 h16 +Center cRed, 자릿수 채우기
Gui, Help: Add, Text, x40 y470 w214 h40 +Center, 지정된 자릿수만큼 0을 채워넣습니다.`n파일명이 숫자여야 합니다.
Gui, Help: Add, Picture, x40 y300 w214 h164 ,  %A_Temp%\ReNamer\7.png
Gui, Help: Add, Text, x296 y280 w210 h16 +Center cRed, 번호 만들기
Gui, Help: Add, Text, x296 y470 w214 h40 +Center, 지정된 자릿수만큼 번호를 추가합니다.`n가장 앞쪽에 추가됩니다.
Gui, Help: Add, Picture, x296 y300 w214 h164 ,  %A_Temp%\ReNamer\8.png
Gui, Help: Tab, 4
Gui, Help: Add, Text, x20 y40 w510 h20 , version 1.00 : 기본
Gui, Help: Add, Text, x20 y+0 w510 h20 , version 1.10 : 폴더를 드래그하여 불러들이는 기능 추가. 
Gui, Help: Add, Text, x20 y+0 w510 h20 , version 1.11 : 파일 이름이 길 경우 자동 줄넘김이 일어나지 않도록 수정.
Gui, Help: Add, Text, x20 y+0 w510 h20 , version 1.12 : UI의 좌표값이 고정되어 단일모니터에서 창이 안나타나던 문제를 수정.
Gui, Help: Add, Text, x20 y+0 w510 h20 cRed, version 1.20 : 목록을 불러올 때 폴더도 불러올 수 있도록 기능 추가.
Gui, Help: Add, Text, x93 y+0 w510 h20 cRed, 파일 확장자 일괄 변경 가능하도록 기능 추가.
Gui, Help: Add, Text, x93 y+0 w510 h20 cRed, 1.1 버전에서 추가된 기능의 오류를 해결.
Gui, Help: Show, w550 h515, ReNamer Help
return //}

Include_Folder: //{
if Include_Folder = 0
	GuiControl, +cRed, Include_Folder
else
	GuiControl, +cBlack, Include_Folder
Gui, Submit, Nohide
return //}

File_List: //{
if A_GuiEvent=Normal
	GuiControl, Enable, Temp_Save
return //}

GuiDropFiles: //{
Directory := A_GuiEvent
gosub, Open_FileList
return //}

Select_Folder: //{
IniRead, Lasted_Folder, FileNameChanger, SelectFolder, Directory
if Lasted_Folder = ERROR
	FileSelectFolder, Directory
else
	FileSelectFolder, Directory, *%Lasted_Folder%, 3
gosub, Open_FileList
return //}

Open_FileList: //{
File_Log:="", Amount=""
GuiControl, text, Directory, %Directory%
Gui, Submit, Nohide

IniWrite, %Directory%, FileNameChanger, SelectFolder, Directory

Loop, %Directory%\*, %Include_Folder%
	Amount++
File_Digit := Survey_Digit(Amount)
Loop, %Directory%\*, %Include_Folder%
{
	IniWrite, %A_LoopFileName%, FileNameLog, File List, % zfill(A_Index, File_Digit+1)
	File_Log .= "`n" . A_LoopFileName
}
File_Log := Redaction(File_Log)
if (File_Log = "")
	File_Log := "ERROR!`n폴더가 아니거나, 표시 가능한 항목이 없습니다."
GuiControl, text, File_List, % File_Log
Gui, Submit, Nohide
Clipboard := File_Log
return //}

Temp_Change: //{
Save_Log()
StringReplace, File_Log, File_Log, %Search_Word%, %Replace_Word%, All
if errorlevel=0
	GuiControl, text, File_List, % File_Log
else
{
	Change_Count--
	if Change_Count=0
		GuiControl, Disable, Undo
}
return //}

Insert_Front: //{
Save_Log()
Loop, parse, File_Log, `n
	Line_Log .= "`n" . Front_Word A_LoopField
File_Log := Redaction(Line_Log)
GuiControl, text, File_List, % File_Log
Line_Log=
return //}

Insert_Back: //{
Save_Log()
Loop, parse, File_Log, `n
{
	StringGetPos, Word_Pos, A_LoopField, ., R
	StringTrimLeft, Line_Ext, A_LoopField, Word_Pos
	StringTrimRight, Line_Name, A_LoopField, StrLen(A_LoopField) - Word_Pos
	Line_Log .= "`n" . Line_Name Back_Word Line_Ext
}
File_Log := Redaction(Line_Log)
GuiControl, text, File_List, % File_Log
Line_Log=
return //}

Remove_Name: //{
Save_Log()
Loop, parse, File_Log, `n
{
	StringGetPos, Word_Pos, A_LoopField, ., R
	StringTrimLeft, Line_File, A_LoopField, Word_Pos
	Line_Log .= "`n" . Line_File
}
File_Log := Redaction(Line_Log)
GuiControl, text, File_List, % File_Log
Line_Log=
return //}

Remove_Extension: //{
Save_Log()
Loop, parse, File_Log, `n
{
	StringGetPos, Word_Pos, A_LoopField, ., R
	StringTrimRight, Line_File, A_LoopField, StrLen(A_LoopField) - Word_Pos - 1
	Line_Log .= "`n" . Line_File
}
File_Log := Redaction(Line_Log)
GuiControl, text, File_List, % File_Log
Line_Log=
return //}

Replace_Extension: //{
Save_Log()
Loop, parse, File_Log, `n
{
	StringGetPos, Word_Pos, A_LoopField, ., R
	if errorlevel=1
		Line_Log .= "`n" . A_LoopField
	else
	{
		StringTrimRight, Line_File, A_LoopField, StrLen(A_LoopField) - Word_Pos - 1
		Line_Log .= "`n" . Line_File Extension_Word
	}
}
File_Log := Redaction(Line_Log)
GuiControl, text, File_List, % File_Log
Line_Log=
return //}

Fill_Zero: //{
ERROR=0
Loop, parse, File_Log, `n
{
	StringGetPos, Word_Pos, A_LoopField, ., R
	StringTrimLeft, Line_Ext, A_LoopField, Word_Pos
	StringTrimRight, Line_Name, A_LoopField, StrLen(A_LoopField) - Word_Pos
	if (Word_Pos >= SubStr(Set_Digit, 1, 1))
	{
		MsgBox, 16, Fill Error, 자릿수를 채울 수 없습니다.`n`n파일명에 숫자가 아닌 문자열이 있으면 안됩니다.`n글자수가 지정한 자릿수와 같거나 크면 안됩니다.
		ERROR = 1
		break
	}
	Line_Log .= "`n" . zfill(Line_Name, SubStr(Set_Digit, 1, 1)) . Line_Ext
}
if ERROR = 0
{
	Save_Log()
	File_Log := Redaction(Line_Log)
	GuiControl, text, File_List, % File_Log
	Line_Log=
}
return //}

Add_Zero: //{
Save_Log()
Loop, parse, File_Log, `n
	Line_Log .= "`n" . zfill(A_Index, SubStr(Set_Digit, 1, 1)) . A_LoopField
File_Log := Redaction(Line_Log)
GuiControl, text, File_List, % File_Log
Line_Log=
return //}

Undo: //{
Gui, Submit, Nohide
if Change_Count > 0
{
	GuiControl, text, File_List, % Name_Log%Change_Count%
	File_Log := Name_Log%Change_Count%
	Change_Count--
	if Change_Count = 0
		GuiControl, Disable, Undo		
}
return //}

Set_Digit: //{
Gui, Submit, Nohide
return //}

Temp_Save: //{
Gui, Submit, Nohide
Change_Count++
Name_Log%Change_Count% := File_Log
File_Log := File_List
if Change_Count=1
	GuiControl, Enable, Undo
GuiControl, Disable, Temp_Save
return //}

File_Rename: //{
Gui, Submit, Nohide
Loop, parse, File_List, `n
{
	IniRead, Before_Name, FileNameLog, File List, % zfill(A_Index, File_Digit+1)
	IfNotExist, % Directory "\" Before_Name "\"
		FileMove, % Directory "\" Before_Name, % Directory "\" A_LoopField, R
	else
	FileMoveDir, % Directory "\" Before_Name, % Directory "\" A_LoopField, R
}
return //}

// Func List {
Survey_Digit(value)
{
	if value<10
		Digit = 1
	else if value<100
		Digit = 2
	else if value<1000
		Digit = 3
	else
		Digit = 4
return Digit
}

zfill(index, value)
{
	Temp_Text := "0000000" index
	StringRight, Output_Text, Temp_Text, value
	return Output_Text
}

Redaction(var)
{
	StringTrimLeft, var, var, 1
	return var
}

Save_Log()
{
	global
	Gui, Submit, Nohide
	Change_Count++
	Name_Log%Change_Count% := File_Log
	if Change_Count=1
		GuiControl, Enable, Undo
}

//}
