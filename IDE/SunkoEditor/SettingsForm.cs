using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace SunkoEditor
{
    public partial class SettingsForm : Form
    {
        internal Form1 refs;
        public SettingsForm()
        {
            InitializeComponent();
        }
        public SettingsForm(Form1 reference)
        {
            refs = reference;
            InitializeComponent();
            UseLocal(reference.Local);
            this.Enable_Edit.Checked = !refs.TextBoxShortcuts;
        }

        public void OnFormClosed(object sender, FormClosingEventArgs e)
        {
            refs.Enabled = true;
            return;
        }

        internal void UseLocal(Localization local)
        {
            SetLang.Text = local.SwSetLanguage;
            this.Text = local.FormSettings;
            this.Enable_Edit.Text = local.SwEnableEdit;
        }

        private void SetEnglish_Click(object sender, EventArgs e)
        {
            refs.UseLocal(Localization.English);
            UseLocal(Localization.English);
        }

        private void SetRussian_Click(object sender, EventArgs e)
        {
            refs.UseLocal(Localization.Russian);
            UseLocal(Localization.Russian);
        }

        private void Enable_Edit_CheckedChanged(object sender, EventArgs e)
        {
            if (Enable_Edit.Checked)
            {
                refs.TurnOnEdit();
            }
            else
            {
                refs.TurnOffEdit();
            }
        }
    }
}
