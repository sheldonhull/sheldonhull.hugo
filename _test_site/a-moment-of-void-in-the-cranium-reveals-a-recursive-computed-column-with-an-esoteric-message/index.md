# A moment of void in the cranium reveals a recursive computed column with an


`Msg 402, Level 16, State 1, Line 67 The data types varchar and void type are incompatible in the add operator.`

I came across this error today when I accidentally used a computed column in a temp table, that referenced itself. This very unhelpful message was caused by referring to the computed column itself in the computed column definition, ie typo. Beware!

