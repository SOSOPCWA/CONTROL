using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Control_DevEdit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        
        if (!IsPostBack)
        {
            if(Request.QueryString["DevID"] == null)Page.RegisterStartupScript("function","<script>Device_notice();</script>");
            //Page.RegisterStartupScript("function","<script>Device_notice();</script>");
            DevID.Text = (Request["DevID"]);  
            GetOP();
            UpdateDate.Text = DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss");
            CreateDate.Text = "�|������";
            TextDevNo.Text = "0";
            Last_Host(); //���ͳ̪�s�W
            Last_Repair(); //���ͼt��
            Last_Staff(); //���ͥӽФH
            Last_Staff_Name(Menu_SW_1, Menu_SW_2);//���ͽҧO�B���u�i�Ѧҿ��
            Last_Staff_Name(Menu_HW_1, Menu_HW_2);
            Last_Staff_Name(Menu_StaffName_1, Menu_StaffName_2);

            
                  
        }
    }

    protected void Page_PreRenderComplete(object sender, EventArgs e)   //��Page_Load�L�k���
    {
        if (Request["DevNo"] != null) DevID.Text = Request["DevNo"];

        if (DevID.Text=="")    //�s�W���A
        {            
            
            BtnEdit.Enabled = false;
            BtnDel.Enabled = false;
        }
        else //�s�説�A
        {
            BtnEdit.Enabled = true;
            BtnDel.Enabled = true;
        }
        
        if (!IsPostBack & DevID.Text != "") { //Ū����Ʒ��J�����γs���i�Ӯ�
            try{
                //���Ƿ|Ū�����`���~���g�J
                List<string> re = ReadDev(int.Parse(DevID.Text));
                DevID.Text = HttpUtility.HtmlEncode(re[0]);
                CreateDate.Text = HttpUtility.HtmlEncode(re[1]);
                OP.Text = HttpUtility.HtmlEncode(re[2]);
                UpdateDate.Text = HttpUtility.HtmlEncode(re[3]);
                Location.Text = HttpUtility.HtmlEncode(re[4]);
            }catch(System.Exception){
                Literal Msg = new Literal();
                Msg.Text = "<script>alert('Ū������');window.location.replace('newdevlist.aspx')</script>";
                Page.Controls.Add(Msg);
            }
        }
    }

    protected List<string> ReadDev(int Devid)
    {
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ControlConnectionString"].ConnectionString);
        Conn.Open();        
		SqlCommand cmd = new SqlCommand("SELECT * FROM [Device2] WHERE [DevID]=@dev", Conn);
		cmd.Parameters.AddWithValue("@dev", Devid);
		
        SqlDataReader dr = null;
        dr = cmd.ExecuteReader();
        List<string> re = new List<string>();
        if (dr.Read())
        {
            //DevID.Text = HttpUtility.HtmlEncode(dr["DevID"].ToString());
            //CreateDate.Text = HttpUtility.HtmlEncode(dr["CreateDate"].ToString());
            HostName.Text = HttpUtility.HtmlEncode(dr["HostName"].ToString());
            //���ܳ]�ƺ����P���ۦP
            for (int i = 0; i < HostClass.Items.Count; i++) if (HostClass.Items[i].Value == dr["HostClass"].ToString().Replace(" ", "")) HostClass.SelectedIndex = i;
            IO_Button(dr["IO"].ToString());
            Repair.Text = HttpUtility.HtmlEncode(dr["Repair"].ToString());
            Functions.Text = HttpUtility.HtmlEncode(dr["Functions"].ToString());
            Memo.Text = HttpUtility.HtmlEncode(dr["Memo"].ToString());
            PS.Text = HttpUtility.HtmlEncode(dr["PS"].ToString());
            StaffName.Text = HttpUtility.HtmlEncode(dr["StaffName"].ToString());
            HW.Text = HttpUtility.HtmlEncode(dr["HW"].ToString());
            SW.Text = HttpUtility.HtmlEncode(dr["SW"].ToString());
            TextDevNo.Text = HttpUtility.HtmlEncode(Get_Area(dr["Xall"].ToString(), dr["Yall"].ToString(), "�w��s��")); //-(X-2)*31-Y
            //Location.Text = HttpUtility.HtmlEncode();
            //OP.Text = HttpUtility.HtmlEncode(dr["OP"].ToString());
            //UpdateDate.Text = HttpUtility.HtmlEncode(dr["UpdateDate"].ToString());
            re.Add(dr["DevID"].ToString());
            re.Add(dr["CreateDate"].ToString());
            re.Add(dr["OP"].ToString());
            re.Add(dr["UpdateDate"].ToString());
            re.Add(Get_Area(dr["Xall"].ToString(), dr["Yall"].ToString(), "�ϰ�W��"));
        }
        if(Location.Text=="")Location.Text="�]�Ʃw����~";
        return re;


    }
    //1=�ҧO 2=���u ��ҧO��F2�n���͸ӽҭ��u
    protected void MenuSN1_SelectedIndexChanged(object sender, EventArgs e)
    {
        Last_Staff_Name(Menu_StaffName_1, Menu_StaffName_2);
    }
    //2��F�n����r���
    protected void MenuSN2_SelectedIndexChanged(object sender, EventArgs e)
    {        
        StaffName.Text = Menu_StaffName_2.SelectedValue;
    }
    protected void MenuHW1_SelectedIndexChanged(object sender, EventArgs e)
    {
        Last_Staff_Name(Menu_HW_1, Menu_HW_2);
    }
    protected void MenuHW2_SelectedIndexChanged(object sender, EventArgs e)
    {        
        HW.Text = Menu_HW_2.SelectedValue;
    }
    protected void MenuSW1_SelectedIndexChanged(object sender, EventArgs e)
    {
        Last_Staff_Name(Menu_SW_1, Menu_SW_2);
    }
    protected void MenuSW2_SelectedIndexChanged(object sender, EventArgs e)
    {        
        SW.Text = Menu_SW_2.SelectedValue;
    }
    //�إ߬Y�ҭ��u�C�����
    protected void Last_Staff_Name(DropDownList which, DropDownList want){
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["IDMSConnectionString"].ConnectionString);
        Conn.Open();        
		SqlCommand cmd = new SqlCommand(@"select Item from Config where Kind=@kind ORDER BY memo DESC", Conn);        
        cmd.Parameters.AddWithValue("kind", which.SelectedValue.ToString());
        DataSet ds = RunQuery(cmd);
        want.Items.Clear();
        want.Items.Add(new ListItem("(�п��)",""));
        if (ds.Tables.Count > 0)
        {
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                want.Items.Add(new ListItem(row[0].ToString(), row[0].ToString()));
            }
        }
    }
    protected void Last_Staff(){//�̪�10���t��
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["IDMSConnectionString"].ConnectionString);
        Conn.Open();        
		SqlCommand cmd = new SqlCommand(@"SELECT Item FROM Config where kind='��T����' AND Item<>' '", Conn);
        DataSet ds = RunQuery(cmd);
        
        
        if (ds.Tables.Count > 0)
        {
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                Menu_StaffName_1.Items.Add(new ListItem(row[0].ToString(), row[0].ToString()));
                Menu_HW_1.Items.Add(new ListItem(row[0].ToString(), row[0].ToString()));
                Menu_SW_1.Items.Add(new ListItem(row[0].ToString(), row[0].ToString()));
            }
        }
    }
        
    //�̪�@�����ʿ���ɱa�J
    protected void MenuHost_SelectedIndexChanged(object sender, EventArgs e)
    {
        ReadDev(int.Parse(MenuHost.SelectedValue));
        DevID.Text = "";
        CreateDate.Text = "�|������";
        //HostName.Text = MenuHost.SelectedValue.ToString();
    }

    protected void Last_Host(){//�إ̪߳�40�����ʲM��
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ControlConnectionString"].ConnectionString);
        Conn.Open();
        //SqlCommand cmd = new SqlCommand("SELECT * FROM [View_�@�~�D��] WHERE [�@�~�s��]=" + TextApNo.Text, Conn);
		SqlCommand cmd = new SqlCommand(@"SELECT  TOP(40) DevID
                                            ,CONCAT(Month(CreateDate),'/',DAY([CreateDate]))      
                                            ,[StaffName]
                                            ,[HOSTNAME]
                                            FROM [control].[dbo].[Device2]
                                            ORDER BY CreateDate DESC", Conn);
        DataSet ds = RunQuery(cmd);
        MenuHost.Items.Add(new ListItem("","0"));
        if (ds.Tables.Count > 0)
        {
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                MenuHost.Items.Add(new ListItem(" ("+row[1].ToString() + "," + row[2].ToString()+")"+row[3].ToString(), row[0].ToString()));
            }
        }
    }
    protected void MenuRepair_SelectedIndexChanged(object sender, EventArgs e)//�t�ӿﶵ������J�t�ӪŮ�
    {
        Repair.Text = MenuRepair.SelectedValue;
    }
    protected void Last_Repair(){//�̪�10���t��
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ControlConnectionString"].ConnectionString);
        Conn.Open();
        //SqlCommand cmd = new SqlCommand("SELECT * FROM [View_�@�~�D��] WHERE [�@�~�s��]=" + TextApNo.Text, Conn);
		SqlCommand cmd = new SqlCommand(@"SELECT TOP(10) Repair, COUNT(*) as c FROM [control].[dbo].[Device2]
                                            WHERE Repair<>'N/A'
                                            GROUP BY Repair
                                            ORDER BY c DESC", Conn);
        DataSet ds = RunQuery(cmd);
        MenuRepair.Items.Add(new ListItem("","N/A"));
        if (ds.Tables.Count > 0)
        {
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                MenuRepair.Items.Add(new ListItem(row[0].ToString(), row[0].ToString()));
            }
        }
    }


    protected void BtnAdd_Click(object sender, EventArgs e)//�s�W���s
    {
        
        Literal Msg = new Literal();
        List<string> xy = Get_XY(int.Parse(TextDevNo.Text));
        if(Null_Check(Msg)){} //�ťսT�{
        else if(xy.Count()==0){ //���~�T�{
            Msg.Text = "<script>alert('�]�Ʃw����~�A�Э��s�w��!');</script>";
        }
        else{
            int id = GetPKNo("DevID", "Device2");
            DevID.Text = HttpUtility.HtmlEncode(id.ToString());
            CreateDate.Text = HttpUtility.HtmlEncode(DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss")); 
            List<SqlParameter> pars = new List<SqlParameter>();		
            string SQL=GetInsConDevSQL(id, pars);   //����s�W�ܳ]�Ƹ�ƪ�y�k
            string SQL2=String.Format("�s�W[�]��1]�G�G ({0}, {1}, {2}, {3}, {4}, {5})",//�ͩR�i���y�k
                                HostName.Text.Trim(),
                                HostClass.SelectedValue.Replace(" ", ""),
                                Functions.Text.Trim(),
                                StaffName.Text.Trim(),
                                IO_Change_Button(Button_check()),
                                Get_Area(xy[0], xy[1], "�ϰ�W��"));  
            try{
                ExecDbSQL(SQL, pars);
                InsLifeSQL(SQL2);         
                Location.Text = Get_Area(xy[0], xy[1], "�ϰ�W��");
                Msg.Text = "<script>alert('�s�W����! ');</script>";
            }
            catch (System.Exception)
            {
                
                Msg.Text = "<script>alert('�s�W����!�Э��s���� ');</script>";
            }                              
        }
        Page.Controls.Add(Msg);
    }
    protected void IO_Button(string IO)//�N���ʺ���:�s��Ʈw->�W��
    {
        if (IO == "I") {
            Radio1.Checked = true;
        }
        else if (IO == "O") {
            Radio2.Checked = true;
        }
        else if (IO == "N") {
            Radio3.Checked = true;
        }
        else {
            Radio4.Checked = true;
        }
    }

    protected void BtnEdit_Click(object sender, EventArgs e)//�s����s
    {   
        
        Literal Msg = new Literal();
        List<string> xy = Get_XY(int.Parse(TextDevNo.Text));
        if(Null_Check(Msg)){} //�ťսT�{
        else if(xy.Count()==0){ //���~�T�{
            Msg.Text = "<script>alert('�]�Ʃw����~�A�Э��s�w��!');</script>";
        }
        else{        
            List<SqlParameter> pars = new List<SqlParameter>();				
            pars.Add(new SqlParameter("@devid", SqlDbType.Int)); 
            pars.Last().Value = int.Parse(DevID.Text);
            
            try
            {
                InsLifeSQL("�ק�1 [" + HostName.Text + "] �G�G " + GetUpdate(int.Parse(DevID.Text), "Life"));
                ExecDbSQL("UPDATE [device2] SET " + GetUpdate(int.Parse(DevID.Text),"SQL", pars) + " WHERE [DevID]= @devid", pars); 
                Msg.Text = "<script>alert('�ק粒��');window.location.replace('newdev.aspx?DevID="+DevID.Text+" ')</script>";
            }
            catch (System.Exception)
            {
                
                Msg.Text = "<script>alert('�ק異�ѡA�ЦA�դ@��');window.location.replace('newdev.aspx?DevID="+DevID.Text+" ')</script>";
            }
        }
        Page.Controls.Add(Msg);
    }
    protected void BtnDel_Click(object sender, EventArgs e)//�R�����s
    {
        Literal Msg = new Literal();
        
        
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ControlConnectionString"].ConnectionString);
        Conn.Open();
        SqlCommand cmd = new SqlCommand("DELETE FROM [device2] WHERE [DevID]=@devid", Conn);
        cmd.Parameters.AddWithValue("devid", DevID.Text);
        List<string> xy = Get_XY(int.Parse(TextDevNo.Text));
        string SQL2=String.Format("�s�W[�]��] ({0}, {1}, {2}, {3}, {4}, {5})",
                                HostName.Text.Trim(),
                                HostClass.SelectedValue.Replace(" ", ""),
                                Functions.Text.Trim(),
                                StaffName.Text.Trim(),
                                IO_Change_Button(Button_check()),
                                Get_Area(xy[0], xy[1], "�ϰ�W��"));
        InsLifeSQL("�R��[�]��1]�D[" + HostName.Text.Trim() + "]�A��l��ơG" + SQL2);
        cmd.ExecuteNonQuery();
        cmd.Cancel(); cmd.Dispose(); Conn.Close(); Conn.Dispose();


        Msg.Text = "<script>alert('�w�R��!');window.close();window.location.replace('List.asp');</script>";
        Page.Controls.Add(Msg);

    }
    protected void BtnTest_Click(object sender, EventArgs e)
    {
        Literal Msg = new Literal();
        
		string SQL=  Request.Cookies["UserName"].Value.ToString()==null?"�L":Request.Cookies["UserName"].Value.ToString();
            
        Msg.Text = "<script>alert('"+SQL+"');</script>";

        Page.Controls.Add(Msg);

    }
    protected void Locat_TextChange(object sender, EventArgs e) //non use
    {
        List<string> xy = Get_XY(int.Parse(TextDevNo.Text));
        Location.Text = Get_Area(xy[0], xy[1], "�ϰ�W��");

    }

    protected bool Null_Check(Literal back){//�ťսT�{
        if(HostClass.SelectedValue==""){
            back.Text = "<script>alert('�|����ܳ]�ƺ���!');</script>";return true;
        }else if(HostName.Text==""){
            back.Text = "<script>alert('�|����g�]�ƦW��!');</script>";return true;
        }else if(StaffName.Text==""){
            back.Text = "<script>alert('�|����g�ӽФH��!');</script>";return true;
        }else if(HW.Text==""){
            back.Text = "<script>alert('�|����g�w��t�d�H!');</script>";return true;
        }else if(OP.Text==""){
            back.Text = "<script>alert('�|����gOP!');</script>";return true;
        }else if(SW.Text==""){
            back.Text = "<script>alert('�|����g�n��t�d�H!');</script>";return true;
        }else if(TextDevNo.Text=="0"){
            back.Text = "<script>alert('�|���w��]�Ʀ�m!');</script>";return true;
        }else return false;
    }
    protected string Button_check()//���ʺ���:�W��->�s��Ʈw
    {
        if (Radio1.Checked) {
                return("I");//in
             }
             else if (Radio2.Checked) {
                return("O");//out
             }
             else if (Radio3.Checked) {
                return("N");//change
             }
             else {
                return("M");//other
             }
    }
    protected static string IO_Change_Button(string IO) //For life
    {
        if (IO == "I") {
                return("���J");//in
             }
             else if (IO == "O") {
                return("���X");//out
             }
             else if (IO == "N") {
                return("��");//change
             }
             else {
                return("�䥦");//other
             }
    }


    protected List<string> Get_XY(int location){//IDMS�a�Ϧ^��PointerNumber�� -> XY�y��
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["IDMSConnectionString"].ConnectionString);
        Conn.Open();
        //SqlCommand cmd = new SqlCommand("SELECT * FROM [View_�@�~�D��] WHERE [�@�~�s��]=" + TextApNo.Text, Conn);
		SqlCommand cmd = new SqlCommand("SELECT ����X,����Y,�ϰ�W�� FROM [�w��]�w] WHERE [�w��s��]=@loc", Conn);
		cmd.Parameters.AddWithValue("@loc", location);
		
        SqlDataReader dr = null;
        dr = cmd.ExecuteReader();
        List<string> re = new List<string>();
        if (dr.Read()){
            re.Add((dr["����X"].ToString()));
            re.Add((dr["����Y"].ToString()));
            re.Add((dr["�ϰ�W��"].ToString()));
        }
        else{

        } 
        cmd.Cancel(); cmd.Dispose(); dr.Close(); Conn.Close(); Conn.Dispose();
        return re;
    }
    protected string Get_Area(string xall, string yall, string ColName){//��JXY�i�o��m�W��
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["IDMSConnectionString"].ConnectionString);
        Conn.Open();
        //SqlCommand cmd = new SqlCommand("SELECT * FROM [View_�@�~�D��] WHERE [�@�~�s��]=" + TextApNo.Text, Conn);
		SqlCommand cmd = new SqlCommand("SELECT * FROM [�w��]�w] WHERE [����X]= @Xall AND [����Y]=@Yall", Conn);
		cmd.Parameters.AddWithValue("@Xall", xall);
        cmd.Parameters.AddWithValue("@yall", yall);
		
        SqlDataReader dr = null;
        dr = cmd.ExecuteReader();
        
        if (dr.Read()){
            if(ColName=="�ϰ�W��"){
                return dr[ColName].ToString() + dr["�w��W��"].ToString();
            }
            else{ //�w��s��
                return dr[ColName].ToString();
            }            
        }else{
            return "�w����~";
        }        
        return null;
    }
    protected void Btnddd(object sender, EventArgs e)//non use
    {
        List<string> x = Get_XY(int.Parse(TextDevNo.Text));


        Literal Msg = new Literal();
        Msg.Text = "<script>alert('"+  x[1] +" ');</script>";
        //Msg.Text = "<script>alert('" + SQL + "');</script>";
        Page.Controls.Add(Msg);
    }

    protected void InsLifeSQL(string action) //lifelog
    {   
        string who = GetUserName();
        List<SqlParameter> pars = new List<SqlParameter>();                     
        pars.Add(new SqlParameter("@ID", GetPKNo("LifeID", "ChangeLog")));
        pars.Add(new SqlParameter("@DevID", DevID.Text));
        pars.Add(new SqlParameter("@Time", SqlDbType.DateTime2));
        pars.Last().Value = DateTime.Now.ToString("yyyy'-'MM'-'dd HH':'mm':'ss");
		pars.Add(new SqlParameter("@type", "�]��"));
        pars.Add(new SqlParameter("@action", action));
        pars.Add(new SqlParameter("@OP", who));
        pars.Add(new SqlParameter("@IP", Request.ServerVariables["REMOTE_ADDR"].ToString()));		
		//7 row
        ExecDbSQL ("INSERT INTO [ChangeLog] values("
            + "@ID" + ","
            + "@type" + ","
            + "@DevID" + ","
            + "@Action" + ","
            + "@OP" + ","
            + "@Time" + ","
            + "@IP )", pars  );
    }
    protected string GetUserName(){//�N�ϥΪ�ID -> Name
        string UserID = Request.Cookies["UserID"].Value.ToString();    //��SSM�������o
        if (UserID == "") return "�L";
        else{
            SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["IDMSConnectionString"].ConnectionString);
            Conn.Open();
            SqlCommand cmd = new SqlCommand("Select Kind,Item from Config where Mark='" + UserID + "'", Conn);
            SqlDataReader dr = null;
            dr = cmd.ExecuteReader();
            if (dr.Read())
            {                
                return dr[1].ToString();//UserName                 
            }
            else{
                return "�L";
            }
        }
    }

    protected string GetInsConDevSQL(int devid ,List<SqlParameter> pars) //���o�s�W��ƪ��y�k
    { 
        //int PointerNo = TextDevNo.Text != ""?int.Parse(TextDevNo.Text):-88;
        List<string> XY =  Get_XY(int.Parse(TextDevNo.Text));
        pars.Add(new SqlParameter("@DevID", DevID.Text));
        pars.Add(new SqlParameter("@Time", SqlDbType.DateTime2));
        pars.Last().Value = DateTime.Now.ToString("yyyy'-'MM'-'dd HH':'mm':'ss");
		
        //�M�ť� �קK�z��
		pars.Add(new SqlParameter("@HostName", HostName.Text.Trim()));
        pars.Add(new SqlParameter("@HostClass", HostClass.SelectedValue.Replace(" ", "")));
        pars.Add(new SqlParameter("@Repair", Repair.Text.Trim()));
        pars.Add(new SqlParameter("@IO", Button_check()));
        pars.Add(new SqlParameter("@Functions", Functions.Text.Trim()));
        pars.Add(new SqlParameter("@Memo", Memo.Text.Trim()));
        pars.Add(new SqlParameter("@PS", PS.SelectedValue));
        pars.Add(new SqlParameter("@StaffName", StaffName.Text.Trim()));
        pars.Add(new SqlParameter("@HW", HW.Text.Trim()));
        pars.Add(new SqlParameter("@SW", SW.Text.Trim()));
        pars.Add(new SqlParameter("@OP", OP.Text.Trim()));
        pars.Add(new SqlParameter("@Xall", XY[0]));
        pars.Add(new SqlParameter("@Yall", XY[1]));


		
		//16 row
        return ("INSERT INTO [Device2] values("
            + "@DevID" + ","
            + "@Time" + ","
            + "@HostName" + ","
            + "@HostClass" + ","
            + "@Repair" + ","
            + "@IO" + ","
            + "@Functions" + ","
            + "@Memo" + ","
            + "@PS" + ","
            + "@StaffName" + ","
            + "@HW" + ","
            + "@SW" + ","
            + "@OP" + ","
            + "@Xall" + ","
            + "@Yall" + ","
            + "@Time )");
    }


    protected int GetPKNo(string PKfield, string PKtbl) //���o�D��s��
    {
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ControlConnectionString"].ConnectionString);
        Conn.Open();
        SqlCommand cmd = new SqlCommand("select max(" + PKfield + ") from " + PKtbl, Conn);
		//SqlCommand cmd = new SqlCommand("select max(@PKfield) from " + PKtbl, Conn);
		//cmd.Parameters.AddWithValue("@PKfield", PKfield);
		//cmd.Parameters.AddWithValue("@PKtbl", PKtbl);
		
        SqlDataReader dr = null;
        dr = cmd.ExecuteReader();
        int PkNo = 1; if (dr.Read()) PkNo=int.Parse(dr[0].ToString()) + 1;
        cmd.Cancel(); cmd.Dispose(); dr.Close(); Conn.Close(); Conn.Dispose();

        return (PkNo);
    }
    

    protected string GetInsConDevSQL() //���o�s�W��ƪ��y�k-�@�목
    {
		
		//15 row
        return (@"INSERT INTO [Device2] values('"
            + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+"','"
            + HostName.Text +"','"
            + HostClass.SelectedValue +"','"
            + Repair.Text + "','"
            + Button_check() + "','"
            + Functions.Text + "','"
            + Memo.Text + "','"
            + PS.SelectedValue + "','"
            + StaffName.Text + "','"
            + HW.Text + "','"
            + SW.Text + "','"
            + "d1 and d2" + "',"
            + 79 + ","
            + 82 + ",'"
            + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+"'");            
    }
    protected string GetUpdateCol(string ColName, string Source, string Target, string Kind, string SQLorLife, List<SqlParameter> pars) //���o��@���ק��ƪ��y�k
    {
        string SQL = "";
        

        if (Source != Target)
        {
            if (SQLorLife == "SQL")
            {
                switch (Kind)
                {
					case "string": case "date": case "datetime": 						
						SQL = SQL + ",[" + ColName + "]=" + "@" + Convert.ToString(pars.Count); 
						pars.Add(new SqlParameter("@" + Convert.ToString(pars.Count), Target));				
						break;
                    case "integer": case "money": 						
						SQL = SQL + ",[" + ColName + "]=" + "@" + Convert.ToString(pars.Count);
						pars.Add(new SqlParameter("@" + Convert.ToString(pars.Count), SqlDbType.Int));
						pars.Last().Value = int.Parse(Target);
						break;
                    case "null": 
						SQL = SQL + ",[" + ColName + "]=" + null; 
						break;
                    default: 						
						SQL = SQL + ",[" + ColName + "]=" + "@" + Convert.ToString(pars.Count); 
						pars.Add(new SqlParameter("@" + Convert.ToString(pars.Count), Target));				
						break;
                }
            }
            
        }
        return (SQL);
    }
    
    protected string GetUpdate(int DevID, string SQLorLife, List<SqlParameter> pars) //���o�ק��ƪ�SQL�y�k
    {
        string SQL = "";
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ControlConnectionString"].ConnectionString);
        Conn.Open();        
		SqlCommand cmd = new SqlCommand("select * from [Device2] where [DevID]=@Dev", Conn);
		cmd.Parameters.AddWithValue("@Dev", DevID);
		List<string> xy = Get_XY(int.Parse(TextDevNo.Text));
        SqlDataReader dr = null;
        dr = cmd.ExecuteReader();
        if (dr.Read())
        {
                          
              SQL =     GetUpdateCol("HostName", dr["HostName"].ToString(), HostName.Text, "string", SQLorLife, pars);
            SQL += GetUpdateCol("HostClass", dr["HostClass"].ToString(), HostClass.SelectedValue, "string", SQLorLife, pars);
            SQL += GetUpdateCol("Repair", dr["Repair"].ToString(), Repair.Text, "string", SQLorLife, pars);
            SQL += GetUpdateCol("IO", dr["IO"].ToString(), Button_check(), "string", SQLorLife, pars);
            SQL += GetUpdateCol("Functions", dr["Functions"].ToString(), Functions.Text, "string", SQLorLife, pars);
            SQL += GetUpdateCol("Memo", dr["Memo"].ToString(), Memo.Text, "string", SQLorLife, pars);
            SQL += GetUpdateCol("PS", dr["PS"].ToString(), PS.SelectedValue, "string", SQLorLife, pars);
            SQL += GetUpdateCol("StaffName", dr["StaffName"].ToString(), StaffName.Text, "string", SQLorLife, pars);
            SQL += GetUpdateCol("HW", dr["HW"].ToString(), HW.Text, "string", SQLorLife, pars);
            SQL += GetUpdateCol("SW", dr["SW"].ToString(), SW.Text, "string", SQLorLife, pars);
            SQL += GetUpdateCol("Xall", dr["Xall"].ToString(), xy[0].ToString(), "integer", SQLorLife, pars);
            SQL += GetUpdateCol("Yall", dr["Yall"].ToString(), xy[1].ToString(), "integer", SQLorLife, pars);
            SQL += GetUpdateCol("OP", dr["OP"].ToString(), OP.Text, "string", SQLorLife, pars);
            SQL += GetUpdateCol("UpdateDate", dr["UpdateDate"].ToString(), DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), "datetime", SQLorLife, pars);;

            if (SQL != "") SQL = SQL.Substring(1);  
        }
        cmd.Cancel(); cmd.Dispose(); dr.Close(); Conn.Close(); Conn.Dispose();

        return (SQL);
    }
    protected string GetUpdateCol(string ColName, string Source, string Target, string Kind, string SQLorLife) //���o��@���ק��ƪ��y�k
    {
        string SQL = "";

        if (Source != Target)
        {
            if (SQLorLife == "SQL")
            {
                switch (Kind)
                {
					case "string":
                    case "date":
                    case "datetime": SQL = SQL + ",[" + ColName + "]='" + Target + "'"; break;
                    case "integer":
                    case "money": SQL = SQL + ",[" + ColName + "]=" + Target; break;
                    case "null": SQL = SQL + ",[" + ColName + "]=" + null; break;
                    default: SQL = SQL + ",[" + ColName + "]='" + Target + "'"; break;
                }
            }
            else if (SQLorLife == "Life")
            {
                if (ColName != "�w��s��")
                {
                    if (Source == "") Source = "(�ť�)";
                    if (Target == "") Target = "(�ť�)";
                    SQL = SQL + ",[" + ColName + "]�G" + Source + " -> " + Target;
                }
                else
                {
                    SQL = SQL + ",[" + ColName + "]�G" + Source + "(" + GetConfig("select [�ϰ�W��]+[�w��W��] as [��m�a�I] from [�w��]�w] where [�w��s��]=" + Source)
                        + ") -> " + Target + "(" + GetConfig("select [�ϰ�W��]+[�w��W��] as [��m�a�I] from [�w��]�w] where [�w��s��]=" + Target) + ")";
                }
            }
        }
        
        return (SQL);
    }
    
    protected string GetUpdate(int DevID, string SQLorLife) //���o�ק��ƪ�SQL�y�k -- LIFELOG
    {
        string SQL = "";
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ControlConnectionString"].ConnectionString);
        Conn.Open();        
		SqlCommand cmd = new SqlCommand("select * from [Device2] where [DevID]=@Dev", Conn);
		cmd.Parameters.AddWithValue("@Dev", DevID);
		List<string> xy = Get_XY(int.Parse(TextDevNo.Text));
        SqlDataReader dr = null;
        dr = cmd.ExecuteReader();
        if (dr.Read())
        {    
            SQL =  GetUpdateCol("HostName", dr["HostName"].ToString(), HostName.Text, "string", SQLorLife);
            SQL += GetUpdateCol("HostClass", dr["HostClass"].ToString(), HostClass.SelectedValue, "string", SQLorLife);
            SQL += GetUpdateCol("Repair", dr["Repair"].ToString(), Repair.Text, "string", SQLorLife);
            SQL += GetUpdateCol("IO", dr["IO"].ToString(), Button_check(), "string", SQLorLife);
            SQL += GetUpdateCol("Functions", dr["Functions"].ToString(), Functions.Text, "string", SQLorLife);
            SQL += GetUpdateCol("Memo", dr["Memo"].ToString(), Memo.Text, "string", SQLorLife);
            SQL += GetUpdateCol("PS", dr["PS"].ToString(), PS.SelectedValue, "string", SQLorLife);
            SQL += GetUpdateCol("StaffName", dr["StaffName"].ToString(), StaffName.Text, "string", SQLorLife);
            SQL += GetUpdateCol("HW", dr["HW"].ToString(), HW.Text, "string", SQLorLife);
            SQL += GetUpdateCol("SW", dr["SW"].ToString(), SW.Text, "string", SQLorLife);
            SQL += GetUpdateCol("Xall", dr["Xall"].ToString(), xy[0].ToString(), "integer", SQLorLife);
            SQL += GetUpdateCol("Yall", dr["Yall"].ToString(), xy[1].ToString(), "integer", SQLorLife);
            SQL += GetUpdateCol("OP", dr["OP"].ToString(), OP.Text, "string", SQLorLife);
            SQL += GetUpdateCol("UpdateDate", dr["UpdateDate"].ToString(), DateTime.Now.ToString("yyyy/MM/dd tt hh:mm:ss"), "datetime", SQLorLife);

            if (SQL != "") SQL = SQL.Substring(1);  
        }
        //return (dr["Xall"].ToString() +" "+ xy[0].ToString());
        cmd.Cancel(); cmd.Dispose(); dr.Close(); Conn.Close(); Conn.Dispose();

        return (SQL);
    }
    protected string GetConfig(string SQL) //Ū���Y�t�γ]�w��
    {
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["IDMSConnectionString"].ConnectionString);
        Conn.Open();
        SqlCommand cmd = new SqlCommand(SQL, Conn);
        SqlDataReader dr = null;
        dr = cmd.ExecuteReader();
        string cfg = ""; if (dr.Read()) cfg = HttpUtility.HtmlEncode(dr[0].ToString());
        cmd.Cancel(); cmd.Dispose(); dr.Close(); Conn.Close(); Conn.Dispose();

        return (cfg);
    }

    protected void GetOP() //�����Ʈw����
    {
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["DiaryConnectionString"].ConnectionString);
        Conn.Open();
        SqlCommand cmd = new SqlCommand("SELECT TOP(1) * FROM SIGN ORDER BY TOUR DESC", Conn);
		SqlDataReader dr = cmd.ExecuteReader();
        if(dr.Read())
        {
            OP.Text = dr["OPname"].ToString();
        }
        cmd.Cancel(); cmd.Dispose(); Conn.Close(); Conn.Dispose();
    }

    protected DataSet RunQuery(SqlCommand sqlQuery) //Ū��DB��T
    {
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["IDMSConnectionString"].ConnectionString);
        SqlDataAdapter dbAdapter = new SqlDataAdapter();
        dbAdapter.SelectCommand = sqlQuery;
        sqlQuery.Connection = Conn;
        DataSet QueryDataSet = new DataSet();
        dbAdapter.Fill(QueryDataSet);
        dbAdapter.Dispose(); Conn.Close(); Conn.Dispose();
        return (QueryDataSet);
    }

    protected void ExecDbSQL(string SQL, List<SqlParameter> pars) //�����Ʈw����
    {
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ControlConnectionString"].ConnectionString);
        Conn.Open();
        SqlCommand cmd = new SqlCommand(SQL, Conn);		
		cmd.Parameters.AddRange(pars.ToArray());		
        cmd.ExecuteNonQuery();
        cmd.Cancel(); cmd.Dispose(); Conn.Close(); Conn.Dispose();
    }
    protected void ExecDbSQL(string SQL) //�����Ʈw����
    {
        SqlConnection Conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ControlConnectionString"].ConnectionString);
        Conn.Open();
        SqlCommand cmd = new SqlCommand(SQL, Conn);			
        cmd.ExecuteNonQuery();
        cmd.Cancel(); cmd.Dispose(); Conn.Close(); Conn.Dispose();
    }
}
