<!-- #include file="..\..\..\connDB\conn.ini" -->
<!-- #include file="..\..\..\Lib\GetConfig.inc" -->
<%
set condb=Server.CreateObject("adodb.connection")     
condb.open strControl 
set rs=server.createobject("adodb.recordset")

if request("search")<>"" and request("applicant")<>"" and request("selYYYY")<>"" and request("selMM")<>"" and request("selDD")<>"" then
	DateIn = DT2(cint(request("selYYYY")), cint(request("selMM")), cint(request("selDD")), "yyyy/mm/dd")
	
	select case request("search")
	case "0"	
		rs.open "select * from people where �ӽФH='" & trim(request("applicant")) & "' order by �i�J��� desc, �i�J�ɶ� desc",condb 
	case "-1"	
		rs.open "select * from people where �ӽФH='" & trim(request("applicant")) & "' and �i�J���<'" & DateIn & "' order by �i�J��� desc",condb 
	case "1"
		rs.open "select * from people where �ӽФH='" & trim(request("applicant")) & "' and �i�J���>'" & DateIn & "' order by �i�J��� asc",condb 
	end select 

	'rs.open "select * from people where �ӽФH='" & trim(request("applicant")) & "' and �i�J���<'" & DateIn & "' order by �i�J��� desc, �i�J�ɶ� desc",condb 
	
	if not rs.eof then
		'response.write rs("Serial")
		response.write rs("�i�J���")
	end if 
	rs.close
end if

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
