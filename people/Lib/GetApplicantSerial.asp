<!-- #include file="..\..\..\connDB\conn.ini" -->

<%
response.Charset="big5"

set condb=Server.CreateObject("adodb.connection")     
condb.open strControl 
set rs=server.createobject("adodb.recordset")

if trim(request("applicant"))<>"" then
	rs.open "select * from people where �ӽФH='" & trim(request("applicant")) & "' order by �i�J��� desc, �i�J�ɶ� desc",condb 
	if not rs.eof then
		response.write rs("Serial")		
	end if 
	rs.close
end if
%>
