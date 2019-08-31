namespace SunkoEditor
{
    partial class Form1
    {
        /// <summary>
        /// Обязательная переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Требуемый метод для поддержки конструктора — не изменяйте 
        /// содержимое этого метода с помощью редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.MainTextBox = new System.Windows.Forms.RichTextBox();
            this.OpenFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.SaveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.MainToolStrip = new System.Windows.Forms.ToolStrip();
            this.FileStrip = new System.Windows.Forms.ToolStripDropDownButton();
            this.File_New = new System.Windows.Forms.ToolStripMenuItem();
            this.File_Open = new System.Windows.Forms.ToolStripMenuItem();
            this.File_Save = new System.Windows.Forms.ToolStripMenuItem();
            this.File_SaveAs = new System.Windows.Forms.ToolStripMenuItem();
            this.File_Exit = new System.Windows.Forms.ToolStripMenuItem();
            this.ProgramStrip = new System.Windows.Forms.ToolStripDropDownButton();
            this.Program_Run = new System.Windows.Forms.ToolStripMenuItem();
            this.MainStatusStrip = new System.Windows.Forms.StatusStrip();
            this.FileStatusStrip = new System.Windows.Forms.ToolStripStatusLabel();
            this.FileNameStrip = new System.Windows.Forms.ToolStripStatusLabel();
            this.EditorVersionStrip = new System.Windows.Forms.ToolStripStatusLabel();
            this.MainToolStrip.SuspendLayout();
            this.MainStatusStrip.SuspendLayout();
            this.SuspendLayout();
            // 
            // MainTextBox
            // 
            this.MainTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.MainTextBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.MainTextBox.Font = new System.Drawing.Font("Consolas", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.MainTextBox.Location = new System.Drawing.Point(0, 24);
            this.MainTextBox.Name = "MainTextBox";
            this.MainTextBox.Size = new System.Drawing.Size(584, 273);
            this.MainTextBox.TabIndex = 2;
            this.MainTextBox.TabStop = false;
            this.MainTextBox.Text = "";
            this.MainTextBox.TextChanged += new System.EventHandler(this.MainTextBox_TextChanged);
            // 
            // OpenFileDialog
            // 
            this.OpenFileDialog.Filter = "Sunko Files|*.snc|All Files|*.*";
            // 
            // SaveFileDialog
            // 
            this.SaveFileDialog.Filter = "Sunko Files|*.snc|All Files|*.*";
            // 
            // MainToolStrip
            // 
            this.MainToolStrip.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.MainToolStrip.AutoSize = false;
            this.MainToolStrip.BackColor = System.Drawing.SystemColors.Control;
            this.MainToolStrip.Dock = System.Windows.Forms.DockStyle.None;
            this.MainToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden;
            this.MainToolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.FileStrip,
            this.ProgramStrip});
            this.MainToolStrip.Location = new System.Drawing.Point(3, 0);
            this.MainToolStrip.Name = "MainToolStrip";
            this.MainToolStrip.Size = new System.Drawing.Size(581, 25);
            this.MainToolStrip.Stretch = true;
            this.MainToolStrip.TabIndex = 5;
            this.MainToolStrip.Text = "MainToolStrip";
            // 
            // FileStrip
            // 
            this.FileStrip.AutoToolTip = false;
            this.FileStrip.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.FileStrip.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.File_New,
            this.File_Open,
            this.File_Save,
            this.File_SaveAs,
            this.File_Exit});
            this.FileStrip.Image = ((System.Drawing.Image)(resources.GetObject("FileStrip.Image")));
            this.FileStrip.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.FileStrip.Name = "FileStrip";
            this.FileStrip.Overflow = System.Windows.Forms.ToolStripItemOverflow.Never;
            this.FileStrip.Padding = new System.Windows.Forms.Padding(5, 0, 5, 0);
            this.FileStrip.ShowDropDownArrow = false;
            this.FileStrip.Size = new System.Drawing.Size(39, 22);
            this.FileStrip.Text = "File";
            // 
            // File_New
            // 
            this.File_New.AutoSize = false;
            this.File_New.Name = "File_New";
            this.File_New.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.File_New.ShortcutKeyDisplayString = "Ctrl+N";
            this.File_New.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.N)));
            this.File_New.Size = new System.Drawing.Size(250, 22);
            this.File_New.Text = "New";
            this.File_New.Click += new System.EventHandler(this.File_New_Click);
            // 
            // File_Open
            // 
            this.File_Open.AutoSize = false;
            this.File_Open.Name = "File_Open";
            this.File_Open.ShortcutKeyDisplayString = "Ctrl+O";
            this.File_Open.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.O)));
            this.File_Open.Size = new System.Drawing.Size(250, 22);
            this.File_Open.Text = "Open";
            this.File_Open.Click += new System.EventHandler(this.File_Open_Click);
            // 
            // File_Save
            // 
            this.File_Save.AutoSize = false;
            this.File_Save.Name = "File_Save";
            this.File_Save.ShortcutKeyDisplayString = "Ctrl+S";
            this.File_Save.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.S)));
            this.File_Save.Size = new System.Drawing.Size(250, 22);
            this.File_Save.Text = "Save";
            this.File_Save.Click += new System.EventHandler(this.File_Save_Click);
            // 
            // File_SaveAs
            // 
            this.File_SaveAs.AutoSize = false;
            this.File_SaveAs.Name = "File_SaveAs";
            this.File_SaveAs.ShortcutKeyDisplayString = "Ctrl+Shift+S";
            this.File_SaveAs.ShortcutKeys = ((System.Windows.Forms.Keys)(((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Shift) 
            | System.Windows.Forms.Keys.S)));
            this.File_SaveAs.Size = new System.Drawing.Size(250, 22);
            this.File_SaveAs.Text = "Save As";
            this.File_SaveAs.Click += new System.EventHandler(this.File_SaveAs_Click);
            // 
            // File_Exit
            // 
            this.File_Exit.AutoSize = false;
            this.File_Exit.Name = "File_Exit";
            this.File_Exit.ShortcutKeyDisplayString = "Alt+F4";
            this.File_Exit.Size = new System.Drawing.Size(250, 22);
            this.File_Exit.Text = "Exit";
            this.File_Exit.Click += new System.EventHandler(this.File_Exit_Click);
            // 
            // ProgramStrip
            // 
            this.ProgramStrip.AutoToolTip = false;
            this.ProgramStrip.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.ProgramStrip.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.Program_Run});
            this.ProgramStrip.Image = ((System.Drawing.Image)(resources.GetObject("ProgramStrip.Image")));
            this.ProgramStrip.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.ProgramStrip.Name = "ProgramStrip";
            this.ProgramStrip.Padding = new System.Windows.Forms.Padding(5, 0, 5, 0);
            this.ProgramStrip.ShowDropDownArrow = false;
            this.ProgramStrip.Size = new System.Drawing.Size(67, 22);
            this.ProgramStrip.Text = "Program";
            this.ProgramStrip.Click += new System.EventHandler(this.ProgramStrip_Click);
            // 
            // Program_Run
            // 
            this.Program_Run.AutoSize = false;
            this.Program_Run.Name = "Program_Run";
            this.Program_Run.ShortcutKeyDisplayString = "F9";
            this.Program_Run.ShortcutKeys = System.Windows.Forms.Keys.F9;
            this.Program_Run.Size = new System.Drawing.Size(250, 22);
            this.Program_Run.Text = "Run";
            this.Program_Run.Click += new System.EventHandler(this.Program_Run_Click);
            // 
            // MainStatusStrip
            // 
            this.MainStatusStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.FileStatusStrip,
            this.FileNameStrip,
            this.EditorVersionStrip});
            this.MainStatusStrip.Location = new System.Drawing.Point(0, 298);
            this.MainStatusStrip.Name = "MainStatusStrip";
            this.MainStatusStrip.Size = new System.Drawing.Size(584, 24);
            this.MainStatusStrip.TabIndex = 6;
            this.MainStatusStrip.Text = "statusStrip1";
            // 
            // FileStatusStrip
            // 
            this.FileStatusStrip.AutoSize = false;
            this.FileStatusStrip.Name = "FileStatusStrip";
            this.FileStatusStrip.Size = new System.Drawing.Size(75, 19);
            this.FileStatusStrip.Text = "Ready";
            this.FileStatusStrip.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // FileNameStrip
            // 
            this.FileNameStrip.BorderSides = ((System.Windows.Forms.ToolStripStatusLabelBorderSides)((System.Windows.Forms.ToolStripStatusLabelBorderSides.Left | System.Windows.Forms.ToolStripStatusLabelBorderSides.Right)));
            this.FileNameStrip.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.FileNameStrip.Name = "FileNameStrip";
            this.FileNameStrip.Size = new System.Drawing.Size(463, 19);
            this.FileNameStrip.Spring = true;
            this.FileNameStrip.Text = "sunko.snc";
            this.FileNameStrip.ToolTipText = "sunko.snc";
            // 
            // EditorVersionStrip
            // 
            this.EditorVersionStrip.Name = "EditorVersionStrip";
            this.EditorVersionStrip.Size = new System.Drawing.Size(31, 19);
            this.EditorVersionStrip.Text = "1.0.0";
            // 
            // Form1
            // 
            this.ClientSize = new System.Drawing.Size(584, 322);
            this.Controls.Add(this.MainStatusStrip);
            this.Controls.Add(this.MainToolStrip);
            this.Controls.Add(this.MainTextBox);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MinimumSize = new System.Drawing.Size(600, 360);
            this.Name = "Form1";
            this.Text = "Sunko Editor";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.MainToolStrip.ResumeLayout(false);
            this.MainToolStrip.PerformLayout();
            this.MainStatusStrip.ResumeLayout(false);
            this.MainStatusStrip.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.RichTextBox MainTextBox;
        private System.Windows.Forms.OpenFileDialog OpenFileDialog;
        private System.Windows.Forms.SaveFileDialog SaveFileDialog;
        private System.Windows.Forms.ToolStrip MainToolStrip;
        private System.Windows.Forms.ToolStripDropDownButton FileStrip;
        private System.Windows.Forms.ToolStripMenuItem File_Open;
        private System.Windows.Forms.ToolStripMenuItem File_Save;
        private System.Windows.Forms.ToolStripMenuItem File_SaveAs;
        private System.Windows.Forms.ToolStripMenuItem File_Exit;
        private System.Windows.Forms.ToolStripDropDownButton ProgramStrip;
        private System.Windows.Forms.ToolStripMenuItem Program_Run;
        private System.Windows.Forms.ToolStripMenuItem File_New;
        private System.Windows.Forms.StatusStrip MainStatusStrip;
        private System.Windows.Forms.ToolStripStatusLabel FileStatusStrip;
        private System.Windows.Forms.ToolStripStatusLabel FileNameStrip;
        private System.Windows.Forms.ToolStripStatusLabel EditorVersionStrip;
    }
}

