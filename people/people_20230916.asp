<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID2.inc" -->
<!-- #include file="..\..\Lib\GetConfig.inc" -->
<% 
set conn=Server.CreateObject("adodb.connection") : conn.Open strControl
set connIDMS=Server.CreateObject("adodb.connection") : connIDMS.Open strIDMS
set rs=server.createobject("adodb.recordset")

dim UnitA : dim UserA   'GetConfig(qryDB,strOrderBy,Kind,WhichIn,Xin,OutNo,OutFormat,ByRef ConfigA)
'---------------------------------------------------------------------------------------------------------------------------------------------
'DBaction		�w��			�w��			�w��			�w��				���			���			���			
'IO				�n�J			�n�X			�ק�			�a�J				�n�J			�n�X			�ק�			
'---------------------------------------------------------------------------------------------------------------------------------------------
'�s�W																				V												
'�ק�																				V				V
'---------------------------------------------------------------------------------------------------------------------------------------------
'Ūsubmit																			V				V				V
'Ūdb							V				V				V																
'---------------------------------------------------------------------------------------------------------------------------------------------
'���D:�n�J		V												V																
'���D:�n�X						V
'���D:�ק�										V
'Ū��-----------------------------------------------------------------------------------------------------------------------------------------
Serial=request("Serial") : DBaction=request("DBaction") : IO=request("IO") 	'I:�n�J�y�{�e�� O:�n�X�y�{�e�� �ť�:���ʬy�{�e��(�w�])
if Serial<>"" and DBaction="" then	'Ūdb : ���Ǹ�(���O�w�Ƶn�J,���i��O�w�Ʊa�J)�B������,�Y�O��ܬY�����
	rs.open "select * from people where Serial=" & Serial,conn
	if not rs.eof then
		if IO="I" then	'�w�Ʊa�J
			Serial=""	'�M�ŧǸ�,�H�K��ڵn�J��,Ū�쪺�Osubmit���,�Ӥ��Odb�����		
			Company=trim(rs(1)) : Staff=trim(rs(2)) : Unit=trim(rs(3)) : Maintainer=trim(rs(4)) : Purpose=trim(rs(5)) : StuffIn=""
			USB="����J" : Process=trim(rs(8)) : StuffOut="" : Cause="" : Memo="" : Amount=1
			OPin="" : OPout="" : DateIn="" : TimeIn="" : DateOut="" : TimeOut=""	
			FloorArea=trim(rs(19)) : FloorArea2=trim(rs(20))			
			WorkArea=""
			
            if GetConfig("IDMS","",Unit,"Item",Maintainer,"","#Item#",UserA)="" then Unit="" '�w���t�d�H�ս�
            
            Purpose=replace(replace(Purpose,"�̳W�w�n�J",""),"�žɸ�w�F�����T�W�w","")	'******************************************************************************************�䥦�n�J
            OtherPurpose="�w�Ʊa�J"
            pos=instr(1,rs(5),"���H��") : if pos>0 then Purpose=Purpose & "," & mid(rs(5),pos-1,4)	'******************************************�䥦�n�J
		else	'ŪDB���
			Company=trim(rs(1)) : Staff=trim(rs(2)) : Unit=trim(rs(3)) : Maintainer=trim(rs(4)) : Purpose=trim(rs(5)) : StuffIn=trim(rs(6))
			USB=trim(rs(7)) : Process=trim(rs(8)) : StuffOut=trim(rs(9)) : Cause=trim(rs(10)) : Memo=trim(rs(11)) : Amount=trim(rs(12))
			OPin=trim(rs(13)) : OPout=trim(rs(14)) : DateIn=trim(rs(15))	: TimeIn=trim(rs(16)) : DateOut=trim(rs(17)) : TimeOut=trim(rs(18))	
			FloorArea=trim(rs(19)) : FloorArea2=trim(rs(20))			
			WorkArea=trim(rs(21))
			
		end if
	end if
	rs.close
else	'Ū��submit�L�Ӫ����
	Company=request("selCompany") : ComKind=request("selComKind") : if ComKind="Self" then Company=trim(request("txtCompany"))
	Staff=request("selStaff") : if Staff="Self" then Staff=trim(request("txtStaff"))
	Unit=request("selUnit") : Maintainer=request("selMaintainer")
		
	if request("chkPurpose")="" then
		Purpose=trim(request("txtPurpose"))
	else
		if trim(request("txtPurpose"))="" then
			Purpose=replace(request("chkPurpose")," ,","",1,-1,1)
		else			
			Purpose=replace(request("chkPurpose")," ,","",1,-1,1) & "," & trim(request("txtPurpose"))
		end if
	end if
	
	if request("chkStuffIn")="" then
		StuffIn=trim(request("txtStuffIn"))
	else
		if trim(request("txtStuffIn"))="" then
			StuffIn=replace(request("chkStuffIn")," ,","",1,-1,1)
		else			
			StuffIn=replace(request("chkStuffIn")," ,","",1,-1,1) & "," & trim(request("txtStuffIn"))
		end if
	end if
	
	if request("chkStuffOut")="" then
		StuffOut=trim(request("txtStuffOut"))
	else
		if trim(request("txtStuffOut"))="" then
			StuffOut=replace(request("chkStuffOut")," ,","",1,-1,1)
		else			
			StuffOut=replace(request("chkStuffOut")," ,","",1,-1,1) & "," & trim(request("txtStuffOut"))
		end if
	end if

	FloorArea2=replace(request("chkFloorArea2")," ,","",1,-1,1)
	
	USB=request("selUSB") : Process=request("txtProcess") : Cause=request("txtCause") : Memo=request("txtMemo") : Amount=request("selAmount")
	OPin=request("selOPin") : OPout=request("selOPout")
	DateIn=request("txtDateIn") : TimeIn=request("txtTimeIn") : DateOut=request("txtDateOut") : TimeOut=request("txtTimeOut")	
	'FloorArea=request("selFloorArea")	
	FloorArea=""	
	WorkArea=request("txtWorkArea")
	
end if
'�w�]��(Ū����ƫ�A���w�]��)-----------------------------------------------------------------------------------------------------------------
if Amount=""  then Amount="0"
if DateIn=""  then DateIn=DT(now,"yyyy/mm/dd")
if TimeIn=""  then TimeIn=DT(now,"hh:mi:ss")
if DateOut="" and IO="O" then DateOut=DT(now,"yyyy/mm/dd")
if TimeOut="" and IO="O" then TimeOut=DT(now,"hh:mi:ss")
'����-----------------------------------------------------------------------------------------------------------------------------------------
if DBaction="a" or DBaction="u" then 
		ABC="C"
		
		rs.open "select * from config where Kind='�ƭȸ�T��' and Item='" & Company & "'",connIDMS
		if not rs.eof then ABC="A"
		rs.close
		
		rs.open "select Item from Config where Kind like '���v�W��%' and Item like '%" & Company & "-" & Staff & "%'",conn
		if not rs.eof then 
			ABC=mid(rs(0),len(rs(0)))			
		end if
		rs.close
				
        AbcMsg=""
		if ABC="A" and (instr(1,Purpose,"A���H��")=0 or instr(1,Purpose,"B���H��")<>0 or instr(1,Purpose,"C���H��")<>0) _ 
			or ABC="B" and (instr(1,Purpose,"B���H��")=0 or instr(1,Purpose,"A���H��")<>0 or instr(1,Purpose,"C���H��")<>0) _ 
			or ABC="C" and (instr(1,Purpose,"C���H��")=0 or instr(1,Purpose,"A���H��")<>0 or instr(1,Purpose,"B���H��")<>0) then
			AbcMsg=Company & "-" & Staff & "-" & ABC & "�A���ˬd�z�����v�覡�O�_�]�w���~!"	
		end if

		if AbcMsg="" then
				select case DBaction
				case "a"	'�s�W
			    	Serial=1
				    rs.open "select max(Serial) from people",conn	
			    	if not rs.eof then Serial=rs(0)+1
				    rs.close

					conn.execute "insert into people values(" & Serial & ",'" & Company & "','" & Staff & "','" & Unit & "','" & Maintainer & "','" & Purpose & "','" _
						& StuffIn & "','" & USB & "','" & Process & "','','" & Cause & "','" & Memo & "'," & Amount & ",'" _
						& OPin & "','','" & DateIn & "','" & TimeIn & "','','','" & FloorArea & "','" & FloorArea2 & "','" & WorkArea & "')" 
						
					'�`�NStuffOut='' OPout='' DateOut='' TimeOut=''	
				case "u"	'�ק�
					rs.open "select * from people where Serial=" & Serial,conn,3,3
						rs(1)=Company : rs(2)=Staff : rs(3)=Unit : rs(4)=Maintainer : rs(5)=Purpose : rs(6)=StuffIn : rs(7)=USB : rs(8)=Process : rs(9)=StuffOut
						rs(10)=Cause : rs(11)=Memo : rs(12)=Amount : rs(13)=OPin : rs(14)=OPout : rs(15)=DateIn : rs(16)=TimeIn : rs(17)=DateOut : rs(18)=TimeOut						
						'rs(19)=FloorArea : 
						rs(20)=FloorArea2								
						rs(21)=WorkArea						
					rs.update
					rs.close	
				end select
        else
            response.write "<script language=""javascript"">" & vbcrlf
			response.write "	alert(""" & AbcMsg & """);" & vbcrlf	
			response.write "</script>" & vbcrlf
		end if		
end if
'�`������-----------------------------------------------------------------------------------------------------------------------------------------
if DBaction<>"" then
	phonetxt=mid(Company,1,1)
	rs.open "select * from phonehead where txt='" & phonetxt & "'",conn	'�d�`���������S��
	if rs.eof then
		rs.close
		rs.open "select * from phonetab where txt like '%" & phonetxt & "%'",conn	'�q�`���r���X�`��
		while not rs.eof
			on error resume next	'�קK���ƦӥX��
			conn.execute "insert into phonehead values('" & mid(rs(0),1,1) & "','" & phonetxt & "')"	'�s�W�ܪ`��������
			on error goto 0
			rs.movenext
		wend
	end if
	rs.close
end if
'���ʳ]�ƴ���-----------------------------------------------------------------------------------------------------------------------------------------
if DBaction<>"" and AbcMsg="" then 
'	if instr(1,Purpose,"���ʳ]��")>0 then
'			response.write "<script language=""vbscript"">" & vbcrlf
'			response.write "Sub window_onload()" & vbcrlf
'			response.write "	msgbox ""1. �аO�o�V�t�d�H�߰ݳ]�ƽs���β��J��A�ðO�����I"" & vbcrlf & ""2. �]�ƶi�X���Щβ��ʦ�m�A�Ч��IDMS��m�a�I�A�Ԩ����e�����i�`�N�ƶ��j�C"",48" & vbcrlf			
'			response.write "    window.open ""today.asp?date=" & DateIn & """,""_self""" & vbcrlf
'			response.write "End Sub" & vbcrlf
'			response.write "</script>" & vbcrlf			
'	else
		response.redirect "today.asp?date=" & DateIn '���ʫ�,�e����ܤ���������ʵe��'
'	end if
end if
'�q������-----------------------------------------------------------------------------------------------------------------------------------------

'���D-----------------------------------------------------------------------------------------------------------------------------------------
select case IO	'�]DBaction���G,���i����e��
case "I"
	cmdSend="�n�J" : DBaction="a"
case "O"
	cmdSend="�n�X" : DBaction="u"
case ""
	cmdSend="��s" : DBaction="u"
end select
'���-----------------------------------------------------------------------------------------------------------------------------------------
Function DT(byval sDT,byval fDT) 'if..then..�ᤣ�i�A�[ : ,���i�h��ԭz
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
	<title>�H���i�X�n�O</title>
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
<table width="100%"><tr><td align="center"><span class="title">�H���i�X����<%=cmdSend%></span></td></tr></table>
<table border="1" align="center" cellpadding="1" cellspacing="1" bordercolor="#B0C4DE">
<form name="form" id="form" method="post">
<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<tr>
		<td align="left" valign="middle"><div align="center" class="item">�t�d���</div></td>
		<td align="left" valign="middle">
			<select name="selUnit" id="selUnit" size="1" class="option" language="javascript" onchange="Option_HTML('selMaintainer',this.value,'');">
				<option></option>
            <%  OutFormat="<option value=""#Item#"" #Sel#>#Item#</option>"
                response.write GetConfig("IDMS","order by mark","�ƭȸ�T��","Item",Unit,"*",OutFormat,UnitA) 
            %>
			</select>
		</td>
		<td align="left" valign="middle"><div align="center" class="item">�t�d�H</div></td>
		<td align="left" valign="middle">
			<select name="selMaintainer" id="selMaintainer" size="1" class="option" onchange="selComKind.options(0).selected=1;">
                <option></option>
			<%	if Unit="" then
					response.write "<option></option>"
				else
                    dim MaintainerA : OutFormat="<option value=""#Item#"" #Sel#>#Item#</option>"
                    response.write GetConfig("IDMS","order by mark",Unit,"Item",Maintainer,"*",OutFormat,MaintainerA) 
                end if
			%>
			</select>
		</td>
		<td align="left" valign="middle"><div align="center" class="item">�ȯZ<span class="style1">(�J)</span> </div></td>
		<td align="left" valign="middle">
			<select name="selOPin" size="1" class="option">
				<option value=""></option>
			<%	dim opA : OutFormat="<option value=""#Item#"" #Sel#>#Item#</option>"
                response.write GetConfig("IDMS","order by mark","�@�~�޲z��","Item",OPin,"*",OutFormat,opA)
			%>  
			</select>
		</td>
		<td><div align="center" class="item">�i�J�ɶ�</div></td>
		<td>
			<input name="txtDateIn" type="text"  value="<%=DateIn%>" size="8">
			<input name="txtTimeIn" type="text"  value="<%=TimeIn%>" size="6">
		</td>
	</tr>
	<tr>
		<td align="left" valign="middle"><div align="center" class="item">�ӽг��</div></td>
		<td align="left" valign="middle">
			<select name="selComKind" id="selComKind" size="1" class="option" onChange="Option_HTML('selCompany',this.value,selMaintainer.value);">
				<option value="All">(����)</option>
				<option value="Self">(�۶�)</option>				
				<option value="Link">(���p)</option>
				<option value="No">(����)</option>			
				<option value="Else">(���k��)</option>
				<option value="A-Z">���(A-Z)</option>
				<option value="�t">���(�t)</option>
				<option value="�u">���(�u)</option>
				<option value="�v">���(�v)</option>
				<option value="�w">���(�w)</option>
				<option value="�x">���(�x)</option>
				<option value="�y">���(�y)</option>
				<option value="�z">���(�z)</option>
				<option value="�{">���(�{)</option>
				<option value="�|">���(�|)</option>
				<option value="�}">���(�})</option>
				<option value="�~">���(�~)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>
				<option value="��">���(��)</option>				
			</select>
			<select name="selCompany" id="selCompany" size="1" class="option" onchange="Option_HTML('selStaff',this.value,'');">                
				<option value=""></option>
			<%	rs.open "select distinct �ӽг�� from people where �i�J���>='" & DT(now-365*3,"yyyy/mm/dd") & "' order by �ӽг��",conn
				selected=""			
				while not rs.eof
					if trim(rs(0))=Company then
						selected="Y"
						response.write "<option value=""" & trim(rs(0)) & """ selected>" & trim(rs(0)) & "</option>" & vbcrlf
					else
						response.write "<option value=""" & trim(rs(0)) & """>" & trim(rs(0)) & "</option>" & vbcrlf
					end if					
					rs.movenext
				wend
				rs.close
				if Company<>"" and selected="" then response.write "<option value=""" & Company & """ selected>" & Company & "</option>" & vbcrlf
			%>
			</select>
			<input name="txtCompany" type="text" class="write" size="6" style="display:none" value="<%=Company%>">                
		</td>
		<td align="left" valign="middle"><div align="center" class="item">�ӽФH</div></td>
		<td align="left" valign="middle">
			<select name="selStaff" size="1" class="option" onChange="Staff_KeyIn(this.value);">
			<%	rs.open "select distinct �ӽФH from people where �ӽг��='" & Company & "' and �i�J���>='" & DT(now-365*3,"yyyy/mm/dd") & "' order by �ӽФH",conn				                
				selected=""
				while not rs.eof
					if trim(rs(0))=Staff then
						selected="Y"
						response.write "<option value=""" & trim(rs(0)) & """ selected>" & trim(rs(0)) & "</option>" & vbcrlf
					else
						response.write "<option value=""" & trim(rs(0)) & """>" & trim(rs(0)) & "</option>" & vbcrlf
					end if					
					rs.movenext
				wend
				rs.close
				if Staff<>"" and selected="" then response.write "<option value=""" & Staff & """ selected>" & Staff & "</option>" & vbcrlf
			%>	<option value="Self">(�۶�)</option>
			</select>
			<input name="txtStaff" type="text" size="6" style="display:none" value="<%=Staff%>">                
		</td>
		<td height="28" class="item"><div align="center">�H��</div></td>
		<td>
			<select name="selAmount" size="1" class="option">
			<%	for i=1 to 30
					if cstr(i)=Amount then
						response.write "<option value=""" & i & """ selected>" & i & "</option>"
					else
						response.write "<option value=""" & i & """>" & i & "</option>"
					end if
				next
			%>
			</select>
		</td>
		<td class="item"><div align="center"><font color="blue">
			<u style="cursor:pointer" onClick="alert('�Y�~�����[����,�ӽФH�񧽤���f�H��,�t�d�H�񤤤߹�f�H���νҪ�,�Ӫ����h��~���ⶤ�m�W !');">��������</u>
		</font></div></td>
		<td><input name="txtMemo" type="text"  size="16" value="<%=Memo%>" /></td>
	</tr>
<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<tr>
		<td align="left" valign="middle"><div align="center" class="item">�Ӽh/����</div></td> 
		<td colspan="7" align="left" valign="middle">
			<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			
			<%	if FloorArea2<>"" then
					FloorArea2A=split(FloorArea2,",")
				end if
				
				rs.open "select * from Config where kind='�Ӽh/����' order by Content",conn 
				while not rs.eof
					if FloorArea2Content="" then 
						response.write "<tr>"					
					elseif FloorArea2Content<>mid(rs("Content"),1,1) then
						response.write "</tr>"
						response.write "<tr>"
					end if
					
					FloorArea2Content=mid(rs("Content"),1,1)
					checked=""
					
					if FloorArea2<>"" then
						for i=0 to UBound(FloorArea2A)
							if trim(FloorArea2A(i))=rs("item") then
								checked="checked"
								FloorArea2A(i)=""
							end if
						next
					end if
					tmp=rs("item")
					
			%>		<td><span class="option"><input type="checkbox" name="chkFloorArea2" value="<%=rs("item")%>" <%=checked%>><%=tmp%>
					</span></td>
			<%		rs.movenext
				wend
				rs.close
			%>
				</tr>
			</table>
		</td>
	</tr>	
<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->
    <tr>
      <td><div align="center" class="item">�I�u�ϰ�/���d</div></td>
      <td colspan="7"><textarea name="txtWorkArea" id="txtWorkArea" cols="97" rows="1" class="intxt" value="<%=WorkArea%>"><%=WorkArea%></textarea></td>      
    </tr>	
<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<tr style="display:<% if IO="O" then response.write "none" %>">
		<td align="left" valign="middle"><div align="center" class="item">�ت��εn�J���p</div></td> 
		<td colspan="7" align="left" valign="middle">
			<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<%	PurposeA=split(Purpose,",")
				rs.open "select * from Config where kind='�ت�' order by Content",conn 
				while not rs.eof
					if PurposeContent="" then 
						response.write "<tr>"					
					elseif PurposeContent<>mid(rs("Content"),1,1) then
						response.write "</tr>"
						response.write "<tr>"
					end if
					
					PurposeContent=mid(rs("Content"),1,1)
					checked=""
					for i=0 to UBound(PurposeA)
						if trim(PurposeA(i))=rs("item") then
							checked="checked"
							PurposeA(i)=""
						end if
					next
					tmp=rs("item")
					if len(rs("Content"))>4 then	tmp=tmp & mid(rs("Content"),5)
					
					if instr(1,rs("Item"),"���H��")>0 then 	'*******************************************************************************�䥦�n�J
						select case mid(rs("Item"),1,1)
						case "A" : response.write "<td><span class=""option"" title=""�����q���A���ݳ��P"">"
						case "B" : response.write "<td><span class=""option"" title=""�ݭn�q���A���ݳ��P"">"
						case "C" : response.write "<td><span class=""option"" title=""�ݭn�q���A�ݭn���P"">"
						end select
						response.write "<hr>"
					else
						response.write "<td><span class=""option"">"
					end if									'*******************************************************************************�䥦�n�J	
			%>			<input type="checkbox" name="chkPurpose" value="<%=rs("item")%>" <%=checked%>><%=tmp%>
					</span></td>
			<%		rs.movenext
				wend
				rs.close
				
				if OtherPurpose="�w�Ʊa�J" then	'*******************************************************************�䥦�n�J
					otherPurpose=""
				else
					for i=0 to UBound(PurposeA)
						if PurposeA(i)<>"" then otherPurpose=otherPurpose & trim(PurposeA(i)) & ","
					next
					if otherPurpose<>"" then otherPurpose=mid(otherPurpose,1,len(otherPurpose)-1)
				end if
			%>		<td><span class="option">
						<font color="red">�n�J����</font>�G<input name="txtPurpose" type="text" id="txtPurpose" value="<%=otherPurpose%>" size="30">
					</span></td>
				</tr>
			</table>
		</td>
	</tr>
<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<tr style="display:<% if IO="O" then response.write "none" %>">
		<td align="left" valign="middle"><div align="center" class="item">��J���~</div></td>
		<td colspan="7" align="left" valign="middle">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td><span class="option">
			<%	StuffInA=split(StuffIn,",")
				rs.open "select * from Config where kind='���~' order by Content",conn 
				while not rs.eof
					if StuffContent="" then
						response.write mid(rs("Content"),5)	& "�G"
					elseif StuffContent<>mid(rs("Content"),5) then
						response.write "</span></td></tr>"
						response.write "<tr><td><span class=""option"">"
						if mid(rs("Content"),5)="��ʸ˸m" then
							response.write mid(rs("Content"),5) & "<font color=""green"">(�Х����o�t�d�H�P�N)</font>�G"					
						else
							response.write mid(rs("Content"),5) & "�G"
						end if
					end if
					StuffContent=mid(rs("Content"),5)
			%>		<input type="checkbox" name="chkStuffIn" value="<%=rs("item")%>"
			<%		for i=0 to UBound(StuffInA)
						if trim(StuffInA(i))=rs("item") then
							response.write " checked"
							StuffInA(i)=""
						end if
					next
			%>		>
			<%		if rs("item")="�{�ɥd" then
						response.write rs("item") & " <font color=""green"">(�Щ�B�z�L�{���� => �{�ɥd��:### )" _
							& "�@<u style=""cursor:pointer"" onclick=""txtProcess.value=txtProcess.value + ' �{�ɥd��:'"";>�ɤJ</u></font>" & "&nbsp;&nbsp;&nbsp;&nbsp;"
                    else	
						response.write rs("item") & "&nbsp;&nbsp;&nbsp;&nbsp;"
					end if
					rs.movenext
				wend
				rs.close
				for i=0 to UBound(StuffInA)
					if StuffInA(i)<>"" then otherStuffIn=otherStuffIn & trim(StuffInA(i)) & ","
				next
				if otherStuffIn<>"" then otherStuffIn=mid(otherStuffIn,1,len(otherStuffIn)-1)
			%>	</span></td></tr>
				<tr><td>
					<span class="option">�䥦�G&nbsp;&nbsp;<input name="txtStuffIn" type="text" value="<%=otherStuffIn%>" size="20"></span>&nbsp;&nbsp;
					<font color="red">�H���СG</font>
					<select name="selUSB" size="1" class="option">
						<option></option>
					<%	rs.open "select Item from Config where Kind='�H����' order by Content",conn
						selected=""
						while not rs.eof
							if trim(rs(0))=USB then
								selected="Y"
								response.write "<option value=""" & trim(rs(0)) & """ selected>" & trim(rs(0)) & "</option>" & vbcrlf
							else
								response.write "<option value=""" & trim(rs(0)) & """>" & trim(rs(0)) & "</option>" & vbcrlf
							end if					
							rs.movenext
						wend
						rs.close
						if USB<>"" and selected="" then response.write "<option value=""" & USB & """ selected>" & USB & "</option>" & vbcrlf
					%>            
					</select>
				</td></tr>
			</table>
		</td>
    </tr>
<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->
    <tr>
      <td><div align="center" class="item">�B�z�L�{</div></td>
      <td colspan="7"><textarea name="txtProcess" id="txtProcess" cols="100" rows="2" class="intxt" value="<%=Process%>"><%=Process%></textarea></td>      
    </tr>
<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<tr style="display:<% if IO="I" then response.write "none" %>">
		<td align="left" valign="middle"><div align="center" class="item">��X���~</div></td>
		<td colspan="7" align="left" valign="middle">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td><span class="option">
			<%	StuffOutA=split(StuffOut,",")
				rs.open "select * from Config where kind='���~' order by Content",conn 
				while not rs.eof
					if StuffContent="" then
						response.write mid(rs("Content"),5)	& "�G"
					elseif StuffContent<>mid(rs("Content"),5) then
						response.write "</span></td></tr>"
						response.write "<tr><td><span class=""option"">"
						response.write mid(rs("Content"),5) & "�G"					
					end if
					StuffContent=mid(rs("Content"),5)
			%>
					<input type="checkbox" name="chkStuffOut" value="<%=rs("item")%>"
			<%		for i=0 to UBound(StuffOutA)
						if trim(StuffOutA(i))=rs("item") then
							response.write " checked"
							StuffOutA(i)=""
						end if
					next
			%>		><%=rs("item")%>&nbsp;				
			<%		rs.movenext
				wend
				rs.close
				for i=0 to UBound(StuffOutA)
					if StuffOutA(i)<>"" then otherStuffOut=otherStuffOut & trim(StuffOutA(i)) & ","
				next
				if otherStuffOut<>"" then otherStuffOut=mid(otherStuffOut,1,len(otherStuffOut)-1)
			%>	</span></td></tr>
				<tr><td>
					<span class="option">�䥦�G&nbsp;&nbsp;<input name="txtStuffOut" type="text" value="<%=otherStuffOut%>" size="20"></span>
				</td></tr>
			</table>
		</td>
    </tr>
<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<tr style="display:<% if IO="I" then response.write "none" %>">    
		<td><span class="item">��X��]</span></td>
		<td colspan="3"><input name="txtCause" type="text" value="<%=Cause%>" size="20"></td>
		<td><div align="center"><span class="item">�ȯZ�H��<span class="style1">(�X)</span></span></div></td>
		<td>
	  		<select name="selOPout" size="1" class="option">
				<option value=""></option>
			<%	OutFormat="<option value=""#Item#"" #Sel#>#Item#</option>"
                response.write GetConfig("IDMS","order by mark","�@�~�޲z��","Item",OPout,"*",OutFormat,opA)
			%>  
			</select>  
		<td><div align="center"><span class="item">���}�ɶ�</span></div></td>
		<td>
			<input name="txtDateOut" type="text"  value="<%=DateOut%>" size="10">
			<input name="txtTimeOut" type="text"  value="<%=TimeOut%>" size="8">
		</td>
	</tr>
<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<input name="DBaction" type="hidden" value="<%=DBaction%>">
	<input name="Serial" type="hidden" value="<%=Serial%>">	
		
</form></table>
<table width="100%"><tr>
	<td width="40%"></td>
	<td width="60%">
		<input name="cmdSend" type="button" class="butn" value="<%=cmdSend%>" onclick="CmdSend_Click();">
	</td>	
</td></tr></table>
<p align="center"><table><tr><td>
�i<a target="_blank" href="../���Ъ��T�ި���Ȫ`�N�ƶ�.doc">�`�N�ƶ�</a>�j�G<br>
<font color="red">
  �� �����t�Ӧ�B1���@�� , �з�Z�P�� �ȥ����������ΤW��<br>
  �� ��w�W�w�A��OP�ѱ��v�M�U�T�{�ӽФH�O�_�ݭt�d�H���P�i�J<br>
  �� �Y���u�w����סv�B�u�n���s�v�Ρu�ե�w�ˡv��, �ХD�ʴ����θ߰ݡu����̡v, �O�_�ݭn"�i��"�i����v�T����H�ΤU��~���<br>
  �� �]�ƶi�X���СA�аO�o�V�t�d�H�߰ݳ]�ƽs���β��J��A�ðO�����I<br>
  �� �]�ƶi�X���Щβ��ʦ�m�A�Ш�귽�޲z�l�t�ΡA����m�a�I���A�߰ݭt�d�H�Y���a�I�N��蠟�A�Y�����ж�g(���N�a�I)(���w�ϰ�)�A���I�O���w���b���Ф��A��m�a�I�����g���Ф��������m�C<br>
  �� <a target="_blank" href="../�D�����ܪ��T�ި�.doc">�D������...</a>
</font>
<br><br>
�i�q�������j�G<br>
A���H���G�ƭȸ�T�դH���αM�סB�n�I�t�ӵ��̱��v�M�U�ҦC�i���ݳq���B���ݳ��P���U�ұ��v�H���C<br>
B���H���G�̱��v�M�U�ҦC�t�d�H�ݳq�����o�����P���U�ұ��v�H���C<br>
C���H���G���C����v�M�U�W���W�A�t�d�H�ݳq���B�ݳ��P���H���C(���v�M�U�ҦC�ݳq���B�ݳ��P���H����M)<br><br>

�i�q�����P�`�N�ƶ��j�G<br>
1. �Y�t�d�H�]�G�L�ƥ��q���εL�k�pô�A�hOP�i�D�ʳq���t�d�H�Ψ�N�z�H���v�d�Ҫ��C<br>
2. �Y�t�d�H�L�k���P�A�t�d�H�i�Ш�N�z�H���v�d�Ҫ����P�C<br>
3. �Y�L�k����W�z��1�β�2�I�AOP�ݬd�֨䨭���ҩ���Ѿާ@�Ҫ��P�N�l�i�i�J�A���ݤĿ�䥦�n�J�ﶵ�A�O���n�J�����A�æC�J�έp�C<br>
4. B�BC���H���D�W�Z�ɶ��i�J���лݨƥ��ѭt�d�H�q���AOP�d��䨭���P�t�d�H�ҳq���̬ۦP�l�i�i�J�C<br>
5. �D�W�Z�ɶ������P�o��OP�N�z�A���ȥH���Ф����]�Ƭ����C
</td></tr></table></p>
<br><br><br><br><!----�����ù��̫���ܤ���------>

<script language="JavaScript">
<!-- #include file="..\Lib\Ajax.inc" -->
function trim(str) { return str.replace(/(^\s*)|(\s*$)/g,""); }
var e=document.getElementById("form");

if("<%=IO%>"=="O") window.open("outwarning.asp","_blank","width=220,height=340,resizable=0,scrollbars=no");	//�n�X����

//Kind	: onchange�������
//which	: onchange��ﶵ�n�������ܪ�����
//other	: ��L�Ѽ�(�ھک����p���t�d�H�Ӳ��Ϳﶵ)
//------------------------------------------------

function Option_HTML(which,Kind,other) { //�ﶵ�ܤ�
	var str ;
	
	if (window.ActiveXObject) {  // IE
		//http_request.setRequestHeader("Content-Type","application/x-www-form-urlencoded") ;	
		http_request.open("POST","Lib/OptionHTML_outer.asp?which=" + which + "&Kind=" + Kind + "&other=" + other,false) ;		
		http_request.send("") ;	
		str=http_request.responseText ;				
		e.elements[which].outerHTML=str ;
	} else { // Edge, Chrome, ...
		//http_request.setRequestHeader("Content-Type","application/x-www-form-urlencoded") ;	
		http_request.open("POST","Lib/OptionHTML_inner.asp?which=" + which + "&Kind=" + Kind + "&other=" + other,false) ;		
		http_request.send("") ;	
		str=http_request.responseText ;				
		e.elements[which].innerHTML=str ;
	}

	if(which=="selCompany") Company_KeyIn(Kind);	//�ӽг��ۦ��J
	if(which=="selStaff") Staff_KeyIn(Kind);	
}

function Company_KeyIn(Kind) {	//�ӽг��ۦ��J
	if(Kind=="Self") {
		e.elements["selCompany"].style.display="none" ;
		e.elements["txtCompany"].style.display="" ;
		e.elements["txtCompany"].focus() ;
		e.elements["selStaff"].style.display="none" ;
		e.elements["txtStaff"].style.display="" ;	
	} else {
		e.elements["selCompany"].style.display="" ;
		e.elements["txtCompany"].style.display="none" ;	
		e.elements["selStaff"].style.display="" ;
		e.elements["txtStaff"].style.display="none" ;	
	}	
}

function Staff_KeyIn(Kind) {	//�ӽФH�ۦ��J
	if(Kind=="Self") {
		e.elements["selStaff"].style.display="none" ;
		e.elements["txtStaff"].style.display="" ;
		e.elements["txtStaff"].focus() ;
	} else {
		e.elements["selStaff"].style.display="" ;
		e.elements["txtStaff"].style.display="none" ;	
	}
}

function CmdSend_Click() {	//Submit�e��J�ˬd
if("<%=IO%>" != "O") {	//�n�J�έק�
	//��ʸ˸m(�ݩ�̫e���P�_)--------------------------------------------------------------------
	for(i=0;i < e.elements["chkStuffIn"].length;i++) {
		if(e.elements["chkStuffIn"][i].checked) {
			if(e.elements["chkStuffIn"][i].value=="���O���q��" || e.elements["chkStuffIn"][i].value=="�����q��" || e.elements["chkStuffIn"][i].value=="���z�����" || e.elements["chkStuffIn"][i].value=="��ʹq��") {
				alert("��J��ʸ˸m�e�Х����o�t�d�H�P�N !");
				break;
			}    
		}
	}
	 //--------------------------------------------------------------------------------------
	if(e.elements["selUnit"].value=="") {
		alert("�п�J�t�d��� !");
		return("");
	} //--------------------------------------------------------------------------------------
	if(e.elements["selMaintainer"].value=="") {
		alert("�п�J�t�d�H !");
		return("");
	} //--------------------------------------------------------------------------------------
	if(e.elements["selCompany"].value=="" && e.elements["selComKind"].value=="Self" && trim(e.elements["txtCompany"].value)=="") {
		alert("�п�J�ӽг�� !");
		return("");
	} 
	if(e.elements["selComKind"].value=="Self" && trim(e.elements["txtCompany"].value)=="") {
		alert("�п�J�ӽг�� !");
		return("");
	} //--------------------------------------------------------------------------------------
	if(e.elements["selStaff"].value=="" && trim(e.elements["txtStaff"].value)=="") {
		alert("�п�J�ӽФH !");
		return("");
	}
	if(e.elements["selStaff"].value=="Self" && trim(e.elements["txtStaff"].value)=="") {
		alert("�п�J�ӽФH !");
		return("");
	} //--------------------------------------------------------------------------------------	
	//if(e.elements["selAmount"].value==2 && e.elements["txtMemo"].value=="") {
	//	alert("�Y�ӽФH�Ƭ�2�H,�����ݵ����H��H���m�W !");
	//	return("");
	//} //--------------------------------------------------------------------------------------
	if(e.elements["selOPin"].value=="") {
		alert("�п�J�ȯZ�H��(�J) !");
		return("");
	} //--------------------------------------------------------------------------------------
	if(trim(e.elements["txtDateIn"].value)=="") {
		alert("�п�J�n�J��� !");
		return("");
	}
	if(e.elements["txtDateIn"].value.length != 10) {
		alert("�n�J����榡�����T !");
		return("");
	} //--------------------------------------------------------------------------------------
	if(trim(e.elements["txtTimeIn"].value)=="") {
		alert("�п�J�n�J�ɶ� !");
		return("");
	}
	if(e.elements["txtTimeIn"].value.length != 8) {
		alert("�n�J�ɶ��榡�����T !");
		return("");
	} //--------------------------------------------------------------------------------------
	var chkYN="n"; var tmpPurpose="" ;var chkSecPolicy="n";
	for(i=0;i < e.elements["chkPurpose"].length;i++) {
        //if (e.elements["chkPurpose"][i].value.indexOf("�žɸ�w�F�����T�W�w")!=-1){
        //    if(e.elements["chkPurpose"][i].checked)chkSecPolicy="y";
        //     continue;
        //}
		if(e.elements["chkPurpose"][i].checked) {
			tmpPurpose=tmpPurpose + e.elements["chkPurpose"][i].value + "," ;
            if(e.elements["chkPurpose"][i].value.indexOf("�žɸ�w�F�����T�W�w")!=-1){   
                chkSecPolicy="y";
                continue;
            }
            if(e.elements["chkPurpose"][i].value.indexOf("���H��")!=-1 || e.elements["chkPurpose"][i].value.indexOf("�n�J")!=-1)continue;
            chkYN="y";
			
		}
	}
	
	if(chkYN=="n") {
		alert("�п�ܩο�J�ت� !");
		return("");
	}
    
    if(chkSecPolicy == "n") {
		alert("�Ыžɸ�w�F�����T�W�w !");
		return("");
	}

	if(tmpPurpose.indexOf("���H��") == -1) {
		alert("�ФĿ�n�J�H�����q�������O�ݩ�ABC���@���H�� !");
		return("");
	} 
	
	if(tmpPurpose.indexOf("�n�J") == -1) {
		alert("�ФĿ�n�J�����檬�p�O�_�̳W�w !");
		return("");
	}
		
	if(tmpPurpose.indexOf("�䥦�n�J") > -1 & trim(e.elements["txtPurpose"].value)=="") {	//*********************************************�䥦�n�J
		alert("�ж�n�J����(�ҡG�p����������v�d�H���A�g�ާ@�Ҫ��P�N��n�J) !");
		return("");
	} //�ɥ�--------------------------------------------------------------------------------------
		
    for(i=0;i < e.elements["chkStuffIn"].length;i++) {
		if(e.elements["chkStuffIn"][i].checked) {
			if(e.elements["chkStuffIn"][i].value=="�{�ɥd" && e.elements["txtProcess"].value.indexOf("�{�ɥd��:") == -1 ) {
		        alert("�Щ�B�z�L�{�����{�ɥd�� ! �榡�p�U�G\n�{�ɥd��:###");
		        return("");
	        }
		}
	} //�H����--------------------------------------------------------------------------------------
	if(e.elements["selUSB"].value=="") {
		alert("�и߰ݬO�_��J�H���СA�T�ꥼ�ϥνп�ܥ���J !");
		return("");
	} 
} else { //�n�X----------------------------------------------------------------------------------------------------------------------------------------
	if(e.elements["selOPout"].value=="") {
		alert("�п�J�ȯZ�H��(�X) !");
		return("");
	} //--------------------------------------------------------------------------------------
	if(trim(e.elements["txtDateOut"].value)=="") {
		alert("�п�J�n�X��� !");
		return("");
	}
	if(e.elements["txtDateOut"].value.length != 10) {
		alert("�n�X����榡�����T !");
		return("");
	} //--------------------------------------------------------------------------------------
	if(trim(e.elements["txtTimeOut"].value)=="") {
		alert("�п�J�n�X�ɶ� !");
		return("");
	}
	if(e.elements["txtTimeOut"].value.length != 8) {
		alert("�n�X�ɶ��榡�����T !");
		return("");
	} //--------------------------------------------------------------------------------------
	if(e.elements["txtDateIn"].value>e.elements["txtDateOut"].value) {
		alert("��J�n�J����j��n�X��� !");
		return("");
	}
	if(e.elements["txtDateIn"].value==e.elements["txtDateOut"].value && e.elements["txtTimeIn"].value>e.elements["txtTimeOut"].value) {
		alert("��J�n�J�ɶ��j��n�X�ɶ� !");
		return("");
	} //�ɥ�--------------------------------------------------------------------------------------
    for(i=0;i < e.elements["chkStuffIn"].length;i++) {
		if(e.elements["chkStuffIn"][i].checked) {
			if(e.elements["chkStuffIn"][i].value=="�{�ɥd" && e.elements["txtProcess"].value.indexOf("�{�ɥd��:") == -1 ) {
		        alert("�Щ�B�z�L�{�����{�ɥd�� ! �榡�p�U�G\n�{�ɥd��:###");
		        return("");
	        }
            if(e.elements["chkStuffIn"][i].value == "�{�ɥd") {
		        if(! confirm("�нT�{�{�ɥd�O�_�w�g�k�� !")) return("");
	        }
	        if(e.elements["chkStuffIn"][i].value == "�_��") {
		        if(! confirm("�нT�{�_�ͬO�_�w�g�k�� !")) return("");
	        }
	        if(e.elements["chkStuffIn"][i].value == "������") {
		        if(! confirm("�нT�{�������O�_�w�g�k�� !")) return("");
	        }
		}
	} //-------------------------------------------------------------------------------------- 
	if(trim(e.elements["txtProcess"].value)=="") {
		alert("�п�J�B�z�L�{ !");
		return("");
	}	
	
	if(e.elements["selCompany"].value=="���M") { //�i��UPS�ιq�q�T��
		window.open("upswarning.asp","_blank","width=150,height=240,resizable=0,scrollbars=no");		
	}
}//----------------------------------------------------------------------------------------------------------------------------------------------------	

	//*********************************************�]�Ʋ��ʴ���
	for(i=0;i < e.elements["chkPurpose"].length;i++) { 
		if(e.elements["chkPurpose"][i].checked && e.elements["chkPurpose"][i].value.indexOf("���ʳ]��")>-1) {
			alert("1. �аO�o�V�t�d�H�߰ݳ]�ƽs���β��J��A�ðO�����I\n2. �]�ƶi�X���Щβ��ʦ�m�A�Ч��IDMS��m�a�I�A�Ԩ����e�����i�`�N�ƶ��j�C");
		}
	}
	
	//������textarea��J������r����TAB��
	var txt1=document.getElementById("txtWorkArea").value;
	var txt2=document.getElementById("txtProcess").value;
	var regex_newline = /\n/g;
	var regex_tab = /\t/g;
	var regex_endspace = /(\s+)$/;
	document.getElementById("txtWorkArea").value = txt1.replace(regex_newline, ' ').replace(regex_tab, '').replace(regex_endspace, '');
	document.getElementById("txtProcess").value = txt2.replace(regex_tab, '').replace(regex_endspace, '');
	
	e.submit();
}			
</script>
</body>
</html>