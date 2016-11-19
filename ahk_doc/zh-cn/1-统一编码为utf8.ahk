#NoEnv
#Warn, UseUnsetGlobal, StdOut
#Warn, LocalSameAsGlobal, StdOut
#Warn, UseUnsetLocal, Off
#Include %A_ScriptDir%
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
ListLines Off

global Gs_Author := "Fonny"
, Gs_OptionFile := SubStr(A_ScriptName, 1, -3) "ini"
, Gs_DebugLevel := 3

Include_CpTransform()
delHead()

ExitApp
return

delHead()
{
   Loop, %A_ScriptDir%\*.htm, , 1
   {
      _fEncoding := File_GetEncoding(A_LoopFileFullPath)

      ;~ 1 = ANSI
      ;~ 4 = UTF-8 +BOM
      ;~ 6 = UTF-8
      if (_fEncoding = 1)
      {
         File_CpTransform(A_LoopFileFullPath, "a", "u")
      }
      else if (_fEncoding = 4)
      {
         File_CpTransform(A_LoopFileFullPath, "b", "u")
      }

      FileRead, content, % A_LoopFileFullPath
      FileDelete, % A_LoopFileFullPath

      _newContent := ""

      ;~ 解析内容
      loop, Parse, % content, `n, `r
      {
         _line := A_LoopField

         if (A_Index < 10)
         {
            if (_line ~= "i)\<meta.+?iso-8859-1")
            {
               _line := RegExReplace(_line, "i)iso-8859-1", "utf-8")
            }
            if (_line ~= "i)\<meta.+?gb2312")
            {
               _line := RegExReplace(_line, "i)gb2312", "utf-8")
            }
         }
         _newContent .= _line "`n"
      }
      ;~ 删除最后的换行符
      _newContent := Trim(_newContent, "`n")
      FileAppend, % _newContent, % A_LoopFileFullPath
      ToolTip, %A_Index% %A_LoopFileFullPath% 完成
   }
   Trace("替换头部完成", 3)
   return
}