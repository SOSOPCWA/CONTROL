<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID.inc" -->
<%
set condb=Server.CreateObject("adodb.connection")     
condb.open strControl 
set rs=server.createobject("adodb.recordset")


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
<html">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=big5" />
	<title>�]���[�Z�W�U</title>
</head>
<body>
<p align="center">
  <table width="100%"><tr>
	<td align="center"><font size="5"><b>�@�@�@�@�ƭȸ�T�վ��мt�ө]���[�Z�H���W�U</b></font></td>
	<td align="right"><font size="2"><%=DT(now,"yyyy/mm/dd")%></font></td>
  </tr></table>
</p>
<% 
rs.open "select * from people where ���}���='' order by �ӽг��",condb 
i=0
%>  
<p align="center"><table border="1" width="100%">
  <tr>
    <td width='20%'><div align="center">���q�W��</div></td>
    <td width='25%'><div align="center">�m�W</div></td>
    <td width='25%'><div align="center">�u�@�a�I</div></td>
    <td><div align="center">�Ƶ�</div></td>
  </tr>
<% 
while not rs.eof
  i=i+1
  response.write "<tr><td width='20%' align='center'>" & rs("�ӽг��") & "</td><td width='20%' align='center'>" & rs("�ӽФH") _
  	& "</td><td width='20%' align='center'><font size='2'><input type='checkbox'>���С@ <input type='checkbox'>319��</font></td><td>�@</td></tr>"
  rs.movenext  
wend
rs.close
%>
</table></p>
<p align="center">�� �@ <%=i%> �H�@�@�@�� �[�Z�W�L21:00�ȥ���g�@�@�@�� �Щ�20:30�e�e��ĵ�ë�</p>
</body>
</html>