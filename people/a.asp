<!-- #include file="..\..\connDB\conn.ini" -->
<!-- #include file="..\..\Lib\GetID.inc" -->
<!-- #include file="..\..\Lib\DT.inc" -->
<%
set condb=Server.CreateObject("adodb.connection")
set connIDMS=Server.CreateObject("adodb.connection")
condb.Open strControl
connIDMS.Open strIDMS
set recset=server.createobject("adodb.recordset")
set rs=server.createobject("adodb.recordset")

rs.open "select Item from Config where Kind='��T����'",connIDMS
while not rs.eof
  strMIC=strMIC & rs(0) & ","
  rs.movenext
wend
rs.close

YYYY=trim(request("YYYY")) : if YYYY="" then YYYY=DT(now-30,"yyyy")
MM=trim(request("MM"))  : if MM="" then MM=DT(now-30,"mm")

SQL=replace(request("SQL"),"$","%")
if SQL="" then
  strYM=trim(YYYY) & "�~" & trim(MM) & "��"
  SQL="select * from people where �i�J��� like '"&trim(YYYY)&"/"&trim(MM)&"/%' order by �ӽг��,�ت�"
else
  strYM=trim(request("selYYYY")) & "�~" & trim(request("selMM")) & "��"
  SQL="select * from people where " & SQL & " order by �ӽг��,�ت�"
end if

Function CleanHw(strPurposes)
  CleanHw="" : dim PurposeA,i : PurposeA=split(strPurposes,",")
  for i=0 to ubound(PurposeA)
    if instr(1,PurposeA(i),"�t�d�H")=0 then CleanHw=CleanHw & PurposeA(i) & ","
  next

  if CleanHw<>"" then CleanHw=mid(CleanHw,1,len(CleanHw)-1)
End Function

dim A(100)  '�t��
dim B(100,20)  '�ت�
dim C(100,20)  '�ɶ�
dim D(100)  '�`�p�ɶ�
dim E(100)  '�`�p�H��
for i=0 to 99
  A(i)=""
next
x=0  '�t�ӭӼ�
dim y(100)  '�P�t�ӥت��Ӽ�

vcnt=0 : no=""
'vresident="HP--���a��  �ùD���--������  IBM--�G����.������"  '2008.03
recset.open "select * from Config where Kind='�`�n�H��' order by Content",condb
while not recset.eof
  if Company<>recset(2) then
    vresident=vresident & "  " & recset(2) & "--" & recset(1)
    Company=recset(2)
  else
    vresident=vresident & "." & recset(1)
  end if
  recset.movenext
wend
recset.close

dim hiddenPurpose(9)  ' 2016.11.5 �бN�n���ê��ت��[�즹array
hiddenPurpose(0)="�žɸ�w�F�����T�W�w"
hiddenPurpose(1)="A���H��"
hiddenPurpose(2)="B���H��"
hiddenPurpose(3)="C���H��"
hiddenPurpose(4)="�̳W�w�n�J"
hiddenPurpose(5)="�䥦�n�J"
on error resume next
recset.open SQL,condb
do while not recset.eof
  if trim(recset("���}���"))="" or trim(recset("���}�ɶ�"))="" then
    no="y"
    exit do
  end if

  ' ----------- 2008.03 ------------
  if InStr(1,vresident,trim(recset("�ӽФH")),1)= 0 then
    vcnt=vcnt+1

    ' 2016.11.5 �z��n���ê��ت�
    vpurpose=recset("�ت�")
    'for each item in hiddenPurpose
    '  if(item<>"") then
    '    if(instr(vpurpose,item)=1) then  ' ���Ŀ�ت�
    '      vpurpose=replace(vpurpose,item,"")
    '    else
    '      vpurpose=replace(vpurpose,", "&item,"")
    '    end if
    '  end if
    'next
    
    for each item in hiddenPurpose
      itemPosition=instr(vpurpose,item)
      if(item<>"" and itemPosition<>0) then
        if(itemPosition=1) then  ' ���Ŀ�ت�
          if(item=hiddenPurpose(4) or item=hiddenPurpose(5)) then
            vpurpose=left(vpurpose,0)
          else
            vpurpose=replace(vpurpose,item,"")
          end if
        else
          if(item=hiddenPurpose(4) or item=hiddenPurpose(5)) then
            vpurpose=left(vpurpose,itemPosition-3)
          else
            vpurpose=replace(vpurpose,", "&item,"")
          end if
        end if
      end if
    next

    if(trim(vpurpose)="") then vpurpose="NULL"  ' ���Ŀ�ت�
    vpurpose=split(CleanHw(vpurpose),",")  '���ѥت����e
    ' 2016.11.5 end

    vtime1=cdate(trim(recset("�i�J���"))&" "&trim(recset("�i�J�ɶ�")) )  '-- ��r����
    vtime2=cdate(trim(recset("���}���"))&" "&trim(recset("���}�ɶ�")) )

    if err.Number>0 then 
      response.write recset("�i�J���") & " " & recset("�i�J�ɶ�") & ","
      err.Number=0
    end if
  end if
  ' ----------------------------------------------------
  recset.movenext
loop
%>
<html>
<head>
  <meta charset="big5">
  <title><%=strYM%>���жi�X�ɶ���έp��</title>
</head>
<body>
  <div align="center">
    <table border="0" cellspacing="1" width="90%">
      <tr>
        <td width="100%">
          <p align="center" style="line-height: 200%; margin-top: 0; margin-bottom: 0">
          <b><font color="#800000" size="6"><%=strYM%></font></b>
          <b><font color="#800000" size="6">���жi�X�ɶ�(�H��)��έp��</font></b>
        </td>
      </tr>
    </table>
  </div>
  <p style="line-height: 100%; margin-top: 0; margin-bottom: 0">�@</p>
  <div align="center">
    <center>
      <table border="1" cellspacing="0" bordercolorlight="#993300" width="100%" height="1">
        <tr>
          <td align="center" width="20%" bgcolor="#FFBFBF">
            <p style="line-height: 150%; margin-top: 0; margin-bottom: 0"><b><font size="4" color="#800000">�t��</font></b>
          </td>
          <td align="center" width="50" bgcolor="#FFBFBF">
            <p style="line-height: 150%; margin-top: 0; margin-bottom: 0"><b><font size="4" color="#800000">�H��</font></b>
          </td>
          <td align="center" width="110" bgcolor="#FFBFBF">
            <p style="line-height: 150%; margin-top: 0; margin-bottom: 0"><b><font size="4" color="#800000">�ɼ��`�p</font></b>
          </td>
          <td align="center" bgcolor="#FFBFBF">
            <p style="line-height: 150%; margin-top: 0; margin-bottom: 0"><b><font size="4" color="#800000">�ت�</font></b>
          </td>
        </tr>

        <tr>
          <td height="16" align="left" bgcolor="<%=vbgcolor%>">
            <p style="line-height: 150%; margin-top: 0; margin-bottom: 0; margin-left: 10; margin-right: 10">
            <font color="#0000FF"><b><%response.write A(i)%></b></font>
          </td>
          <td height="16" align="right" bgcolor="<%=vbgcolor%>">
            <p style="line-height: 150%; margin-top: 0; margin-bottom: 0; margin-left: 10; margin-right: 15">
            <font color="#0000FF"><%response.write vamount%></font>
          </td>
          <td height="16" align="right" bgcolor="<%=vbgcolor%>">
            <p style="line-height: 150%; margin-top: 0; margin-bottom: 0; margin-left: 10; margin-right: 10">
            <font color="#0000FF"><b><% response.write vtotal%></b></font>
          </td>
          <td height="16" align="left" bgcolor="<%=vbgcolor%>">
            <p style="line-height: 150%; margin-top: 0; margin-bottom: 0; margin-left: 10; margin-right: 10">
            <font color="#0000FF"><%=vpurposeList%></font>
          </td>
        </tr>

      </table>
      <br />
      <font color="blue">
        �`�H���G<%=TotalPeople%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        �`�ɼơG<%=(TotalTime\1440) & "��" & ((TotalTime mod 1440)\60) & "�p��" & (TotalTime mod 60) & "��" %>
      </font>
      <br />
      <br />
      <font color="red"> ** ���C�J�ɼƲέp���`�n�H���G�����ߤH�� <%=vresident%></font>
    </center>
  </div>
</body>
</html>
<%
if vcnt=0 or no="y" then
  if vcnt=0 then 
    response.write "�L�C�L��ơ@�I�I"
  else 
    response.write "�|���H�����n�X�A�еn�X��A����@�I�I"
  end if
end if
%>