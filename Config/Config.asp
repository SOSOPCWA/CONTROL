<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID2.inc" -->
<%
Dim connControl  : Set connControl=Server.CreateObject("ADODB.Connection")  : connControl.Open strControl
set rs=server.createobject("ADODB.recordset")

head="�t�ΰѼƳ]�w"	'���D

Which=request("which") : Kind=request("selKind")
if kind<>"" then
	Item=request("txtItem") : oldItem=request("selItem") : Content=request("txtContent")
	DBaction=request("DBaction") 'a:�s�W u:�ק� d:�R�� m:���

	select case DBaction
	case "a"	'�s�W
		connControl.execute "insert into Config values('" & kind & "','" & Item & "','" & Content & "')"			
	case "u"	'�ק�
		rs.open "select * from Config where kind='" & kind & "' and Item='" & oldItem & "'",connControl,3,3
		rs(1)=Item : rs(2)=Content
		rs.update : rs.close
	case "d"	'�R��
		connControl.execute "delete from Config where kind='" & kind & "' and Item='" & oldItem & "'"
		Item="" : Content=""
	case "m"	'���
	end select
end if
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=big5">
	<title>�t�γ]�w</title>
</head>
<body bgcolor="#DFEFFF"><br>
<p align="center"><font color="blue" size="5"><b>
<%	select case which
	case "people"
		response.write "�H���i�X�t�γ]�w"
	case "device"
		response.write "�]�Ʋ��ʨt�γ]�w"
	end select
%>
</font></b></p>
<form name="form" id="form" method="POST" target="_self"> 
<table width="300" align="center">
<tr>
	<td>���O�G</td>
	<td>
		<select size="1" name="selKind" onchange="form.txtItem.value='';form.txtContent.value='';form.DBaction.value='m';form.submit();"> 
			<option></option>
		<%	rs.open "select * from Config where kind='" & which & "' order by Content",connControl
			while not rs.eof
       			if rs(1)=Kind then
	       			response.write "<option value='" & rs(1) & "' selected>" & rs(1) & "</option>"
			   	else
			   		response.write "<option value='" & rs(1) & "'>" & rs(1) & "</option>"
	    	   	end if
	       		rs.movenext
	    	wend	
    	   	rs.close  	  	
		%>        
		</select>
	</td>
</tr>
<tr>
	<td>���ءG</td>
	<td>
		<select size="18" name="selItem" onclick="selItem_onClick(this);"> 
		    <%	rs.open "select * from Config where kind='" & Kind & "' order by Content",connControl
    			while not rs.eof	'Item(Content)�Gorder
    				if rs(2)="" then
    					if rs(1)=Item then
			   				response.write "<option value='" & rs(1) & "' selected>" & Server.HTMLEnCode(rs(1)) & "</option>"
				   		else
		   					response.write "<option value='" & rs(1) & "'>" & Server.HTMLEnCode(rs(1))  & "</option>"
	  					end if
    				else
	    				if rs(1)=Item then
			   				response.write "<option value='" & rs(1) & "' selected>" & Server.HTMLEnCode(rs(1) & "�G" & rs(2)) & "</option>"
				   		else
		   					response.write "<option value='" & rs(1) & "'>" & Server.HTMLEnCode(rs(1) & "�G" & rs(2)) & "</option>"
	  					end if
	  				end if
	    			rs.movenext
    			wend	
    			rs.close
			%>        
    	</select><br>
    </td>
</tr>
<tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;�ȡG</td>
    <td>
		<input type="text" name="txtItem" id="txtItem" value="<%=Item%>" size="30"><br><br>
	</td>
</tr>
<tr>
	<td>���e�G</td>
	<td><input type="text" name="txtContent" id="txtContent" value="<%=Content%>" size="30"><br><br></td>
</tr>
<tr>
	<td colspan="2">	
	  <p align="center">       
		  <input type="button" value="�s�W" onclick="form.DBaction.value='a';form.submit();">�@  
		  <input type="button" value="�ק�" onclick="form.DBaction.value='u';form.submit();">    �@  
		  <input type="button" value="�R��" onclick="cmdDel_onClick();"> 
	  </p>
	</td>
</tr>
</table>
<input type="hidden" name="DBaction">
</form>
<p align="center"><table>
    <tr><td><font size="2" color="green">1.����t�d�H��s���v�M�U�ɡA�ж��K��s���B�����v�W��α��v�ɶ�</font></td></tr>
    <tr><td><font size="2" color="green">2.���v�ɶ��G�ˬd���v�H���W��.xls�O�_��s���ɶ�����I</font></td></tr>
    <tr><td><font size="2" color="green">3.���v���Ť����A�ثe�u���줣�P���q�P�H�W�A���P�ҩΦP���q�P�H�W�|�L</font></td></tr>
    <tr><td><font size="2" color="green">5.���v�H�������e���A�ثe�ȨѰѦҡA�S����ڥγ~</font></td></tr>
    <tr><td><font size="2" color="green">6.�`�n�H�����C�J�ɼƲέp�A�ư��W�椣�C�J�ֳt�n�J</font></td></tr>    
    <tr><td><font size="2" color="green">7.�Y�ǯS��\�઺�ت��P���~���P�{���s�ʡA�Y���T�w�A�Х���SSM�p��</font></td></tr>
    
</table></p>
</body>
</html>
<script language="JavaScript"> 
function selItem_onClick(ee) {	//Item(Content)�Gorder
	var e=document.getElementById("form") ;
	e.elements["txtItem"].value=ee.value ;
	txt=ee.options[ee.selectedIndex].text;		
	if(txt.indexOf("�G")>0) e.elements["txtContent"].value=txt.substr(txt.indexOf("�G")+1) ;
}

function cmdDel_onClick() {	
	with(document.getElementById("form")) {
		var e=elements["selItem"]
		if(confirm("�T�w�R��[" + e.options[e.selectedIndex].text + "]?")) {
			DBaction.value="d";
			submit();
		}
	}		
}
</script>