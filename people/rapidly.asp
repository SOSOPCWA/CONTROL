<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID2.inc" -->
<!-- #include file="..\..\Lib\GetConfig.inc" -->
<% 
set conn=Server.CreateObject("adodb.connection") : conn.Open strControl
set connIDMS=Server.CreateObject("adodb.connection") : connIDMS.Open strIDMS
set connGF2000=Server.CreateObject("adodb.connection") : connGF2000.Open strGF2000
set rs=server.createobject("adodb.recordset")
set rs1=server.createobject("adodb.recordset")

authority=request("authority")
SosColor="green" : ScsColor="green" : NmsColor="green" : DcsColor="green" : ElseColor="green" : MicColor="green" : CardColor="green" : HpcColor="green" : ManyColor="green"
NpsColor="green" : ApsColor="green"
select case authority
	case "card" : CardColor="red" : memo="<font color=""green"" size=""2"">(列出登記過門禁資料的今日刷卡登入機房人員，請注意勿選取<font color=""red"" size=""3"">不同廠商但相同姓名</font>人員)</font>"
	case "sos" : kind="授權名單-操作課" : SosColor="red"
	case "scs" : kind="授權名單-系統課" : ScsColor="red"
	case "nms" : kind="授權名單-網路課" : NmsColor="red"
 	case "dcs" : kind="授權名單-資管課" : DcsColor="red" 
    case "nps" : kind="授權名單-數值課" : NpsColor="red"
 	case "aps" : kind="授權名單-軟體課" : ApsColor="red"
    case "mic" : kind="授權名單-資訊中心" : MicColor="red"
	case else  : ElseColor="red" : memo="<font color=""green"" size=""2"">(列出近一年最常進出機房人員)</font>"
end select

select case authority
case "sos","scs","nms","dcs","mic","nps","aps"
	memo=memo & "<br><font color=""green"" size=""2"">"
	rs.open "select * from Config where kind='授權方式'",conn
	while not rs.eof
		memo=memo & rs(1) & "." & rs(2) & "　"
		rs.movenext
	wend
	rs.close
	memo=memo & "</font>"
end select

if authority="sos" or authority="scs" or authority="nms" or authority="dcs" or authority="nps" or authority="aps" then
	set fs=server.createobject("scripting.filesystemobject")
	set F=fs.GetFile("d:\機房行政\門禁資料\授權人員名單.xlsx")
	rs.open "select item from Config where kind='授權時間' order by item desc",conn
	if DT(F.DateLastModified,"yyyy/mm/dd hh:mi")>rs(0) then
		memo=memo & "<br><font color=""red"" size=""5"">(授權人員名單.xlsx已更新,請更新授權人員及授權時間之系統參數)</font>"
	end if
	rs.close
end if

Function DT(byval sDT,byval fDT)
	dim YY0,MM0,DD0,HH0,MI0,SS0
	DT=lcase(fDT)
	YY0=year(sDT)   : if instr(1,DT,"yy",1)>0 and instr(1,DT,"yyyy",1)=0 then YY0=mid(YY0,3)
	DT=replace(replace(DT,"yyyy","yy"),"yy",YY0)
	MM0=month(sDT)  : if MM0<10 then MM0="0" & MM0
	DT=replace(DT,"mm",MM0)
	DD0=day(sDT)    : if DD0<10 then DD0="0" & DD0
	DT=replace(DT,"dd",DD0)
	HH0=hour(sDT)   : if HH0<10 then HH0="0" & HH0
	DT=replace(DT,"hh",HH0)
	MI0=minute(sDT) : if MI0<10 then MI0="0" & MI0
	DT=replace(DT,"mi",MI0)
	SS0=second(sDT) : if SS0<10 then SS0="0" & SS0
	DT=replace(DT,"ss",SS0) 
End Function
%> 

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=big5" />
	<title>快速登入</title>
	<style type="text/css">
	<!--
	body {
	background-repeat: repeat;
	margin: 0px;
	line-height: 100%;
	background-color: #99CC66
	}
	-->
	</style>
	<link href="Lib/people.css" rel="stylesheet" type="text/css">	
</head>
<body  bgproperties="fixed">
<div align="center"><span class="title">進出人員快速登入</span></div>
<form name="form" id="form" method="post" >
<table width="90%" align="center"><tr>
	<td><font color="<%=ElseColor%>"><u style="cursor:pointer" onClick="window.open('rapidly.asp','_self');">一年最常進出</u></font></td>
	<!--<td><font color="<%=CardColor%>"><u style="cursor:pointer" onClick="window.open('rapidly.asp?authority=card','_self');">今日刷卡</u></font></td> vm16會出現just in time視窗，網頁會出現SQL錯誤，故拿掉-->
	<td><font color="<%=SosColor%>"> <u style="cursor:pointer" onClick="window.open('rapidly.asp?authority=sos','_self');">操作課</u></font></td>
	<td><font color="<%=ScsColor%>"> <u style="cursor:pointer" onClick="window.open('rapidly.asp?authority=scs','_self');">系統課</u></font></td>
	<td><font color="<%=NmsColor%>"> <u style="cursor:pointer" onClick="window.open('rapidly.asp?authority=nms','_self');">網路課</u></font></td>	
	<td><font color="<%=DcsColor%>"> <u style="cursor:pointer" onClick="window.open('rapidly.asp?authority=dcs','_self');">資管課</u></font></td>
    <td><font color="<%=NpsColor%>"> <u style="cursor:pointer" onClick="window.open('rapidly.asp?authority=nps','_self');">數值課</u></font></td>
    <td><font color="<%=ApsColor%>"> <u style="cursor:pointer" onClick="window.open('rapidly.asp?authority=aps','_self');">軟體課</u></font></td>
	<td><font color="<%=MicColor%>"> <u style="cursor:pointer" onClick="window.open('rapidly.asp?authority=mic','_self');">資訊中心</u></font></td>	
    <!--
	<td><font color="<%=HpcColor%>"> <u style="cursor:pointer" onClick="window.open('Many.asp?Company=富士通','_self');">富士通</u></font></td>
	<td><font color="<%=ManyColor%>"> <u style="cursor:pointer" onClick="window.open('Many.asp?Company=寶迅','_self');">寶迅</u></font></td>
    -->
</tr></table>
<hr>
<!-- <table width="90%" border="1" align="center" cellpadding="5" cellspacing="0"> -->
<table width="90%" border="1" align="center" cellpadding="5" cellspacing="1" bordercolor="#B0C4DE">
<%	select case authority
	case "sos","scs","nms","dcs","nps","aps"
		rs.open "select * from Config where kind='" & kind & "'",conn
		i=0 : SQL=""
		while not rs.eof
			pos1=instr(1,rs(1),"-") : pos2=instr(pos1+1,rs(1),"-") : unit=mid(rs(1),1,pos1-1) : name=mid(rs(1),pos1+1,pos2-pos1-1) : AuthorityNo=mid(rs(1),pos2+1)
			if i=0 then
				SQL="(申請單位='" & unit & "' and 申請人='" & name & "'"
			else
				SQL=SQL & "or 申請單位='" & unit & "' and 申請人='" & name & "'"
			end if
			i=i+1
			strNames=strNames & AuthorityNo & "." & name & vbcrlf
			rs.movenext
		wend
		rs.close
		if i>0 then SQL=SQL & ")"
    case "mic"
        rs.open "select * from Config where kind='數值資訊組'",connIDMS
		i=0 : SQL=""
		while not rs.eof
			unit=rs(1) : AuthorityNo="A"
            rs1.open "select * from Config where kind='" & unit & "'",connIDMS
            while not rs1.eof
                name=rs1(1)
                if i=0 then
				    SQL="(申請單位='" & unit & "' and 申請人='" & name & "'"
			    else
				    SQL=SQL & "or 申請單位='" & unit & "' and 申請人='" & name & "'"
			    end if
                rs1.movenext
                i=i+1
			    strNames=strNames & AuthorityNo & "." & name & vbcrlf
            wend
            rs1.close
			rs.movenext
		wend
		rs.close
		if i>0 then SQL=SQL & ")"
	case "card"
		i=0 : SQL=""
		rs.open "select distinct UserName from LogDB,UserDB where LogDB.UserID=UserDB.UserID and LogDB.LogTime >='" & DT(now,"yyyy/mm/dd 00:00") & "'",connGF2000
		while not rs.eof
        	if i=0 then
				SQL="(申請人='" & rs(0) & "'"
			else
				SQL=SQL & "or 申請人='" & rs(0) & "'"
			end if
			strNames=strNames & "?." & rs(0) & vbcrlf
        	rs.movenext
        	i=i+1			
        wend
		rs.close
		if i>0 then SQL=SQL & ")"
	case else
		rs.open "select 申請人,count(*) from people where 進入日期>='" & DT(now-365,"yyyy/mm/dd") & "' group by 申請人 order by count(*) desc",conn
		i=0 : SQL="進入日期>='" & DT(now-365,"yyyy/mm/dd") & "'"
		while not rs.eof and i<28		
			if i=0 then
				SQL=SQL & " and (申請人='" & rs(0) & "'"		
			else
				SQL=SQL & " or 申請人='" & rs(0) & "'"
			end if
			i=i+1
			rs.movenext
		wend
		rs.close
		if i>0 then SQL=SQL & ")"
	end select
	
	'排除名單不列入快速登入
	rs.open "select * from Config where kind='排除名單'",conn
	while not rs.eof
		Exceptions=Exceptions & rs(1) & "：" & rs(2) & "："
		rs.movenext
	wend
	rs.close
	
	'response.write SQL
	'response.end
	if SQL<>"" then

	rs.open "select * from people where " & SQL & " order by 申請單位,申請人,Serial desc",conn
	i=1 : r=0
	while not rs.eof
		if tmp<>trim(rs("申請人")) then
			r=i mod 4 
			if r=1 then response.write "<tr>"
			tmp=trim(rs("申請人")) : Names=trim(rs("申請人")) : pos1=instr(1,strNames,Names)
			if pos1>0 then
				pos2=instr(pos1,strNames,vbcrlf)
				Names=mid(strNames,pos1-2,pos2-pos1+2)
			end if			
			if instr(1,Exceptions,trim(rs("申請單位")) & "：" & Names)=0 then
%>				<td align="center" class="item"><%=trim(rs("申請單位"))%>　</td>
				<td align="center"><input type="button" class="butn" value="<%=Names%>" onClick="set_value ('<%=rs("Serial")%>');"></td>
<%				if r=0 then response.write "</tr>"
				i=i+1
			end if
		end if
		rs.movenext
	wend
	rs.close
	
	if r<>0 then
		response.write "<td colspan=""" & 2*(4-(i-1) mod 4) & """>　</td>"
		response.write "</tr>"
	end if

	end if
%>  
</table>
</form>
<%="<p align=""center"">" & memo & "<br><br><font color=""green"" size=""2"">(只顯示曾登入過的人員,以便匯入最近一筆資料,正式的完整清單請見授權清冊 )</font></p>"%>
</body>
</html>
<script language="javascript">
    function set_value(Serial) {
        var e = document.getElementById("form");
        e.action = "people.asp?IO=I&Serial=" + Serial;
        e.submit();
    }
</script>