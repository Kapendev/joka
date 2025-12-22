import os
import strutils

var n = 0
if paramCount() > 0:
    n = parseInt(paramStr(1))
if n == 0:
    echo "Usage: array_append_remove <count>"
    quit(0)

var array: seq[int32]
for i in 0..<n:
    array.add(int32(i))
while array.len != 0:
    discard array.pop()
