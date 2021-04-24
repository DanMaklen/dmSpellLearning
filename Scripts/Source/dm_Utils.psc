Scriptname dm_Utils Hidden
{Some utility functions used through out the code}

; Transforms float to string with with certain precision
string Function FloatToString(float val, int precision = 2) global
    int decimalUnit = Math.pow(10, precision) as int
    int fixedDecimalValue = (val * decimalUnit) as int
    Return (fixedDecimalValue / decimalUnit) + "." + AppendFillCharacter(fixedDecimalValue % decimalUnit, "0", precision)
EndFunction

string Function FloatToPercentage(float val, int precision = 2) global
    return FloatToString(val * 100, precision) + "%"
EndFunction

string Function FloatToHours(float val) global
    string hours = " Hour"
    If (val > 1)
        hours += "s"
    EndIf
    return Math.Ceiling(val) + hours
EndFunction

string Function AppendFillCharacter(string str, string char, int width) global
    int count = width - StringUtil.GetLength(str)
    While (count > 0)
        str = char + str
        count -= 1
    EndWhile
    return str
EndFunction

int Function MinInt(int a, int b) global
    If (a < b)
        return a
    EndIf
    return b
EndFunction

float Function MaxFloat(float a, float b) global
    If (a > b)
        return a
    EndIf
    return b
EndFunction

float Function GetGameTimeInHours() global
    return Utility.GetCurrentGameTime() * 24
EndFunction