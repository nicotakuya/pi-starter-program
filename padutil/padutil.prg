'gamepad util by takuya matsubara and みなつ
acls
filename$="GAMEPADLIST.TXT"

'KEYCODE
RIGHT = 28
LEFT  = 29
UP    = 30
DOWN  = 31
ENTER = 13
SPACE = 32
ESCAPE= &H1B

dim btnname$[0]
dim btnx[0]
dim btny[0]
dim padname$[0]
dim assign$[0]
dim dev$[0]
dim stylename$[0]
push stylename$,"xbox"
push stylename$,"playstation"
push stylename$,"nintendo"

restore @btndata
for i=1 to 32*3
 read name$
 read x,y
 push btnname$,name$
 push btnx,x
 push btny,y
next

'---
gosub @loadlist
idx=0
ofsy=0
listy=24
wid=20
while 1
 cls
 gbox 0,0,639,359,#navy
 gbox 0,0,639,8,#navy
 gbox 0,((listy+wid)*8),639,(listy*8),#navy

 color #yellow
 print "GAMEPAD UTIL (";len(padname$);"このゲ-ムパッドをとうろく)"
 color #white
 IDX=FIXNUM(IDX,0,len(padname$)-1)
 if idx<ofsy         then dec ofsy
 if idx>(ofsy+wid-1) then inc ofsy

 for tmp=0 to len(padname$)-1
  x=0
  y=(tmp-ofsy)
  if y<0 or y>=wid then continue
  y=y+listy
  if tmp==idx then color 0,#white else color #cyan,0
  locate x,y
  print left$(padname$[tmp]+(" "*80),80)
  color #white,0
  if tmp==idx then
   puticon padname$[tmp]
   btnassign assign$[tmp]
  endif
 next

 color #yellow
 locate 0,44
 color #white
 print "[up][down]:select | ";
 print "[1]:ゲ-ムパッドをとうろく | ";
 print "[2]:ゲ-ムパッドのどうさテスト | ";
 print "[3]:リストからさくじょ";

 BT=KEYWAIT()
 IF BT==ESCAPE THEN BREAK
 IF BT==UP    THEN DEC IDX
 IF BT==DOWN  THEN INC IDX
 IDX=FIXNUM(IDX,0,len(padname$)-1)

 if bt==asc("1") then gosub @addgamepad:continue
 if bt==asc("2") then gosub @testgamepad:continue
 if bt==asc("3") then gosub @delgamepad:continue

wend
end
'---
@delgamepad
cls
print padname$[idx];"をさくじょします"

if INPUTYN()==asc("N") then return

for i=idx to len(padname$)-2
 padname$[i]=padname$[i+1]
 assign$[i]=assign$[i+1]
next
r$=pop(padname$)
r$=pop(assign$)

gosub @savelist

return
'---
@addgamepad
cls
print "check usb device"
t$=system$("lsusb")
while len(dev$):dummy$=shift(dev$):wend

ptr=0
while 1
 ptr2=instr(ptr,t$,chr$(10))
 if ptr2<0 then break
 a$=mid$(t$,ptr,ptr2-ptr)

 if instr(a$,"Standard Microsystems Corp.")>0 then
  'skip
 elseif instr(a$,"Linux Foundation")>0 then
  'skip
 else
  i=instr(a$,"ID ")
  if i>=0 then a$=mid$(a$,i,999)
  if isGamePad(mid$(a$,3,9)) then push dev$,a$ '//ゲームパッドかどうか判定//
 endif
 ptr=ptr2+1
 if ptr>=len(t$) then break
wend

for i=0 to len(dev$)-1
 vidPid$=mid$(dev$[i],3,9) '//VID:PID//
 print " [";i+1;"]:";dev$[i];"(";getName$(vidPid$);
 if getType(vidPid$)==0 then '//XInputかDirectInputかの判定 開始//
  color #cyan:print " [XInput]";
 else
  color #yellow:print " [DirectInput]";
 endif
 color #white:print ")" '//XInputかDirectInputかの判定 終了//
next
print
print "ゲ-ムパッドはどれですか?(ばんごうにゅうりょく)"
i=keywaitnum()
i=i-1
if i<0 or i>len(dev$)-1 then return

name$=mid$(dev$[i],len("ID "),999)
while right$(name$,1)==" "
 name$=left$(name$,len(name$)-1)
wend

vender$=left$(name$,9) 'vender and product id
padID=getID(vender$)   '//コントローラID//

t$=system$("lsusb -v")
ptr=instr(t$,vender$)
if ptr<0 then print "Error:"
ptr=instr(ptr,t$,"  iProduct")
if ptr<0 then print "Error:"
ptr=ptr+len("  iProduct")
while 1
 if asc(mid$(t$,ptr,1))>=&H30 then break
 inc ptr
wend
inc ptr
while 1
 if asc(mid$(t$,ptr,1))==10 then break
 name$=name$+mid$(t$,ptr,1)
 inc ptr
wend

work$=" 0"*38
for id=0 to 31
 id2=id+1
 if id>16 then id2=0
 padassign id,id2
next

print
print "ボタンのひょうじレイアウト"
for i=0 to 2
 print "[";i;"]:";stylename$[i]
next
print "(0-2)?"
i=keywaitnum()

if i<0 or i>2 then return
style=i

print
print "padmode だい1ひきすう(0:Xinput/1:DirectInput)?"
i=keywaitnum()
if i<0 then return
arg1=i

print "padmode だい2ひきすう(0/1/2)"
i=keywaitnum()
if i<0 then return
arg2=i

padmode arg1,arg2

if arg1==1 then
cls

locate 0,0
print "ボタンをがくしゅうします [esc]:cancel / [space]:skip"
endflag=0
for id=0 to 16
 btnsub (1<<id)

 locate 0,id+1
 print btnname$[id];"をおしてください ";
 while 1
  btn=button(0,-1,padID) '//コントローラIDを指定//
  k$=inkey$()
  if k$==chr$(&H1B) then
   endflag=1
   break
  endif
  if k$!="" then break
  if btn then break
  vsync
 wend
 if endflag==1 then break
 if k$!="" then 
  print "skip"
  id2=0
 else
  for id2=0 to 31
   if btn and (1<<id2) then
    break
   endif
  next
  id2=id2+1
  print id2
 endif
 work$=setwork(work$,id,id2)
 while button(0,-1,padID) '//コントローラIDを指定//
  vsync
 wend
next
if endflag==1 then return
endif

print
work$=setwork(work$,35,arg1)
work$=setwork(work$,36,arg2)
work$=setwork(work$,37,style)

push padname$,name$
push assign$,work$
gosub @savelist

cls

return
'---
@testgamepad
gcls
cls

print "check usb device"
t$=system$("lsusb")

'//カーソルで選択中のパッドを優先して探す///
vender$=left$(padname$[IDX],9)
if getName$(vender$)!="" then
 idx=IDX
else
 '//選択中のパッドが見つからなかったら,接続中のパッドを探す//
 for i=0 to len(padname$)-1
  name$=padname$[i]
  vender$=left$(name$,9)
  if instr(t$,vender$)>=0 then
   print "detect:";padname$[i]
   break
  endif
 next
 idx=i
endif

if idx>len(padname$)-1 then
 print "とうろくされていないゲ-ムパッドです"
 print "ゲ-ムパッドをとうろくしてください"
 wait 180
 return
endif
print 

padID=getID(vender$) '//コントローラID//

t$=assign$[idx]
arg1=getwork(t$,35)
arg2=getwork(t$,36)
style=getwork(t$,37)
print "padmode ";arg1;",";arg2
padmode arg1,arg2

for id=0 to 31
 id2=getwork(t$,id)
 padassign id,id2
 print "padassign ";id;",";id2
next

wait 180
cls
print name$
while 1
 locate 0,36
 bt=button(0,-1,padID) '//コントローラIDを指定//
 print "button=";bin$(bt,32)
 btnsub bt
 sticksub #SID_L,padID
 sticksub #SID_R,padID
 vsync
 if inkey$()!="" then break
wend
cls
gcls
spclr
return
end

'---
def sticksub stkID,padID
 if stkID==#SID_L then
  spn=0
  jx=(20*8)+(4*3.5*8)
 else
  spn=1
  jx=(20*8)+(4*7.5*8)
 endif
 jy=29*8
 if spused(spn)==false then spset spn,2544
 stick stkID,padID OUT x,y
 locate jx/8-6,jy/8+4
 print format$("%6.3f",x);",";
 print format$("%6.3f",y)
 size=32
 x=(x*size)+jx
 y=(y*size)+jy
 spofs spn,x,y+8
 gbox jx-size,jy-size,jx+size,jy+size,#navy
end

'---
def btnsub nowbutton
 for i=0 to 16
  i2=i+(style*32)
  x=btnx[i2]*4+20
  y=btny[i2]*4+2
  if (1<<i) and nowbutton then
   color #white,#magenta
  else
   color #white,#navy
  endif
  locate x-1,y-1:print " "*7
  locate x-1,y:print " "
  locate x+5,y:print " "
  locate x-1,y+1:print " "*7
  color #white,0
  locate x,y
  print btnname$[i2]
 next
end
'---
def puticon a$
 locate 0,1
 x1=0
 y1=24
 print mid$(a$,9,999)
 filename$=mid$(a$,0,4)+mid$(a$,5,4)
 if chkfile(filename$+".png")==0 then
  gfill x1,y1,x1+159,y1+159,#gray
 else
  load "grp1:"+filename$+".png"
  gcopy 1,0,0,159,159,x1,y1,1
 endif

 x1=1+(160/8)
 y1=3
 for x=x1 to x1+21
  for y=y1 to y1+18
   locate x,y
   print " ";
  next
 next
 if chkfile(filename$+".txt")==0 then
 else
  load "txt:"+filename$+".txt" out t$
  x=x1
  y=y1
  for i=0 to len(t$)-1
   if mid$(t$,i,1)==chr$(10) then x=x1:y=y+1:continue
   locate x,y
   print mid$(t$,i,1)
   x=x+1
   if x>(x1+21) then x=x1:y=y+1
   if y>(y1+18) then break
  next
 endif
end
'---
def btnassign a$
 x1=44
 y1=3
 gbox x1*8,y1*8,(x1+36)*8,(y1+20)*8,#navy
 for i=0 to 16
  i2=i+(style*32)
  x=btnx[i2]*3+x1
  y=btny[i2]*3+y1+2
  color #white,#navy
  locate x,y
  print "   ";
  locate x,y
  print btnname$[i2];
  color #white,#maroon
  locate x,y+1
  print " ";getwork(a$,i);" ";
  color #white,0
 next

 arg1=getwork(a$,35)
 arg2=getwork(a$,36)
 style=getwork(a$,37)
 locate x1,y1+0
 print "padmode ";arg1;",";arg2;
 locate x1+10,y1+2
 print stylename$[style];" style"

end

@btndata
data "UP"         , 1,2 '#BID_UP   
data "DOWN"       , 1,4 '#BID_DOWN 
data "LEFT"       , 0,3 '#BID_LEFT 
data "RIGHT"      , 2,3 '#BID_RIGHT
data "A"          , 9,4 '#BID_A
data "B"          ,10,3 '#BID_B
data "X"          , 8,3 '#BID_X
data "Y"          , 9,2 '#BID_Y
data "LB"         , 0,1 '#BID_LB
data "RB"         ,10,1 '#BID_RB   
data "START"      , 6,2 '#BID_START
data "LT"         , 0,0 '#BID_LT
data "RT"         ,10,0 '#BID_RT
data "BACK"       , 4,2 '#BID_BACK
data "左スティック押込"   , 3,5 '#BID_LS
data "右スティック押込"   , 7,5 '#BID_RS
data "HOME"       , 5,3 '#BID_HOME
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0

data "UP"          , 1,2 '#BID_UP   
data "DOWN"        , 1,4 '#BID_DOWN 
data "LEFT"        , 0,3 '#BID_LEFT 
data "RIGHT"       , 2,3 '#BID_RIGHT
data "ばつ(A)"       , 9,4 '#BID_A
data "まる(B)"       ,10,3 '#BID_B
data "しかく(X)"      , 8,3 '#BID_X
data "さんかく(Y)"     , 9,2 '#BID_Y
data "L1(LB)"      , 0,1 '#BID_LB
data "R1(RB)"      ,10,1 '#BID_RB   
data "START"       , 6,2 '#BID_START
data "L2(LT)"      , 0,0 '#BID_LT
data "R2(RT)"      ,10,0 '#BID_RT
data "SELECT"      , 4,2 '#BID_BACK
data "左スティック押込"    , 3,5 '#BID_LS
data "右スティック押込"    , 7,5 '#BID_RS
data "PS(HOME)"    , 5,3 '#BID_HOME
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0

data "UP"          , 1,2 '#BID_UP   
data "DOWN"        , 1,4 '#BID_DOWN 
data "LEFT"        , 0,3 '#BID_LEFT 
data "RIGHT"       , 2,3 '#BID_RIGHT
data "A"           ,10,3 '#BID_A
data "B"           , 9,4 '#BID_B
data "X"           , 9,2 '#BID_X
data "Y"           , 8,3 '#BID_Y
data "LB"          , 0,1 '#BID_LB
data "RB"          ,10,1 '#BID_RB   
data "START"       , 6,2 '#BID_START
data "LT"          , 0,0 '#BID_LT
data "RT"          ,10,0 '#BID_RT
data "SELECT"      , 4,2 '#BID_BACK
data "左スティック押込"    , 3,5 '#BID_LS
data "右スティック押込"    , 7,5 '#BID_RS
data "HOME"        , 5,3 '#BID_HOME
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0
data "",0,0

'---
@savelist
t$=""
for i=0 to len(padname$)-1
 t$=t$+padname$[i]+chr$(10)
 t$=t$+assign$[i]+chr$(10)
next
save "TXT:"+filename$,t$
return

'---
@loadlist
if chkfile(filename$)==0 then
 return
endif
load "TXT:"+filename$ out t$
ptr=0
while 1
 ptr2=instr(ptr,t$,chr$(10))
 if ptr2<0 then break
 push padname$,mid$(t$,ptr,ptr2-ptr)
 ptr=ptr2+1
 if ptr>=len(t$) then break
 ptr2=instr(ptr,t$,chr$(10))
 if ptr2<0 then break
 push assign$,mid$(t$,ptr,ptr2-ptr)
 ptr=ptr2+1
 if ptr>=len(t$) then break
wend
return
'---
def getwork(work$,id)
 if id*2>=len(work$) then return 0
 return val(mid$(work$,id*2,2))
end
'---
def setwork(work$,id,dat)
 if id*2>=len(work$) then return work$
 work$=subst$(work$,id*2,2,format$("%2d",dat))
 return work$
end

'---
DEF keywaitnum()
 WHILE 1
  bt=keywait()
  if bt==escape then return(-1)
  if bt>=&H30 and bt<=&H39 then
   print chr$(bt)
   return(bt-&H30)
  endif
 wend
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
 IF BT>=&H60 AND BT<=&H7F THEN BT=BT-&H20 'ucase
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

'
'"VID:PID"から,コントローラIDを取得
'
'
def getID(vidPid$)
 dim padName$[0],padVidPid$[0],padDirectInput[0]
 padName out padName$,padVidPid$,padDirectInput

 var i
 for i=0 to len(padVidPid$)-1
  if padVidPid$[i]==vidPid$ then return i
 next
 return 0
end

'
'"VID:PID"から,ゲームパッドかどうかを判定
'
'
def isGamePad(vidPid$)
 dim padName$[0],padVidPid$[0],padDirectInput[0]
 padName out padName$,padVidPid$,padDirectInput

 var i
 for i=0 to len(padVidPid$)-1
  if padVidPid$[i]==vidPid$ then return true
 next

 return false
end

'
'"VID:PID"から,デバイス名を取得
'
'
def getName$(vidPid$)
 dim padName$[0],padVidPid$[0],padDirectInput[0]
 padName out padName$,padVidPid$,padDirectInput

 var i
 for i=0 to len(padVidPid$)-1
  if padVidPid$[i]==vidPid$ then return padName$[i]
 next

 return ""
end

'
'"VID:PID"から,タイプを判定(XInput=0, DirectInput=1
'
'
def getType(vidPid$)
 dim padName$[0],padVidPid$[0],padDirectInput[0]
 padName out padName$,padVidPid$,padDirectInput

 var i
 for i=0 to len(padVidPid$)-1
  if padVidPid$[i]==vidPid$ then return padDirectInput[i]
 next

 return ""
end


'
'ゲームパッド情報を取得
'
'
def padName out outName$,outVidPid$,outDirectInput
 dim t0$[4]:outName$=t0$:fill outName$,"接続されていません"
 dim t1$[4]:outVidPid$=t1$
 dim t2[4]:outDirectInput=t2
 var lf$=chr$(&h0a)

 'デバイス情報を取得
 var dev$=system$("/bin/cat /proc/bus/input/devices")
 dim devices$[0]
 
 '空行で分割
 split dev$,lf$+lf$ out devices$

 var padId=0
 while len(devices$)
  '改行で分割
  dim lines$[0]
  split shift(devices$),lf$ out lines$

  var n$="",id=-1,ev$="",key$="",abs$=""
  var pid$="",vid$=""
  dim elm$[0]
  while len(lines$)
   var l$=shift(lines$)

   '0123456789012345678901234567890123456789012345678
   'I: Bus=XXXX Vendor=XXXX Product=XXXX Version=XXXX
   if left$(l$,2)=="I:" then
    vid$=mid$(l$,19,4) 'VIDを抽出
    pid$=mid$(l$,32,4) 'PIDを抽出
   endif

   '01234567890123456789
   'N: Name="デバイス名"
   if left$(l$,8)=="N: Name=" then
    n$=mid$(l$,9,len(l$)-10) 'デバイス名を抽出
   endif

   '0123456789012345678901
   'H: Handlers=XXX jsX XXX
   if left$(l$,12)=="H: Handlers=" then
    split mid$(l$,12,len(l$)-12)," " out elm$
    while len(elm$)
     var e$=shift(elm$)
     if len(e$)==3 && left$(e$,2)=="js" then
      id=val(mid$(e$,2,1)) 'デバイスIDを抽出
     endif
    wend
   endif

   '0123456789012345678901
   'B: EV=XXX...
   if left$(l$,6)=="B: EV=" then
    ev$=mid$(l$,6,len(l$)-6) 'イベントタイプを抽出
   endif

   '0123456789012345678901
   'B: KEY=XXXX... YYYY..
   if left$(l$,7)=="B: KEY=" then
    split mid$(l$,7,len(l$)-7)," " out elm$
    key$=elm$[0] 'KEYを抽出
   endif

   '0123456789012345678901
   'B: ABS=XXXX...
   if left$(l$,7)=="B: ABS=" then
    abs$=mid$(l$,7,len(l$)-7) 'ABSを抽出
   endif
  wend

  if id!=-1 then
   id=padId:inc padId
   outName$[id]=n$:n$=""
   outVidPid$[id]=format$("%s:%s",vid$,pid$)
   outDirectInput[id]=(right$(ev$,2)=="1b")
  endif
 wend
end

'
'文字列のスプリット
'
'
def split s$,delim$ out split$
 var ret$[0]
 var l=len(s$)
 var st=0
 while st<l
  var ed=instr(st,s$,delim$)
  if ed==-1 then ed=l
  push ret$,mid$(s$,st,ed-st)
  st=ed+1
 wend
 split$=ret$
end


