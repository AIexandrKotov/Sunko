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
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            UseLocal(Localization.Russian);
            MainStatusStrip.Text = local.StReady;
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

        private void MainTextBox_TextChanged(object sender, EventArgs e)
        {
            FileStatusStrip.Text = local.StChange;
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
                    //if (!File.Exists(Program.currentfile))
                    //{
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
                    //}
                    //else File.WriteAllText("log.txt", File.ReadAllText(Program.currentfile));
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

        private void ProgramStrip_Click(object sender, EventArgs e)
        {
            Program_Run.Enabled = launchsunko.Status != TaskStatus.Running;
        }

        private void File_New_Click(object sender, EventArgs e)
        {
            Program.currentfile = null;
            MainTextBox.Clear();
            FileStatusStrip.Text = local.StChange;
            FileNameStrip.Text = "sunko.snc";
            FileNameStrip.ToolTipText = "sunko.snc";
        }

        private void UseLocal(Localization local)
        {
            this.local = local;
            this.FileStrip.Text = local.TsFILE;
            this.File_New.Text = local.TNew;
            this.File_Open.Text = local.TOpen;
            this.File_Save.Text = local.TSave;
            this.File_SaveAs.Text = local.TSaveAs;
            this.File_Exit.Text = local.TExit;
            this.ProgramStrip.Text = local.TsPROGRAM;
            this.Program_Run.Text = local.TsRun;
        }
    }
}
