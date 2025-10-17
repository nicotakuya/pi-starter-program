'kairozu editer by takuya matsubara
acls

dim kairo$[0]
dim undo$[0]
dim buf$[0]
undomax=8

PATH$=chdir()
size=80
partsfile$="PARTS.TXT"
qwe$="QWERTYUIOP@[]"

dim tmp$[0]
push tmp$,"┌┐┘└"
push tmp$,"─│─│"
push tmp$,"├┬┤┴"
push tmp$,""
push tmp$,""
push tmp$,""

'KEYCODE
RIGHT = 28
LEFT  = 29
UP    = 30
DOWN  = 31
ENTER = 13
SPACE = 32
ESCAPE= &H1B

vieww=60
viewh=36

dim keisen$[0]
dim parts$[0]

gosub @loadparts

acls

gosub @grid

restore @keisendata
while 1
 read a$
 if a$=="" then break
 push keisen$,a$
wend
@keisendata
data "│","─","└","┘","┌","┐","├","┤","┬","┴","┼","●","μ","","","","",""

'&b0001  ""
'&b0010  ""
'&b0100  ""
'&b1000  ""
'&b0101  "│"
'&b1010  "─"
'&b0011  "└"
'&b1001  "┘"
'&b0110  "┌"
'&b1100  "┐"
'&b0111  "├"
'&b1101  "┤"
'&b1110  "┬"
'&b1011  "┴"
'&b1111  "┼"

' "└│┌├┘─┴┐┤┬┼"

'--- FONTDEF
RESTORE @FONTDATA
for i=0 to len(keisen$)-1
 c=asc(keisen$[i])
 A$=""
 FOR Y=0 TO 7
  READ D$
  FOR X=0 TO 7
   IF MID$(D$,X,1)!=" " THEN
    A$=A$+"FFFFFFFF"
   ELSE
    A$=A$+"00000000"
   ENDIF
  NEXT
 NEXT
 FONTDEF C,A$
next

@FONTDATA
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "

DATA "        "
DATA "        "
DATA "        "
DATA "11111111"
DATA "        "
DATA "        "
DATA "        "
DATA "        "

DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   11111"
DATA "        "
DATA "        "
DATA "        "
DATA "        "

DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "1111    "
DATA "        "
DATA "        "
DATA "        "
DATA "        "

DATA "        "
DATA "        "
DATA "        "
DATA "   11111"
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "

DATA "        "
DATA "        "
DATA "        "
DATA "1111    "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "

DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   11111"
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "

DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "1111    "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "

DATA "        "
DATA "        "
DATA "        "
DATA "11111111"
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "

DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "11111111"
DATA "        "
DATA "        "
DATA "        "
DATA "        "

DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "11111111"
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "

DATA "   11   "
DATA "  1111  "
DATA " 111111 "
DATA "11111111"
DATA "11111111"
DATA " 111111 "
DATA "  1111  "
DATA "   11   "

DATA "        "
DATA " 1    1 "
DATA " 1    1 "
DATA " 1    1 "
DATA " 1    1 "
DATA " 11  11 "
DATA " 1 11 1 "
DATA " 1      "

DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "        "
DATA "        "
DATA "        "
DATA "        "

DATA "        "
DATA "        "
DATA "        "
DATA "        "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "

DATA "        "
DATA "        "
DATA "        "
DATA "1111    "
DATA "        "
DATA "        "
DATA "        "
DATA "        "

DATA "        "
DATA "        "
DATA "        "
DATA "   11111"
DATA "        "
DATA "        "
DATA "        "
DATA "        "

DATA "1  1    "
DATA " 1 1    "
DATA "  11    "
DATA "11111111"
DATA "   1    "
DATA "  11    "
DATA " 1 1    "
DATA "1  1    "

DATA "       1"
DATA "       1"
DATA "       1"
DATA "11111111"
DATA "       1"
DATA "       1"
DATA "       1"
DATA "       1"

DATA "    1111"
DATA "      11"
DATA "     1 1"
DATA "    1  1"
DATA "   1    "
DATA "  1     "
DATA " 1      "
DATA "1       "

DATA "   1    "
DATA "  111   "
DATA " 1 1 1  "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "

DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA "   1    "
DATA " 1 1 1  "
DATA "  111   "
DATA "   1    "

DATA "        "
DATA "     1  "
DATA "      1 "
DATA "11111111"
DATA "      1 "
DATA "     1  "
DATA "        "
DATA "        "

DATA "        "
DATA "  1     "
DATA " 1      "
DATA "11111111"
DATA " 1      "
DATA "  1     "
DATA "        "
DATA "        "


ofsp=0
ofsx=0
ofsy=0
mx=floor(vieww/2)
my=floor(viewh/2)

spn=0
spset spn,300
spscale spn,0.5,0.5
SPANIM spn,"I",6,32,6,298,0

kairofile$="newfile.txt"
for i=0 to size-1
 push kairo$," "*size
next
gosub @partslist
gosub @clearmenu
gosub @initmenu

olddir=0
mode=0
x1=0
y1=0

redraw=1
while 1
 mx=FIXNUM(mx,0,size-1)
 my=FIXNUM(my,0,size-1)
 while 1
  if mx<ofsx          then dec ofsx:redraw=1:continue
  if mx>=(ofsx+vieww) then inc ofsx:redraw=1:continue
  if my<ofsy          then dec ofsy:redraw=1:continue
  if my>=(ofsy+viewh) then inc ofsy:redraw=1:continue
  break
 wend
 locate 45,44
 print "(x=";format$("%2d",mx);
 print ",y=";format$("%2d",my);")";

 if redraw then
  gosub @redrawkairo
  redraw=0
 endif

 spofs spn,(mx-ofsx)*8,(my-ofsy)*8
 gridend ofsx,ofsy

 bt=KEYWAIT()
 if bt==up    then autokeisen 1:dec my:x1=0 :y1=-1
 if bt==down  then autokeisen 4:inc my:x1=0 :y1=1 
 if bt==left  then autokeisen 8:dec mx:x1=-1:y1=0 
 if bt==right then autokeisen 2:inc mx:x1=1 :y1=0 
 if bt==escape then break

 if bt==enter then
  mode=0
  gosub @cutarea
  gosub @clearmenu
  gosub @initmenu
  gosub @redrawkairo
  continue
 endif

 if bt==asc("*") then
  mode=(mode+1) mod 3
  gosub @clearmenu
  gosub @initmenu
  continue
 endif

 if mode==1 then
  if bt>=&H20 then
   pushundo
   kairo$[my]=subst$(kairo$[my],mx,1,chr$(bt))
   redraw=1
   mx=mx+x1
   my=my+y1
  endif
  continue
 endif

 if bt==space then
  pushundo
  kairo$[my]=subst$(kairo$[my],mx,1," ")
  redraw=1
'  locate mx-ofsx,my-ofsy
'  print " ";
  mx=mx+x1
  my=my+y1
 endif

 if bt==asc("+") then inc ofsp:gosub @partslist
 if bt==asc("-") then dec ofsp:gosub @partslist

 if bt==asc("V") then
  gosub @pastearea
  redraw=1
  continue
 endif

 if bt==asc("Z") then
  if len(undo$)==0 then continue
  for i=0 to size-1
   kairo$[(size-1)-i]=pop(undo$)
  next
  redraw=1
 endif

 if bt==asc("L") then
  a$=fileselect(0,".txt")
  if a$!="" then
   kairofile$=a$
   gosub @loadkairo
  endif
  gosub @partslist
  gosub @grid
  gosub @clearmenu
  gosub @initmenu
  gosub @redrawkairo
  continue
 endif

 if bt==asc("N") then
  gosub @clearmenu
  a$=""
  input "change filename";a$
  if a$!="" then
   IF right$(ucase(a$),4)!=".TXT" THEN a$=a$+".TXT"
   kairofile$=a$
  endif
  gosub @clearmenu
  gosub @initmenu
  continue
 endif

 if bt==asc("S") then
  gosub @savekairo
  gosub @clearmenu
  gosub @initmenu
  continue
 endif

 gosub @putkeisen
 gosub @putparts

 vsync
wend

gosub @savekairo
acls
end
'---

def autokeisen dir

if mode!=2 then return

pushundo

b$=mid$(kairo$[my],mx,1)

base=instr(" └│┌├┘─┴┐┤┬┼",b$)
if base<0 then base=0

a$=mid$(" └│┌├┘─┴┐┤┬┼",olddir or dir or base,1)

kairo$[my]=subst$(kairo$[my],mx,1,a$)

if dir==1 then olddir=4
if dir==2 then olddir=8
if dir==4 then olddir=1
if dir==8 then olddir=2

redraw=1
end


'---
@exportpng

gosub @clearmenu
print "PNGファイルをほぞんしますか"
IF INPUTYN()==ASC("N") THEN return
a$=""
input "ほぞんするfilename";a$
if a$=="" then return
if right$(ucase(a$),4)!=".PNG" then a$=a$+".PNG"
GCLS #white
cls
for i=0 to len(buf$)-1
 x=0
 y=8*i
 gputchr x,y,buf$[i],1,1,#black
next
save "grp0:"+a$
wait 120
return

'---
@exportprog1
gosub @clearmenu
print "PRINTぶんにしてPRGファイルとしてほぞんしますか"
IF INPUTYN()==ASC("N") THEN return
a$=""
input "ほぞんするfilename";a$
if a$=="" then return
if right$(ucase(a$),4)!=".PRG" then a$=a$+".PRG"
gcls
cls
t$=""
for i=0 to len(buf$)-1
 t$=t$+"PRINT "+chr$(34)+buf$[i]+chr$(34)+CHR$(10)
next
print t$
x=20
y=43
save "txt:"+a$,t$
wait 120
return

'---
@redrawkairo
for i=0 to viewh-1
 if (i+ofsy)>=len(kairo$) then break
 locate 0,i
 print mid$(kairo$[i+ofsy],ofsx,vieww);
next
return

'---
@clearmenu
x=0
for y=viewh to 44
 locate x,y
 print " "*60;
next

color #cyan,0
locate 0,viewh
print "'";kairofile$;"'"
color #white,0
locate 0,38
return

'---
@initmenu
x=40
y=41
locate x,y
color 0,#yellow
print "[*]";
color #white,0
print "モ-ドきりかえ";

if mode==1 then
 locate 1,39
 print "もじにゅうりょくモ-ド ON"
 return
endif

x=1
y=41
locate x,y
color 0,#yellow
print "[ESC]";
color #white,0
print "SAVE&EXIT";

x=60
y=0
locate x,y
color 0,#yellow
print "[-]";
color #white,0
print "/";
color 0,#yellow
print "[+]";
color #white,0
print "parts select";

x=1
y=43
locate x,y
color 0,#yellow
print "[Z]";
color #white,0
print "UNDO";

x=10
y=43
locate x,y
color 0,#yellow
print "[V]";
color #white,0
print "PASTE";

x=51
y=39
locate x,y
color 0,#yellow
print "[L]";
color #white,0
print "LOAD";

x=51
y=41
locate x,y
color 0,#yellow
print "[S]";
color #white,0
print "SAVE";

x=31
y=39
locate x,y
color 0,#yellow
print "[N]";
color #white,0
print "CHANGE FILENAME";

x=20
y=43
locate x,y
color 0,#yellow
print "[ENTER]";
color #white,0
print "りょういきせんたく";

if mode==2 then
 locate 1,39
 print "じどうけいせんモ-ド ON"
 return
endif

'keisen sample
for i=0 to len(qwe$)-1
 x=i*2+1
 y=38
 locate x,y
 color 0,#yellow
 print mid$(qwe$,i,1)
 color #white,0
 locate x,y+1
 print keisen$[i];
next
return
'---
@putkeisen
n=instr(qwe$,chr$(bt))
if n<0 then return
if n>=len(keisen$) then return

pushundo

kairo$[my]=subst$(kairo$[my],mx,1,keisen$[n])
'locate mx-ofsx,my-ofsy
'print keisen$[n];
mx=mx+x1
my=my+y1
redraw=1
return

'---
@partslist
ofsp=FIXNUM(ofsp,0,99)

x=60
y=1
for i=0 to 43
 locate x,y+i
 print " "*20;
next

j=0
for i=0 to 999
 if j>=len(parts$) then break

 if i>=ofsp then
  color #blue,0
  locate x,y
  print ""*20;
  color 0,#yellow
  locate x,y
  print "[";i-ofsp;"]"
  color #white,0
  inc y
 endif

 while 1
  if j>=len(parts$) then break
  a$=parts$[j]
  inc j
  if a$=="" then break
  if i>=ofsp then
   locate x,y
   inc y
   if y>43 then break
   print left$(a$,20);
  endif
 wend
 if y>43 then break
next
return

'---
def pushundo
if len(undo$)>=size*undomax then
 for i=0 to size-1
  ret$=shift(undo$)
 next
endif
for i=0 to size-1
 push undo$,kairo$[i]
next

end
'---
@putparts
n=bt-&h30
if n<0 then return
if n>9 then return

pushundo

n=n+ofsp
j=0
while n
 a$=parts$[j]
 if a$=="" then dec n
 inc j
wend

for i=0 to 999
 a$=parts$[j]
 if a$=="" then break
 kairo$[my+i]=subst$(kairo$[my+i],mx,len(a$),a$)
 inc j
next
redraw=1
return

'---
@cutarea
gosub @clearmenu

x=1
y=39
locate x,y
color 0,#yellow
print "[ESCAPE]";
color #white,0
print "CANCEL";

x=42
y=39
locate x,y
color 0,#yellow
print "[A]";
color #white,0
print "ライブラリにとうろく";

x=42
y=41
locate x,y
color 0,#yellow
print "[P]";
color #white,0
print "がぞうファイルにほぞん";

x=42
y=43
locate x,y
color 0,#yellow
print "[T]";
color #white,0
print "PRINTぶんでほぞん";

x=1
y=41
locate x,y
color 0,#yellow
print "[X]";
color #white,0
print "CUT";

x=1+10
y=41
locate x,y
color 0,#yellow
print "[C]";
color #white,0
print "COPY";

x=1
y=43
locate x,y
color 0,#yellow
print "[R]";
color #white,0
print "RIGHT TRUN";

x=1+15
y=43
locate x,y
color 0,#yellow
print "[L]";
color #white,0
print "LEFT TRUN";

xa=mx
ya=my
'while 1
' xa=FIXNUM(xa,0,size-1)
' ya=FIXNUM(ya,0,size-1)
' if xa<ofsx          then dec ofsx:redraw=1
' if xa>=(ofsx+vieww) then inc ofsx:redraw=1
' if ya<ofsy          then dec ofsy:redraw=1
' if ya>=(ofsy+viewh) then inc ofsy:redraw=1
' spcolor spn,#red
' spofs spn,(xa-ofsx)*8,(ya-ofsy)*8
' bt=KEYWAIT()
' if bt==up    then dec ya:x1=0 :y1=-1
' if bt==down  then inc ya:x1=0 :y1=1
' if bt==left  then dec xa:x1=-1:y1=0
' if bt==right then inc xa:x1=1 :y1=0
' if bt==escape then break
' if bt==enter then break
' vsync
'wend
xb=xa
yb=ya
while 1
 xb=FIXNUM(xb,0,size-1)
 yb=FIXNUM(yb,0,size-1)
 if xb<ofsx          then dec ofsx:redraw=1
 if xb>=(ofsx+vieww) then inc ofsx:redraw=1
 if yb<ofsy          then dec ofsy:redraw=1
 if yb>=(ofsy+viewh) then inc ofsy:redraw=1
 spofs spn,(xb-ofsx)*8,(yb-ofsy)*8
 gridend ofsx,ofsy

 drawbox (xa-ofsx),(ya-ofsy),(xb-ofsx),(yb-ofsy),#red
 gosub @redrawkairo
 bt=KEYWAIT()
 drawbox (xa-ofsx),(ya-ofsy),(xb-ofsx),(yb-ofsy),#navy

 if bt==up    then dec yb
 if bt==down  then inc yb
 if bt==left  then dec xb
 if bt==right then inc xb
 if bt==asc("C") then break
 if bt==asc("X") then break
 if bt==asc("R") then break
 if bt==asc("L") then break
 if bt==asc("A") then break
 if bt==asc("P") then break
 if bt==asc("T") then break
 if bt==escape then break
 vsync
wend
if bt==escape then return

pushundo

spcolor spn,#white
if xa>xb then swap xa,xb
if ya>yb then swap ya,yb

while len(buf$)>0
 ret$=pop(buf$)
wend

for y=ya to yb
 w=(xb-xa)+1
 push buf$,mid$(kairo$[y],xa,w)
 if bt==asc("X") or bt==asc("R") or bt==asc("L") then
  kairo$[y]=subst$(kairo$[y],xa,w," "*w)
 endif
next

if bt==asc("P") then 'save PNG
 gosub @exportpng
 GCLS
 gosub @grid
 gosub @clearmenu
 gosub @initmenu
 gosub @redrawkairo
 gosub @partslist
 return
endif

if bt==asc("T") then 'copy PRG1:
 gosub @exportprog1
 gosub @grid
 gosub @clearmenu
 gosub @initmenu
 gosub @redrawkairo
 gosub @partslist
 return
endif

if bt==asc("A") then 'ライブラリついか
 unshift parts$,""
 for y=len(buf$)-1 to 0 step -1
  unshift parts$,buf$[y]
 next
 gosub @partslist
 gosub @clearmenu
 print "ライブラリについかしました"
 print "parts.txtにほぞんしますか?"
 IF INPUTYN()==ASC("N") THEN
  ret$=shift( parts$)
  for y=len(buf$)-1 to 0 step -1
   ret$=shift(parts$)
  next
  gosub @partslist
  return
 endif
 gosub @saveparts
 return
endif

if bt==asc("R") then
 for y=0 to len(buf$)-1
  for x=0 to len(buf$[0])-1
   a$=mid$(buf$[y],x,1)
   a$=turnchr(a$,1)
   kairo$[ya+x]=subst$(kairo$[ya+x],xb-y,len(a$),a$)
  next
 next
 return
endif

if bt==asc("L") then
 for y=0 to len(buf$)-1
  for x=0 to len(buf$[0])-1
   a$=mid$(buf$[y],x,1)
   a$=turnchr(a$,-1)
   kairo$[yb-x]=subst$(kairo$[yb-x],xa+y,len(a$),a$)
  next
 next
 return
endif

return
'---
def drawbox tx1,ty1,tx2,ty2,col

if tx2<tx1 then swap tx1,tx2
if ty2<ty1 then swap ty1,ty2

if tx1<0 then tx1=0
if ty1<0 then ty1=0
if tx2>vieww-1 then tx2=vieww-1
if ty2>viewh-1 then ty2=viewh-1
gbox tx1*8,ty1*8,tx2*8+8,ty2*8+8,col

end

'---
@pastearea
pushundo

for i=0 to len(buf$)-1
 a$=buf$[i]
 kairo$[my+i]=subst$(kairo$[my+i],mx,len(a$),a$)
next

return

'---
@loadkairo
while len(kairo$)>0 'all claer
 ret$=shift(kairo$)
wend
if kairofile$=="" then
 return
endif
if chkfile(kairofile$)==0 then
 for i=0 to size-1
  push kairo$," "*size
 next
 return
endif
print "load"
load "TXT:"+kairofile$ out t$
ptr=0
while 1
 ptr2=instr(ptr,t$,chr$(10))
 if ptr2<0 then break
 push kairo$,mid$(t$,ptr,ptr2-ptr)
 ptr=ptr2+1
 if ptr>=len(t$) then break
wend
return

'---
@savekairo
gosub @clearmenu
print "TXTファイルをほぞんしますか"
IF INPUTYN()==ASC("N") THEN return
if chkfile(kairofile$)==1 then
 gosub @clearmenu
 print "うわがきしますか"
 IF INPUTYN()==ASC("N") THEN return
endif

t$=""
for i=0 to len(kairo$)-1
 t$=t$+kairo$[i]
 if right$(t$,1)!=chr$(10) then t$=t$+chr$(10)
next
save "TXT:"+kairofile$,t$
return

'---
@loadparts
if chkfile(partsfile$)==0 then
 print "error"
 return
endif
print "load"
load "TXT:"+partsfile$ out t$
ptr=0
while 1
 ptr2=instr(ptr,t$,chr$(10))
 if ptr2<0 then break
 a$=mid$(t$,ptr,ptr2-ptr)
 if left$(a$,1)==chr$(34) then a$=mid$(a$,1,999)
 if right$(a$,1)==chr$(34) then a$=left$(a$,len(a$)-1)

' for num=10 to 99
'  b$=str$(num)
'  ptr=instr(a$,b$)
'  if ptr>=0 then
'   a$=subst$(a$,ptr,2,chr$(57600+num)+" ")
'  endif
' next

 push parts$,a$
 ptr=ptr2+1
 if ptr>=len(t$) then break
wend
return

'---
@saveparts
t$=""
for i=0 to len(parts$)-1
 t$=t$+parts$[i]+chr$(10)
next
print "save"
save "TXT:"+partsfile$,t$
return

'---
def turnchr(ch$,r1)

for k=0 to len(tmp$)-1
 r=instr(tmp$[k],ch$)
 if r>=0 then
  r=(r+r1) and 3
  return(mid$(tmp$[k],r,1))
 endif
next

return ch$
end

'---
DEF KEYWAIT()
 BT=0
 WHILE BT==0
  VSYNC 1
  NOWKEY$=INKEY$()
  IF NOWKEY$ != "" THEN BT=ASC(NOWKEY$)
 WEND
 WHILE 1
  VSYNC 2
  IF INKEY$=="" THEN BREAK 'KEY BUFF CLEAR
 WEND
 IF BT>=&H60 AND BT<=&H7A THEN BT=BT-&H20 'ucase
 RETURN BT
END

'---
DEF SWOFFWAIT
 WHILE 1
  VSYNC 1
  IF INKEY$=="" THEN BREAK
 WEND
END

'---
DEF INPUTYN()
 PRINT
 COLOR #BLACK,#WHITE
 PRINT " よろしいですか? [Y]/[N] ";
 COLOR #WHITE,0
 WHILE 1
  YN=KEYWAIT()
  IF YN==ASC("Y") THEN PRINT " YES":BREAK
  IF YN==ASC("N") THEN PRINT " NO":BREAK
 WEND
 WAIT 30
 RETURN YN
END

'---
DEF FIXNUM(NUM,MINNUM,MAXNUM)
 IF NUM<MINNUM THEN NUM=MINNUM
 IF NUM>MAXNUM THEN NUM=MAXNUM
 RETURN NUM
END

'---
def gridend x,y

if x==0 then tempc=#magenta else tempc=#navy
gbox 0,0,0,viewh*8,tempc

if y==0 then tempc=#magenta else tempc=#navy
gbox 0,0,vieww*8,0,tempc

if x==size-vieww then tempc=#magenta else tempc=#navy
gbox vieww*8,0,vieww*8,viewh*8,tempc

if y==size-viewh then tempc=#magenta else tempc=#navy
gbox 0,viewh*8,vieww*8,viewh*8,tempc

end

'---
DEF FILESELECT(DIRFLAG,FILTER$)

dim name$[0]
dim name2$[0]
COLOR #WHITE,0
CLS
GCLS
if spused(0) then spofs 0,999,999

FILTER$=UCASE(FILTER$)

FP=48
FH=20

SELPATH$=PATH$
OFX=0
OFY=0

LOCATE 1,FH+4
PRINT "[UP][DOWN]:カ-ソルいどう / [SPACE]:けってい / [ESC]:CANCEL"

WHILE 1
 COLOR #BLACK,#BLUE
 FOR I=0 TO FH+1+2
  LOCATE OFX,OFY+I
  PRINT " "*(FP+2)
 NEXT
 COLOR #WHITE,0
 FOR I=0 TO FH-1
  LOCATE OFX+1,OFY+I+1+2
  PRINT " "*FP
 NEXT
 
 LOCATE OFX+1,OFY+1
 PRINT "DIR:";SELPATH$

 IF FILTER$!="" THEN
  LOCATE OFX+38,OFY+1
  PRINT "FILTER:";FILTER$
 ENDIF
 WHILE LEN(NAME2$)
  R$=POP(NAME2$)
 WEND
 FILES SELPATH$,NAME$
 FOR I=0 TO LEN(NAME$)-1
  T$=NAME$[I]
  IF ucase(T$)==" PARTS.TXT" THEN CONTINUE
  IF MID$(T$,1,1)=="@" THEN CONTINUE
  IF DIRFLAG==0 THEN
   IF LEFT$(T$,1)!="+" THEN
    IF FILTER$!="" AND INSTR(UCASE(T$),FILTER$)<0 THEN CONTINUE
   ENDIF
  ELSE
   IF LEFT$(T$,1)!="+" THEN CONTINUE
  ENDIF
  PUSH NAME2$,T$
 NEXT
 UNSHIFT NAME2$,"+.."

 IF DIRFLAG THEN
  PUSH NAME2$,"["+SELPATH$+"にけってい]"
  IDX=LEN(NAME2$)-1
 ELSE
  IDX=0
 ENDIF

 IDXOFS=0
 WHILE 1
  FOR I=0 TO LEN(NAME2$)-1
   X=OFX+1
   Y=(I-IDXOFS)
   IF Y<0 THEN CONTINUE
   IF Y>=FH THEN BREAK
   Y=Y+OFY+1+2
   LOCATE X,Y
   T$=" "*FP
   T$=SUBST$(T$,0,LEN(NAME2$[I]),NAME2$[I])
   IF IDX==I THEN COLOR 0,#WHITE ELSE COLOR #WHITE,0
   PRINT T$;
  NEXT
  COLOR #WHITE,0

'  WHILE 1
'   STICK STICKID OUT SX,SY
'   IF ABS(SX)<STICKLV AND ABS(SY)<STICKLV THEN
'    IF BUTTON()==0 THEN BREAK
'   ENDIF
'   VSYNC
'  WEND
  BT=KEYWAIT()
  IF BT==SPACE THEN BREAK
  IF BT==ENTER THEN BREAK
  IF BT==UP    THEN DEC IDX
  IF BT==DOWN  THEN INC IDX
  IF BT==ESCAPE THEN IDX=-1:BREAK

  IDX=FIXNUM(IDX,0,LEN(NAME2$)-1)

  WHILE IDXOFS>IDX
   DEC IDXOFS
  WEND
  WHILE (IDXOFS+FH-1)<IDX
   INC IDXOFS
  WEND
 WEND
 LOCATE 1,FH+4
 PRINT " "*80

 IF IDX<0 THEN SELPATH$="":BREAK

 NB$=MID$(NAME2$[IDX],0,1)
 NA$=MID$(NAME2$[IDX],1,999)
 IF DIRFLAG==0 THEN
  IF NB$!="+" THEN
   IF RIGHT$(SELPATH$,1)!="/" THEN SELPATH$=SELPATH$+"/"
   RETURN (SELPATH$+NA$)
  ENDIF
 ELSE
  IF IDX==LEN(NAME2$)-1 THEN BREAK
 ENDIF

 IF NA$==".." THEN
  TMP=1
  WHILE 1
   IF LEFT$(RIGHT$(SELPATH$,TMP),1)=="/" THEN BREAK
   INC TMP
  WEND
  SELPATH$=LEFT$(SELPATH$,LEN(SELPATH$)-TMP)
  IF LEFT$(SELPATH$,1)!="/" THEN SELPATH$="/"+SELPATH$
 ELSE
  IF RIGHT$(SELPATH$,1)!="/" THEN SELPATH$=SELPATH$+"/"
  SELPATH$=SELPATH$+NA$
 ENDIF
WEND
RETURN SELPATH$
END

'---
DEF LCASE(TMP$)
 FOR TMPI=0 TO LEN(TMP$)-1
  TMPC=ASC(MID$(TMP$,TMPI,1))
  IF TMPC>=&H41 AND TMPC<=&H5A THEN
   TMP$=SUBST$(TMP$,TMPI,1,CHR$(TMPC+&H20))
  ENDIF
 NEXT
 RETURN TMP$
END

'---
DEF UCASE(TMP$)
 FOR TMPI=0 TO LEN(TMP$)-1
  TMPC=ASC(MID$(TMP$,TMPI,1))
  IF TMPC>=&H61 AND TMPC<=&H7A THEN
   TMP$=SUBST$(TMP$,TMPI,1,CHR$(TMPC-&H20))
  ENDIF
 NEXT
 RETURN TMP$
END

'---
@grid
for y=0 to viewh
 gline 0,y*8,vieww*8,y*8,#navy
next
for x=0 to vieww
 gline x*8,0,x*8,viewh*8,#navy
next
'gbox 0,0,639,359,#navy
gbox vieww*8,0,639,359,#navy
'gbox 0,0,vieww*8,viewh*8,#navy
return


