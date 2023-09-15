<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID2.inc" -->
<%
Dim conn  : Set conn=Server.CreateObject("ADODB.Connection")  : conn.Open strControl
set rs=server.createobject("ADODB.recordset")

Function DT(byval sDT,byval fDT)
  DT=lcase(fDT)
  YY=year(sDT)   : if instr(1,DT,"yy",1)>0 and instr(1,DT,"yyyy",1)=0 then YY=mid(YY,3)
  DT=replace(replace(DT,"yyyy","yy"),"yy",YY)
  MM=month(sDT)  : if MM<10 then MM="0" & MM
  DT=replace(DT,"mm",MM)
  DD=day(sDT)    : if DD<10 then DD="0" & DD
  DT=replace(DT,"dd",DD)
  HH=hour(sDT)   : if HH<10 then HH="0" & HH
  DT=replace(DT,"hh",HH)
  MI=minute(sDT) : if MI<10 then MI="0" & MI
  DT=replace(DT,"mi",MI)
  SS=second(sDT) : if SS<10 then SS="0" & SS
  DT=replace(DT,"ss",SS) 
End Function
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=big5" />
	<title>���v�d��</title>
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
<body>
<p align="center" class="title">���жi�X�H�����v�����d��</p>
<form name="form" id="form" method="post">
  <p>�i�J��� �G 
  	<select size="1" name="selYYYY">      
    <%  response.write "<option></option>"
		for i=cint(DT(now,"yyyy"))-4 to cint(DT(now,"yyyy"))
			response.write "<option value='" & i & "'>" & i & "</option>"
		next
	%>
    </select>�~�@
  	<select size="1" name="selMM">
    <%  response.write "<option></option>"
		for i=1 to 12
			if i>9 then
				response.write "<option value='" & i & "'>" & i & "</option>"
			else
				response.write "<option value='0" & i & "'>0" & i & "</option>"
			end if
		next
	%>
    </select>��
  </p>
  <p>�j�M�r�� �G<input type="text" name="txtFull" size="15">�@
  	<font size="2" color="#CC6600">(��Ҧ���r�����r��O�_�ŦX�A�ťչj�}�j�M�r��i��and���A��
  	&quot;<font color="red"><u onclick="txtFull.value='�䥦�n�J'">�䥦�n�J</u></font>&quot; 
    �Y�i�C�X���̳W�w�n�J����)</font>
  </p> 
  
  <p>�Ӽh/����(AND) �G<input type="text" name="txtFullAreaAnd" size="15">�@
  	<font size="2" color="#CC6600">(�ťչj�}�j�M�r��i�� <u>AND</u> ���)</font>
  </p>  
  <p>�Ӽh/����(OR) �G<input type="text" name="txtFullAreaOr" size="15">�@
  	<font size="2" color="#CC6600">(�ťչj�}�j�M�r��i�� <u>OR</u> ���)</font>
  </p>   
  
  <p>�t�d�H �G       
  �@<select size="1" name="selUnit">      
    <%  response.write "<option></option>"
		rs.open "select distinct �t�d�H from people",conn
		while not rs.eof
			if trim(rs(0))<>"" then response.write "<option value='" & rs(0) & "'>" & rs(0) & "</option>"
			rs.movenext
		wend
		rs.close
	%>
    </select>
  </p> 
  <p>�H���� �G       
  �@<select size="1" name="selUSB">      
    <%  response.write "<option></option>"
		rs.open "select Item from Config where Kind='�H����' order by Content",conn
		while not rs.eof
			response.write "<option value='" & rs(0) & "'>" & rs(0) & "</option>"
			rs.movenext
		wend
		rs.close
	%>
    </select>
  </p>
  <p>�H�� �G       
  �@<select size="1" name="selAmount">      
  		<option></option>
  		<option value="=1">����1�H</option>
  		<option value="=2">����2�H</option>
  		<option value=">1">�j��1�H</option>
  		<option value=">2">�j��2�H</option>
    </select>
  </p>
  <p>�d�ߵ��G �G 
  �@<select size="1" name="selOrder">      
  		<option value="ASC">�� -> �s</option>
  		<option value="DESC">�s -> ��</option>
    </select> 
	<!--
  �@<select size="1" name="selNewPage">      
  		<option value="_blank">�}�s����</option>
  		<option value="_self">�d�b����</option>
    </select> 
	-->
  </p>   
  <p>
	<!--
  	<input type="button" value="�@���@���@�d�@�ߡ@" name="cmdLog"  onClick="HistoryOK('report.asp');">�@
  	<input type="button" value="�@�ɡ@�ơ@�Ρ@�p�@" name="cmdTime" onClick="HistoryOK('time.asp');">&nbsp;  	
	<input type="hidden" name="SQL">
	-->
	<input type="button" value="�@���@���@�d�@�ߡ@" name="cmdLog"  onClick="HistoryPostProc('report.asp');">�@
  	<input type="button" value="�@�ɡ@�ơ@�Ρ@�p�@" name="cmdTime" onClick="HistoryPostProc('time.asp');">&nbsp;  	
	<input type="hidden" name="which">	
  </p> 
</form>

<script language="javascript">
var e=document.getElementById("form");

function HistoryPostProc(which) {
	if (e.elements['selYYYY'].value == "" && e.elements['selMM'].value == "" && e.elements['txtFull'].value == "" && e.elements['selUnit'].value == "" && e.elements['selUSB'].value == "" && e.elements['selAmount'].value == "") {
		alert("�d�߱��󤣨�,�п�J�d�߱��� !");	
	} else {
		e.elements['which'].value = which;
		e.target="_blank";
		//e.target=e.elements['selNewPage'].value;
		e.action="history_postproc.asp";
		e.submit();
	}
}
</script>
</body>
</html>