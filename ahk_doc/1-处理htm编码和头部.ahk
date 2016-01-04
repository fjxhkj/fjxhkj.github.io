#NoEnv
#Warn
#Warn, LocalSameAsGlobal, Off
#Warn, UseUnsetLocal, StdOut

global Gs_IsDebug := true
, gs_version := 0.1
, gs_author := "Fonny"
, gs_public := "2015"
, gs_setting_ini := SubStr(A_ScriptName, 1, -4) ".ini"

Include_Functions()
Include_CpTransform()

delHead()

ExitApp
return

delHead()
{
   ;~ Loop, %A_ScriptDir%\*.htm, , 1
   ;~ 遍历目录用 D, 文件用 F, 文件和目录用 DF.
   loop, Files, %A_ScriptDir%\*.htm*, RF
   {
      _fEncoding := Unicode_GetFileEncoding(A_LoopFileLongPath)
      
      ;~ Debug(A_LineFile "`nFunc `: " A_ThisFunc "`nLine : " A_LineNumber "`n`n"
      ;~ . "encoding " _fEncoding "`n" A_LoopFileLongPath)

      ;~ utf8+bom,需要改为 utf8 no bom
      if (_fEncoding = 4)
      {
          File_CpTransform(A_LoopFileFullPath, "b", "u")
      }
      ;~ ansi,需要改为utf8 no bom
      else if (_fEncoding = 1)
      {
         ;~ Debug(A_LineFile "`nline`: " A_LineNumber "`nFunc`:" A_ThisFunc "`n`n"
         ;~ . A_LoopFileFullPath)
         
         File_CpTransform(A_LoopFileFullPath, "a", "u")
      }
      ;~ utf8 no bom,改为ANSI
      else if (_fEncoding = 6)
      {
         ;~ File_CpTransform(A_LoopFileFullPath, "u", "a")         
      }
      
      FileRead, content, % A_LoopFileFullPath
      FileDelete, % A_LoopFileFullPath
      
      _newContent := ""      
      
      ;~ 解析内容
      loop, Parse, % content, `n, `r
      {
         _line := A_LoopField
         
         if (A_Index = 6)
         || (A_Index = 7)
         {
            if (_line ~= "i)charset=iso-8859-1")
            {
               _line := RegExReplace(_line,"i)charset=iso-8859-1","charset=utf-8")
            }            
            else if (_line ~= "i)charset=GB2312")
            {
               _line := RegExReplace(_line,"i)charset=GB2312","charset=utf-8")               
            }
         }
         else if (A_Index = 9)
         || (A_Index = 10)
         {
            if (_line ~= "^<script.*jquery")
            {
               continue
            }
         }
         
         _newContent .= _line "`n"
      }
      ;~ 删除最后的换行符
      _newContent := SubStr(_newContent, 1 , -1)
      FileAppend, % _newContent, % A_LoopFileFullPath
      ToolTip, %A_Index% %A_LoopFileLongPath% 完成
   }
   Trace("替换头部完成", 3)
   return
}

go_change1()
{
   ;~ 新版的js引用位置变化
   _replaceStr1 =
   (`"
   static/jquery.js" type="text/javascript"></script>
   )

   _replaceStr2=
   (`"
   static/tree.jquery.js" type="text/javascript"></script>
   )

   Loop, %A_ScriptDir%\*.htm, , 1
   {
       FileRead, content, % A_LoopFileFullPath
       FileDelete, % A_LoopFileFullPath

      _newContent := ""
      Loop, parse, content, `n, `r
      {
         _line := Trim(A_LoopField)
         if (A_Index < 20)
         && ((_line ~= _replaceStr1) || (_line ~= _replaceStr2))
         {
            continue
         }
         _newContent .= A_LoopField "`n"
      }
      
      ;~ 删除最后的换行符
      _newContent := SubStr(_newContent, 1 , -1)
      
      FileAppend, % _newContent, % A_LoopFileFullPath
   }
   Trace("第一步完成")
   Sleep, 500
   return
}
