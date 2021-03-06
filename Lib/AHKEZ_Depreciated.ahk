
IfNotBetween_DEPRECIATED(ByRef var, LowerBound, UpperBound) {
  If var not between %LowerBound% and %UpperBound%
    Return, true
}
IfIs_DEPRECIATED(ByRef var, type) {
  If var is %type%
    Return, true
}
IfIsNot_DEPRECIATED(ByRef var, type) {
  If var is not %type%
    Return, true
}
IfIs_Type(ByRef var, type) {
  If var is %type%
    Return, true
}
StrIsBlank_DEPRECIATED(Haystack) {
  Return RegExMatch(Haystack, "^[\s]+$")
}
StrIsEmpty_DEPRECIATED(Haystack) {
  Return (Haystack = "")
}
StringGetPos_DEPRECIATED(ByRef InputVar, SearchText, Mode = "", Offset = "") {
  StringGetPos, v, InputVar, %SearchText%, %Mode%, %Offset%
  Return, v
}
StringLeft_DEPRECIATED(ByRef InputVar, Count) {
  StringLeft, v, InputVar, %Count%
  Return, v
}
StringLen_DEPRECIATED(ByRef InputVar) {
  StringLen, v, InputVar
  Return, v
}
StringMid_DEPRECIATED(ByRef InputVar, StartChar, Count , L = "") {
  StringMid, v, InputVar, %StartChar%, %Count%, %L%
  Return, v
}
StringReplace_DEPRECIATED(ByRef InputVar, SearchText, ReplaceText = "", All = "") {
  StringReplace, v, InputVar, %SearchText%, %ReplaceText%, %All%
  Return, v
}
StringRight_DEPRECIATED(ByRef InputVar, Count) {
  StringRight, v, InputVar, %Count%
  Return, v
}
StringTrimLeft_DEPRECIATED(ByRef InputVar, Count) {
  StringTrimLeft, v, InputVar, %Count%
  Return, v
}
StringTrimRight_DEPRECIATED(ByRef InputVar, Count) {
  StringTrimRight, v, InputVar, %Count%
  Return, v
}
Transform_DEPRECIATED(SubCommand, Value1, Value2 = "") {
  Transform, v, %SubCommand%, %Value1%, %Value2%
  Return, v
}
