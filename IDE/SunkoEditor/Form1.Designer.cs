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
            this.MainStatusStrip = new System.Windows.Forms.StatusStrip();
            this.FileStatusStrip = new System.Windows.Forms.ToolStripStatusLabel();
            this.FileLength = new System.Windows.Forms.ToolStripStatusLabel();
            this.FileLines = new System.Windows.Forms.ToolStripStatusLabel();
            this.FileNameStrip = new System.Windows.Forms.ToolStripStatusLabel();
            this.EditorVersionStrip = new System.Windows.Forms.ToolStripStatusLabel();
            this.FileStrip = new System.Windows.Forms.ToolStripDropDownButton();
            this.File_New = new System.Windows.Forms.ToolStripMenuItem();
            this.File_Open = new System.Windows.Forms.ToolStripMenuItem();
            this.File_Save = new System.Windows.Forms.ToolStripMenuItem();
            this.File_SaveAs = new System.Windows.Forms.ToolStripMenuItem();
            this.File_Exit = new System.Windows.Forms.ToolStripMenuItem();
            this.EditStrip = new System.Windows.Forms.ToolStripDropDownButton();
            this.Edit_Undo = new System.Windows.Forms.ToolStripMenuItem();
            this.Edit_Redo = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.Edit_Cut = new System.Windows.Forms.ToolStripMenuItem();
            this.Edit_Paste = new System.Windows.Forms.ToolStripMenuItem();
            this.Edit_Copy = new System.Windows.Forms.ToolStripMenuItem();
            this.Editor_SelectAll = new System.Windows.Forms.ToolStripMenuItem();
            this.ProgramStrip = new System.Windows.Forms.ToolStripDropDownButton();
            this.Program_Run = new System.Windows.Forms.ToolStripMenuItem();
            this.Program_Compile = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolsStrip = new System.Windows.Forms.ToolStripDropDownButton();
            this.Tools_Settings = new System.Windows.Forms.ToolStripMenuItem();
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
            this.MainTextBox.DetectUrls = false;
            this.MainTextBox.Font = new System.Drawing.Font("Consolas", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.MainTextBox.Location = new System.Drawing.Point(0, 28);
            this.MainTextBox.Name = "MainTextBox";
            this.MainTextBox.ShortcutsEnabled = false;
            this.MainTextBox.Size = new System.Drawing.Size(584, 269);
            this.MainTextBox.TabIndex = 2;
            this.MainTextBox.TabStop = false;
            this.MainTextBox.Text = "";
            this.MainTextBox.WordWrap = false;
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
            this.EditStrip,
            this.ProgramStrip,
            this.ToolsStrip});
            this.MainToolStrip.Location = new System.Drawing.Point(3, 0);
            this.MainToolStrip.Name = "MainToolStrip";
            this.MainToolStrip.RenderMode = System.Windows.Forms.ToolStripRenderMode.Professional;
            this.MainToolStrip.Size = new System.Drawing.Size(581, 25);
            this.MainToolStrip.Stretch = true;
            this.MainToolStrip.TabIndex = 5;
            this.MainToolStrip.Text = "MainToolStrip";
            // 
            // MainStatusStrip
            // 
            this.MainStatusStrip.AutoSize = false;
            this.MainStatusStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.FileStatusStrip,
            this.FileLength,
            this.FileLines,
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
            // FileLength
            // 
            this.FileLength.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Left;
            this.FileLength.Name = "FileLength";
            this.FileLength.Size = new System.Drawing.Size(17, 19);
            this.FileLength.Text = "0";
            // 
            // FileLines
            // 
            this.FileLines.Name = "FileLines";
            this.FileLines.Size = new System.Drawing.Size(13, 19);
            this.FileLines.Text = "0";
            // 
            // FileNameStrip
            // 
            this.FileNameStrip.BorderSides = ((System.Windows.Forms.ToolStripStatusLabelBorderSides)((System.Windows.Forms.ToolStripStatusLabelBorderSides.Left | System.Windows.Forms.ToolStripStatusLabelBorderSides.Right)));
            this.FileNameStrip.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.FileNameStrip.Name = "FileNameStrip";
            this.FileNameStrip.Size = new System.Drawing.Size(433, 19);
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
            this.FileStrip.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.FileStrip.Margin = new System.Windows.Forms.Padding(1);
            this.FileStrip.Name = "FileStrip";
            this.FileStrip.Overflow = System.Windows.Forms.ToolStripItemOverflow.Never;
            this.FileStrip.Padding = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.FileStrip.ShowDropDownArrow = false;
            this.FileStrip.Size = new System.Drawing.Size(37, 23);
            this.FileStrip.Text = "File";
            // 
            // File_New
            // 
            this.File_New.AutoSize = false;
            this.File_New.Image = global::SunkoEditor.Properties.Resources.new_file;
            this.File_New.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.File_New.Name = "File_New";
            this.File_New.ShortcutKeyDisplayString = "Ctrl+N";
            this.File_New.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.N)));
            this.File_New.ShowShortcutKeys = false;
            this.File_New.Size = new System.Drawing.Size(159, 22);
            this.File_New.Text = "TEXT_NEW_ALIGNMENTS";
            this.File_New.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.File_New.Click += new System.EventHandler(this.File_New_Click);
            // 
            // File_Open
            // 
            this.File_Open.AutoSize = false;
            this.File_Open.Image = global::SunkoEditor.Properties.Resources.open;
            this.File_Open.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.File_Open.Name = "File_Open";
            this.File_Open.ShortcutKeyDisplayString = "Ctrl+O";
            this.File_Open.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.O)));
            this.File_Open.ShowShortcutKeys = false;
            this.File_Open.Size = new System.Drawing.Size(159, 22);
            this.File_Open.Text = "Open";
            this.File_Open.Click += new System.EventHandler(this.File_Open_Click);
            // 
            // File_Save
            // 
            this.File_Save.AutoSize = false;
            this.File_Save.Image = global::SunkoEditor.Properties.Resources.save;
            this.File_Save.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.File_Save.Name = "File_Save";
            this.File_Save.ShortcutKeyDisplayString = "Ctrl+S";
            this.File_Save.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.S)));
            this.File_Save.ShowShortcutKeys = false;
            this.File_Save.Size = new System.Drawing.Size(159, 22);
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
            this.File_SaveAs.ShowShortcutKeys = false;
            this.File_SaveAs.Size = new System.Drawing.Size(159, 22);
            this.File_SaveAs.Text = "Save As";
            this.File_SaveAs.Click += new System.EventHandler(this.File_SaveAs_Click);
            // 
            // File_Exit
            // 
            this.File_Exit.AutoSize = false;
            this.File_Exit.Name = "File_Exit";
            this.File_Exit.ShortcutKeyDisplayString = "Alt+F4";
            this.File_Exit.ShowShortcutKeys = false;
            this.File_Exit.Size = new System.Drawing.Size(159, 22);
            this.File_Exit.Text = "Exit";
            this.File_Exit.Click += new System.EventHandler(this.File_Exit_Click);
            // 
            // EditStrip
            // 
            this.EditStrip.AutoToolTip = false;
            this.EditStrip.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.EditStrip.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.Edit_Undo,
            this.Edit_Redo,
            this.toolStripSeparator1,
            this.Edit_Cut,
            this.Edit_Paste,
            this.Edit_Copy,
            this.Editor_SelectAll});
            this.EditStrip.Image = ((System.Drawing.Image)(resources.GetObject("EditStrip.Image")));
            this.EditStrip.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.EditStrip.Margin = new System.Windows.Forms.Padding(1);
            this.EditStrip.Name = "EditStrip";
            this.EditStrip.Overflow = System.Windows.Forms.ToolStripItemOverflow.Never;
            this.EditStrip.Padding = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.EditStrip.ShowDropDownArrow = false;
            this.EditStrip.Size = new System.Drawing.Size(39, 23);
            this.EditStrip.Text = "Edit";
            this.EditStrip.DropDownOpened += new System.EventHandler(this.EditStrip_Click);
            // 
            // Edit_Undo
            // 
            this.Edit_Undo.AutoSize = false;
            this.Edit_Undo.Image = global::SunkoEditor.Properties.Resources.undo;
            this.Edit_Undo.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.Edit_Undo.Name = "Edit_Undo";
            this.Edit_Undo.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Z)));
            this.Edit_Undo.ShowShortcutKeys = false;
            this.Edit_Undo.Size = new System.Drawing.Size(169, 22);
            this.Edit_Undo.Text = "Undo";
            this.Edit_Undo.Click += new System.EventHandler(this.Edit_Undo_Click);
            // 
            // Edit_Redo
            // 
            this.Edit_Redo.AutoSize = false;
            this.Edit_Redo.Image = global::SunkoEditor.Properties.Resources.redo;
            this.Edit_Redo.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.Edit_Redo.Name = "Edit_Redo";
            this.Edit_Redo.ShortcutKeyDisplayString = "";
            this.Edit_Redo.ShortcutKeys = ((System.Windows.Forms.Keys)(((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Shift) 
            | System.Windows.Forms.Keys.Z)));
            this.Edit_Redo.ShowShortcutKeys = false;
            this.Edit_Redo.Size = new System.Drawing.Size(169, 22);
            this.Edit_Redo.Text = "Redo";
            this.Edit_Redo.Click += new System.EventHandler(this.Edit_Redo_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(112, 6);
            // 
            // Edit_Cut
            // 
            this.Edit_Cut.AutoSize = false;
            this.Edit_Cut.Image = global::SunkoEditor.Properties.Resources.cut;
            this.Edit_Cut.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.Edit_Cut.Name = "Edit_Cut";
            this.Edit_Cut.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.X)));
            this.Edit_Cut.ShowShortcutKeys = false;
            this.Edit_Cut.Size = new System.Drawing.Size(169, 22);
            this.Edit_Cut.Text = "Cut";
            this.Edit_Cut.Click += new System.EventHandler(this.Edit_Cut_Click);
            // 
            // Edit_Paste
            // 
            this.Edit_Paste.AutoSize = false;
            this.Edit_Paste.Image = global::SunkoEditor.Properties.Resources.paste;
            this.Edit_Paste.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.Edit_Paste.Name = "Edit_Paste";
            this.Edit_Paste.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.V)));
            this.Edit_Paste.ShowShortcutKeys = false;
            this.Edit_Paste.Size = new System.Drawing.Size(169, 22);
            this.Edit_Paste.Text = "Paste";
            this.Edit_Paste.Click += new System.EventHandler(this.Edit_Paste_Click);
            // 
            // Edit_Copy
            // 
            this.Edit_Copy.AutoSize = false;
            this.Edit_Copy.Image = global::SunkoEditor.Properties.Resources.copy;
            this.Edit_Copy.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.Edit_Copy.Name = "Edit_Copy";
            this.Edit_Copy.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.C)));
            this.Edit_Copy.ShowShortcutKeys = false;
            this.Edit_Copy.Size = new System.Drawing.Size(169, 22);
            this.Edit_Copy.Text = "Copy";
            this.Edit_Copy.Click += new System.EventHandler(this.Edit_Copy_Click);
            // 
            // Editor_SelectAll
            // 
            this.Editor_SelectAll.AutoSize = false;
            this.Editor_SelectAll.Name = "Editor_SelectAll";
            this.Editor_SelectAll.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.A)));
            this.Editor_SelectAll.ShowShortcutKeys = false;
            this.Editor_SelectAll.Size = new System.Drawing.Size(169, 22);
            this.Editor_SelectAll.Text = "Select All";
            this.Editor_SelectAll.Click += new System.EventHandler(this.Edit_SelectAll_Click);
            // 
            // ProgramStrip
            // 
            this.ProgramStrip.AutoToolTip = false;
            this.ProgramStrip.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.ProgramStrip.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.Program_Run,
            this.Program_Compile});
            this.ProgramStrip.Image = ((System.Drawing.Image)(resources.GetObject("ProgramStrip.Image")));
            this.ProgramStrip.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.ProgramStrip.Margin = new System.Windows.Forms.Padding(1);
            this.ProgramStrip.Name = "ProgramStrip";
            this.ProgramStrip.Overflow = System.Windows.Forms.ToolStripItemOverflow.Never;
            this.ProgramStrip.Padding = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.ProgramStrip.ShowDropDownArrow = false;
            this.ProgramStrip.Size = new System.Drawing.Size(65, 23);
            this.ProgramStrip.Text = "Program";
            this.ProgramStrip.DropDownOpening += new System.EventHandler(this.ProgramStrip_Click);
            // 
            // Program_Run
            // 
            this.Program_Run.AutoSize = false;
            this.Program_Run.Image = global::SunkoEditor.Properties.Resources.start;
            this.Program_Run.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.Program_Run.Name = "Program_Run";
            this.Program_Run.ShortcutKeyDisplayString = "F9";
            this.Program_Run.ShortcutKeys = System.Windows.Forms.Keys.F9;
            this.Program_Run.ShowShortcutKeys = false;
            this.Program_Run.Size = new System.Drawing.Size(179, 22);
            this.Program_Run.Text = "TEXT_RUN_ALIGNMENTS";
            this.Program_Run.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.Program_Run.Click += new System.EventHandler(this.Program_Run_Click);
            // 
            // Program_Compile
            // 
            this.Program_Compile.AutoSize = false;
            this.Program_Compile.Image = global::SunkoEditor.Properties.Resources.format;
            this.Program_Compile.ImageTransparentColor = System.Drawing.Color.Maroon;
            this.Program_Compile.Name = "Program_Compile";
            this.Program_Compile.Size = new System.Drawing.Size(179, 22);
            this.Program_Compile.Text = "COMPILE";
            this.Program_Compile.Click += new System.EventHandler(this.Program_Compile_Click);
            // 
            // ToolsStrip
            // 
            this.ToolsStrip.AutoToolTip = false;
            this.ToolsStrip.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.ToolsStrip.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.Tools_Settings});
            this.ToolsStrip.Image = ((System.Drawing.Image)(resources.GetObject("ToolsStrip.Image")));
            this.ToolsStrip.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.ToolsStrip.Margin = new System.Windows.Forms.Padding(1);
            this.ToolsStrip.Name = "ToolsStrip";
            this.ToolsStrip.Overflow = System.Windows.Forms.ToolStripItemOverflow.Never;
            this.ToolsStrip.Padding = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.ToolsStrip.ShowDropDownArrow = false;
            this.ToolsStrip.Size = new System.Drawing.Size(48, 23);
            this.ToolsStrip.Text = "Tools";
            // 
            // Tools_Settings
            // 
            this.Tools_Settings.AutoSize = false;
            this.Tools_Settings.Image = global::SunkoEditor.Properties.Resources.Icons_16x16_Options;
            this.Tools_Settings.Name = "Tools_Settings";
            this.Tools_Settings.Size = new System.Drawing.Size(199, 22);
            this.Tools_Settings.Text = "Settings";
            this.Tools_Settings.Click += new System.EventHandler(this.SettingsToolStripMenuItem_Click);
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
        private System.Windows.Forms.ToolStripDropDownButton ToolsStrip;
        private System.Windows.Forms.ToolStripMenuItem Tools_Settings;
        private System.Windows.Forms.ToolStripDropDownButton EditStrip;
        private System.Windows.Forms.ToolStripMenuItem Edit_Undo;
        private System.Windows.Forms.ToolStripMenuItem Edit_Redo;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripMenuItem Edit_Cut;
        private System.Windows.Forms.ToolStripMenuItem Edit_Paste;
        private System.Windows.Forms.ToolStripMenuItem Edit_Copy;
        private System.Windows.Forms.ToolStripMenuItem Editor_SelectAll;
        private System.Windows.Forms.ToolStripStatusLabel FileLength;
        private System.Windows.Forms.ToolStripStatusLabel FileLines;
        private System.Windows.Forms.ToolStripMenuItem Program_Compile;
    }
}

