using System;
using System.Linq;
using MoonCommonLib;
using UnityEditor;
using UnityEngine;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

public static class EditorTools
{

    [MenuItem("ROTools/SceneTools/Pause %x")]
    static void Pause()
    {
        if (EditorApplication.isPaused)
        {
            EditorApplication.isPaused = false;
        }
        else
        {
            EditorApplication.isPaused = true;
        }
    }

    public static void ReplaceLuaManager()
    {
        string[] files = Directory.GetFiles(Application.dataPath + "/Scripts/Lua/ModuleMgr", "*.lua");
        foreach (var filePath in files)
        {
            List<string> contents = new List<string>();
            List<string> finalContents = new List<string>();
            List<int> funcLines = new List<int>();
            Dictionary<string, int> funcs = new Dictionary<string, int>();
            string tableName = "";
            using (StreamReader sr = new StreamReader(filePath))
            {
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    Match mc = Regex.Match(line, @"module\s*\(\s*""ModuleMgr\.(\w+)""");
                    if (mc != Match.Empty)
                    {
                        contents.Add("module(\"ModuleMgr\", package.seeall)");
                        contents.Add(string.Format("{0} = class(\"{0}\")", mc.Groups[1].Value));
                        tableName = mc.Groups[1].Value;
                        continue;
                    }

                    if (!string.IsNullOrEmpty(tableName))
                    {
                        mc = Regex.Match(line, @"\s*function\s*(\w+)\((.*)\)");
                        if (mc != Match.Empty)
                        {
                            if (!mc.Groups[1].Value.Contains(":"))
                            {
                                string funcName = mc.Groups[1].Value;
                                contents.Add(string.Format("function {0}.{1}({2})", tableName, funcName, mc.Groups[2].Value));
                                funcs[funcName] = contents.Count;
                                funcLines.Add(contents.Count);
                                continue;
                            }
                        }
                    }

                    contents.Add(line);
                }
            }

            using (StreamReader sr = new StreamReader(filePath))
            {
                string line;
                int inFunc = 0;
                for (int i = 0; i < contents.Count; i++)
                {
                    line = contents[i];
                    if (line.StartsWith("function"))
                    {
                        inFunc += 1;
                        finalContents.Add(line);
                        continue;
                    }else if (line.StartsWith("end"))
                    {
                        inFunc -= 1;
                        finalContents.Add(line);
                        continue;
                    }

                    if (inFunc > 0)
                    {
                        // 函数体内的方法
                        foreach (var funcPair in funcs)
                        {
                            MatchCollection mcs = Regex.Matches(line, string.Format(@"\s*({0})\s*\(", funcPair.Key));
                            for (int j = 0; j < mcs.Count; j++)
                            {
                                Match m = mcs[j];
                                if (m != Match.Empty)
                                {
                                    line = line.Replace(m.Groups[1].Value, string.Format("{0}.{1}", tableName, m.Groups[1].Value));
                                    break;
                                }
                            }
                        }
                    }
                    else
                    {
                        Match mcend = Regex.Match(line, @"(\w+)");
                        // 非函数体内声明的非局部变量
                        if (mcend != Match.Empty && mcend.Groups[1].Value == "local")
                        {
                            finalContents.Add(line);
                            continue;
                        }

                        mcend = Regex.Match(line, @"(\w+)\s*=\s*(.*)");
                        if (mcend != Match.Empty)
                        {
                            finalContents.Add(string.Format("{0}.{1} = {2}", tableName, mcend.Groups[1].Value, mcend.Groups[2].Value));
                            continue;
                        }
                    }
                    finalContents.Add(line);
                }
            }

            using (StreamWriter sw = new StreamWriter(filePath, false, Encoding.UTF8))
            {
                foreach (var line in finalContents)
                {
                    sw.WriteLine(line);
                }
            }
        }
    }

    public static void RemoveSymbol(string symbol)
    {
        var defineSymbolsStr = PlayerSettings.GetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup);
        var defineSymbols = defineSymbolsStr.Split(';').ToList();
        if (defineSymbols.Contains(symbol))
        {
            defineSymbols.Remove(symbol);
        }
        defineSymbolsStr = defineSymbols.Join(";");
        PlayerSettings.SetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup, defineSymbolsStr);
    }

    public static void AddSymbol(string symbol)
    {
        var defineSymbolsStr = PlayerSettings.GetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup);
        var defineSymbols = defineSymbolsStr.Split(';').ToList();
        if (!defineSymbols.Contains(symbol))
        {
            defineSymbols.Add(symbol);
        }
        defineSymbolsStr = defineSymbols.Join(";");
        PlayerSettings.SetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup, defineSymbolsStr);
    }

    public static bool HasSymbol(string symbol)
    {
        string symbolsString = PlayerSettings.GetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup);
        return symbolsString.Contains(symbol);
    }

    private static bool _avoidReimport = false;
    public static bool AvoidReimport
    {
        get => _avoidReimport;
        set
        {
            _avoidReimport = value;
            Debug.Log("value:" + value);
        }
    }


    public static void AvoidAutoRefreshAndImport(bool refresh)
    {
        EditorPrefs.SetBool("kAutoRefresh", refresh);
        AvoidReimport = !refresh;
        AssetDatabase.Refresh();
    }
}
