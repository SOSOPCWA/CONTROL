<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID.inc" -->
<!-- #include file="..\..\Lib\GetConfig.inc" -->
<% 
set conn=Server.CreateObject("adodb.connection") : conn.Open strControl
set rs=server.createobject("adodb.recordset")
set rs1=server.createobject("adodb.recordset")

Company=request("Company") : if Company="" then Company="�I�h�q"
Names=request("Names") : if Names<>"" then Names=mid(Names,1,len(Names)-1)
OP=request("selOP")

Serial=1
rs.open "select max(Serial) from people",conn	
if not rs.eof then Serial=rs(0)+1
rs.close

Unit="�D���B�ޥ�" : Maintainer="�L����" : StuffIn="" : if Company="�I�h�q" then StuffIn="���O���q��"
USB="����J" : Process="HPC�t�Φw�˫ظm" : Cause="" : Memo="" : Amount=1

DateIn=DT(now,"yyyy/mm/dd")	: TimeIn=DT(now,"hh:mi:ss")		        

if OP<>"" then
    dim NameA : NameA=split(Names,",")
    for i=0 to UBound(NameA)
    	rs.open "select * from people where �ӽг��='" & Company & "' and �ӽФH='" & NameA(i) & "' and (�i�J���='" & DT(now,"yyyy/mm/dd") & "' or ���}���='')",conn,3,3
    	if rs.eof then
            Purpose="�t�Φw�˫ظm, " & GetABC(Company,NameA(i)) & "���H��, �̳W�w�n�J"
	        conn.execute "insert into people values(" & Serial & ",'" & Company & "','" & NameA(i) & "','" & Unit & "','" & Maintainer & "','" & Purpose & "','" _
			    & StuffIn & "','" & USB & "','" & Process & "','" & StuffIn & "','" & Cause & "','" & Memo & "'," & Amount & ",'" _
			    & OP & "','','" & DateIn & "','" & TimeIn & "','','')" 
		else
			if trim(rs("���}���"))="" then
				rs("�ȯZ�H��2")=OP : rs("���}���")=DT(now,"yyyy/mm/dd") : rs("���}�ɶ�")=DT(now,"hh:mi:ss")
			else
				rs("�ȯZ�H��2")="" : rs("���}���")="" : rs("���}�ɶ�")=""				
			end if	
			rs.update		
		end if
		rs.close
        Serial=Serial+1
    next
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

Function GetABC(byval Company,byval Staff)
    set rsABC=server.createobject("adodb.recordset")
    rsABC.open "select Item from Config where Kind like '���v�W��%' and Item like '%" & Company & "-" & Staff & "%'",conn
	if not rsABC.eof then 
		GetABC=mid(rsABC(0),len(rsABC(0)))
	else
		GetABC="C"
	end if
	rsABC.close
End Function
%> 

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=big5" />
	<title>�j�q�n�J</title>
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
<div align="center"><span class="title">�i�X�t�Ӥj�q�n�J - <%=Company%></span></div>
<form name="form" id="form" method="post">
<table width="90%" border="1" align="center" cellpadding="5" cellspacing="0">
<%	rs.open "select distinct �ӽФH from people where �ӽг��='" & Company & "' and (�i�J���='" & DT(now,"yyyy/mm/dd") & "' or ���}���='')",conn	'TodayNames:����n�J�Ω|���n�X��
    while not rs.eof
        TodayNames=TodayNames & rs(0) & ","
        rs.movenext
    wend
    rs.close
    
    rs.open "select distinct �ӽФH from people where �ӽг��='" & Company & "' and �i�J��� between '" & DT(now-7,"yyyy/mm/dd") & "' and '" & DT(now-1,"yyyy/mm/dd") & "'",conn	'WeekNames:��@�g�n�J��
    while not rs.eof
        WeekNames=WeekNames & rs(0) & ","
        rs.movenext
    wend
    rs.close
    
    'rs.open "select distinct �ӽФH,substring(�ӽФH,1,1) as FirstName from people where �ӽг��='" & Company & "' order by �ӽФH",conn	'�����n�J��
    rs.open "select * from Config where Kind='���v�W��-HPC�M��(" & Company & ")' order by Content",conn	'�����n�J��
	i=1 : r=0
	while not rs.eof
		r=i mod 8
		pos1=instr(1,rs(1),"-") : pos2=instr(pos1+1,rs(1),"-") : Pname=mid(rs(1),pos1+1,pos2-pos1-1)
		if r=1 then response.write "<tr>"
        if instr(1,TodayNames,Pname & ",")>0 then	'TodayNames:����n�J�Ω|���n�X��
        	rs1.open "select * from people where �ӽг��='" & Company & "' and �ӽФH='" & Pname & "' and ���}���=''",conn
        	if not rs1.eof then	'�|���n�X�̾侀�Ŧr
	        	response.write "<td width=""12.5%"" style=""background:orange""><input type=""checkbox"" name=""chk" & i & """ value=""" & Pname & """ />&nbsp;<font color=""blue"">" & Pname & "</font></td>"
	        else	'�w�n�X�̺��Ŧr
	        	response.write "<td width=""12.5%"" style=""background:green""><input type=""checkbox"" name=""chk" & i & """ value=""" & Pname & """ />&nbsp;<font color=""blue"">" & Pname & "</font></td>"
	        end if
	        rs1.close
        elseif instr(1,WeekNames,Pname & ",")>0 then	'��@�g�n�J���Ŧr
        	response.write "<td width=""12.5%""><input type=""checkbox"" name=""chk" & i & """ value=""" & Pname & """ />&nbsp;<font color=""blue"">" & Pname & "</font></td>"
        else
            response.write "<td width=""12.5%""><input type=""checkbox"" name=""chk" & i & """ value=""" & Pname & """ />&nbsp;" & Pname & "</td>"
        end if
		if r=0 then response.write "</tr>"
		i=i+1
	    rs.movenext
	wend
	rs.close
	
	if r<>0 then
		response.write "<td colspan=""" & (8-(i-1) mod 8) & """>�@</td>"
		response.write "</tr>"
	end if
%>  
</table>

<p align="center">
    �ȯZ�H���G
    <select name="selOP" size="1">
        <option value=""></option>
	    <%	dim opA : OutFormat="<option value=""#Item#"" #Sel#>#Item#</option>"
            response.write GetConfig("IDMS","order by mark","�@�~�޲z��","Item",OP,"*",OutFormat,opA)
	    %>  
    </select>�@�@&nbsp;
    <input type="button" value="�j�q�n�J / �j�q�n�X / �����n�X" class="butn" onClick="set_login();">�@&nbsp;
    <input type="button" value="���s��z" class="butn" onClick="window.open('many.asp','_self');">
</p>
<font color="#008000">
<input type="hidden" name="Company" value="<%=Company%>" />
<input type="hidden" name="Names" />
</font>
</form>
</body>
</html>
<script>
    var e = document.getElementById("form")
    function Eobj(str) { return document.getElementById(str); }
    function Fobj(str) { return e.elements[str]; }

    if ("<%=OP%>") alert("�s�ɧ����I");

    function set_login() {
        if (Fobj("selOP").value) {
            for (i = 0; i < document.all.length; i++) {
                if (document.all(i).tagName == "INPUT")
                    if (document.all(i).type == "checkbox")
                        if (document.all(i).checked & document.all(i).value != "") Fobj("Names").value = Fobj("Names").value + document.all(i).value + ",";
            }
            e.target = "_self";
            e.action = "Many.asp";
            e.submit();
        }
        else
            alert("�п�ܭȯZ�H���I");
    }
</script>
<p><font color="#008000" size="2">
1.���T�ި�--&gt;�H���i�X--&gt;�ֳt�n�J--&gt;�I�h�q���_�T���ﶵ���A�w�N��ñ�p�O�K�����H���M��C�b�W��(�ѦҸ�޽�-�͵a�����),����v����(����B���H��)�Ѩt�γ]�w��Ū��; 
�Y�b�ӿ��W�L���H���A����C���H���A�з�Z�P���`�N.<br><br>
2.�Y���i���W��W�����H��,���b���T�ި�--&gt;�H���i�X--&gt;�ֳt�n�J--&gt;�I�h�q���ﶵ���L�ﶵ,��Z�P���i�G<br>
�@a.�C�L<a target="_blank" href="file://10.6.1.4/d/SSM_WEB/control/people/Help/20150522_161336_CWB-MIC-ISMS-ISR-D002-�ĤT��H���O�K������_20150521_v2.1.doc">�O�K������</a>�Ш�ñ�p,�B�O����x.<br>
�@b.�Эt�d�H�a�J,�n�JC���H��.�@�k�i2��1<br><br>
-----by ��w�p��</font></p>