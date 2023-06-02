<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID.inc" -->
<%
set condb=Server.CreateObject("adodb.connection")     
condb.open strControl 
set rs=server.createobject("adodb.recordset")

Serial=trim(request("Serial")) : DateIn=request("DateIn") : nowDT=DT(now,"yyyy/mm/dd")

if request("diff")="" then
	diff=0
else
	diff=cint(request("diff"))
end if

if DateIn="" then DateIn=nowDT
DateIn=DT(DateSerial(mid(DateIn,1,4),mid(DateIn,6,2),mid(DateIn,9,2)) + diff,"yyyy/mm/dd")	

if request("selYYYY")<>"" and request("selMM")<>"" and request("selDD")<>"" then
	DateIn = DT2(cint(request("selYYYY")), cint(request("selMM")), cint(request("selDD")), "yyyy/mm/dd")
end if 

dateInSerial = DateSerial(mid(DateIn,1,4),mid(DateIn,6,2),mid(DateIn,9,2))
DateInYear = year(dateInSerial)
DateInMonth = month(dateInSerial)
DateInDay = day(dateInSerial)

week=WeekdayName(DatePart("w",DateSerial(mid(DateIn,1,4),mid(DateIn,6,2),mid(DateIn,9,2))))

select case request("DBaction")
case "c"	'�����n�J
	condb.execute "update people set �ȯZ�H��2='',���}���='',���}�ɶ�='' where Serial=" & Serial
case "d"	'�R���O��
	condb.execute "delete from people where Serial=" & Serial
end select 

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

Function DT2(byval YY0, byval MM0, byval DD0, byval fDT)
	DT2=lcase(fDT)
	if instr(1,DT2,"yy",1)>0 and instr(1,DT2,"yyyy",1)=0 then YY0=mid(YY0,3)
	DT2=replace(replace(DT2,"yyyy","yy"),"yy",YY0)
	if MM0<10 then MM0="0" & MM0
	DT2=replace(DT2,"mm",MM0)
	if DD0<10 then DD0="0" & DD0
	DT2=replace(DT2,"dd",DD0)
End Function
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=big5" />
	<title>�i�X�O��</title>
	<!--<link href="people.css" rel="stylesheet" type="text/css" />-->
	<link href="Lib/people.css" rel="stylesheet" type="text/css" />
</head>
<body>
<form id="form" name="form" method="post">
<% 
orderBy=request("orderBy")
'response.write len(orderBy)
if orderBy<>""	then 
	rs.open "select * from people where �i�J���='" & DateIn & "' or ���}���='' order by " & orderBy & " desc, �i�J��� desc,�i�J�ɶ� desc",condb 
else 
	rs.open "select * from people where �i�J���='" & DateIn & "' or ���}���='' order by �i�J��� desc,�i�J�ɶ� desc",condb 
end if 
i=0
%>  
<table border="0" align="center">
  <tr>
    <td align="center">
    	<span class="head">
    	<% if DateIn=nowDT then
    		response.write "����H���i�X���Ь���"
    	   else
    	   	response.write DateIn & "(" & week & ") �H���i�X���Ь���"
    	   end if 
    	%>
    	</span>
	</td>
  </tr>
</table>
<table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
	<td><div align="center">
      <input type="button" class="butn" value="<< �e10��" onClick="Form_Submit(-10);" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div></td>
    <td><div align="center">
      <input type="button" class="butn" value="��3�� >>" onClick="Form_Submit(3);" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div></td>
    <td><div align="center">
      <input type="button" class="butn" value="<  �e�@��" onClick="Form_Submit(-1);" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div></td>
    <td ><div bgcolor="red" align="center">
      <input type="button" class="butn1" value="��       ��" onClick="Form_Submit(0);"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div></td>
    <td><div align="center">
      <input type="button" class="butn" value="��@��  >" onClick="Form_Submit(1);"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div></td>	
  </tr>
</table>
<br>
<table align="center" border="1" cellpadding="5" cellspacing="1" bordercolor="#B0C4DE"> <!-- #B0C4DE: light steel blue -->
  <tr>
    <td width="120" ><div align="center" class="item"><a href="today.asp?orderBy=�ӽг��" target="body">�t��</a></div></td>
    <td width="100" ><div align="center" class="item"><a href="today.asp?orderBy=�ӽФH" target="body">�H��</a></div></td>
    <td width="100"><div align="center" class="item"><a href="today.asp?orderBy=" target="body">�i�J�ɶ�</a></div></td>
    <td width="100"><div align="center" class="item">���}�ɶ�</div></td>
	<!--<td><div align="center" class="item"><a href="today.asp?orderBy=�Ӽh" target="body">�Ӽh/����</a></div></td>-->
	<td><div align="center" class="item"><a href="today.asp?orderBy=�ϰ�" target="body">�Ӽh/����</a></div></td>
    <td><div align="center" class="item">����</div></td>
    <td><div align="center" class="item">�ɥ�</div></td>		
	<td width="120"><div align="center" class="item">�I�u�ϰ�/���d</div></td>	
  </tr>
<% 
while not rs.eof
   i=i+1 %>	
  <tr>
	<td class="word" align="center">&nbsp<% =rs("�ӽг��") 	%>&nbsp</td>
    <td class="word" align="center">&nbsp<u style="cursor:pointer" onClick="window.open('people.asp?IO=I&Serial=<%=rs("Serial")%>','_self');"><% =rs("�ӽФH")%></u>&nbsp</td>
    <td class="word" align="center">&nbsp
    <%	if DateIn=rs("�i�J���") then
    		response.write rs("�i�J�ɶ�")
    	else
    		response.write rs("�i�J���")    		
    	end if
    %>&nbsp</td>
    <td class="word" align="center">&nbsp
	 <%	if rs("���}�ɶ�")="" then
			response.write "�@"
		else
			response.write rs("���}�ɶ�")
		end if
	%>&nbsp</td>
	<!--<td>-->
	<% '=rs("�Ӽh") 
	%>
	<!--</td>-->																					
	<td>&nbsp<% =rs("�ϰ�") %>&nbsp</td>
    <td>&nbsp
    <%	if trim(rs("���}���")) ="" then %>			
    		<!-- <a href="people.asp?IO=O&Serial=
				<% '=rs("Serial")
				%>
			" target="body">�n�X</a> -->
			<b><font face="�s�ө���" color="#990099" onClick="Logout('<%=rs("Serial")%>','<%=trim(rs("�ӽФH"))%>','<%=trim(rs("�I�u�ϰ�"))%>');" style="cursor:pointer"><u>�n�X</u></font></b>			
	<%	else %>
			<font color="gray" onClick="Login_Cancel('<%=rs("Serial")%>','<%=trim(rs("�ӽФH"))%>');" style="cursor:pointer"><u>����</u></font>
	<%	end if %>&nbsp;&nbsp;&nbsp;
    	<a href="people.asp?Serial=<%=trim(rs("Serial"))%>" target="body">��s</a>&nbsp;&nbsp;&nbsp;
    	<font color="blue" onClick="Login_Del('<%=rs("Serial")%>','<%=trim(rs("�ӽФH"))%>');" style="cursor:pointer"><u>�R��</u></font>
	&nbsp</td>
    <td align="center"><font size="2">&nbsp
    <%	if instr(1,rs("��J���~"),"�{�ɥd")>0 then response.write "�{�ɥd&nbsp;"
    	if instr(1,rs("��J���~"),"�_��")>0 then response.write "�_��&nbsp;"
    	if instr(1,rs("��J���~"),"������")>0 then response.write "������"
    %>
    </font>&nbsp</td>		
	<td>&nbsp<% =rs("�I�u�ϰ�") %>&nbsp</td>	
  </tr>
<% 
   rs.movenext  
wend
rs.close
%>
</table>

<% if i=0 then response.write "<p align='center' class='msg'>�Ӥ�L�H���i�J�I</p>" %>
<input type="hidden" name="DateIn" value="<%=DateIn%>">
<input type="hidden" name="diff">
</form>

<%	
	'rs.open "SELECT �I�u�ϰ� FROM people WHERE �i�J���='" & DateIn & "' OR ���}���='" & DateIn & "'",condb 		
	'rs.open "SELECT �I�u�ϰ� FROM people WHERE �i�J���='" & DateIn & "' OR ���}���='' OR ���}���='" & DateIn & "'",condb 		
	rs.open "SELECT �I�u�ϰ� FROM people WHERE �i�J���<='" & DateIn & "' AND (���}���='' OR ���}���>='" & DateIn & "')",condb 		
	str_workareas = " "
	while not rs.eof
		if rs("�I�u�ϰ�") <> "" then
			str_workarea_i = rs("�I�u�ϰ�")			
			str_workarea_i = Replace(str_workarea_i, ",", " ")
			str_workarea_i = Replace(str_workarea_i, ";", " ")
			str_workarea_i = Replace(str_workarea_i, "�F", " ")
			str_workarea_i = Replace(str_workarea_i, "�A", " ")
			str_workarea_i = Replace(str_workarea_i, "�B", " ")
			str_workareas_i = Split(str_workarea_i," ")			
			for j = 0 to ubound(str_workareas_i)
				if InStr(str_workareas, str_workareas_i(j)) = 0 then
					str_workareas = str_workareas & str_workareas_i(j) & " "
				end if					
			next			
		end if
		rs.movenext  
	wend		
	rs.close
%>
<table align="center" border="1" cellpadding="5" cellspacing="1" bordercolor="#B0C4DE"> <!-- #B0C4DE: light steel blue -->
  <tr>
    <td width="190"><div align="center" class="item"><%=DateIn%> �I�u�ϰ�/���d</div></td>
    <td width="670"><p id="workareas"></p></td>
  </tr>
</table>
<br>
<table border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
	<td><div align="center">
      <input type="button" class="butn" value="<< �e10��" onClick="Form_Submit(-10);" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div></td>
    <td><div align="center">
      <input type="button" class="butn" value="��3�� >>" onClick="Form_Submit(3);" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div></td>
    <td><div align="center">
      <input type="button" class="butn" value="<  �e�@��" onClick="Form_Submit(-1);" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div></td>
    <td><div align="center">
      <input type="button" class="butn1" value="��       ��" onClick="Form_Submit(0);"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div></td>
    <td><div align="center">
      <input type="button" class="butn" value="��@��  >" onClick="Form_Submit(1);"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div></td>
    <td><div align="center">
      <input type="button" class="butn" value="�]���[�Z�W�U" onClick="alert('���\��ȧ@����U�u�㤧��');window.open('night.asp','_blank');"/>
    </div></td>
  </tr>
</table>
<br /><br />
</body>
</html>
<script language="javascript">
var e=document.getElementById("form")
var str_workareas = '<%=str_workareas%>';
var workareas = str_workareas.trim().split(' ');
workareas.sort(function(a, b) {return a.localeCompare(b, "zh-Hant-TW");});
document.getElementById("workareas").innerHTML = workareas.toString().replaceAll(',', '�B');

function Form_Submit(diff) {
	e.elements["diff"].value=diff ;
	if(diff==0) e.elements["DateIn"].value="" ;
	e.submit() ;
}

function Login_Cancel(Serial,p) {
	if(confirm(p + "�T�w�n�����n�X?")) window.open("today.asp?DBaction=c&Serial=" + Serial,"_self") ;
}

function Login_Del(Serial,p) {
	if(confirm("�T�w�n�R��"+ p +"���n�J�O��?")) window.open("today.asp?DBaction=d&Serial=" + Serial,"_self") ;
}

function Logout(Serial,p,WorkArea) {
	if(WorkArea == "" || confirm("�и���l�� "+ p +" �� �I�u�ϰ�/���d�G"+ WorkArea + " �����Ҵ_�챡�ΡC")) window.open("people.asp?IO=O&Serial=" + Serial,"_self") ;
}
</script>