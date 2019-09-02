using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace SunkoEditor
{
    class Localization
    {
        private string tsFILE, tNew, tOpen, tSave, tSaveAs, tExit, tsPROGRAM, tRun, tCompile, tsTOOLS, tsSettings, tsEDIT, tUndo, tRedo, tCut, tCopy, tPaste, tSelectAll;
        private string stReady, stSaving, stOpening, stChange;
        private string swSetLanguage, swEnableEdit;
        private string formSettings;

        public static Localization English, Russian;

        public void SetFiels(Dictionary<string, string> dict)
        {
            tsFILE = dict["tsfile"];
            tNew = dict["tnew"];
            tOpen = dict["topen"];
            tSave = dict["tsave"];
            tSaveAs = dict["tsaveas"];
            tExit = dict["texit"];
            tsPROGRAM = dict["tsprogram"];
            tRun = dict["trun"];
            tCompile = dict["tcompile"];
            tsTOOLS = dict["tstools"];
            tsSettings = dict["tssettings"];
            stReady = dict["stready"];
            stSaving = dict["stsaving"];
            stOpening = dict["stopening"];
            stChange = dict["stchange"];
            swSetLanguage = dict["swsetlanguage"];
            formSettings = dict["formsettings"];
            tsEDIT = dict["tsedit"];
            tUndo = dict["tundo"];
            tRedo = dict["tredo"];
            tCut = dict["tcut"];
            tPaste = dict["tpaste"];
            tCopy = dict["tcopy"];
            tSelectAll = dict["tselectall"];
            swEnableEdit = dict["swenableedit"];
        }

        public Localization(string local)
        {
            var dict = new Dictionary<string, string>();
            //try
            //{
                foreach (var x in File.ReadAllLines(local).Select(x => x.Split('=')))
                {
                    dict.Add(x[0].ToLower(), x[1]);
                }
                //try
                {
                    SetFiels(dict);
                }
                //finally { }
            //}
            //finally { }
        }

        public Localization(Stream stream)
        {
            using (StreamReader reader = new StreamReader(stream))
            {
                var dict = new Dictionary<string, string>();
                foreach (var x in reader.ReadToEnd().Split(Environment.NewLine.Replace(((char)13).ToString(), "")[0]).Select(x => x.Split('=')))
                {
                    dict.Add(x[0].ToLower(), x[1]);
                }
                try
                {
                    SetFiels(dict);
                }
                finally { }
            }
        }

        static Localization()
        {
            var assembly = Assembly.GetExecutingAssembly();
            File.WriteAllLines("log.txt", assembly.GetManifestResourceNames());
            using (Stream stream = assembly.GetManifestResourceStream("SunkoEditor.Resources.english.lng")) English = new Localization(stream);
            using (Stream stream = assembly.GetManifestResourceStream("SunkoEditor.Resources.russian.lng")) Russian = new Localization(stream);
        }

        public string StReady { get => stReady; set => stReady = value; }
        public string StSaving { get => stSaving; set => stSaving = value; }
        public string StOpening { get => stOpening; set => stOpening = value; }
        public string StChange { get => stChange; set => stChange = value; }
        public string TsFILE { get => tsFILE; set => tsFILE = value; }
        public string TNew { get => tNew; set => tNew = value; }
        public string TOpen { get => tOpen; set => tOpen = value; }
        public string TSave { get => tSave; set => tSave = value; }
        public string TSaveAs { get => tSaveAs; set => tSaveAs = value; }
        public string TExit { get => tExit; set => tExit = value; }
        public string TsPROGRAM { get => tsPROGRAM; set => tsPROGRAM = value; }
        public string TRun { get => tRun; set => tRun = value; }
        public string SwSetLanguage { get => swSetLanguage; set => swSetLanguage = value; }
        public string FormSettings { get => formSettings; set => formSettings = value; }
        public string TsTOOLS { get => tsTOOLS; set => tsTOOLS = value; }
        public string TsSettings { get => tsSettings; set => tsSettings = value; }
        public string TsEDIT { get => tsEDIT; set => tsEDIT = value; }
        public string TUndo { get => tUndo; set => tUndo = value; }
        public string TRedo { get => tRedo; set => tRedo = value; }
        public string TCut { get => tCut; set => tCut = value; }
        public string TCopy { get => tCopy; set => tCopy = value; }
        public string TPaste { get => tPaste; set => tPaste = value; }
        public string TSelectAll { get => tSelectAll; set => tSelectAll = value; }
        public string SwEnableEdit { get => swEnableEdit; set => swEnableEdit = value; }
        public string TCompile { get => tCompile; set => tCompile = value; }
    }
}
