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

        }

        private void OpenFile()
        {
            toolStripStatusLabel1.Text = "Opening...";

            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                var fn = openFileDialog1.FileName;
                using (StreamReader reader = new StreamReader(fn, Encoding.UTF8))
                {
                    richTextBox1.Text = reader.ReadToEnd();
                    reader.Close();
                }
                Program.currentfile = fn;
                toolStripStatusLabel2.Text = Path.GetFileName(Program.currentfile);
            }

            toolStripStatusLabel1.Text = "Ready";
        }

        private void SaveAsFile()
        {
            toolStripStatusLabel1.Text = "Saving...";

            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                var fn = saveFileDialog1.FileName;
                using (StreamWriter writer = new StreamWriter(fn, false, Encoding.UTF8))
                {
                    writer.Write(richTextBox1.Text);
                    writer.Close();
                }
                Program.currentfile = fn;
                toolStripStatusLabel2.Text = Path.GetFileName(Program.currentfile);
            }

            toolStripStatusLabel1.Text = "Ready";
        }

        private void SaveFile()
        {
            using (StreamWriter writer = new StreamWriter(Program.currentfile, false, Encoding.UTF8))
            {
                writer.Write(richTextBox1.Text);
            }

            toolStripStatusLabel1.Text = "Ready";
        }

        private void NewToolStripMenuItem_Click(object sender, EventArgs e)
        {
            OpenFile();
        }

        private void Filestatus_Click(object sender, EventArgs e)
        {

        }

        private Font fbold = new Font("Consolas", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
        private Font fubold = new Font("Consolas", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));

        private System.Threading.Tasks.Task launchsunko = new Task(() => { });

        private void RichTextBox1_TextChanged_1(object sender, EventArgs e)
        {
            toolStripStatusLabel1.Text = "Changed";
            /* int xx = richTextBox1.SelectionStart;
            Font f = this.Font;
            foreach (var ho in Highlightning.Hights)
            {
                MatchCollection allBW = Regex.Matches(richTextBox1.Text, ho.word);
                foreach (Match findBW in allBW)
                {
                    richTextBox1.SelectionStart = findBW.Index;
                    richTextBox1.SelectionLength = findBW.Length;
                    richTextBox1.SelectionColor = ho.rgb;
                    richTextBox1.SelectionFont = fbold;
                }
                richTextBox1.SelectionStart = xx;
                richTextBox1.SelectionLength = 0;
                richTextBox1.SelectionColor = Color.Black;
                richTextBox1.Font = fubold;
            } */
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

        private void RichTextBox1_KeyDown(object sender, KeyEventArgs e)
        {

        }

        private void SaveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveAsFile();
        }

        private void ExitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            System.Environment.Exit(0);
        }

        private void SaveToolStripMenuItem1_Click(object sender, EventArgs e)
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

        private void StatusStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

        private void LocalRun()
        {
            var s = $"{Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData)}\\sunko.snc";
            using (StreamWriter writer = new StreamWriter(s, false, Encoding.UTF8))
            {
                writer.Write(richTextBox1.Text);
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

        private void RunToolStripMenuItem_Click(object sender, EventArgs e)
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

        private void ProgramToolStripMenuItem_Click(object sender, EventArgs e)
        {
            programToolStripMenuItem1.Enabled = launchsunko.Status != TaskStatus.Running;
        }

        private void HelpToolStripMenuItem_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Sunko Editor v1.0 by Alexandr Kotov");
        }

        private void ToolStripDropDownButton1_Click(object sender, EventArgs e)
        {

        }

        private void NewToolStripMenuItem_Click_1(object sender, EventArgs e)
        {
            Program.currentfile = null;
            richTextBox1.Clear();
            toolStripStatusLabel1.Text = "Ready";
            toolStripStatusLabel2.Text = "sunko.snc";
        }
    }
}
