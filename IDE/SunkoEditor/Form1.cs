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

        private void NewToolStripMenuItem_Click(object sender, EventArgs e)
        {
            toolStripStatusLabel1.Text = "Opening...";

            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                using (StreamReader reader = new StreamReader(openFileDialog1.FileName, Encoding.UTF8))
                {
                    richTextBox1.Text = reader.ReadToEnd();
                }
                Program.currentfile = openFileDialog1.FileName;
            }

            toolStripStatusLabel1.Text = "Ready";
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
        
        private string Tabulation(string txt, int pos)
        {
            var sb = new StringBuilder();
            var currenttabs = 0;
            for (var i = 0; i < pos; i++)
            {
                if (txt[i] == (char)9)
                {
                    currenttabs++;
                }
                if (txt[i] == (char)10 && i != pos - 2)
                {
                    currenttabs = 0;
                }
                if (i != pos) sb.Append(txt[i]);
                else
                {
                    sb.Append(txt[i]);
                    sb.Append(new string((char)9, currenttabs));
                    break;
                }
            }
            sb.Append(txt.Substring(pos, txt.Length - pos));
            return sb.ToString();
        }

        private void RichTextBox1_KeyPress(object sender, KeyPressEventArgs e)
        {

        }

        private void SaveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            toolStripStatusLabel1.Text = "Saving...";

            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                using (StreamWriter writer = new StreamWriter(saveFileDialog1.FileName, false, Encoding.UTF8))
                {
                    writer.Write(richTextBox1.Text);
                }
                Program.currentfile = saveFileDialog1.FileName;
            }

            toolStripStatusLabel1.Text = "Ready";
        }

        private void ExitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            System.Environment.Exit(0);
        }

        private void SaveToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            if (Program.currentfile != null)
            {
                using (StreamWriter writer = new StreamWriter(Program.currentfile, false, Encoding.UTF8))
                {
                    writer.Write(richTextBox1.Text);
                }
            }
            else
            {
                toolStripStatusLabel1.Text = "Saving...";

                if (saveFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    using (StreamWriter writer = new StreamWriter(saveFileDialog1.FileName, false, Encoding.UTF8))
                    {
                        writer.Write(richTextBox1.Text);
                    }
                    Program.currentfile = saveFileDialog1.FileName;
                }

                toolStripStatusLabel1.Text = "Ready";
            }
        }

        private void StatusStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

        private void RunToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (launchsunko.Status == TaskStatus.Running) return;
            if (Program.currentfile != null)
            {
                if (File.Exists("Sunko.exe"))
                {
                    launchsunko = new Task(() =>
                    {
                        var pr = new Process();
                        pr.StartInfo.FileName = "Sunko.exe";
                        pr.StartInfo.Arguments = Program.currentfile;
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
                    var s = $"{Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData)}\\sunkoprogram.snc";
                    using (StreamWriter writer = new StreamWriter(s, false, Encoding.UTF8))
                    {
                        writer.Write(richTextBox1.Text);
                    }
                    launchsunko = new Task(() =>
                    {
                        var pr = new Process();
                        pr.StartInfo.FileName = "Sunko.exe";
                        pr.StartInfo.Arguments = s;
                        pr.Start();
                        while (Process.GetProcessesByName("Sunko").Any()) { System.Threading.Thread.Sleep(5); }
                        File.Delete(s);
                    });
                    launchsunko.Start();
                }
                else MessageBox.Show("Sunko script not exists");
            }
        }

        private void ProgramToolStripMenuItem_Click(object sender, EventArgs e)
        {
            runToolStripMenuItem.Enabled = launchsunko.Status != TaskStatus.Running;
        }
    }
}
