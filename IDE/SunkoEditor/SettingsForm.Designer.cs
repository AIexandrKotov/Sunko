namespace SunkoEditor
{
    partial class SettingsForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.SetEnglish = new System.Windows.Forms.Button();
            this.SetLang = new System.Windows.Forms.GroupBox();
            this.SetRussian = new System.Windows.Forms.Button();
            this.Enable_Edit = new System.Windows.Forms.CheckBox();
            this.SetLang.SuspendLayout();
            this.SuspendLayout();
            // 
            // SetEnglish
            // 
            this.SetEnglish.Location = new System.Drawing.Point(6, 19);
            this.SetEnglish.Name = "SetEnglish";
            this.SetEnglish.Size = new System.Drawing.Size(94, 23);
            this.SetEnglish.TabIndex = 0;
            this.SetEnglish.Text = "English";
            this.SetEnglish.UseVisualStyleBackColor = true;
            this.SetEnglish.Click += new System.EventHandler(this.SetEnglish_Click);
            // 
            // SetLang
            // 
            this.SetLang.Controls.Add(this.SetRussian);
            this.SetLang.Controls.Add(this.SetEnglish);
            this.SetLang.Location = new System.Drawing.Point(365, 267);
            this.SetLang.Name = "SetLang";
            this.SetLang.Size = new System.Drawing.Size(107, 83);
            this.SetLang.TabIndex = 1;
            this.SetLang.TabStop = false;
            this.SetLang.Text = "SetLanguage";
            // 
            // SetRussian
            // 
            this.SetRussian.Location = new System.Drawing.Point(7, 49);
            this.SetRussian.Name = "SetRussian";
            this.SetRussian.Size = new System.Drawing.Size(93, 23);
            this.SetRussian.TabIndex = 1;
            this.SetRussian.Text = "Русский";
            this.SetRussian.UseVisualStyleBackColor = true;
            this.SetRussian.Click += new System.EventHandler(this.SetRussian_Click);
            // 
            // Enable_Edit
            // 
            this.Enable_Edit.AutoSize = true;
            this.Enable_Edit.Checked = true;
            this.Enable_Edit.CheckState = System.Windows.Forms.CheckState.Checked;
            this.Enable_Edit.Location = new System.Drawing.Point(13, 13);
            this.Enable_Edit.Name = "Enable_Edit";
            this.Enable_Edit.Size = new System.Drawing.Size(79, 17);
            this.Enable_Edit.TabIndex = 2;
            this.Enable_Edit.Text = "Enable edit";
            this.Enable_Edit.UseVisualStyleBackColor = true;
            this.Enable_Edit.CheckedChanged += new System.EventHandler(this.Enable_Edit_CheckedChanged);
            // 
            // SettingsForm
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
            this.ClientSize = new System.Drawing.Size(484, 362);
            this.Controls.Add(this.Enable_Edit);
            this.Controls.Add(this.SetLang);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "SettingsForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "SettingsForm";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.OnFormClosed);
            this.SetLang.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button SetEnglish;
        private System.Windows.Forms.GroupBox SetLang;
        private System.Windows.Forms.Button SetRussian;
        private System.Windows.Forms.CheckBox Enable_Edit;
    }
}