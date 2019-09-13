using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Text.RegularExpressions;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;

namespace SunkoEditor
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            this.FileStrip.DropDown.AutoSize = false;
            this.FileStrip.DropDown.Size = new Size(160, 114);
            this.ProgramStrip.DropDown.AutoSize = false;
            this.ProgramStrip.DropDown.Size = new Size(180, 48);
            this.ToolsStrip.DropDown.AutoSize = false;
            this.ToolsStrip.DropDown.Size = new Size(200, 26);
            this.EditStrip.DropDown.AutoSize = false;
            this.EditStrip.DropDown.Size = new Size(170, 142);
            TurnOffEdit();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            UseLocal(Localization.Russian);
            MainStatusStrip.Text = local.StReady;
            //SetsForm = new SettingsForm();
            //SetsForm.UseLocal(Localization.Russian);
        }

        private Localization local;

        private void OpenFile()
        {
            FileStatusStrip.Text = local.StOpening;

            if (OpenFileDialog.ShowDialog() == DialogResult.OK)
            {
                var fn = OpenFileDialog.FileName;
                using (StreamReader reader = new StreamReader(fn, Encoding.UTF8))
                {
                    MainTextBox.Text = reader.ReadToEnd();
                    reader.Close();
                }
                Program.currentfile = fn;
                FileNameStrip.Text = Path.GetFileName(Program.currentfile);
                FileNameStrip.ToolTipText = Program.currentfile;
            }

            FileStatusStrip.Text = local.StReady;
        }

        private void SaveAsFile()
        {
            FileStatusStrip.Text = local.StSaving;

            if (SaveFileDialog.ShowDialog() == DialogResult.OK)
            {
                var fn = SaveFileDialog.FileName;
                using (StreamWriter writer = new StreamWriter(fn, false, Encoding.UTF8))
                {
                    writer.Write(MainTextBox.Text);
                    writer.Close();
                }
                Program.currentfile = fn;
                FileNameStrip.Text = Path.GetFileName(Program.currentfile);
                FileNameStrip.ToolTipText = Program.currentfile;
            }

            FileStatusStrip.Text = local.StReady;
        }

        private void SaveFile()
        {
            using (StreamWriter writer = new StreamWriter(Program.currentfile, false, Encoding.UTF8))
            {
                writer.Write(MainTextBox.Text);
            }

            FileStatusStrip.Text = local.StReady;
        }

        private void File_Open_Click(object sender, EventArgs e)
        {
            OpenFile();
        }

        private void Filestatus_Click(object sender, EventArgs e)
        {

        }

        private Font fbold = new Font("Consolas", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
        private Font fubold = new Font("Consolas", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));

        private System.Threading.Tasks.Task launchsunko = new Task(() => { });

        internal Localization Local { get => local; set => local = value; }

        private void MainTextBox_TextChanged(object sender, EventArgs e)
        {
            FileStatusStrip.Text = local.StChange;
            FileLength.Text = MainTextBox.Text.Length.ToString();
            FileLines.Text = MainTextBox.Lines.Length.ToString();
            /*int xx = MainTextBox.SelectionStart;
            Font f = this.Font;
            foreach (var ho in Highlightning.Hights)
            {
                MatchCollection allBW = Regex.Matches(MainTextBox.Text, ho.word);
                foreach (Match findBW in allBW)
                {
                    MainTextBox.SelectionStart = findBW.Index;
                    MainTextBox.SelectionLength = findBW.Length;
                    MainTextBox.SelectionColor = ho.rgb;
                    MainTextBox.SelectionFont = fbold;
                }
                MainTextBox.SelectionStart = xx;
                MainTextBox.SelectionLength = 0;
                MainTextBox.SelectionColor = Color.Black;
                MainTextBox.Font = fubold;
            }*/
        }
        
        private int CountSpaces(string s)
        {
            var x = 0;
            for (var i = 0; i < s.Length; i++)
            {
                if (s[i] != ' ')
                    return x;
                else x++;
            }
            return x;
        }

        private string Tabulation(string txt, int pos)
        {
            var sb = new StringBuilder();
            var line = 0;
            for (var i = 0; i < pos; i++)
                if (txt[i] == (char)10) line++;
            var x = txt.Split((char)10);
            if (line > 1) x[line] = $"{new string(' ', CountSpaces(x[line - 1]))}{x[line]}";
            foreach (var s in x)
            {
                sb.Append(x);
                sb.Append((char)10);
            }
            return sb.ToString();
        }

        private void File_SaveAs_Click(object sender, EventArgs e)
        {
            SaveAsFile();
        }

        private void File_Exit_Click(object sender, EventArgs e)
        {
            System.Environment.Exit(0);
        }

        private void File_Save_Click(object sender, EventArgs e)
        {
            if (Program.currentfile != null)
            {
                SaveFile();
            }
            else
            {
                SaveAsFile();
            }
        }

        private void LocalRun()
        {
            var s = $"{Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData)}\\sunko.snc";
            using (StreamWriter writer = new StreamWriter(s, false, Encoding.UTF8))
            {
                writer.Write(MainTextBox.Text);
                writer.Close();
            }
            launchsunko = new Task(() =>
            {
                var pr = new Process();
                pr.StartInfo.FileName = "Sunko.exe";
                pr.StartInfo.Arguments = "'" + s + "'";
                pr.Start();
                while (Process.GetProcessesByName("Sunko").Any()) { System.Threading.Thread.Sleep(5); }
                File.Delete(s);
            });
            launchsunko.Start();
        }

        private void Program_Run_Click(object sender, EventArgs e)
        {
            if (launchsunko.Status == TaskStatus.Running) return;
            if (Program.currentfile != null)
            {
                if (File.Exists("Sunko.exe"))
                {
                    File.WriteAllText("log.txt", Program.currentfile);
                    launchsunko = new Task(() =>
                    {
                        var pr = new Process();
                        pr.StartInfo.FileName = "Sunko.exe";
                        pr.StartInfo.Arguments = "'" + Program.currentfile + "'";
                        pr.Start();
                        while (Process.GetProcessesByName("Sunko").Any()) { System.Threading.Thread.Sleep(5); }
                    });
                    launchsunko.Start();
                }
                else MessageBox.Show("Sunko script not exists");
            }
            else
            {
                if (File.Exists("Sunko.exe"))
                {
                    LocalRun();
                }
                else MessageBox.Show("Sunko script not exists");
            }
        }

        private void Program_Compile_Click(object sender, EventArgs e)
        {
            if (File.Exists("SunkoClear.exe"))
            {
                File.WriteAllText("log.txt", Program.currentfile);
                launchsunko = new Task(() =>
                {
                    var pr = new Process();
                    pr.StartInfo.FileName = "SunkoClear.exe";
                    pr.StartInfo.Arguments = "!notrun" + " '" + Program.currentfile + "'";
                    pr.Start();
                    while (Process.GetProcessesByName("Sunko").Any()) { System.Threading.Thread.Sleep(5); }
                });
                launchsunko.Start();
            }
            else
            if (File.Exists("Sunko.exe"))
            {
                File.WriteAllText("log.txt", Program.currentfile);
                launchsunko = new Task(() =>
                {
                    var pr = new Process();
                    pr.StartInfo.FileName = "Sunko.exe";
                    pr.StartInfo.Arguments = "!notrun" + " '" + Program.currentfile + "'";
                    pr.Start();
                    while (Process.GetProcessesByName("Sunko").Any()) { System.Threading.Thread.Sleep(5); }
                });
                launchsunko.Start();
            }
            else MessageBox.Show("Sunko script not exists");
        }

        private void ProgramStrip_Click(object sender, EventArgs e)
        {
            Program_Run.Enabled = launchsunko.Status != TaskStatus.Running;
            Program_Compile.Enabled = !string.IsNullOrEmpty(Program.currentfile) && launchsunko.Status != TaskStatus.Running;
        }

        private void File_New_Click(object sender, EventArgs e)
        {
            Program.currentfile = null;
            MainTextBox.Clear();
            FileStatusStrip.Text = local.StChange;
            FileNameStrip.Text = "sunko.snc";
            FileNameStrip.ToolTipText = "sunko.snc";
        }

        internal void UseLocal(Localization local)
        {
            this.local = local;
            this.FileStrip.Text = local.TsFILE;
            this.File_New.Text = local.TNew;
            this.File_Open.Text = local.TOpen;
            this.File_Save.Text = local.TSave;
            this.File_SaveAs.Text = local.TSaveAs;
            this.File_Exit.Text = local.TExit;
            this.EditStrip.Text = local.TsEDIT;
            this.Edit_Undo.Text = local.TUndo;
            this.Edit_Redo.Text = local.TRedo;
            this.Edit_Paste.Text = local.TPaste;
            this.Edit_Copy.Text = local.TCopy;
            this.Edit_Cut.Text = local.TCut;
            this.Editor_SelectAll.Text = local.TSelectAll;
            this.ProgramStrip.Text = local.TsPROGRAM;
            this.Program_Run.Text = local.TRun;
            this.Program_Compile.Text = local.TCompile;
            this.ToolsStrip.Text = local.TsTOOLS;
            this.Tools_Settings.Text = local.TsSettings;
        }

        public bool TextBoxShortcuts { get => this.MainTextBox.ShortcutsEnabled; set => this.MainTextBox.ShortcutsEnabled = value; }

        public void TurnOnEdit()
        {
            this.EditStrip.Visible = true;
            this.MainTextBox.ShortcutsEnabled = false;
        }

        public void TurnOffEdit()
        {
            this.EditStrip.Visible = false;
            this.MainTextBox.ShortcutsEnabled = true;
        }

        private void SettingsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Enabled = false;
            SettingsForm SetsForm = new SettingsForm(this);
            SetsForm.Show();
        }

        private void Edit_Undo_Click(object sender, EventArgs e)
        {
            MainTextBox.Undo();
        }

        private void EditStrip_Click(object sender, EventArgs e)
        {
            Edit_Undo.Enabled = MainTextBox.CanUndo;
            Edit_Redo.Enabled = MainTextBox.CanRedo;
            Edit_Cut.Enabled = MainTextBox.SelectionLength > 0;
            Edit_Copy.Enabled = MainTextBox.SelectionLength > 0;
            Edit_Paste.Enabled = Clipboard.ContainsText();
        }

        private void Edit_Redo_Click(object sender, EventArgs e)
        {
            MainTextBox.Redo();
        }

        private void Edit_Cut_Click(object sender, EventArgs e)
        {
            MainTextBox.Cut();
        }

        private void Edit_Paste_Click(object sender, EventArgs e)
        {
            if (Clipboard.ContainsText()) MainTextBox.Paste();
        }

        private void Edit_Copy_Click(object sender, EventArgs e)
        {
            MainTextBox.Copy();
        }

        private void Edit_SelectAll_Click(object sender, EventArgs e)
        {
            MainTextBox.SelectAll();
        }
    }
}
