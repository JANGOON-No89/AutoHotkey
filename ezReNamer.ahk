#NoEnv
#KeyHistory 0
#CommentFlag //
ListLines Off
Process, Priority, , H
SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1

//{
	FileCreateDir, %A_Temp%\ReNamer
	FileInstall, images\help1.png, %A_Temp%\ReNamer\help1.png, 1
	FileInstall, images\help2.png, %A_Temp%\ReNamer\help2.png, 1
	FileInstall, images\help3.png, %A_Temp%\ReNamer\help3.png, 1
	FileInstall, images\help4.png, %A_Temp%\ReNamer\help4.png, 1
	FileInstall, images\help5.png, %A_Temp%\ReNamer\help5.png, 1
	FileInstall, images\help6.png, %A_Temp%\ReNamer\help6.png, 1
	FileInstall, images\help7.png, %A_Temp%\ReNamer\help7.png, 1
	FileInstall, images\help8.png, %A_Temp%\ReNamer\help8.png, 1
	FileInstall, images\help9.png, %A_Temp%\ReNamer\help9.png, 1
	FileInstall, images\notice.png, %A_Temp%\ReNamer\notice.png, 1
	FileInstall, images\a_Button_usual.png, %A_Temp%\ReNamer\a_Button_usual.png, 1
	FileInstall, images\a_Button_hover.png, %A_Temp%\ReNamer\a_Button_hover.png, 1
	FileInstall, images\a_Button_click.png, %A_Temp%\ReNamer\a_Button_click.png, 1
	FileInstall, ReNamer_Set.ini, %A_Temp%\ReNamer\ReNamer_Set.ini, 1
	FileInstall, Update_Set.ini, %A_Temp%\ReNamer\Update_Set.ini
//}

//{
	IniRead, version_chk, %A_Temp%\ReNamer\Update_Set.ini, setting, ask_update
	if (version_chk = "true")
	{
		IniRead, Current_ver, %A_Temp%\ReNamer\ReNamer_Set.ini, setting, version
		IniRead, Releases_path, %A_Temp%\ReNamer\ReNamer_Set.ini, setting, releases_path
		Elements := Get_Elements(Releases_path)
		if (Elements != "")
		{
			RegExMatch(Elements, "\n\s*(v[0-9.]*)\n\s*", o)
			Releases_ver := o1
			
			if (Current_ver != Releases_ver)
			{
				Gui, Notice: Add, Picture, x20 y15 w34 h34 , %A_Temp%\ReNamer\notice.png
				Gui, Notice: Add, Text, x+20 y18 w170 h12 , 새 버전이 있습니다.
				Gui, Notice: Add, Text, xp y+5 w170 h12 , 지금 업데이트 하시겠습니까?
				Gui, Notice: Add, CheckBox, x70 y+20 w300 h30 vAsk_Again , 다시 물어보지 않기
				Gui, Notice: Add, Button, x20 y+0 w100 h30 gUpdate_Yes , 예
				Gui, Notice: Add, Button, x+20 yp w100 h30 gUpdate_No , 아니오
				Gui, Notice: Show, w260 h140 , Notice
				Update_Answer := false
				WinWaitClose, Notice
				
				if (Update_Answer = true)
				{
					IniRead, File_URL, %A_Temp%\ReNamer\ReNamer_Set.ini, setting, download_url
					URLDownloadToFile, %File_URL%, %A_WorkingDir%\new_renamer.exe
					if errorlevel = 0
					{
						Run, new_renamer.exe
						WinWait, ahk_exe new_renamer.exe
						WinWaitClose, ahk_exe new_renamer.exe
						Run %comspec% /c Del "%A_ScriptFullPath%" & move "%A_WorkingDir%\new_renamer.exe" "%A_ScriptFullPath%",, hide
						ExitApp
					}
					else
						MsgBox, 48, Update Fail, 자동 업데이트에 실패했습니다.
				}
			}
		}
	}
//}

//{
	Gui, Add, CheckBox, x75 y3 w222 h18 cRed Checked vInclude_Folder gInclude_Folder, 목록을 불러올 때 폴더도 불러옵니다.
	Gui, Add, Edit, x10 y21 w240 h18 ReadOnly vDirectory , 우측 버튼을 눌러 경로를 선택해주세요.
	Gui, Add, Button, x260 y20 w100 h20 gSelect_Folder , 폴더 선택
	
	Gui, Add, GroupBox, x4 y38 w250 h57
	Gui, Add, Edit, x10 y50 w100 h18 vSearch_Word , 
	Gui, Add, Edit, xp y70 w100 h18 vReplace_Word ,
	Gui, Add, Text, x+2 y53 w35 h18 , (을)를
	Gui, Add, Text, xp y73 w35 h18 , (으)로
	Gui, Add, Button, x150 y49 w100 h40 gTemp_Change , 찾아 바꾸기
	
	Gui, Add, Picture, x260 y44 w100 h50 vRename_BTN_base , %A_Temp%\ReNamer\a_Button_usual.png
	Gui, Add, Picture, x260 y44 w100 h50 vRename_BTN_hover gFile_Rename +Hidden , %A_Temp%\ReNamer\a_Button_hover.png
	Gui, Add, Picture, x260 y44 w100 h50 vRename_BTN_click +Hidden , %A_Temp%\ReNamer\a_Button_click.png
	
	Gui, Add, Edit, x10 y101 w350 h390 vFile_List gFile_List -Wrap ReadOnly , 
	
	Gui, Add, GroupBox, x370 y10 w225 h55
	Gui, Add, Button, x375 y20 w120 h40 vTemp_Save gTemp_Save , 임시 저장
	Gui, Add, Button, x500 y20 w90 h40 vUndo gUndo , 이전으로
	
	Gui, Add, GroupBox, x370 y65 w225 h60
	Gui, Add, Edit, x375 y76 w120 h18 vFront_Word ,
	Gui, Add, Edit, x375 y101 w120 h18 vBack_Word ,
	Gui, Add, Button, x500 y75 w90 h20 gInsert_Front, 앞쪽에 추가
	Gui, Add, Button, x500 y100 w90 h20 gInsert_Back, 뒤쪽에 추가
	
	Gui, Add, GroupBox, x370 y125 w110 h70
	Gui, Add, Button, x375 y135 w100 h25 gRemove_Name , 파일명 제거
	Gui, Add, Button, x375 y165 w100 h25 gRemove_Extension , 확장자 제거
	
	Gui, Add, GroupBox, x485 y125 w110 h70
	Gui, Add, Edit, x491 y136 w98 h23 vExtension_Word ,
	Gui, Add, Button, x490 y165 w100 h25 gReplace_Extension , 확장자 변경
	
	Gui, Add, GroupBox, x370 y200 w225 h70
	Gui, Add, Text, x460 y200 w45 h20 +0x201 , 자릿수
	Gui, Add, Radio, x383 y220 w25 h20 gSet_Digit, 2
	Gui, Add, Radio, x+10 yp w25 h20 vSet_Digit gSet_Digit Checked , 3
	Gui, Add, Radio, x+10 yp w25 h20 gSet_Digit , 4
	Gui, Add, Radio, x+10 yp w25 h20 gSet_Digit , 5
	Gui, Add, Radio, x+10 yp w25 h20 gSet_Digit , 6
	Gui, Add, Radio, x+10 yp w25 h20 gSet_Digit , 7
	Gui, Add, Button, x490 y240 w100 h25 gFill_Zero , 자릿수 채우기
	Gui, Add, Button, x375 y240 w100 h25 gAdd_Zero , 번호 만들기
	
	Gui, Add, Button, x9 y495 w112 h20 gHelp , 도움말
	Gui, Add, Button, x249 y495 w112 h20 vGui_Expand gGui_Expand , 기능 확장 >>
	Gui, Add, Text, x130 y500 w110 h15 +Center , version 1.6
	
	Gui, Color, White
	Gui, Show, w370 h520, ReNamer
	
	GuiControl, Disable, Undo
	GuiControl, Disable, Temp_Save
	
	Amount := 0 , Change_Count = 0, Gui_Expand = 0, User_Fix = 1
	
	IniRead, Manual, %A_Temp%\ReNamer\ReNamer_Set.ini, setting, manual
	StringReplace, Manual, Manual, ``n, `n, All
	GuiControl, text, File_List, %Manual%
	
	Gui, Submit, Nohide
	OnMessage(0x200,"Hover")
return //}

GuiClose: //{
	FileDelete, %A_Temp%\ReNamer\History.ini
	ExitApp
return //}

Help: //{
	Gui, Help: New
	Gui, Font, cBlack
	Gui, Help: Add, Tab2, x0 y-2 w550 h20 , 주의 사항|버튼 도움말 1|버튼 도움말 2|변경 사항
	Gui, Help: Add, Picture, x0 y18 w550 h500 ,  %A_Temp%\ReNamer\help1.png
	
	Gui, Help: Tab, 2
	Gui, Help: Add, Text, x40 y40 w214 h16 +Center cRed, 앞쪽에 추가
	Gui, Help: Add, Text, x40 y230 w214 h16 +Center, "AAA" 를 앞쪽에 추가
	Gui, Help: Add, Picture, x40 y60 w214 h164 ,  %A_Temp%\ReNamer\help3.png
	
	Gui, Help: Add, Text, x296 y40 w210 h16 +Center cRed, 뒤쪽에 추가
	Gui, Help: Add, Text, x296 y230 w214 h16 +Center, "BBB" 를 뒤쪽에 추가
	Gui, Help: Add, Picture, x296 y60 w214 h164 ,  %A_Temp%\ReNamer\help4.png
	
	Gui, Help: Add, Text, x40 y280 w214 h16 +Center cRed, 자릿수 채우기
	Gui, Help: Add, Text, x40 y470 w214 h40 +Center, 지정된 자릿수만큼 0을 채워넣습니다.
	Gui, Help: Add, Picture, x40 y300 w214 h164 ,  %A_Temp%\ReNamer\help7.png
	
	Gui, Help: Add, Text, x296 y280 w210 h16 +Center cRed, 번호 만들기
	Gui, Help: Add, Text, x296 y470 w214 h40 +Center, 지정된 자릿수만큼 번호를 추가합니다.`n가장 앞쪽에 추가됩니다.
	Gui, Help: Add, Picture, x296 y300 w214 h164 ,  %A_Temp%\ReNamer\help8.png
	
	Gui, Help: Tab, 3
	Gui, Help: Add, Text, x40 y40 w214 h16 +Center cRed, 찾아 바꾸기
	Gui, Help: Add, Text, x40 y230 w214 h40 +Center, "A" 를 "드라마" 로 바꾸기
	Gui, Help: Add, Picture, x40 y60 w214 h164 ,  %A_Temp%\ReNamer\help2.png
	
	Gui, Help: Add, Text, x40 y280 w214 h16 +Center cRed, 확장자 변경
	Gui, Help: Add, Text, x40 y470 w214 h40 +Center, 모든 확장자를 "ini"로 변경`n점(.)은 입력하면 안됩니다.
	Gui, Help: Add, Picture, x40 y300 w214 h164 ,  %A_Temp%\ReNamer\help9.png
	
	Gui, Help: Add, Text, x296 y280 w210 h16 +Center cRed, 확장자 제거
	Gui, Help: Add, Text, x296 y470 w214 h40 +Center, 모든 확장자를 제거
	Gui, Help: Add, Picture, x296 y300 w214 h164 ,  %A_Temp%\ReNamer\help6.png
	
	Gui, Help: Add, Text, x296 y40 w210 h16 +Center cRed, 파일명 제거
	Gui, Help: Add, Text, x296 y230 w214 h40 +Center, 모든 파일명을 제거
	Gui, Help: Add, Picture, x296 y60 w214 h164 ,  %A_Temp%\ReNamer\help5.png
	
	Gui, Help: Tab, 4

	Gui, Help: Font, S12 Bold
	Gui, Help: Add, Text, x20 y40 w510 h20 , version 1.6
	Gui, Help: Font, S9 norm
	Gui, Help: Add, Text, x30 y60 w510 h20 cRed , "파일명 변경", "뒤쪽에 추가" 오류 수정 및 기능 개선
	Gui, Help: Add, Text, xp y+0 w510 h20 cRed , 버전 확인 및 자동 업데이트 기능 추가
	Gui, Help: Add, Text, xp y+0 w510 h20 cRed , 업데이트 로그(변경 사항) 디자인 변경
	Gui, Help: Font, S12 Bold
	Gui, Help: Add, Text, x20 y+20 w510 h20 , 이전 버전
	Gui, Help: Font, S9 norm
	Gui, Help: Add, Edit, x20 y+10 w510 h330 ReadOnly vPrev_Log, 	
	Gui, Help: Color, White
	Gui, Help: Show, w550 h520, ReNamer Help
	
	IniRead, Update_Log, %A_Temp%\ReNamer\ReNamer_Set.ini, setting, update_log
	StringReplace, Update_Log, Update_Log, ``n, `n, All
	GuiControl, text, Prev_Log, %Update_Log%
	
	Gui, Submit, Nohide
return //}

Update_Yes: //{
	Update_Answer := true
	gosub, Update_Ask
return //}

Update_No: //{
	gosub, Update_Ask
return //}

Update_Ask: //{
	Gui, Submit, Nohide
	if Ask_Again = 1
		IniWrite, false, %A_Temp%\ReNamer\Update_Set.ini, setting, ask_update
	Gui, Notice: Cancel
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
	{
		GuiControl, Enable, Temp_Save
		User_Fix := 0
	}
return //}

GuiDropFiles: //{
	Directory := A_GuiEvent
	gosub, Open_FileList
return //}

Gui_Expand: //{
	if (Gui_Expand = 0)
	{
		Gui_Expand = 1
		GuiControl, text, Gui_Expand, 기능 축소 <<
		Gui, Show, w600 h520
	}
	else
	{
		Gui_Expand = 0
		GuiControl, text, Gui_Expand, 기능 확장 >>
		Gui, Show, w370 h520
	}
	Gui, Submit, Nohide
return //}

Select_Folder: //{
	IniRead, Lasted_Folder, %A_Temp%\ReNamer\History.ini, SelectFolder, Directory
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
	IniDelete, %A_Temp%\ReNamer\History.ini, File_List
	IniWrite, %Directory%, %A_Temp%\ReNamer\History.ini, SelectFolder, Directory
	Loop, %Directory%\*, %Include_Folder%
		Amount++
	File_Digit := Survey_Digit(Amount)
	Loop, %Directory%\*, %Include_Folder%
	{
		IniWrite, %A_LoopFileName%, %A_Temp%\ReNamer\History.ini, File_List, % zfill(A_Index, File_Digit+1)
		File_Log .= "`n" . A_LoopFileName
	}
	File_Log := Redaction(File_Log)
	Original_Files := File_Log
	if (File_Log = "")
		File_Log := "ERROR!`n폴더가 아니거나, 표시 가능한 항목이 없습니다."
	GuiControl, text, File_List, % File_Log
	GuiControl, -ReadOnly, File_List
	Gui, Submit, Nohide
return //}

Temp_Change: //{
	Temp_Save(User_Fix)
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
	Temp_Save(User_Fix)
	Save_Log()
	Loop, parse, File_Log, `n
		Line_Log .= "`n" . Front_Word A_LoopField
	File_Log := Redaction(Line_Log)
	Line_Log := ""
	GuiControl, text, File_List, % File_Log
return //}

Insert_Back: //{
	Temp_Save(User_Fix)
	Save_Log()
	Loop, parse, File_Log, `n
	{
		IniRead, This_File, %A_Temp%\ReNamer\History.ini,  File_List, % zfill(A_Index, 3)
		FileGetAttrib, File_Att, % Directory "\" This_File
		IfInString, File_Att, D
			Line_Log .= "`n" . A_LoopField Back_Word
		else
		{
			StringGetPos, Word_Pos, A_LoopField, ., R
			if (Word_Pos = -1 || Word_Pos < StrLen(A_LoopField) - 6)
				Line_Log .= "`n" . A_LoopField Back_Word
			else
			{
				StringTrimLeft, Line_Ext, A_LoopField, Word_Pos
				StringTrimRight, Line_Name, A_LoopField, StrLen(A_LoopField) - Word_Pos
				Line_Log .= "`n" . Line_Name Back_Word Line_Ext
			}
		}
	}
	File_Log := Redaction(Line_Log)
	Line_Log := ""
	GuiControl, text, File_List, % File_Log
return //}

Remove_Name: //{
	Temp_Save(User_Fix)
	Save_Log()
	Loop, parse, File_Log, `n
	{
		StringGetPos, Word_Pos, A_LoopField, ., R
		StringTrimLeft, Line_File, A_LoopField, Word_Pos
		Line_Log .= "`n" . Line_File
	}
	File_Log := Redaction(Line_Log)
	Line_Log := ""
	GuiControl, text, File_List, % File_Log
return //}

Remove_Extension: //{
	Temp_Save(User_Fix)
	Save_Log()
	Loop, parse, File_Log, `n
	{
		StringGetPos, Word_Pos, A_LoopField, ., R
		StringTrimRight, Line_File, A_LoopField, StrLen(A_LoopField) - Word_Pos - 1
		Line_Log .= "`n" . Line_File
	}
	File_Log := Redaction(Line_Log)
	Line_Log := ""
	GuiControl, text, File_List, % File_Log
return //}

Replace_Extension: //{
	Temp_Save(User_Fix)
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
	Line_Log := ""
	GuiControl, text, File_List, % File_Log
return //}

Fill_Zero: //{
	Temp_Save(User_Fix)
	ERROR=0
	Loop, parse, File_Log, `n
	{
		StringGetPos, Word_Pos, A_LoopField, ., R
		if (Word_Pos > 0)
		{
			StringTrimLeft, Line_Ext, A_LoopField, Word_Pos
			StringTrimRight, Line_Name, A_LoopField, StrLen(A_LoopField) - Word_Pos
		}
		Str_Pos := RegExMatch(Line_Name, "[\.\$\^\(\)\+\[\]\{\}\s!,~``@%&\-_=;'ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z ]", opt) -1
		if (Str_Pos < 0)
		{
			if (StrLen(Line_Name) > Set_Digit + 1)
			{
				MsgBox, 16, Fill Error, 자릿수를 채울 수 없습니다.`n`n앞쪽 숫자의 갯수가 지정한 자릿수를 초과합니다.
				ERROR = 1
				break
			}
			Str_Pos := StrLen(Line_Name)
		}
		if (Str_Pos > Set_Digit + 1)
		{
			MsgBox, 16, Fill Error, 자릿수를 채울 수 없습니다.`n`n앞쪽 숫자의 갯수가 지정한 자릿수를 초과합니다.
			ERROR = 1
			break
		}
		StringLeft, Front_String, Line_Name, %Str_Pos%
		if (Front_String != "" && Front_String - 1 = "")
		{
			MsgBox, 16, Fill Error, 자릿수를 채울 수 없습니다.`n`n제목 앞쪽에 인식할 수 없는 문자가 존재합니다.
			ERROR = 1
			break
		}
		if (Front_String = "")
			Line_Log .= "`n" . zfill(Front_String, Set_Digit + 1) Line_Name . Line_Ext
		else
			Line_Log .= "`n" . StrReplace(Line_Name, Front_String, zfill(Front_String, Set_Digit + 1) , , 1) . Line_Ext
	}
	if ERROR = 0
	{
		Save_Log()
		File_Log := Redaction(Line_Log)
		Line_Log := ""
		GuiControl, text, File_List, % File_Log
	}
return //}

Add_Zero: //{
	Temp_Save(User_Fix)
	Save_Log()
	Loop, parse, File_Log, `n
		Line_Log .= "`n" . zfill(A_Index, Set_Digit+1) . A_LoopField
	File_Log := Redaction(Line_Log)
	Line_Log := ""
	GuiControl, text, File_List, % File_Log
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
	Temp_Save(User_Fix)
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
	User_Fix = 1
return //}

File_Rename: //{
	Gui, Submit, Nohide
	Img_Click()
	Rename_Err := 0, Change_List := ""
	Loop, parse, File_List, `n
	{
		IniRead, Before_Name, %A_Temp%\ReNamer\History.ini, File_List, % zfill(A_Index, File_Digit+1)
		IfNotExist, % Directory "\" Before_Name "\"
			FileMove, % Directory "\" Before_Name, % Directory "\" A_LoopField
		else
			FileMoveDir, % Directory "\" Before_Name, % Directory "\" A_LoopField, R
		if errorlevel = 0
		{
			IniWrite, %A_LoopField%, %A_Temp%\ReNamer\History.ini, File_List, % zfill(A_Index, File_Digit+1)
			Change_List .= "`n" A_LoopField
		}
		else
		{
			Change_List .= "`n" Before_Name
			Rename_Err++
		}
	}
	if (Rename_Err > 0)
	{
		File_List := Redaction(Change_List)
		GuiControl, text, File_List, %File_List%
		Gui, Submit, Nohide
		MsgBox, 이름이 중복되어 %Rename_Err%개 파일의 이름 변경에 실패했습니다.
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

Temp_Save(User_Fix)
{
	global
	if (User_Fix = 0)
	{
		Gui, Submit, Nohide
		Change_Count++
		Name_Log%Change_Count% := File_Log
		File_Log := File_List
		if Change_Count=1
			GuiControl, Enable, Undo
		GuiControl, Disable, Temp_Save
		User_Fix = 1
	}
}

Img_Click()
{
	GuiControl, Hide, Rename_BTN_hover
	GuiControl, Show, Rename_BTN_click
	KeyWait, Lbutton
	GuiControl, Show, Rename_BTN_hover
	GuiControl, Hide, Rename_BTN_click
}

Hover()
{
	MouseGetPos, , , , var
	if (var = "Static3" || var = "Static4")
	{
		GuiControl, Hide, Rename_BTN_base
		GuiControl, Show, Rename_BTN_hover
	}
	else
	{
		GuiControl, Show, Rename_BTN_base
		GuiControl, Hide, Rename_BTN_hover
	}
}

Get_Elements(var)
{
	try
	{
		p := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		p.Open("GET",var)
		p.Send()
		p.WaitForResponse()
		return p.ResponseText 
	}
	catch
		return
}

//}
