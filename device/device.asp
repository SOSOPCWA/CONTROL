<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID.inc" -->
<%
Dim connDiary 	 : Set connDiary=Server.CreateObject("ADODB.Connection")  : connDiary.Open strDiary
Dim connIDMS 	 : Set connIDMS=Server.CreateObject("ADODB.Connection")   : connIDMS.Open strIDMS
Dim connDevice   : Set connDevice=Server.CreateObject("ADODB.Connection") : connDevice.Open strControl
dim rs : set rs=server.createobject("ADODB.recordset")

'CreateDate="" ?,�᭱�|�ΨӧP�_device.asp��ƬO�_������DB(�s�W,�ק�,��ܬҦ�,�L�k��DBaction�P�_),Reset��
DBaction=lcase(request("DBaction"))	'�s�W(c) �ק�(s) �R��(d) ��ܩΫ���() �פJ(m)
CreateDate=trim(request("TextCreateDate"))		:	HostName  =trim(Request("TextHostName"))
HostClass =trim(Request("ComboHostClass"))		:	Repair    =trim(Request("TextRepair"))
IO		  =trim(Request("RadioIO"))				:	Functions =trim(Request("TextFunctions"))
Memo     =trim(Request("TextMemo"))             :   PS=trim(Request("CombPS"))                 
StaffName =trim(Request("TextStaffName"))		:	Hw        =trim(Request("TextHw"))
SW        =trim(Request("TextSw"))				:	OP        =trim(Request("TextOP"))
UpdateDate=DT(now,"yymmddhhmiss")
PointerNo =trim(Request("TextPointerNo"))       :   Xall=0 : Yall=0
Areas="�|���w��"

Sub GetXY(PointerNo)
    dim rs1 : set rs1=server.createobject("ADODB.recordset")
    if PointerNo<>"" then       
        rs1.open "select * from [�w��]�w] where [�w��s��]=" & PointerNo,connIDMS
        if not rs1.eof then
            Xall=rs1("����X") : Yall=rs1("����Y")
            Areas=rs1("�ϰ�W��") & rs1("�w��W��")
        end if
        rs1.close
    end if          
End Sub

Sub GetArea(Xall,Yall)
    dim rs1 : set rs1=server.createobject("ADODB.recordset")
    if Xall<>"" then       
        rs1.open "select * from [�w��]�w] where [�w��覡]='����' and [����X]=" & Xall & " and [����Y]=" & Yall,connIDMS
        if not rs1.eof then
            PointerNo=rs1("�w��s��")
            Areas=rs1("�ϰ�W��") & rs1("�w��W��")
        end if
        rs1.close
    end if          
End Sub

select case DBaction
case "c","s"	'�s�W(c) �ק�(s)
	if DBaction="c" then	'�s�W		
		CreateDate=UpdateDate
        call GetXY(PointerNo)
	    sql="Insert into Device values('" & CreateDate & "','" & HostName & "','" & HostClass & "','" & Repair & "','" _
			& IO & "','" & Functions & "','" & Memo & "','" & PS & "','"  _
			& StaffName & "','" & Hw & "','" & Sw & "','" & OP & "'," _
			& Xall & "," & Yall & ",'" & UpdateDate & "');"		
		connDevice.execute sql
	else	'�ק�
        call GetXY(PointerNo)
		rs.open "Select * from Device where CreateDate='" & CreateDate & "'",connDevice,3,3				
		rs("HostName")=HostName     :     rs("HostClass")=HostClass        :     rs("Repair")=Repair
		rs("IO")=IO                          :     rs("Functions")=Functions       :     rs ("Memo")=Memo
		rs("PS")=PS                          :     rs("StaffName")=StaffName
		rs("Hw")=Hw				:	rs("Sw")=Sw				 :     rs("OP")=OP
		rs("Xall")=Xall				:	rs("Yall")=Yall			       :	rs("UpdateDate")=UpdateDate
		rs.update					:	rs.close
	end if
	
	response.write "<script language=""vbscript"">" & vbcrlf
	response.write "Sub window_onload()" & vbcrlf
	response.write "	msgbox ""�x�s����!"",32" & vbcrlf
	response.write "End Sub" & vbcrlf
	response.write "</script>" & vbcrlf
case "d"	'�R��
	connDevice.execute "Delete from Device where CreateDate='" & CreateDate & "'"
	SQL="Select * from Device where CreateDate like '" & mid(CreateDate,1,4) & "%' order by CreateDate Desc"
	response.redirect "List.asp?SQL=" & Server.URLEnCode(SQL)
case else	'���,����("")�αa�J("m")
	OP=ShowOP
	if CreateDate="" then CreateDate=trim(request("CreateDate"))
	rs.open "Select * from Device where CreateDate='" & CreateDate & "'",connDevice
	if not rs.eof then
		HostName=rs("HostName")     :     HostClass=rs("HostClass")      :     Repair=rs("Repair")
		IO=rs("IO")                           :     Functions=rs("Functions")    :     Memo=rs("Memo")
		PS=rs("PS")             :     StaffName=rs("StaffName")
		Hw=rs("Hw")				 :     Sw=rs("Sw")		           :     if DBaction<>"m" then OP=rs("OP")
		Xall=rs("Xall")				 :	 Yall=rs("Yall")			     :     UpdateDate=rs("UpdateDate")
	end if
	rs.close
	call GetArea(Xall,Yall)

	if DBaction="m" then CreateDate=""	'TextCreateDate�O�s�ɮ�submit��,CreateDate�O*.asp?CreateDate=...��
	
	if CreateDate="" then
		response.write "<script language=""vbscript"">" & vbcrlf
		response.write "Sub window_onload()" & vbcrlf
		response.write "	msgbox ""1. �аO�o�V�t�d�H�߰ݳ]�ƽs���β��J��A�ðO�����I"" & vbcrlf & ""2. �]�ƶi�X���Щβ��ʦ�m�A�Ч��IDMS��m�a�I�A�Ԩ����e�����i�`�N�ƶ��j�C"",48" & vbcrlf
		response.write "End Sub" & vbcrlf
		response.write "</script>" & vbcrlf
	end if
end select

Function ShowOP()
	rs.open "Select * from SIGN where TOUR=(Select max(Tour) from SIGN)",connDiary
	if not rs.eof then ShowOP=trim(rs("OPNAME"))
	rs.close
End Function

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
<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=big5" />
  <title>��ƫ���</title>	
  <link rel="stylesheet" type="text/css" href="JsDoMenu/jsdomenu.css" />
  <script type="text/javascript" src="JsDoMenu/jsdomenu.js"></script>
 </head>
 <body onLoad="initjsDOMenu()" bgcolor="#DFEFFF" text="#0000FF" onMouseOver="HideTimeOutMenus()" link="#FF0066">
  <p align="center"><b><font size="5" color="#000066">�]�Ʋ��ʸ�ƫ��ɩβ��ʤ���</font></b></p>
  <form name="form1" method="POST" target="_self" action="device.asp">   <!-- action ���g,�|����debug-->         
   <input type="hidden"  name="DBaction" id="DBaction">                                                                                                                    
   <p align="center"><table border="1" cellpadding="0" cellspacing="0" width="98%">
    <tr>
      <td  height="40" width="105"><font size="3">���ɤ��</font></td>
      <td  height="40" width="383">
        <input type="hidden" name="TextCreateDate" value='<% if CreateDate<>"" and DBaction<>"m" then response.write CreateDate%>'>      	
        <font size="3" color="black"><b><span id="divCreateDate">
<% if CreateDate<>empty and DBaction<>"m" then 
	   response.write "20" & mid(CreateDate,1,2) & "/" & mid(CreateDate,3,2) & "/" & mid(CreateDate,5,2) _
                           & " " & mid(CreateDate,7,2) & ":" & mid(CreateDate,9,2) & ":" & mid(CreateDate,11,2)
      else
         response.write "�|������"
      end if 
%>
        </span></b></font>�@                                                                                                                                                                                                                                                             
<% if CreateDate="" or DBaction="d" or DBaction="m" then %>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    	  <font size="2" color="#800080"><u>                                                                                                                                                          
    	    <span  style="cursor:pointer;" onMouseOver="ShowMenu('menuHostName')" onMouseOut="MenusOut()" tagName="spanHost">�Ѧҿ��</span>       
    	  </u></font>                                                                                                               
    	  <font color="#CC6600" size="2">(�i�פJkey in �L���)</font>                                                                                                                                                 
	  <font color="#CC6600"><% end if %></font>                                                                
	 </td>        
       <td height="40" width="113"><font size="3">���ʺ��� (<font color="#FF0000">*</font>)</font></td>                                                                                                                                                                                                                                                 
       <td height="40" width="372">         <font size="3" color="black" title="�]�Ʋ��J����">       
        	<input type="radio" value="I" name="RadioIO" <%if IO="" or IO="I" then response.write "checked"%>><b>���J</b>          
        	<font color="#FF0000">��</font>         
        </font>�@                                                                                                                                                                                                                                                                                
        <font size="3" color="black" title="�]�Ʋ��X����">       
        	<input type="radio" value="O" name="RadioIO" <%if IO="O" then response.write "checked"%>><b>���X</b>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
        	<font color="#FF0000">��</font>       
        </font>�@                                                                                                                                                                                                                                                                                
        <font size="3" color="black" title="�󴫳]��(�´��s�A�a���n)">       
        	<input type="radio" value="N" name="RadioIO" <%if IO="N" then response.write "checked"%>><b>��</b>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
        	<font color="#FF0000">��</font>       
        </font>�@                                                                                                                                                                                                                                                                                
        <font size="3" color="black" title="�D����W�A�]�Ʋ���....(�Щ�]�ƥγ~��줤����)">       
        	<input type="radio" value="M" name="RadioIO" <%if IO="M" then response.write "checked"%>><b>�䥦</b>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
        	<font color="#FF0000">��</font>                                                                                                          
        </font>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
      </td>        
    </tr>       
    <tr>              
      <td height="40" width="105">       
      	�]�ƺ��� (<font color="#FF0000">*</font>)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
      </td>       
      <td height="40" width="383">       
      	<select size="1" name="ComboHostClass" style="visibility:">             
<%       
    	response.write "<option></option>"       
     	YN=false       
	rs.open "select Item from Config where Kind='�]�ƺ���' order by Item",connDevice       
	while not rs.eof       
		if rs(0)=HostClass then       
			response.write "<option selected value='" & HostClass & "'>" & HostClass & "</option>"       
			YN=true       
		else       
			response.write "<option value='" & rs(0) & "'>" & rs(0) & "</option>"       
		end if       
		rs.movenext       
	wend       
	rs.close       
     
	if not YN and HostClass<>"" then response.write "<option selected value='" & HostClass & "'>" & HostClass & "</option>"	       
%>       
           </select>�@                                                                                                                                                                                                                                                                         
         <font color="#CC6600" size="2">(�Y���D���A�]�ƦW�����ж� hostname )</font>                                                                      
        </td>                             
        <td height="40" width="113"><font size="3">�]�Ƽt��</font></td>       
        <td height="40" width="372">       
          <input type="text" name="TextRepair" size="20" value="<%=repair%>">       
          <u><span onMouseOver="ShowMenu('menuRepair')" onMouseOut="MenusOut()">   
          <font size="2" color="#800080" style="cursor:pointer;">�Ѧҿ��</font></span></u>       
        </td>       
      </tr>       
      <tr>             
       <td height="40" width="105">�]�ƦW�� (<font color="#FF0000">*</font>) </td>                                                                    
       <td  height="40" width="868" colspan="3">       
         <input type="text" name="TextHostName" size="80" value="<%=HostName%>">�@<font color="#CC0000" size="2">(<b>�е��OIDMS���]�ƽs��</b>)</font>                                                                      
       </td>                                   
    </tr> 
    <tr> 
      <td height="40" width="105"><font size="3">�]�ƥ\��</font></td> 
      <td height="40" width="868" colspan="3"><input type="text" name="TextFunctions" size="80" value="<%=Functions%>">�@<font color="#CC6600"><font size="2">(�ж�g�]�ƥD�n�\�ΡA�����ж�g��]�ƻ���)</font></font>�@</td> 
    </tr>         
    <tr> 
      <td height="40" width="105">�]�ƻ���</td>   
      <td height="40" width="868" colspan="3">   
        <input type="text" name="TextMemo" size="80" value="<% =Memo%>">�@<font color="#CC6600" size="2">(�ƫ~�B���N�B����B�ȩ񨫹D�B���X���@�B���ܦa�U�ǡB���o...)�@</font>�@
        <br>
        <font size="2">(��/����)���J��</font>
        <select size="1" name="CombPS">                                       
        <option value="" <%if PS="" then response.write "selected"%> ></option>
        <option value="�ݳ�" <%if PS="�ݳ�" then response.write "selected"%> >�ݶ񲾤J��</option>
        <option value="����" <%if PS="����" then response.write "selected"%> >���ݶ񲾤J��д���</option>
        <option value="�ȩ�" <%if PS="�ȩ�" then response.write "selected"%> >���ݶ񲾤J��мȩ�</option>
        <option value="�N��" <%if PS="�N��" then response.write "selected"%> >���ݶ񲾤J��ХN��</option>
        </select>
        <font color="#CC6600" size="2">(�������J�ж񲾤J�ӽг�A���աB�ȩ�B�N�ް��~)</font>                                                                                                                  
      </td>   
    </tr>       
    <tr>  
      <td height="40" width="105"><font size="3">�ӽФH�� (<font color="#FF0000">*</font>)</font></td>                                                                    
      <td height="40" width="383">       
        <input type="text" name="TextStaffName" size="20" value="<%=StaffName%>">       
        <u><span onMouseOver="ShowMenu('menuStaffName')" onMouseOut="MenusOut()">                                                                         
        <font size="2" color="#800080" style="cursor:pointer;">�Ѧҿ��</font></span></u><font color="#CC6600" size="2">&nbsp;&nbsp;(��i�ۦ�Key In)</font></td>       
      <td height="40" width="113">       
        <font size="3">�w��t�d�H (<font color="#FF0000">*</font>)</font><font color="#CC6600" size="2">                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
      </td>       
      <td height="40" width="372">       
        <input type="text" name="TextHw" size="20" value="<%=hw%>">        
        <u><span onMouseOver="ShowMenu('menuHw')" onMouseOut="MenusOut()">                                                                         
        <font size="2" color="#800080" style="cursor:pointer;">�Ѧҿ��</font></span></u><font color="#CC6600" size="2">&nbsp;&nbsp;(��i�ۦ�Key In)</font>                                                                               
      </td>         
    </tr>           
    <tr>       
      <td height="40" width="105"><font size="3">�ݢޡ@ �@(<font color="#FF0000">*</font>)</font></td>                                                                               
      <td height="40" width="383">   
        <input type="text" name="TextOP" size="20" value="<%=op%>"> 
          <u><span onMouseOver="ShowMenu('menuOP')" onMouseOut="MenusOut()">                                                                         
          <font size="2" color="#800080" style="cursor:pointer;">�Ѧҿ��</font></span></u><font color="#CC6600" size="2">&nbsp;&nbsp;(��i�ۦ�Key In)</font>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
        </td>        
        <td height="40" width="113"><font size="3">�n��t�d�H (<font color="#FF0000">*</font>)</font></td>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
        <td height="40" width="372">       
          <input type="text" name="TextSw" size="20" value="<%=sw%>">       
          <u><span onMouseOver="ShowMenu('menuSw')" onMouseOut="MenusOut()">                                                                         
          <font size="2" color="#800080" style="cursor:pointer;">�Ѧҿ��</font></span></u><font color="#CC6600" size="2">&nbsp;&nbsp;(��i�ۦ�Key In)</font>                                                                               
        </td>                           
      </tr>       
      <tr>       
       <td height="40" width="105" align="center">       
         <input type="button" value="�]�Ʃw��(*)" name="CmdMapLink" style="color: #FF0000; font-weight: bold">                                                    
       </td>       
       <td id="tdMap" height="40" width="383">       
        <input name="TextPointerNo" type="text" size="4" id="TextPointerNo" value="<%=PointerNo%>" OnKeyDown="event.returnValue=false;" style="background-color:Silver;" /> 
        <font size="3" color="black"><b><span id="divAreas"><%=Areas%></span></b></font>       
      </td>       
      <td height="40" width="113"><font size="3">�ק���</font></td>       
      <td height="40" width="372">       
        <font size="3" color="black"><b>       
<%  if UpdateDate<>"" and DBaction<>"m" then       
   		response.write "20" & mid(UpdateDate,1,2) & "/" & mid(UpdateDate,3,2) & "/" & mid(UpdateDate,5,2) & " "  _       
		& mid(UpdateDate,7,2) & ":"  & mid(UpdateDate,9,2) & ":"  & mid(UpdateDate,11,2)       
    	else       
    		response.write DT(now,"yyyy/mm/dd hh:mi:ss")       
    	end if       
%>       
     	  </b></font>       
      </td>       
    </tr>       
  </table> 
  </p> 
  
  <p align="center">      
  <table border="0" width="98%">       
    <tr>       
      <td width="71%" valign="top"> 
      	<font color="#CC6600">�i<a target="_blank" href="../���Ъ��T�ި���Ȫ`�N�ƶ�.doc">�`�N�ƶ�</a>�j</font><br><br>      
        <font color="#CC6600">�@�B����(</font><font color="#FF0000">*</font>   
        <font color="#CC6600">)���������A�䥦���Y�ťձN�H N/A ���N</font><br><br>                                                                      
        <font color="#CC6600">�G�B���}�e�бN�Žc�l��������z���b</font><br><br>                                                               
        <b><font color="#CC6600">�T�B�Y���u�w����סv�B�u�n���s�v�Ρu�ե�w�ˡv��,&nbsp;�ХD�ʴ����θ߰ݡu����̡v<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �O�_�ݭn&quot;�i��&quot;�i����v�T����H�ΤU��~���</font></b><br><br>
        <font color="#CC6600">�|�B �]�ƶi�X���СA�аO�o�V�t�d�H�߰ݳ]�ƽs���β��J��A�ðO�����I</font><br><br>
  		<font color="#CC6600">���B �]�ƶi�X���Щβ��ʦ�m�A�Ш�귽�޲z�l�t�ΡA����m�a�I���A�߰ݭt�d�H�Y���a�I�N��蠟�A�Y�����ж�g(���N�a�I)(���w�ϰ�)�A���I�O���w���b���Ф��A��m�a�I�����g���Ф��������m�C</font> <br><br>  
  		<font color="#CC6600">���B <a target="_blank" href="../�D�����ܪ��T�ި�.doc">�D������...</a></font>  
      </td>      
      <td width="29%" valign="middle">       
         <p align="right">	      	 				       
<% if CreateDate="" or DBaction="m" then %>       
          <input type="button" value=" �� �� " name="cmdAdd" style="font-size: 24pt; font-weight: bold" title="�s�ؤ@�����">       
<% else %>        
          <input type="button" value=" �� �� " name="cmdUpd" style="font-size: 18pt; font-weight: bold" title="�ק糧�����">	&nbsp;&nbsp;&nbsp;&nbsp;		        
	    <input type="button" value=" �R �� " name="cmdDel" style="font-size: 18pt; font-weight: bold" title="�R���������">      
<% end if %>      
	   </p>                                                                                                                                                                            
       </td>       
     </tr>       
   </table> 
</p>         
 </form>   
     
<div align="center"><center>       
 <table border="0" width="656" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" cellspacing="0">       
  <tr>       
    <td width="652" align="center">  
     <marquee style="color: rgb(255,0,0); font-size: 15pt; font-family: �з���; font-style: italic; font-weight: bold" align="middle" width="650" scrollamount="5" scrolldelay="5" border="0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 102�~12��Ұȷ|ĳ�Mĳ�G�����W���о��[�e�A���Эt�d�H�bIDMS�إ߳]�Ƹ�T�A��ú�沾�J��A�Y�L�h�Ш�����g�I�îֹ�IDMS��ƬO�_���T�C</marquee>  
    </td>       
   </tr>       
 </table>       
</center></div>     
</body>
<script language="vbscript">
'���pwindow.open "*.asp"��window.location.reload,submit�ʧ@���ɷ|����
'���ɵL�k���ʬO�]form1�Ψ����W�٥ΤFID,������name�~�i�H,��div�ݥ�id
'----------------------------------------------�]�Ʃw��--------------------------------------------------------------------------
Sub cmdMapLink_onClick()
    PointerNo=form1.TextPointerNo.value
    if PointerNo="" then PointerNo="0"

	for each obj in Document.all.RadioIO
		if obj.checked then exit for
	next
	if obj.value="O" then
		window.open "/IDMS/Lib/map.aspx?IO=O&PointerNo=" & PointerNo,"_blank","location=no;menubar=no;resizable=yes;scrollbars=no;status=no;toolbar=no"
	else
		window.open "/IDMS/Lib/map.aspx?IO=I&PointerNo=" & PointerNo,"_blank","location=no;menubar=no;resizable=yes;scrollbars=no;status=no;toolbar=no"
	end if
	
	divAreas.innerText="�w��a�I�N��s�ɫ����"
End Sub
'----------------------------------------------����/�ק�---------------------------------------------------------------------
Sub cmdAdd_onClick()
	msgbox "102�~12��Ұȷ|ĳ�Mĳ�A�����W���о��[�e�G" & vbcrlf & vbcrlf _
		& "1. ���Эt�d�H�bIDMS�إ߳]�Ƹ�T" & vbcrlf _
		& "2. ��ú�沾�J��(�ťղ��J��IDMS���s��)" & vbcrlf _
		& "3. �b���T�B��x�l�ܤβ��J����O�]�ƽs���A�H�K�i�������p" & vbcrlf _
		& "4. �Y�L�h�Ш�����g�I" & vbcrlf _
		& "5. �Y���ʺ|�A�ȥ��O����x�l�ܡA�ë�ĳ�]�w��xmail�q��" & vbcrlf _
		& "6. ú���J��ɽЮֹ�IDMS��ƬO�_���T�A�ò�����xmail�q���]�w" & vbcrlf _
		& "7. �Y�L�h�Ш�����g�I�îֹ�IDMS��ƬO�_���T�C"  & vbcrlf _
		& "8. �Y�������X���СA�ЧY�ɧ��IDMS����m�a�I�C",48

		
	if SaveYN then
		form1.DBaction.value="c"
		form1.submit()
	end if
End Sub
Sub cmdUpd_onClick()
	if SaveYN then
		form1.DBaction.value="s"
		form1.submit()
	end if
End Sub
Function SaveYN()
	SaveYN=True
	if trim(form1.textHostName.value)="" then
		msgbox "[�]�ƦW��]���ť�!�A�иɶ�C",48
		SaveYN=False : exit Function
	end if
	if trim(form1.ComboHostClass.value)="" then
		msgbox "[�]�ƺ���]���ť�!�A�иɶ�C",48
		SaveYN=False : exit Function
	end if	
	if trim(form1.TextStaffName.value)="" then
		msgbox "[�ӽФH��]���ť�!�A�иɶ�C",48
		SaveYN=False : exit Function
	end if
	if trim(form1.textHw.value)="" then
		msgbox "[�w��t�d�H]���ť�!�A�иɶ�C",48
		SaveYN=False : exit Function
	end if
	if trim(form1.textSw.value)="" then
		msgbox "[�n��t�d�H]���ť�!�A�иɶ�C",48
		SaveYN=False : exit Function
	end if
	if trim(form1.textOP.value)="" then
		msgbox "[OP]���ť�!�A�иɶ�C",48
		SaveYN=False : exit Function
	end if
	if form1.TextPointerNo.value="" or form1.TextPointerNo.value="0" then
		msgbox "[�]�Ʃw��]���ť�!�A���I��]�Ʃw����s�H�Щw�]�Ʀ�m�C",48
		SaveYN=False : exit Function
	end if
	
	if trim(form1.TextRepair.value)="" then form1.TextRepair.value="N/A"
	if trim(form1.TextFunctions.value)="" then form1.TextFunctions.value="N/A"

	call MsgboxPower()
End Function

Sub MsgboxPower()
	if form1.RadioIO(0).checked then msgbox "�з�ZOP �n�O IDMS������m�P�q�O��T !",48						'���J		
	if form1.RadioIO(1).checked then msgbox "�з�ZOP �ק� IDMS������m�P�q�O��T(���X���׫h�K)!",48			'���X
	if form1.RadioIO(2).checked then msgbox "�з�ZOP �߰� IDMS������m�P�q�O�O�_���ܰʡA�Y���Ч�� !",48		'��
	if form1.RadioIO(3).checked then msgbox "�з�ZOP ��s IDMS������m�P�q�O��T !",48						'�䥦
End Sub 
'----------------------------------------------�C�L/�R��/���]--------------------------------------------------------------------------
Sub cmdDel_onClick()
	CreateDate=form1.TextCreateDate.value
	HostName=form1.TextHostName.value
	if CreateDate<>"" then
		YN=false
		if msgbox("�T�w�n�R��[" & hostname & "]�H",49,"�R���]�Ƹ��")=1 then
			call MsgboxPower()
			form1.DBaction.value="d"
			form1.submit()
		end if	
	end if	
End Sub
'----------------------------------------------����--------------------------------------------------------------------------
Sub TextHostName_onKeyPress()
	select case window.event.keycode
	case 39,34,60,62,123,125 ''"<>{}
		window.event.keycode=0
	end select
End Sub
Sub TextRepair_onKeyPress()
	select case window.event.keycode
	case 39,34,60,62,123,125 ''"<>{}
		window.event.keycode=0
	end select
End Sub
Sub TextFunctions_onKeyPress()
	select case window.event.keycode
	case 39,34,60,62,123,125 ''"<>{}
		window.event.keycode=0
	end select
End Sub
Sub TextStaffName_onKeyPress()
	select case window.event.keycode
	case 39,34,60,62,123,125 ''"<>{}
		window.event.keycode=0
	end select
End Sub
Sub TextHw_onKeyPress()
	select case window.event.keycode
	case 39,34,60,62,123,125 ''"<>{}
		window.event.keycode=0
	end select
End Sub
Sub TextSw_onKeyPress()
	select case window.event.keycode
	case 39,34,60,62,123,125 ''"<>{}
		window.event.keycode=0
	end select
End Sub
Sub TextOP_onKeyPress()
	select case window.event.keycode
	case 39,34,60,62,123,125 ''"<>{}
		window.event.keycode=0
	end select
End Sub
  </script>
<script language="javascript">
var whichselected;
function ShowMenu(which)
{	menuYN="N";
	HidingAllMenus();
	menuYN="Y";	
	whichselected=which;
	switch (which)
    { case "menuHostName":
  		//form1.ComboHostClass.style.visibility="hidden";
        setPopUpMenu(menuHostName);
        break;
      case "menuRepair":
        setPopUpMenu(menuRepair);
        break;
      case "menuFunctions":
        setPopUpMenu(menuFunctions);
        break;
      case "menuStaffName":
        setPopUpMenu(menuStaffName);
        break;
      case "menuHw":
        setPopUpMenu(menuStaffName);
        break;
      case "menuSw":
        setPopUpMenu(menuStaffName);
        break;
      case "menuOP":
        setPopUpMenu(menuStaffName);
        break;
    }	
	activatePopUpMenuBy(0,2);
	leftClickHandler();
}

//---------------------------�}�C = new jsDOMenu(����); addMenuItem(new menuItem("���ئW��","�����ܼ�","code:������"));
//---------------------------�}�C = new jsDOMenu(����); menuHostName.items.���ذ}�C.setSubMenu(menuUnit" & i & ");
function createjsDOMenu()
{//--------------------------------------�]�ƦW��------------------------------------------------------------------------------
  menuHostName = new jsDOMenu(108);
  <% response.write "menuHostName.addMenuItem(new menuItem(""�Ҧ��]��...."",""Host0" & """,""code:SelectMenu('other');""));" & vbcrlf
	rs.open "select hostname,CreateDate,staffName from Device order by CreateDate Desc",connDevice
	 for i=1 to 5
	 	response.write "menuHostName.addMenuItem(new menuItem(""�̪�" & 10*i & "���]��"",""Host" & i & """,""""));" & vbcrlf
  		response.write "menuHost" & i & " = new jsDOMenu(400);" & vbcrlf
		response.write "with (menuHost" & i & ")" & vbcrlf
		response.write "{" & vbcrlf
		j=0
		while not rs.eof and j<10
			j=j+1 
			response.write "addMenuItem(new menuItem(""(" & mid(rs(1),3,2) & "/" & mid(rs(1),5,2) & "," & rs(2) & ")" _
				& rs(0) & ""","""",""code:SelectMenu('" & rs("CreateDate") & "');""))" & vbcrlf
			rs.movenext
		wend			 	
		response.write "}" & vbcrlf
		response.write "menuHostName.items.Host" & i & ".setSubMenu(menuHost" & i & ");" & vbcrlf
	 next
	 rs.close
   %>
//--------------------------------------�]�Ƽt��------------------------------------------------------------------------------
  menuRepair = new jsDOMenu(96);
  <% 'rs.open "select Item from Config where Kind='�]�Ƽt��' order by Item",connDevice
  	 rs.open "select distinct repair from device where CreateDate>='" & DT(now-1000,"yymmddhhmiss") & "'",connDevice
	 i=0
	 while not rs.eof
	 	i=i+1
	 	response.write "menuRepair.addMenuItem(new menuItem(""�e" & 10*i & "���t��"",""Repair" & i & """,""""));" & vbcrlf
	 	
  		response.write "menuRepair" & i & " = new jsDOMenu(80);" & vbcrlf
		response.write "with (menuRepair" & i & ")" & vbcrlf
		response.write "{" & vbcrlf
		j=0
		while not rs.eof and j<10
			j=j+1
			response.write "addMenuItem(new menuItem(""" & rs(0) & ""","""",""code:form1.TextRepair.value='" & rs(0) & "';""));" & vbcrlf
			rs.movenext
		wend					 	
		response.write "}" & vbcrlf
		response.write "menuRepair.items.Repair" & i & ".setSubMenu(menuRepair" & i & ");" & vbcrlf
	 wend
	 rs.close
   %>
/*--------------------------------------�]�ƥγ~------------------------------------------------------------------------------
  menuFunctions = new jsDOMenu(120);
  with (menuFunctions)  	
  <% 'response.write "{" & vbcrlf
'  	 for i=1 to 5
' 		response.write "addMenuItem(new menuItem(""�̪�" & 10*i & "���γ~"",""Func" & i & """,""""));" & vbcrlf	    
'	 next
'	 response.write "}" & vbcrlf
'	 rs.open "select distinct Functions,CreateDate,staffName from Device order by CreateDate Desc",connDevice
'	 for i=1 to 5
'  		response.write "menuFunc" & i & " = new jsDOMenu(400);" & vbcrlf
'		response.write "with (menuFunc" & i & ")" & vbcrlf
'		response.write "{" & vbcrlf
'		j=0
'		while not rs.eof and j<10
'			j=j+1
'			response.write "addMenuItem(new menuItem(""(" & mid(rs(1),3,2) & "/" & mid(rs(1),5,2) & "," & rs(2) & ")" _
'				& rs(0) & ""","""",""code:form1.TextFunctions.value='" & rs(0) & "';""));" & vbcrlf
'			rs.movenext
'		wend			 	
'		response.write "}" & vbcrlf
'		response.write "menuFunctions.items.Func" & i & ".setSubMenu(menuFunc" & i & ");" & vbcrlf
'	 next
'	 rs.close
   %>
----------------------------------------------------------------------------------------------------------------------------*/
//--------------------------------------�ӽг��------------------------------------------------------------------------------
  menuStaffName = new jsDOMenu(92);
  with (menuStaffName)
{<%
  	rs.open "select Item from Config where kind='��T����'",connIDMS
	i=1
	dim UnitNameA(50)
	while not rs.eof
  		response.write "addMenuItem(new menuItem(""" & rs(0) & """,""Unit" & i & """,""""))" & vbcrlf
	  	UnitNameA(i)=rs(0)
		rs.movenext
		i=i+1
  	wend
  	rs.close
%>}<%
  while i>1
  	i=i-1
  	response.write "menuUnit" & i & " = new jsDOMenu(72);" & vbcrlf
	response.write "with (menuUnit" & i & "){" & vbcrlf
    rs.open "select Item from Config where Kind='" & UnitNameA(i) & "' order by Mark",connIDMS
	while not rs.eof
		response.write "addMenuItem(new menuItem(""" & rs(0) & """," & """""" & ",""code:SelectMenu('" & rs(0) & "');""))" & vbcrlf
		rs.movenext
	wend
	rs.close
	response.write "}" & vbcrlf
	response.write "menuStaffName.items.Unit" & i & ".setSubMenu(menuUnit" & i & ");"	
  wend
%>}
//--------------------------------------�����------------------------------------------------------------------------------
function SelectMenu(txt)
{	switch (whichselected)
	{ case "menuStaffName":
        form1.TextStaffName.value=txt;
        break;
      case "menuHw":
        form1.TextHw.value=txt;
        break;
      case "menuSw":
        form1.TextSw.value=txt;
        break;
      case "menuOP":
        form1.TextOP.value=form1.TextOP.value+"  "+txt;
        break;
      case "menuHostName":
        switch (txt)
        { case "":        	
            break;
          case "other":
          	window.open("List.asp?Sel=Y","_blank");
            break;
          default:
          	window.open("device.asp?CreateDate=" + txt + "&DBaction=m","_self");
            break;
        }      
        break;
    }
    //form1.ComboHostClass.style.visibility="";		
}
  </script>
</html>