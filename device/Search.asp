<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID.inc" -->
<%
Dim connDevice  : Set connDevice=Server.CreateObject("ADODB.Connection")  : connDevice.Open strControl
set rs=server.createobject("ADODB.recordset")
%>
<!-- #include file="Lib\inScript.ini" -->
<%  Execute inScript("Lib\FxLibs.txt") %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=big5">
	<title>search</title>
</head>
<body text="" bgcolor="#DFEFFF">
<p align="center"><b><font size="5" color="#000066">�]�Ʋ��ʶi���d�ߤ���</font></b></p>
<form id="FormSearch">
  <p>���ɤ��(YYMMDD)����           
  	<input type="text" name="TextCreate1" size="20">�M           
  	<input type="text" name="TextCreate2" size="20">���� �@ <font color="#CC6600">          
  	<font size="2">(�᭱��������ܥu�d��@���) (�褸�~)</font> 
  </font>
  </p>
  <p>�ק���(YYMMDD)����           
  	<input type="text" name="TextUpd1" size="20">�M           
  	<input type="text" name="TextUpd2" size="20">���� �@ <font color="#CC6600">          
  	<font size="2">(�᭱��������ܥu�d��@���) (�褸�~)</font> 
  </font>
  </p>
  <p>�j�M�r�� �G<input type="text" name="TextFull" size="30">�@<font size="2" color="#CC6600">(     
  ��Ҧ���r�����r��O�_�ŦX�A�H�����j�}�j�M�r�갵and���     
  )</font>
  </p>
  <p>�]�Ʋ��� �G         
  	<input type="checkbox" name="CheckI" value="ON">���J�@         
  	<input type="checkbox" name="CheckO" value="ON">���X�@         
  	<input type="checkbox" name="CheckN" value="ON">�󴫡@  
  	<input type="checkbox" name="CheckM" value="ON">�䥦
  </p>
  <p>�]�ƺ��� �G       
  �@<select size="1" name="selHostClass">      
    <%  response.write "<option></option>"
		rs.open "select Item from Config where Kind='�]�ƺ���' order by Item",connDevice
		while not rs.eof
			response.write "<option value='" & rs(0) & "'>" & rs(0) & "</option>"
			rs.movenext
		wend
		rs.close
	%>
    </select>
  </p>
  <p>�t�d�H �G �@<select size="1" name="selMaintainer">      
    <%  response.write "<option></option>"
		rs.open "select distinct Content from Config where Kind='�t�d���'",connDevice
		while not rs.eof
			response.write "<option value='" & rs(0) & "'>" & rs(0) & "</option>"
			rs.movenext
		wend
		rs.close
	%>
    </select>
  <font size="2" color="#CC6600">(�t�ӽФH�B�w���n��t�d�H)</font>
  </p>
  <p align="right">
  	<input type="button" value="�@�d�@�ߡ@" name="ButtonOK">�@ 
  	<input type="reset" value="���s�]�w" name="B2">
  </p>
</form>
<script language="vbscript">
Sub ButtonOK_onClick()
	if len(formSearch.TextCreate1.value)<>6 and len(formSearch.TextUpd1.value)<>6 _
		and formSearch.TextFull.value="" _
		and (not FormSearch.checkI.checked) and (not FormSearch.checkO.checked) _
		and (not FormSearch.checkN.checked) and (not FormSearch.checkM.checked) _
		and FormSearch.selHostClass.value="" and FormSearch.selMaintainer.value="" then exit sub
	'*******************����j�M****************************************
	if len(FormSearch.TextCreate1.value)=6 then	'���ɤ��
		if len(FormSearch.TextCreate2.value)=6 then
			SQLdate="CreateDate between '20" & FormSearch.TextCreate1.value & "' and '20" & FormSearch.TextCreate2.value & "'"
		else
			SQLdate="CreateDate like '" & FormSearch.TextCreate1.value & "%'"
		end if
		SQL=SQL_format("and",SQLdate,SQL)
	end if	
	
	if len(FormSearch.TextUpd1.value)=6 then	'�ק���
		if len(FormSearch.TextUpd2.value)=6 then
			SQLdate="UpdateDate between '20" & FormSearch.TextUpd1.value & "' and '20" & FormSearch.TextUpd2.value & "'"
		else
			SQLdate="UpdateDate like '" & FormSearch.TextUpd1.value & "%'"
		end if
		SQL=SQL_format("and",SQLdate,SQL)
	end if	

	'*******************�r��j�M****************************************
	hosts="HostName;Repair;Functions;Memo;PS;StaffName;Hw;Sw;OP"
	SQL=SQL_format("and",strSQL_Create(hosts,DelHT(FormSearch.TextFull.value)), SQL)	
	'*******************�]�Ʋ���****************************************
	if FormSearch.checkI.checked then SQLIO=SQL_format("or","IO='I'",SQLIO)
	if FormSearch.checkO.checked then SQLIO=SQL_format("or","IO='O'",SQLIO)
	if FormSearch.checkN.checked then SQLIO=SQL_format("or","IO='N'",SQLIO)
	if FormSearch.checkM.checked then SQLIO=SQL_format("or","IO='M'",SQLIO)
	SQL=SQL_format("and",SQLIO,SQL)
	'*******************�]�ƺ���****************************************
	if FormSearch.selHostClass.value<>"" then SQL=SQL_format("and","HostClass='" & FormSearch.selHostClass.value & "'",SQL)
	'*******************�t�d�H****************************************
	if FormSearch.selMaintainer.value<>"" then 
	    SQLMT="(StaffName='" & FormSearch.selMaintainer.value & "' or Hw='" & FormSearch.selMaintainer.value & "' or Sw='" & FormSearch.selMaintainer.value & "')"
	end if
	SQL=SQL_format("and",SQLMT,SQL)
	'********************����j�M****************************************************
	if SQL<>"" then window.open "List.asp?SQL=SELECT DevID,convert(varchar, CreateDate, 111) as CreateDate,[HostName],[HostClass],[Repair],[IO],[Functions],[Memo],[PS],[StaffName],[Hw],[Sw],[OP],[Xall],[Yall],[UpdateDate] FROM Device2 where " & SQL & " order by CreateDate Desc&SQLsearch=y","_self"
End Sub

Sub TextDate1_onKeyPress
	select case window.event.keycode
	case 48,49,50,51,52,53,54,55,56,57			
	case else
		window.event.keycode=0
	end select
End Sub
Sub TextDate2_onKeyPress
	select case window.event.keycode
	case 48,49,50,51,52,53,54,55,56,57			
	case else
		window.event.keycode=0
	end select
End Sub
Sub TextFull1_onKeyPress
	select case window.event.keycode
	case 39,44,34,124 '['][,]["][|]
		window.event.keycode=0
	end select
End Sub
Sub TextFull1_onKeyPress
	select case window.event.keycode
	case 39,44,34,124 '['][,]["][|]
		window.event.keycode=0
	end select
End Sub
Sub TextFull1_onKeyPress
	select case window.event.keycode
	case 39,44,34,124 '['][,]["][|]
		window.event.keycode=0
	end select
End Sub
</script>
</body>

</html>