using System.Collections;
using System.Collections.Generic;
using LitJson;
using MoonCommonLib;
using UnityEditor;
using UnityEngine;

public class PlatformConfigSign {

    [MenuItem("ROTools/Hotfix Tools/Sign MPlatformConfig")]
    public static void Sign()
    {
        MPlatformConfigManager.GetLocal(true).SaveLocal();
    }
}
