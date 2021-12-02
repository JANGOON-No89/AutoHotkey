#NoEnv
#KeyHistory 0
#CommentFlag //
ListLines Off
Process, Priority, , H
SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1

//{ 실행에 필요한 파일을 준비
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
FileInstall, Override_Set.ini, %A_Temp%\ReNamer\Override_Set.ini, 1
FileInstall, NoneOver_Set.ini, %A_Temp%\ReNamer\NoneOver_Set.ini
//}

//{ 버전 체크 및 업데이트
IniRead, version_chk, %A_Temp%\ReNamer\NoneOver_Set.ini, setting, ask_update
if (version_chk = "true")
{
	IniRead, Current_ver, %A_Temp%\ReNamer\Override_Set.ini, setting, version
	IniRead, Releases_path, %A_Temp%\ReNamer\Override_Set.ini, setting, releases_path
	Elements := Get_Elements(Releases_path)
	if (Elements != "")
	{
		RegExMatch(Elements, "\n\s*(v[0-9.]*)\n\s*", o) = ? Releases_ver := o1 : false
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
				IniRead, File_URL, %A_Temp%\ReNamer\Override_Set.ini, setting, download_url
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
} //}

//{ 메인 창 구성 및 초기설정
Gui, Add, CheckBox, x75 y3 w222 h18 cBlack vInclude_Folder gInclude_Folder, 목록을 불러올 때 폴더도 불러옵니다.
Gui, Add, Edit, x10 y21 w240 h18 ReadOnly vDirectory , 우측 버튼을 눌러 경로를 선택해주세요.
Gui, Add, Button, x260 y20 w100 h20 gSelect_Folder , 폴더 선택

Gui, Add, GroupBox, x4 y38 w250 h57
Gui, Add, Edit, x10 y50 w100 h18 vSearch_Word , 
Gui, Add, Edit, xp y70 w100 h18 vReplace_Word ,
Gui, Add, Text, x+2 y53 w35 h18 , (을)를
Gui, Add, Text, xp y73 w35 h18 , (으)로
Gui, Add, Button, x150 y49 w100 h40 gSrc_n_Rep , 찾아 바꾸기

Gui, Add, Picture, x260 y44 w100 h50 vRename_BTN_base , %A_Temp%\ReNamer\a_Button_usual.png
Gui, Add, Picture, x260 y44 w100 h50 vRename_BTN_hover gFile_Rename +Hidden , %A_Temp%\ReNamer\a_Button_hover.png
Gui, Add, Picture, x260 y44 w100 h50 vRename_BTN_click +Hidden , %A_Temp%\ReNamer\a_Button_click.png

Gui, Add, Edit, x10 y101 w350 h390 vEdit_Area gEdit_Area -Wrap ReadOnly , 

Gui, Add, GroupBox, x370 y10 w225 h55
Gui, Add, Button, x375 y20 w120 h40 vUndo gUndo , 이전으로
Gui, Add, Button, x500 y20 w90 h40 vList_Refresh gList_Refresh, 폴더 새로고침

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
Gui, Add, Radio, x383 y220 w25 h20 gFill_Digit, 2
Gui, Add, Radio, x+10 yp w25 h20 vFill_Digit gFill_Digit Checked , 3
Gui, Add, Radio, x+10 yp w25 h20 gFill_Digit , 4
Gui, Add, Radio, x+10 yp w25 h20 gFill_Digit , 5
Gui, Add, Radio, x+10 yp w25 h20 gFill_Digit , 6
Gui, Add, Radio, x+10 yp w25 h20 gFill_Digit , 7
Gui, Add, Button, x375 y240 w100 h25 gAdd_Zero , 번호 만들기
Gui, Add, Button, x490 y240 w100 h25 gFill_Zero , 자릿수 채우기

Gui, Add, GroupBox, x370 y270 w225 h70
Gui, Add, Text, x460 y270 w45 h20 +0x201 , 자릿수
Gui, Add, Radio, x383 y290 w25 h20 gDel_Digit, 1
Gui, Add, Radio, x+10 yp w25 h20 vDel_Digit gDel_Digit Checked , 2
Gui, Add, Radio, x+10 yp w25 h20 gDel_Digit , 3
Gui, Add, Radio, x+10 yp w25 h20 gDel_Digit , 4
Gui, Add, Radio, x+10 yp w25 h20 gDel_Digit , 5
Gui, Add, Radio, x+10 yp w25 h20 gDel_Digit , 6
Gui, Add, Button, x375 y310 w100 h25 gRemove_Front , 앞 문자열 제거
Gui, Add, Button, x490 y310 w100 h25 gRemove_Back , 뒷 문자열 제거

Gui, Add, Button, x9 y495 w112 h20 gHelp , 도움말
Gui, Add, Button, x249 y495 w112 h20 vGui_Expand gGui_Expand , 기능 확장 >>
Gui, Add, Button, x530 y495 w60 h20 gSetting , 설정

Gui, Add, Text, x130 y500 w110 h15 +Center , version 1.8
Gui, Color, White

// Gui 확장 여부 확인
IniRead, expand_chk, %A_Temp%\ReNamer\NoneOver_Set.ini, setting, gui_expand
if (expand_chk = "true")
{
	Gui_Expand := false
	Gui, Show, w600 h520, ReNamer
	GuiControl, text, Gui_Expand, 기능 축소 <<
}
else
{
	Gui_Expand := true
	Gui, Show, w370 h520, ReNamer
}

// 편집창에 메뉴얼 표시
IniRead, Manual, %A_Temp%\ReNamer\Override_Set.ini, setting, manual
StringReplace, Manual, Manual, ``n, `n, All
GuiControl, text, Edit_Area, %Manual%

// F5 새로고침 활성 여부 확인
IniRead, refresh_chk, %A_Temp%\ReNamer\NoneOver_Set.ini, setting, input_refresh
Input_Refresh := (refresh_chk = "true") ? 1 : 0

// 목록에 폴더를 표시할 것인지 확인
IniRead, include_chk, %A_Temp%\ReNamer\NoneOver_Set.ini, setting, include_folder
if (include_chk = "true")
{
	GuiControl, , Include_Folder, 1
	Gui, Font, cRed
	GuiControl, Font, Include_Folder
}

// 초기 설정 - 버튼 비활성화
GuiControl, Disable, Undo
GuiControl, Disable, List_Refresh
Gui, Submit, Nohide

// 초기 설정 - 마우스 Hover 이벤트 설정
OnMessage(0x200,"Hover")
return //}

GuiClose:
ExitApp
return

Help: //{ 도움말 창 구성
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
Gui, Help: Add, Text, x20 y40 w510 h20 , version 1.8
Gui, Help: Font, S9 norm
Gui, Help: Add, Text, x30 y60 w510 h20 cRed , 파일명에서 앞,뒤 문자열을 제거하는 기능 추가
Gui, Help: Add, Text, xp y+0 w510 h20 cRed , 기능을 확장한채로 프로그램 실행 기능 추가
Gui, Help: Add, Text, xp y+0 w510 h20 cRed , 기타 자잘한 오류 해결 및 로직 개선

Gui, Help: Font, S12 Bold
Gui, Help: Add, Text, x20 y+20 w510 h20 , 이전 버전
Gui, Help: Font, S9 norm
Gui, Help: Add, Edit, x20 y+10 w510 h330 ReadOnly vPrev_Log, 	
Gui, Help: Color, White
Gui, Help: Show, w550 h520, ReNamer Help

IniRead, Update_Log, %A_Temp%\ReNamer\Override_Set.ini, setting, update_log
StringReplace, Update_Log, Update_Log, ``n, `n, All
GuiControl, text, Prev_Log, %Update_Log%

Gui, Submit, Nohide
return //}

Setting: //{ 설정 창 구성
Gui, Setting: New
Gui, Setting: Add, Checkbox, x20 y20 w240 h20 vAuto_Update gAuto_Update , % " 자동 업데이트 허용"
Gui, Setting: Add, Checkbox, x20 y+10 w240 h20 vInput_Refresh gInput_Refresh , % " F5 키로 새로고침 허용"
Gui, Setting: Add, Checkbox, x20 y+10 w240 h20 vAlways_Expand gAlways_Expand , % " 기능을 확장한 채로 프로그램 실행"
Gui, Setting: Show, w280 h120, Setting

// 자동 업데이트 설정 여부 확인
IniRead, version_chk, %A_Temp%\ReNamer\NoneOver_Set.ini, setting, ask_update
GuiControl, , Auto_Update, % version_chk = "true" ? 1 : 0

// F5 새로고침 활성 여부 확인
IniRead, refresh_chk, %A_Temp%\ReNamer\NoneOver_Set.ini, setting, input_refresh
GuiControl, , Input_Refresh, % refresh_chk = "true" ? 1 : 0

// 기능 확장 여부 확인
IniRead, expand_chk, %A_Temp%\ReNamer\NoneOver_Set.ini, setting, gui_expand
GuiControl, , Always_Expand, % expand_chk = "true" ? 1 : 0

Gui, Submit, Nohide
return //}



//{ 설정

Auto_Update: //{ 자동 업데이트 체크
IniWrite, % Auto_Update = 0 ? "true" : "false", %A_Temp%\ReNamer\NoneOver_Set.ini, setting, ask_update
Gui, Submit, Nohide
return //}

Input_Refresh: //{ F5 키로 새로고침 허용
IniWrite, % Input_Refresh = 0 ? "true" : "false", %A_Temp%\ReNamer\NoneOver_Set.ini, setting, input_refresh
Gui, Submit, Nohide
return //}

Always_Expand: //{ 기능을 확장한 채로 프로그램 실행
IniWrite, % Always_Expand = 0 ? "true" : "false", %A_Temp%\ReNamer\NoneOver_Set.ini, setting, gui_expand
Gui, Submit, Nohide
return //}

Include_Folder: //{ 폴더 목록도 불러오기
IniWrite, % Include_Folder = 0 ? "true" : "false", %A_Temp%\ReNamer\NoneOver_Set.ini, setting, include_folder
Gui, Font, % Include_Folder = 0 ? "cRed" : "cBlack"
GuiControl, Font, Include_Folder
Gui, Submit, Nohide
return //}}



//{ 업데이트 알림

Update_Yes: //{ 예 버튼
Update_Answer := true

Update_No: // 아니오 버튼
gosub, Update_Ask
return //}

Update_Ask: //{ 다시 물어보지 않음
Gui, Submit, Nohide
IniWrite, % Ask_Again = 0 ? "true" : "false", %A_Temp%\ReNamer\NoneOver_Set.ini, setting, ask_update
Gui, Notice: Cancel
return //}}



//{ Gui 컨트롤

Edit_Area: //{ 편집 영역에서 사용자 편집을 감지
if A_GuiEvent=Normal
{
	Gui, Submit, Nohide
	User_Fix := true
	if (Edit_Area = File_Log && Change_Count = 0)
		GuiControl, Disable, Undo
	else
		GuiControl, Enable, Undo
}
return //}

Gui_Expand: //{ Gui 확장 및 축소
if (Gui_Expand = true)
{
	Gui_Expand := false
	GuiControl, text, Gui_Expand, 기능 확장 >>
	Gui, Show, w370 h520
}
else
{
	Gui_Expand := true
	GuiControl, text, Gui_Expand, 기능 축소 <<
	Gui, Show, w600 h520
}
Gui, Submit, Nohide
return //}

Fill_Digit: //{	채울 자릿수 선택
Del_Digit: //	제거할 자릿수 선택
Save_UserFix()
return //}}



//{ 폴더 선택 명령

GuiDropFiles: //{ 폴더를 드래그하여 파일목록 불러오기
Directory := A_GuiEvent

List_Refresh: // 목록 새로고침
gosub, Open_FileList
return //}

#IfWinActive, ReNamer //{ F5 키를 누르면 목록 새로고침
F5::
GuiControlGet, Button_State, Enabled, List_Refresh
if (Input_Refresh = 1 && Button_State = 1)
	gosub, Open_FileList
return
#If //}

Select_Folder: //{ 폴더 선택
if (Directory = "")
	FileSelectFolder, Directory
else
	FileSelectFolder, Directory, *%Directory%, 3
gosub, Open_FileList
return //}

Open_FileList: //{ 파일 목록 불러오기
Origin_List := "", Att_List := "", Change_Count := -1, User_Fix := false, ERROR := 0
GuiControl, Disable, Undo
GuiControl, text, Directory, %Directory%
Gui, Submit, Nohide
FileGetAttrib, File_Att, %Directory%
IfInString, File_Att, D
{
	File_List := "", Amount := 0
	Origin_List := Object(), Att_List := Object()
	Loop, %Directory%\*, %Include_Folder%
		Amount++
	if (Amount != 0)
	{
		Loop, %Directory%\*, %Include_Folder%
		{
			ObjRawSet(Origin_List, A_Index, A_LoopFileName)
			ObjRawSet(Att_List, A_Index, A_LoopFileAttrib)
			File_List .= "`n" . A_LoopFileName
		}
		Save()
		GuiControl, Enable, List_Refresh
		GuiControl, -ReadOnly, Edit_Area
	}
	else
		ERROR = 1
}
else
	ERROR = 1
if ERROR != 0
{
	GuiControl, text, Edit_Area, ERROR!`n`n대상이 잘못되었거나, 표시 가능한 항목이 없습니다.
	GuiControl, Disable, List_Refresh
	GuiControl, +ReadOnly, Edit_Area
}
Gui, Submit, Nohide
return //}}



//{ 편집 명령

File_Rename: //{ 파일명 변경
Img_Click()
Save_UserFix()
Loop, parse, Edit_Area, `n
{
	if InStr(Att_List[A_Index], "D")
		FileMoveDir, % Directory "\" Origin_List[A_Index], % Directory "\" A_LoopField, R
	else
		FileMove, % Directory "\" Origin_List[A_Index], % Directory "\" A_LoopField
	if errorlevel = 0
	{
		ObjRawSet(Origin_List, A_Index, A_LoopField)
		File_List .= "`n" . A_LoopField
	}
	else
	{
		File_List .= "`n" . Origin_List[A_Index]
		Err_Stack++
	}
}
Save()
if (Err_Stack > 0)
	MsgBox, 파일명이 중복되어 %Err_Stack%개 파일의 이름 변경에 실패했습니다.
return //}


Undo: //{ 이전으로
Save_UserFix()
if (Change_Count > 0)
{
	Change_Count--
	GuiControl, text, Edit_Area, % Name_Log%Change_Count%
	File_Log := Name_Log%Change_Count%
	if Change_Count = 0
		GuiControl, Disable, Undo		
}
Gui, Submit, Nohide
return //}


Src_n_Rep: //{ 찾아 바꾸기
Save_UserFix()
StringReplace, File_Log, File_Log, %Search_Word%, %Replace_Word%, All
if errorlevel = 0
{
	GuiControl, text, Edit_Area, % File_Log
	Save_Log()
}
return //}


Insert_Front: //{ 앞쪽에 추가
Save_UserFix()
if (Front_Word != "")
{
	Loop, parse, File_Log, `n
		File_List .= "`n" . Front_Word A_LoopField
	Save()
}
return //}


Insert_Back: //{ 뒤쪽에 추가
Save_UserFix()
if (Back_Word != "")
{
	Loop, parse, File_Log, `n
	{
		Not_Ext := Ext_Chk()
		if (Not_Ext = true)
			File_List .= "`n" . A_LoopField . Back_Word
		else
		{
			StringTrimLeft, File_Ext, A_LoopField, Dot_Pos
			StringTrimRight, File_Name, A_LoopField, StrLen(A_LoopField) - Dot_Pos
			File_List .= "`n" . File_Name . Back_Word . File_Ext
		}
	}
	Save()
}
return //}


Remove_Name: //{ 파일명 제거
Save_UserFix()
ERROR := 0, Err_Stack := 0
Loop, parse, File_Log, `n
{
	Not_Ext := Ext_Chk()
	if (Not_Ext = true)
		File_List .= "`n", Err_Stack++
	else
	{
		StringTrimLeft, File_Ext, A_LoopField, Dot_Pos
		File_List .= "`n" . File_Ext
	}
}
if (Err_Stack > 0)
{
	MsgBox, 52, Caution!, 확장자가 없는 파일이 있습니다.`n`n문자열 제거시 공란이 됩니다. 정말 제거하시겠습니까?
	IfMsgBox, No
		ERROR = 1
}
if ERROR = 0
	Save()
else
	File_List := ""
return //}


Remove_Extension: //{ 확장자 제거
Save_UserFix()
Loop, parse, File_Log, `n
{
	Not_Ext := Ext_Chk()
	if (Not_Ext = true)
		File_List .= "`n" . A_LoopField
	else
	{
		StringTrimRight, File_Name, A_LoopField, StrLen(A_LoopField) - Dot_Pos - 1
		File_List .= "`n" . File_Name
	}
}
Save()
return //}


Replace_Extension: //{ 확장자 변경
Save_UserFix()
if (Extension_Word != "")
{
	Loop, parse, File_Log, `n
	{
		Not_Ext := Ext_Chk()
		if (Not_Ext = true)
			File_List .= "`n" . A_LoopField
		else
		{
			StringTrimRight, File_Name, A_LoopField, StrLen(A_LoopField) - Dot_Pos - 1
			File_List .= "`n" . File_Name . Extension_Word
		}
	}
	Save()
}
return //}


Add_Zero: //{ 번호 만들기
Save_UserFix()
Loop, parse, File_Log, `n
	File_List .= "`n" . zfill(A_Index, Fill_Digit+1) . A_LoopField
Save()
return //}


Fill_Zero: //{ 자릿수 채우기
Save_UserFix()
ERROR := 0
Loop, parse, File_Log, `n
{
	Not_Ext := Ext_Chk()
	if (Not_Ext = true)
		File_Name := A_LoopField, File_Ext := ""
	else
	{
		StringTrimLeft, File_Ext, A_LoopField, Dot_Pos
		StringTrimRight, File_Name, A_LoopField, StrLen(A_LoopField) - Dot_Pos
	}
	RegExMatch(File_Name, "^\d*", Front_Num) = ? Front_Num := Front_Num1 : false
	Front_Digit := Front_Num = "" ? 0 : StrLen(Front_Num)
	StringTrimLeft, Front_Text, File_Name, Front_Digit
	if (Front_Digit > Fill_Digit + 1)
	{
		MsgBox, 16, Fill Error, 자릿수를 채울 수 없습니다.`n`n앞쪽 숫자의 갯수가 지정한 자릿수를 초과하는 파일이 있습니다.
		ERROR = 1
		break
	}
	else
		File_List .= "`n" . zfill(Front_Num, Fill_Digit + 1) . Front_Text . File_Ext
}
if ERROR = 0
	Save()
else
	File_List := ""	
return //}}


Remove_Front: //{ 앞 뒤 문자열 제거
Left_Trim := true
Remove_Back:
Save_UserFix()
ERROR := 0, Err_Stack := 0
Loop, parse, File_Log, `n
{
	Not_Ext := Ext_Chk()
	if (Not_Ext = true)
		File_Name := A_LoopField, File_Ext := ""
	else
	{
		StringTrimLeft, File_Ext, A_LoopField, Dot_Pos
		StringTrimRight, File_Name, A_LoopField, StrLen(A_LoopField) - Dot_Pos
	}
	if (StrLen(File_Name) = Del_Digit && Not_Ext)
		File_List .= "`n", Err_Stack++
	else if (StrLen(File_Name) >= Del_Digit)
	{
		if (Left_Trim = true)
			StringTrimLeft, File_Name, File_Name, Del_Digit
		else
			StringTrimRight, File_Name, File_Name, Del_Digit
		File_List .= "`n" . File_Name . File_Ext
	}
	else
	{
		MsgBox, 16, Remove Error, 문자열을 제거할 수 없습니다.`n`n파일명이 제거하려는 글자 수 보다 작습니다.
		ERROR = 1
		break
	}
}
if (Err_Stack > 0)
{
	MsgBox, 52, Caution!, 확장자가 없는 파일이 있습니다.`n`n문자열 제거시 공란이 됩니다. 정말 제거하시겠습니까?
	IfMsgBox, No
		ERROR = 1
}
if ERROR = 0
	Save()
else
	File_List := "", Left_Trim := false
return //}



//{ 사용되는 함수

zfill(index, value) // 숫자 앞에 0을 넣어 자릿수를 맞춤
{
	Temp_Text := "0000000" index
	StringRight, Output_Text, Temp_Text, value
	return Output_Text
}

LF_Trim(var) // 문자열의 첫번째 글자를 지움. 엔터를 제거할 용도
{
	StringTrimLeft, var, var, 1
	return var
}

Ext_Chk() // 파일명에 확장자가 있는지 확인하여 분류
{
	global Dot_Pos, Att_List
	if InStr(Att_List[A_Index], "D")
		var := true
	else
	{
		StringGetPos, Dot_Pos, A_LoopField, ., R
		if (Dot_Pos > 0)
			var := false
		else
			var := true
	}
	return var
}

Save_UserFix() // 편집영역에서 사용자가 직접 편집한 내용을 기록
{
	global
	Gui, Submit, Nohide
	if (User_Fix = true && Edit_Area != File_Log)
	{
		Change_Count++
		Name_Log%Change_Count% := Edit_Area
		File_Log := Edit_Area
		User_Fix := false
	}
}

Save_Log() // 버튼으로 편집한 내용을 기록
{
	global
	Gui, Submit, Nohide
	Change_Count++
	Name_Log%Change_Count% := File_Log
	if (Change_Count > 0)
		GuiControl, Enable, Undo
}

Save() // 편집 내용 기록 절차를 한번에 실행
{
	global
	File_Log := LF_Trim(File_List)
	File_List := ""
	GuiControl, text, Edit_Area, % File_Log
	Save_Log()
}

Img_Click() // 마우스 클릭 이벤트. 이미지를 버튼으로 사용하기 위함
{
	GuiControl, Hide, Rename_BTN_hover
	GuiControl, Show, Rename_BTN_click
	KeyWait, Lbutton
	GuiControl, Show, Rename_BTN_hover
	GuiControl, Hide, Rename_BTN_click
}

Hover() // 마우스 Hover 이벤트. 이미지를 버튼으로 사용하기 위함
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

Get_Elements(var) // 온라인에서 최신 버전정보를 추출
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
} //}
