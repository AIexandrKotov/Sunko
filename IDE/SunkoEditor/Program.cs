using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace SunkoEditor
{
    static class Program
    {
        public static string currentfile;
        /// <summary>
        /// Главная точка входа для приложения.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}
