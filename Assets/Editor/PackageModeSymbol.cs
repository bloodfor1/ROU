using MoonCommonLib;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class PackageModeSymbol {

    [InitializeOnLoadMethod]
    static void OnProjectLoadedInEditor()
    {
        if (Directory.Exists(DirectoryEx.Combine(Application.dataPath, "artres")))
        {
            EditorTools.RemoveSymbol("PACKAGE_MODE");
        }
        else
        {
            EditorTools.AddSymbol("PACKAGE_MODE");
        }
    }
}
