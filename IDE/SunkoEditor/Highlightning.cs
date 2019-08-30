using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace SunkoEditor
{
    internal class HObject
    {
        public string word;
        public Color rgb;
        public bool isbold;
        public HObject(string w, Color c, bool ib)
        {
            word = w;
            rgb = c;
            isbold = ib;
        }
    }
    internal static class Highlightning
    {
        public static HObject[] Hights;

        public static string[] TypeWords = { "int", "string", "date", "real" };
        public static string[] KeyWords = { "if", "then", "while", "do", "for", "to", "repeat", "until", "else" };
        public static string[] OperatorsWords = { "exit", "sunko", "end" };
        static Highlightning()
        {
            var lst = new List<HObject>();
            foreach (var x in TypeWords)
            {
                lst.Add(new HObject(x, Color.FromArgb(0, 0, 255), false));
            }
            foreach (var x in KeyWords)
            {
                lst.Add(new HObject(x, Color.FromArgb(0, 0, 255), true));
            }
            foreach (var x in OperatorsWords)
            {
                lst.Add(new HObject(x, Color.FromArgb(255, 0, 0), true));
            }
            Hights = lst.ToArray();
        }
    }
}
