<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID.inc" -->
<!-- #include file="..\..\Lib\DT.inc" -->
<%
Dim connDevice : Set connDevice=Server.CreateObject("ADODB.Connection") : connDevice.Open strControl
Dim connIDMS : Set connIDMS=Server.CreateObject("ADODB.Connection") : connIDMS.Open strIDMS
set rs=server.createobject("ADODB.recordset")
set objWShell = CreateObject("WScript.Shell")
'�i���j�M--------------------------- : SQL�d��----------- : �~��(YYYY/MM)--- : �O�_���N���e��------  : ���ʺ���-------------------- : ����D��--------------------
SQLsearch=trim(request("SQLsearch")) : SQL=request("SQL") : YM=request("YM") : Burn=request("Burn")  : DBaction=request("DBaction") : CreateDate=request("CreateDate")
Sel=request("Sel") '�q�Ѧҿ��פJ���,"":�D�פJ�e��,Y:�פJdevice.asp,none and full:�Pcase����
if DBaction="d" then 
	connDevice.execute "delete from Device where CreateDate='" & CreateDate & "'" 
end if 

if YM="" then 
	YM=DT(now,"yyyy/mm")
end if

%>
<!-- #include file="Lib\inScript.ini" -->
<%  Execute inScript("Lib\XY_Trans.txt") %>
<html>
	
    
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=big5; IE=8">
	<title>
	<%  if SQLsearch="" and YM<>"" then
			response.write mid(YM,1,4) & "�~" & mid(YM,6,2) & "����г]�Ʋ��ʬ���"
		elseif Sel="Y" or Sel="full" then
			response.write "�פJ�������������"
		else
			response.write "���г]�Ʋ��ʬ���"
		end if
	%>
	</title>
	
</head>
<body id="bodyData"  bgcolor="#DFEFFF"  text="" >
  
  <p align="center"><font size='6' color="#000066"><b>
  	<%if Burn<>"" then 
  		if SQLsearch="" and YM<>"" then
  			response.write mid(YM,1,4) & "�~" & mid(YM,6,2) & "����г]�Ʋ��ʬ���"
  		else
  			response.write "���г]�Ʋ��ʬ���"
  		end if
  	  elseif Sel="Y" or Sel="full" then 
  		response.write "�פJ�������������<font size='3' color='#CC6600'>(�H�ƹ��I��ӦC�����Y�i)</font>"
  	  end if
  	%>
  </b></font></p>
  <!-- #include file="Lib/head.inc" -->
  <table id= "TableData" border="1" width="100%" cellpadding="0" cellspacing="0" title="">
    <tr>
      <% if burn="" then tmpStyle="style=""cursor:pointer""" %>
      <td width="44" align="center"  <%=tmpStyle%> onClick="Order_Click('CreateDate')"><u><font size="2" color="#0000FF">����</font></u></td>
      <td            align="center" <%=tmpStyle%> onClick="Order_Click('HostName')">   <u><font size="2" color="#0000FF">�]�ƦW��</font></u></td>
      <td width="56" align="center"  <%=tmpStyle%> onClick="Order_Click('HostClass')"> <u><font size="2" color="#0000FF">�]�ƺ���</font></u></td>
      <td width="56" align="center"  <%=tmpStyle%> onClick="Order_Click('Repair')">    <u><font size="2" color="#0000FF">�]�Ƽt��</font></u></td>
      <td            align="center" <%=tmpStyle%> onClick="Order_Click('Functions')">  <u><font size="2" color="#0000FF">�]�ƥγ~</font></u></td> 
      <td width="40" align="center"  <%=tmpStyle%> onClick="Order_Click('Hw')">        <u><font size="2" color="#0000FF">�w��</font></u></td>
      <td width="40" align="center"  <%=tmpStyle%> onClick="Order_Click('StaffName')"> <u><font size="2" color="#0000FF">�ӽ�</font></u></td>
      <td width="28" align="center"  <%=tmpStyle%> onClick="Order_Click('IO')">        <u><font size="2" color="#0000FF">����</font></u></td>
      <td width="48" align="center" <%=tmpStyle%> onClick="Order_Click('Xall,Yall')">  <u><font size="2" color="#0000FF">��m</font></u></td>
      <td width="32" align="center"  <%=tmpStyle%> onClick="Order_Click('OP')">        <u><font size="2" color="#0000FF">OP</font></u></td>
    </tr>
<%

Function GetArea(byval Xall,byval Yall)
    dim rs1 : set rs1=server.createobject("ADODB.recordset")
    GetArea=""
    if Xall<>"" then       
        rs1.open "select * from [�w��]�w] where [�w��覡]='����' and [����X]=" & Xall & " and [����Y]=" & Yall,connIDMS
        if not rs1.eof then GetArea=rs1("�ϰ�W��") & rs1("�w��W��")
        rs1.close
    end if          
End Function






YY=mid(YM,1,4) : MM=mid(YM,6,2) 
SQL="SELECT DevID,convert(varchar, CreateDate, 111) as CreateDate,[HostName],[HostClass],[Repair],[IO],[Functions],[Memo],[PS],[StaffName],[Hw],[Sw],[OP],[Xall],[Yall],[UpdateDate] FROM Device2 WHERE YEAR([CreateDate]) = '" & YY & "' AND MONTH([CreateDate])= '"& MM & "' "
rs.open SQL,connDevice
i=0
while not rs.eof
	i=i+1
	DevID = rs("DevID")
	CreateDate=rs("CreateDate")
	'CreateDay =mid(CreateDate,1,2) & "/" & mid(CreateDate,3,2) & "/" & mid(CreateDate,5,2)
	CreateDay = mid(CreateDate,3)
	CreateTime=mid(CreateDate,7,2) & ":" & mid(CreateDate,9,2) & ":" & mid(CreateDate,11,2)	
	UpdateDay=rs("UpdateDate")
	UpdateDate=mid(UpdateDate,1,2) & "/" & mid(UpdateDate,3,2) & "/" & mid(UpdateDate,5,2)
	UpdateTime=mid(UpdateDate,7,2) & ":" & mid(UpdateDate,9,2) & ":" & mid(UpdateDate,11,2)	
	Xall=rs("Xall") : Yall=rs("Yall") : Areas=GetArea(Cstr(Xall),Cstr(Yall))
	IO=rs("IO")
	select case IO
	case "I"
		IO="���J"
	case "O"
		IO="���X"
	case "N"
		IO="��"
	case else
		IO="�䥦"
	end select
	HostName=rs("HostName"):if trim(HostName)="" or IsNull(HostName) then HostName="*"
	HostClass=rs("HostClass"):if trim(HostClass)="" then HostClass="*"
	Repair=rs("Repair"):if trim(Repair)="" then Repair="*"
	Functions=rs("Functions"):if trim(Functions)="" or IsNull(Functions) then Functions="*"
	Memo=rs("Memo"):if trim(Memo)="" or IsNull(Memo) then Memo=" " else Memo=" ("&Memo&") "
      PS=rs("PS"):if trim(PS)="" or IsNull(PS) then PS=" " else PS=" ["&PS&"] "
	hw=rs("hw"):if trim(hw)="" then hw="*"
	StaffName=rs("StaffName"):if trim(StaffName)="" then StaffName="*"
	OP=rs("op"):if trim(OP)="" then OP="*"
	opA=split(OP," ",-1,1) : OP=""
	for j=0 to UBound(opA)
		OP=OP & "<span title='" & opA(j) & "'>" & mid(opA(j),1,1) & " </span>"
	Next
	
	if burn="" then
		textHTML="<tr onmouseover=me.style.color='#9900FF' onmouseout=me.style.color='' style='cursor:pointer' onClick='Select_Click """ & DevID & """'>"
	else
		textHTML="<tr>"
	end if	
    textHTML=textHTML &  "<td><font size='2'>" & CreateDay & "</font></td>" 
    textHTML=textHTML &  "<td><font size='2'>" & HostName & "</font></td>"
    textHTML=textHTML &  "<td><font size='2'>" & HostClass & "</font></td>"
    textHTML=textHTML &  "<td><font size='2'>" & Repair & "</font></td>"
    textHTML=textHTML &  "<td><font size='2'>" & Functions & Memo & PS & "</font></td>"
    textHTML=textHTML &  "<td><font size='2'>"  & hw & "</font></td>" 
    textHTML=textHTML &  "<td><font size='2'>"  & StaffName & "</font></td>" 
    textHTML=textHTML &  "<td><font size='2'>"  & IO & "</font></td>"
    textHTML=textHTML &  "<td><font size='2'>" & Areas & "</font></td>"     
    textHTML=textHTML &  "<td><font size='2'>" & OP & "</font></td>" 
    textHTML=textHTML & "</tr>"
	rs.movenext
	response.write textHTML & vbcrlf	
wend
rs.close
%>
</table>

<% if Burn="" and Sel="" then %>
  <p align="right">
	<input type="button" value="�T�w" name="cmdOK" title="��ܩέק�ҿ�������" style="font-size: 24pt; font-weight: bold">			 
	<input type="button" value="�R��" name="cmdDel" title="�R���ҿ�������">   
  </p>
<% end if %> 
<form name="form" method="POST" target="_self">
	<input type="hidden" value="<%=SQL%>" name="SQL">
	<input type="hidden" name="CreateDate">
	<input type="hidden" value="<%=YM%>" name="YM">
	<input type="hidden" name="DBaction">
</form>
<script language="vbscript"> 
dim SelRow : SelRow=0
Sub cmdBurn_onClick()
	window.open "List.asp?SQLsearch=" & "<%=request("SQLsearch")%>" _
		& "&YM=" & textShowMonth.value & "&Burn=Y","_blank"
End Sub

Sub Order_Click(order)
	SQL=replace("<%=SQL%>","%","$") : pos=instr(1,SQL,"order by")
	if pos>0 and "<%=Sel%>"="none" then
		if order="CreateDate" then
			window.open "List.asp?SQLsearch=y&SQL=" & mid(SQL,1,pos+8) & order & "&Sel=<%=Sel%>","_self"
		else
			window.open "List.asp?SQLsearch=y&SQL=" & mid(SQL,1,pos+8) & order & ",CreateDate&Sel=<%=Sel%>","_self"
		end if
	elseif pos>0 and "<%=burn%>"="" then		
		if order="CreateDate" then
			window.open "List.asp?SQLsearch=y&SQL=" & mid(SQL,1,pos+8) & order & "&YM=" & textShowMonth.value & "&Sel=<%=Sel%>","_self"
		else
			window.open "List.asp?SQLsearch=y&SQL=" & mid(SQL,1,pos+8) & order & ",CreateDate&YM=" & textShowMonth.value & "&Sel=<%=Sel%>","_self"
		end if	
	end if
End Sub

Sub Select_Click(CreateDate)
	tmpCreateDate=mid(CreateDate,1,2) & "/" & mid(CreateDate,3,2) & "/" & mid(CreateDate,5,2) & " "  _
		& mid(CreateDate,7,2) & ":" & mid(CreateDate,9,2) & ":" & mid(CreateDate,11,2)
	if "<%=Sel%>"="Y" then
		
		opener.open "newdevice.asp","_self"
		window.close
	elseif "<%=Sel%>"="full" then
		YN=false
		for i=1 to opener.window.frames(0).document.all.TableData.rows.length-1
			if opener.window.frames(0).document.all.TableData.rows(i).cells(0).title=CreateDate then
				YN=true
				opener.window.frames(0).document.all.TableData.rows(i).style.backgroundcolor="red"
			else
				opener.window.frames(0).document.all.TableData.rows(i).style.backgroundcolor=""
			end if
		next
		if YN=false then
			SQL="select * from Device where CreateDate='" & CreateDate & "'"
			for i=1 to opener.window.frames(0).document.all.TableData.rows.length-1
				tmp=opener.window.frames(0).document.all.TableData.rows(i).cells(0).title
				tmp=mid(tmp,1,2) & mid(tmp,4,2) & mid(tmp,7,2) & mid(tmp,10,2) & mid(tmp,13,2) & mid(tmp,16,2)
				if tmp<>CreateDate then SQL=SQL & " or CreateDate='" & tmp & "'"
			next			
			SQL=SQL & " order by CreateDate"
			opener.window.frames(0).open "newdevice/List.asp?Sel=none&SQL=" & SQL,"_self"
		end if			
		window.close
	elseif "<%=Sel%>"<>"none" then
		'
	end if
	TableData.title=CreateDate : form.CreateDate.value=CreateDate
	
	for i=1 to document.all.TableData.rows.length-1	
		if document.all.TableData.Rows(i).cells(0).title=tmpCreateDate then
			document.all.TableData.Rows(i).style.backgroundcolor="red"
			SelRow=i
		else
			document.all.TableData.Rows(i).style.backgroundcolor=""
		end if
	next
End Sub

Sub cmdOK_onClick()
	'window.open "device.asp?CreateDate=" & form.CreateDate.value & "&YM=<%=YM%>","_self"
	window.open "newdev.aspx?DevID=" & form.CreateDate.value ,"_self"
End Sub

Sub TableData_ondblClick()
	call cmdOK_onClick()
End Sub

Sub cmdDel_onClick()
	if SelRow>0 then
		if msgbox("�T�w�n�R��[" & TableData.Rows(SelRow).cells(1).innerText & "]�H",49,"�R���]�Ƹ��")=1 then
			form.DBaction.value="d"
			form.submit
		end if
	end if
End Sub
  </script>

</body>
</html>