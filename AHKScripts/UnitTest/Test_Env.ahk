
#Include <AHKEZ>
#Include <AHKEZ_UnitTest>

T := New UnitTest()

DEBUG := T.GetOption("Debug") ;DEBUG := True

;** START TEST

Var := 0
EnvAdd(Var, 10) 
EnvAdd(Var, 10) 
;MsgBox 0, EnvAdd, Var= %NL% %Var%
T.Assert(A_ScriptName, A_Linenumber, Var , 20)

v := EnvGet("SystemDrive")
;EnvGet, v, SystemDrive
;MsgBox 0, EnvGet, v= %NL% %v%
T.Assert(A_ScriptName, A_Linenumber, v , "C:")

EnvSet("MY_ENV_VAR", "My Value")
v := EnvGet("MY_ENV_VAR")
;MsgBox 0, EnvSet, v= %NL% %v%
T.Assert(A_ScriptName, A_Linenumber, v , "My Value")

EnvUpdate()

Var := 20
EnvSub(Var, 10) 
EnvSub(Var, 10) 
;MsgBox 0, EnvSub, Var= %NL% %Var%
T.Assert(A_ScriptName, A_Linenumber, Var , 0)

T.Close()
T := ""
ExitApp

Escape::
ExitApp

