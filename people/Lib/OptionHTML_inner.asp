<!-- #include file="..\..\..\connDB\conn.ini" -->
<!-- #include file="..\..\..\Lib\GetConfig.inc" -->
<%
response.Charset="big5"

Dim conn : Set conn=Server.CreateObject("ADODB.Connection") : conn.Open strControl
set rs=server.createobject("ADODB.recordset")

Kind=request("Kind")	'onchange�������
which=request("which")	'onchange��ﶵ�n�������ܪ�����
other=request("other")	'��L�Ѽ�(�ھک����p���t�d�H�Ӳ��Ϳﶵ)

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

optHTML="<option value=""""></option>"

select case which
case "selCompany"	'�ӽг��
	'selHTML="<select name=""" & which & """ size=""1"" class=""option"" onchange=""Option_HTML('selStaff',this.value,'');"">"
	selHTML=""
	SQL="select distinct �ӽг�� from people where �i�J���>='" & DT(now-365*3,"yyyy/mm/dd") & "'"
	select case Kind
	case "All"	'(����)
		SQL=SQL & " order by �ӽг��"
	case "Adm"	'(�p���)
		SQL="select dept from accesslist  group by dept order by COUNT(dept) asc"			
	case "Link"	'(���p)
		SQL=SQL & " and �t�d�H='" & other & "' order by �ӽг��"
	case "No"	'(����)
		SQL="select �ӽг��,count(*) from people where �i�J���>='" & DT(now-365*3,"yyyy/mm/dd") & "' group by �ӽг�� order by count(*) desc,�ӽг��"
	case "A-Z"	'���(A-Z)	
		SQL=SQL & " and (�ӽг�� like 'A%'"	
		for i=66 to 90
			SQL=SQL & " or �ӽг�� like '" & chr(i) & "%'"
		next
		SQL=SQL & ") order by �ӽг��"
	case "Else"	'(���k��)
		SQL=SQL & " and LEFT(�ӽг��,1) not in (select txt from phonehead)"
		for i=65 to 90
			SQL=SQL & " and �ӽг�� not like '" & chr(i) & "%'"
		next
		SQL=SQL & " order by �ӽг��"
		
	case "Self"	'(�۶�)
		'����coding,�������
	case else	'���(�t-��)
		SQL=SQL & " and ("			
		rs.open "select * from phonehead where head like '" & Kind & "%'",conn
		if not rs.eof then
			SQL=SQL & "�ӽг�� like '" & rs(1) & "%'"
			rs.movenext
		else
			SQL=SQL & "1=2"
		end if
		while not rs.eof
			SQL=SQL & " or �ӽг�� like '" & rs(1) & "%'"
			rs.movenext
		wend
		rs.close
		SQL=SQL & ") order by �ӽг��"
	end select
case "selStaff"	'�ӽФH
	'selHTML="<select name=""" & which & """ size=""1"" class=""option"" onChange=""Staff_KeyIn(this.value);"">"
	'selHTML=""
	if other="Adm" then
		SQL = "select name from accesslist  where dept='" & Kind & "'"
	else
		SQL="select distinct �ӽФH from people where �ӽг��='" & Kind & "' and �i�J���>='" & DT(now-365*3,"yyyy/mm/dd") & "' order by �ӽФH"
	end if
end select	

if which<>"selMaintainer" then
	if SQL<>"" then
		rs.open SQL, conn
		while not rs.eof
			if Kind="No" then
				optHTML=optHTML & vbcrlf & "<option value=""" & trim(rs(0)) & """>" & trim(rs(0)) & "(" & trim(rs(1)) & ")</option>"
			else
				optHTML=optHTML & vbcrlf & "<option value=""" & trim(rs(0)) & """>" & trim(rs(0)) & "</option>"
			end if
			rs.movenext
		wend
		rs.close
	end if

	if which="selStaff" then optHTML=optHTML & vbcrlf & "<option value=""Self"">(�۶�)</option>"

	'response.write selHTML & optHTML & "</select>"
	response.write selHTML & optHTML
else	'selMaintainer�t�d�H
	'response.write "<select name=""" & which & """ size=""1"" class=""option"" onchange=""selComKind.options(0).selected=1;"">"
	response.write "<option value=""""></option>"
    dim MaintainerA 
    OutFormat="<option value=""#Item#"">#Item#</option>"
    response.write GetConfig("IDMS","order by mark",Kind,"","","*",OutFormat,MaintainerA)	
    'response.write "</select>"
end if
%>