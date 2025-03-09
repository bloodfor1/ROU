//***************************

//文件名称(File Name)： AutoBuild.cs

//功能描述(Description)： 资源管理

//数据表(Tables)： nothing

//作者(Author)： zzr

//Create Date: 2017.08.10

//修改记录(Revision History)：
//* 这个文件待整理 todo @tm

//***************************
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEngine;
using MoonCommonLib;

#if UNITY_IOS
using UnityEditor.iOS.Xcode;
#endif

using System.IO;
using System.Linq;
using System.Xml.Linq;
using LitJson;
using System;
using System.Text;
using FMODUnity;
using System.Collections;

/// <summary>
/// 自动化-打包模块
/// </summary>
partial class AutoBuild
{
    /// <summary>
    /// 打包模式
    ///添加一种mode 需要在package.sh里面添加下列参数相应的值
    ///MODE_STR  DEBUG_STR  DEBUG_STR_BIGWORD
    /// </summary>
    private enum EPackageMode
    {
        None = -1,
        Debug = 0,
        Release = 1,
        Profiler = 2,
        Uwa = 3,
        Hdg = 4,
    }

    // android keystore密码
    public static string strKeyStoreName = "Assets/Plugins/Android/roandroid.keystore";

    public static string strChinaKeyAliasName = "ro-rexue";
    public static string strKoreaKeyAliasName = "korea-ro-rexue";
    public static string strKoreaCBTKeyAliasName = "korea-cbt-ro-rexue";
    public static string strKoreaONESKeyAliasName = "korea-ones-ro-rexue";
    public static string strKeyStorePass = "Ro123uoR$";
    public static string strKeyAliasPass = "Ro123uoR$";

    /// <summary>
    /// 导出路径
    /// </summary>
    private static string strExportPath = "";

    private static EPackageMode mode = EPackageMode.Release;
    private static BuildTarget buildTarget = BuildTarget.StandaloneWindows64;
    private static int mainVersion = 0;
    private static int bigVersion = 0;
    private static int innerVersion = 0;
    private static int versionCode = 1;

    private static MGameArea gameArea = MGameArea.China;
    private static MGameLanguage gameLanguage = MGameLanguage.Chinese;
    private static string gameChannelCode = "ro_inner";

    #region 强更与热更

    private static MUpdateWay programUpdateType = MUpdateWay.None;
    private static string programUpdateAddress = null;
    private static string programPreUpdateAddress = null;
    private static string programUpdateChannelId = null;
    private static MUpdateWay hotUpdateType = MUpdateWay.None;
    private static string hotUpdateAddress = null;
    private static string hotPreUpdateAddress = null;
    private static string hotUpdateChannelId = null;

    #endregion 强更与热更

    private static bool enableDllHotfix = false;
    private static bool enableAutoTest = false;
    private static bool useIl2cpp = false;
    private static string bundleId = "com.joyyou.ro";
    private static bool isOpenGM = true;
    private static EMZipMode zipMode = EMZipMode.UNZIP;
    private static EMABMode abMode = EMABMode.BLOCK;
    private static string apiDomain = "";
    private static bool useObb = false;
    private static bool exportAS = false;
    
    public static bool iOSDistribution = false; //当前是dev包还是dist包 默认是dev的包

    public static bool ENABLE_MSDK = false;
    public static bool ENABLE_LEIBIAN = false;
    public static bool ENABLE_KOREASDK = false;

    public static string AndroidSdkPath = "";
    public static string AndroidNdkPath = "";
    public static string JdkPath = "";

    #region 对外开放的打包接口

#if UNITY_IOS
    // ios gamelibs 编译
    static void UpdateGameLibsXcodeProj()
    {
        var projectPath = MSysEnvHelper.GetEnvParam("MoonGameLibPath") + "/buildtool/build_ios/ROGameLib.xcodeproj/project.pbxproj";
        PBXProject pbxProject = new PBXProject();
        pbxProject.ReadFromFile(projectPath);
        string targetGuid = pbxProject.TargetGuidByName("rocommongamelibs");

        // 关闭Bitcode
        pbxProject.SetBuildProperty(targetGuid, "ENABLE_BITCODE", "NO");
        pbxProject.SetBuildProperty(targetGuid, "LIBRARY_SEARCH_PATHS", MSysEnvHelper.GetEnvParam("MoonGameLibPath") + "/lib/ios/");

        // 添加link libraries的build phase
        pbxProject.AddFrameworksBuildPhase(targetGuid);

        //添加lib
        // AddLibToProject(pbxProject, targetGuid, "libprotobuf-lite.a");
        AddLibToProject(pbxProject, targetGuid, "libluajit.a");

        // 应用修改
        File.WriteAllText(projectPath, pbxProject.WriteToString());
    }

    static void AddLibToProject(PBXProject inst, string targetGuid, string lib)
    {
        string fileGuid = inst.AddFile("lib/ios/" + lib, "lib/ios/" + lib, PBXSourceTree.Source);
        inst.AddFileToBuild(targetGuid, fileGuid);
    }
#endif
    private static void SwitchPlatform(BuildTargetGroup group,BuildTarget targetPlatform)
    {
        if (EditorUserBuildSettings.activeBuildTarget != targetPlatform)
        {
            MDebug.singleton.AddLog("SwitchPlatform To Target Platform");
            bool ret = EditorUserBuildSettings.SwitchActiveBuildTarget(group, targetPlatform);
            if (ret)
            {
                EditorApplication.Exit(0);
            }
            else
            {
                EditorApplication.Exit(1);
            }
        }
    }
    private static void SwitchIOS()
    {
        bool ret = EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.iOS, BuildTarget.iOS);
        if (ret)
        {
            EditorApplication.Exit(0);
        }
        else
        {
            EditorApplication.Exit(1);
        }
    }

    private static void SwitchAndroid()
    {
        bool ret = EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.Android, BuildTarget.Android);
        if (ret)
        {
            EditorApplication.Exit(0);
        }
        else
        {
            EditorApplication.Exit(1);
        }
    }

    [MenuItem("ROTools/ABTools/Enable Run With Dll")]
    public static void EnableDllHotfix()
    {
        File.Move(DirectoryEx.Combine(Application.dataPath, "Plugins/GameLibs/MoonClient.dll"),
            DirectoryEx.Combine(Application.dataPath, "Resources/MoonClient.bytes"));
        XDocument xDoc = XDocument.Load(DirectoryEx.Combine(Application.dataPath, "link.xml"));
        xDoc.Root?.Elements()?.Where(e => e?.Attribute("fullname")?.Value == "MoonClient").Remove();
        xDoc.Save(DirectoryEx.Combine(Application.dataPath, "link.xml"));
    }

    [MenuItem("ROTools/ABTools/Build IOS")]
    public static void BuildIOS()
    {
        try
        {
            buildTarget = BuildTarget.iOS;
            SwitchPlatform(BuildTargetGroup.iOS, buildTarget);
            CommonPipeline();
            SetBundleVersion();
            SetProductName();

            if (strExportPath == "")
            {
                strExportPath = "xcode";
            }
            var errorReport = BuildPipeline.BuildPlayer(GetBuildScenes(), strExportPath, buildTarget, GetBuildOptions());
            ResetParameters();
            PrintErrorLog(errorReport.summary.result);
        }
        catch (Exception ex)
        {
            MDebug.singleton.AddErrorLog(ex.ToString());
            EditorApplication.Exit(1);
        }
    }

    // 注意：在BuildOptions是Development时这个设置无效...，会默认使用debug.keystore
    public static void SetKeystore()
    {
        MDebug.singleton.AddLogF("Step:SetKeystore bundleId = {0}", bundleId);
        PlayerSettings.Android.keystoreName = strKeyStoreName;
        if (bundleId.Equals("com.tencent.ro") || bundleId.Equals("com.joyyou.ro"))
        {
            PlayerSettings.Android.keyaliasName = strChinaKeyAliasName;
        }
        else if (bundleId.Equals("com.gravity.ragnarokorigin.aos"))
        {
            PlayerSettings.Android.keyaliasName = strKoreaKeyAliasName;
        }
        else if (bundleId.Equals("com.gravity.roo.cbt.aos"))
        {
            PlayerSettings.Android.keyaliasName = strKoreaCBTKeyAliasName;
        }
        else if (bundleId.Equals("com.gravity.ragnarokorigin.one"))
        {
            PlayerSettings.Android.keyaliasName = strKoreaONESKeyAliasName;
        }
        PlayerSettings.keystorePass = strKeyStorePass;
        PlayerSettings.keyaliasPass = strKeyAliasPass;
    }

    [MenuItem("ROTools/ABTools/Build Android")]
    public static void BuildAndroid()
    {
        try
        {
            buildTarget = BuildTarget.Android;
            SwitchPlatform(BuildTargetGroup.Android, buildTarget);

            EditorUserBuildSettings.androidETC2Fallback = AndroidETC2Fallback.Quality16Bit;
            CommonPipeline();
            SetKeystore();
            SetBundleVersion();
            SetProductName();

            if (GameLaunch.NotShowLaunchMovieAtStart == false)
            {
                AssetDatabaseDeleteAsset(@"Assets/StreamingAssets/Movie/launch.mp4");
            }
            else
            {
                AssetDatabaseDeleteAsset(@"Assets/Plugins/Android/res/raw/launch.mp4");
            }

            if (strExportPath == "")
            {
                strExportPath = "apk";
            }

            var errorReport = BuildPipeline.BuildPlayer(GetBuildScenes(), strExportPath, buildTarget, GetBuildOptions());
            ResetParameters();
            MDebug.singleton.AddLogF(errorReport.ToString());
            PrintErrorLog(errorReport.summary.result);
        }
        catch (Exception ex)
        {
            MDebug.singleton.AddErrorLog(ex.ToString());
            EditorApplication.Exit(1);
        }
    }

    [PostProcessBuild(999)]
    public static void OnPostProcessBuild(BuildTarget target, string pathToBuiltProject)
    {
#if UNITY_ANDROID
        var moonClientPackProjPath = MSysEnvHelper.GetEnvParam("MoonClientPackProjPath");
        var moonSdkLibPath = MSysEnvHelper.GetEnvParam("MoonSdkLibPath");
        string srcPath = Path.Combine(moonClientPackProjPath, "Temp/StagingArea/symbols");
        string destPath = Path.Combine(moonSdkLibPath, "Tools/AndroidSymbols/il2cppSymbols");
        if (Directory.Exists(srcPath) && Directory.Exists(destPath))
        {
            DirectoryEx.DirectoryCopy(srcPath, destPath, true, overrideFile: true);
            MDebug.singleton.AddLogF("AutoBuild OnPostProcessBuild il2cppSymbols srcPath = {0}, destPath = {1} copy successed", srcPath, destPath);
        }
        else
        {
            MDebug.singleton.AddLogF("AutoBuild OnPostProcessBuild il2cppSymbols srcPath = {0}, destPath = {1} copy failed", srcPath, destPath);
        }
        srcPath = Path.Combine(moonClientPackProjPath, "Temp/StagingArea/libs");
        destPath = Path.Combine(moonSdkLibPath, "Tools/AndroidSymbols/unityLibsSymbols");
        if (Directory.Exists(srcPath) && Directory.Exists(destPath))
        {
            DirectoryEx.DirectoryCopy(srcPath, destPath, true, overrideFile: true);
            MDebug.singleton.AddLogF("AutoBuild OnPostProcessBuild unityLibsSymbols srcPath = {0}, destPath = {1} copy successed", srcPath, destPath);
        }
        else
        {
            MDebug.singleton.AddLogF("AutoBuild OnPostProcessBuild unityLibsSymbols srcPath = {0}, destPath = {1} copy failed", srcPath, destPath);
        }
#endif
    }

    #region PC Pack

    /// <summary>
    /// 提供给ci接口
    /// </summary>
    public static void BuildPCForCIWithoutBuildDll()
    {
        if (buildPC(false))
        {
            EditorApplication.Exit(0);
        }
        else
        {
            EditorApplication.Exit(1);
        }
    }

    [MenuItem("ROTools/ABTools/PC包/打PC包")]
    public static void BuildPCWithoutBuildDll()
    {
        buildPC(false);
    }

    [MenuItem("ROTools/ABTools/PC包/打PC包+编译dll(需要配置msbuild+代码权限)")]
    public static void BuildPCWithBuildDll()
    {
        buildPC(true);
    }

    [MenuItem("ROTools/ABTools/PC包/编译PC包DLL(需要配置msbuild+代码权限)")]
    public static void BuildDllForPCMenu()
    {
#if UNITY_EDITOR_WIN
        EditorUtility.DisplayProgressBar("编译C# DLL", "开始编译MoonClient.dll与MoonCommonLib.dll", 0);
        if (buildDllForPC())
        {
            EditorUtility.DisplayDialog("编译pc包dll", "编译pc包dll成功", "确定");
        }
        else
        {
            EditorUtility.DisplayDialog("编译pc包dll", "编译pc包dll失败", "确定");
        }
        EditorUtility.ClearProgressBar();
#endif
    }

#endregion PC Pack

#endregion 对外开放的打包接口

    // 出包

#region 内部使用函数

    private static void AddUniqueSdkSymbol(string sdkSymbol)
    {
        if (!EditorTools.HasSymbol(sdkSymbol))
        {
            EditorTools.AddSymbol(sdkSymbol);
        }
    }

    /// <summary>
    /// 解析unity3d的build选项
    ///
    /// build_out_path=输出路径 debug 开启Debug模式
    ///
    /// <example>
    /// 例如: build_out_path-$SCRIPT_DIR/../../game/xcode debug</example>
    /// </summary>
    private static void AnalysisParameters()
    {
        string packConfigJsonPath = DirectoryEx.Combine(MSysEnvHelper.GetEnvParam("MoonClientProjPath"), "../pack_config.json");
        var packConfigJson = FileEx.ReadText(packConfigJsonPath);
        if (packConfigJson == null)
        {
            MDebug.singleton.AddErrorLogF("AutoBuild AnalysisParameters Error {0} not exits", packConfigJsonPath);
            EditorApplication.Exit(1);
            return;
        }

        JsonData jsonData = JsonMapper.ToObject(packConfigJson);
        IDictionary dict = jsonData as IDictionary;
        MDebug.singleton.AddGreenLogF("AutoBuild AnalysisParameters Log Json Data Start -----------------------------");
        string dictStr = "";
        foreach (string key in dict.Keys)
        {
            dictStr = dictStr + "[" + key.ToString() + ":" + dict[key: key].ToString() + "] ";
        }
        MDebug.singleton.AddLogF(dictStr);
        MDebug.singleton.AddGreenLogF("AutoBuild AnalysisParameters Log Json Data End -----------------------------");

        if (dict.Contains("build_out_path"))
        {
            strExportPath = dict["build_out_path"].ToString();
        }
        if (dict.Contains("mode"))
        {
            bool isSuccess = int.TryParse(dict["mode"].ToString(), out int buildMode);
            if (isSuccess)
            {
                mode = (EPackageMode)buildMode;
            }
        }
        if (dict.Contains("main_version"))
        {
            mainVersion = int.Parse(dict["main_version"].ToString());
        }
        if (dict.Contains("big_version"))
        {
            bigVersion = int.Parse(dict["big_version"].ToString());
        }
        if (dict.Contains("inner_version"))
        {
            innerVersion = int.Parse(dict["inner_version"].ToString());
        }
        if (dict.Contains("version_code"))
        {
            versionCode = int.Parse(dict["version_code"].ToString());
        }
        if (dict.Contains("update_type"))
        {
            var typeNumber = int.Parse(dict["update_type"].ToString());
            switch (typeNumber)
            {
                case 1:
                    programUpdateType = MUpdateWay.None;
                    hotUpdateType = MUpdateWay.None;
                    break;

                case 2:
                    programUpdateType = MUpdateWay.Internal;
                    hotUpdateType = MUpdateWay.Internal;
                    break;

                case 3:
                    programUpdateType = MUpdateWay.Dolphin;
                    hotUpdateType = MUpdateWay.Dolphin;
                    break;

                case 4:
                    programUpdateType = MUpdateWay.LeBian;
                    hotUpdateType = MUpdateWay.LeBian;
                    break;

                default:
                    programUpdateType = MUpdateWay.None;
                    hotUpdateType = MUpdateWay.None;
                    break;
            }
        }
        if (dict.Contains("update_checkurl"))
        {
            programUpdateAddress = dict["update_checkurl"].ToString();
            hotUpdateAddress = dict["update_checkurl"].ToString();
        }
        if (dict.Contains("pre_update_checkurl"))
        {
            programPreUpdateAddress = dict["pre_update_checkurl"].ToString();
            hotPreUpdateAddress = dict["pre_update_checkurl"].ToString();
        }
        if (dict.Contains("update_cid"))
        {
            programUpdateChannelId = dict["update_cid"].ToString();
            hotUpdateChannelId = dict["update_cid"].ToString();
        }
        if (dict.Contains("dllhotfix"))
        {
            if (int.Parse(dict["dllhotfix"].ToString()) == 1)
            {
                enableDllHotfix = true;
            }
        }
        if (dict.Contains("autotest"))
        {
            if (int.Parse(dict["autotest"].ToString()) == 1)
            {
                enableAutoTest = true;
            }
        }
        if (dict.Contains("il2cpp"))
        {
            if (int.Parse(dict["il2cpp"].ToString()) == 1)
            {
                useIl2cpp = true;
            }
        }
        if (dict.Contains("closegm"))
        {
            if (int.Parse(dict["closegm"].ToString()) == 1)
            {
                isOpenGM = false;
            }
        }
        if (dict.Contains("obb"))
        {
            if (int.Parse(dict["obb"].ToString()) == 1)
            {
                useObb = true;
            }
        }
        if (dict.Contains("export_as"))
        {
            if (int.Parse(dict["export_as"].ToString()) == 1)
            {
                exportAS = true;
            }
        }
        if (dict.Contains("target_area"))
        {
            bool isSuccess = int.TryParse(dict["target_area"].ToString(), out int areaInt);
            if (isSuccess)
            {
                gameArea = (MGameArea)areaInt;
            }
        }
        if (dict.Contains("target_language"))
        {
            bool isSuccess = int.TryParse(dict["target_language"].ToString(), out int languageInt);
            if (isSuccess)
            {
                gameLanguage = (MGameLanguage)languageInt;
            }
        }
        if (dict.Contains("bundle_id"))
        {
            bundleId = dict["bundle_id"].ToString();
        }
        if (dict.Contains("channel"))
        {
            gameChannelCode = dict["channel"].ToString();
        }
        if (dict.Contains("enable_msdk"))
        {
            bool.TryParse(dict["enable_msdk"].ToString(), out ENABLE_MSDK);
        }
        if (dict.Contains("enable_msdk"))
        {
            bool.TryParse(dict["enable_lebian"].ToString(), out ENABLE_LEIBIAN);
        }
        if (dict.Contains("enable_koreasdk"))
        {
            bool.TryParse(dict["enable_koreasdk"].ToString(), out ENABLE_KOREASDK);
        }
        if (dict.Contains("zip_mode"))
        {
            bool isSuccess = int.TryParse(dict["zip_mode"].ToString(), out int mode);
            if (isSuccess)
            {
                zipMode = (EMZipMode)mode;
            }
            else
            {
#if UNITY_IOS
                zipMode = EMZipMode.PACKAGE;
#else
                zipMode = EMZipMode.UNZIP;
#endif
            }
        }
        if (dict.Contains("ab_mode"))
        {
            bool isSuccess = int.TryParse(dict["ab_mode"].ToString(), out int mode);
            if (isSuccess)
            {
                abMode = (EMABMode)mode;
            }
            else
            {
                abMode = EMABMode.BLOCK;
            }
        }
        if (dict.Contains("api_domain"))
        {
            apiDomain = dict["api_domain"].ToString();
        }
        if (dict.Contains("distribute_mode"))
        {
            if (dict["distribute_mode"].ToString().Equals("1"))
            {
                iOSDistribution = true;
            }
        }
        if (dict.Contains("androidSdkPath"))
        {
            AndroidSdkPath = dict["androidSdkPath"].ToString();
        }
        if (dict.Contains("androidNdkPath"))
        {
            AndroidSdkPath = dict["androidNdkPath"].ToString();
        }
        if (dict.Contains("jdkPath"))
        {
            AndroidSdkPath = dict["jdkPath"].ToString();
        }

        //兼容之前的打包流程
        EditorPrefs.SetString("AndroidSdkRoot", AndroidSdkPath != "" ? AndroidSdkPath : "/Users/jenkins/Library/Android/sdk");
        EditorPrefs.SetString("AndroidNdkRoot", AndroidNdkPath != "" ? AndroidNdkPath : "/Users/jenkins/Library/Android/android-ndk-r16b");
        EditorPrefs.SetString("JdkPath", JdkPath != "" ? JdkPath : "/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home");
    }

    /// <summary>
    /// 重置build选项
    /// </summary>
    private static void ResetParameters()
    {
        strExportPath = "";
        mode = EPackageMode.None;
        mainVersion = 0;
        bigVersion = 0;
        innerVersion = 0;
        versionCode = 1;
        gameArea = MGameArea.China;
        gameLanguage = MGameLanguage.Chinese;
        gameChannelCode = "ro_inner";
        programUpdateType = MUpdateWay.None;
        programUpdateAddress = null;
        programUpdateChannelId = null;
        hotUpdateType = MUpdateWay.None;
        hotUpdateAddress = null;
        hotUpdateChannelId = null;
        enableDllHotfix = false;
        enableAutoTest = false;
        useIl2cpp = false;
        abMode = EMABMode.BLOCK;
        zipMode = EMZipMode.UNZIP;
        apiDomain = "";
        useObb = false;
    }

    /// <summary>
    /// 获取所有可用的场景文件
    /// </summary>
    /// <returns></returns>
    private static string[] GetBuildScenes()
    {
        List<string> sceneNames = new List<string>();
        foreach (EditorBuildSettingsScene e in EditorBuildSettings.scenes)
        {
            if (e == null)
                continue;
            if (e.enabled && IsNeedThisScene(e.path))
            {
                sceneNames.Add(e.path);
            }
        }

        var defineSymbolsStr = PlayerSettings.GetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup);
        MDebug.singleton.AddLogF("build param:defineSymbolsStr:{0} | sceneNames:{1}", defineSymbolsStr, sceneNames.ConverToString());

        bool isHasNotFinded = (IsUwaMode() || IsHdgMode());
        foreach (var val in sceneNames)
        {
            if (IsHdgMode())
            {
                if (val.Contains("GameEntryHdg"))
                {
                    isHasNotFinded = false;
                }
            }
        }
        if (isHasNotFinded)
        {
            MDebug.singleton.AddLogF("mode:{0} dont finded scene!!!", mode);
        }
        return sceneNames.ToArray();
    }

    /// <summary>
    /// 把所有的场景文件加到可build列表（给任务用的）
    /// </summary>
    [MenuItem("ROTools/SceneTools/刷新场景到EditorBuildSetting")]
    public static void AddScenesToBuildSetting()
    {
        var pathList = Directory.GetFiles($"{MResMgr.ResourcePrePath}Scenes", "*.unity", SearchOption.AllDirectories);
        var sceneList = EditorBuildSettings.scenes.ToList();
        var scenePathList = sceneList.Select(s => s.path);
        foreach (var path in pathList)
        {
            var index = path.LastIndexOf("Assets");
            var finalPath = path.Substring(index);
            if (!scenePathList.Contains(finalPath))
            {
                sceneList.Add(new EditorBuildSettingsScene(finalPath, true));
            }
        }
        EditorBuildSettings.scenes = sceneList.ToArray();
        AssetDatabase.SaveAssets();
    }

    /// <summary>
    /// 是否需要这个场景
    /// </summary>
    /// <param name="e"></param>
    /// <returns></returns>
    private static bool IsNeedThisScene(string path)
    {
        if (!File.Exists(path))
        {
            return false;
        }

        if (path.Contains("GameEntryHdg.unity"))
        {
            return IsHdgMode();
        }

        return true;
    }

    /// <summary>
    /// 获取构建选项
    /// </summary>
    /// <returns></returns>
    private static BuildOptions GetBuildOptions()
    {
        BuildOptions options = BuildOptions.None;
        if (IsProfilerMode())
        {
            options |= BuildOptions.Development;
            options |= BuildOptions.ConnectWithProfiler;
            if (Application.platform == RuntimePlatform.IPhonePlayer)
            {
                options |= BuildOptions.SymlinkLibraries;
            }
        }
        else if (IsUwaMode() || IsDebugMode())   //uwa 操作设置
        {
            // 注：这个设置会导致使用默认的debug.keystore，所以打包机上的~/.android目录下的debug.keystore要换成我们自己的keystore
            options |= BuildOptions.Development;
        }
        if (exportAS)
        {
            options |= BuildOptions.AcceptExternalModificationsToPlayer;
        }

        return options;
    }

    private static bool IsOpenTraceLog()
    {
        return (IsDebugMode() || IsHdgMode());
    }

    private static void CloseTraceLogType()
    {
        PlayerSettings.SetStackTraceLogType(LogType.Log, StackTraceLogType.None);
        PlayerSettings.SetStackTraceLogType(LogType.Warning, StackTraceLogType.None);
    }

    private static void GenerateConfig()
    {
        GetPlatformConfig();

        GeneratePlayerSettings();

        AssetDatabase.Refresh();
        AssetDatabase.ImportAsset("Assets/Resources/config.json");
        MDebug.singleton.AddLogF("result config:{0}|mode:{1}", JsonMapper.ToJson(MPlatformConfigManager.GetLocal(true)), mode);
    }

    private static void GeneratePlayerSettings()
    {
        if (IsReleaseMode()) // release关掉debug和warning日志
        {
            CloseTraceLogType();
            EditorTools.RemoveSymbol("DEBUG");
        }

        if (IsDebugMode())
        {
            EditorTools.AddSymbol("DEBUG");
        }
        else
        {
            EditorTools.RemoveSymbol("DEBUG");
        }

        if (IsProfilerMode())
        {
            PlayerSettings.enableInternalProfiler = true;
        }
        else
        {
            PlayerSettings.enableInternalProfiler = false;
        }

        if (IsUwaMode())   //uwa 操作设置
        {
            EditorTools.AddSymbol("UWA_TEST");
            CloseTraceLogType();
            PlayerSettings.SetManagedStrippingLevel(BuildTargetGroup.Android, ManagedStrippingLevel.Disabled);
            PlayerSettings.enableInternalProfiler = true;
        }
        else
        {
            EditorTools.RemoveSymbol("UWA_TEST");
        }

        if (IsHdgMode())
        {
            EditorTools.AddSymbol("HDG_TEST");
        }
        else
        {
            EditorTools.RemoveSymbol("HDG_TEST");
        }

        if (IsOpenTraceLog())
        {
            EditorTools.AddSymbol("TRACE_LOG");
        }
        else
        {
            EditorTools.RemoveSymbol("TRACE_LOG");
        }

        var symbolENABLE_AUTOTEST = "ENABLE_AUTOTEST";
        if (enableAutoTest)
        {
            EditorTools.AddSymbol(symbolENABLE_AUTOTEST);
        }
        else
        {
            EditorTools.RemoveSymbol(symbolENABLE_AUTOTEST);
        }


        // 设置架构和编译方式
        if (IsAndroidPlatform())
        {
            AndroidArchitecture aac = AndroidArchitecture.ARMv7;
            if (useIl2cpp) // il2cpp才支持arm64
            {
                PlayerSettings.SetScriptingBackend(EditorUserBuildSettings.selectedBuildTargetGroup, ScriptingImplementation.IL2CPP);
                if (!(useObb && IsDebugMode())) // debug模式的小包就不打arm64了，会超过100m
                {
                    aac |= AndroidArchitecture.ARM64;
                }
            }
            else
            {
                PlayerSettings.SetScriptingBackend(BuildTargetGroup.Android, ScriptingImplementation.Mono2x);
                aac |= AndroidArchitecture.X86;
            }
            PlayerSettings.Android.targetArchitectures = aac;
        }

        if (!string.IsNullOrEmpty(bundleId))
        {
            PlayerSettings.applicationIdentifier = bundleId;
        }
    }

    private static MPlatformConfig GetPlatformConfig()
    {
        MPlatformConfig config = MPlatformConfigManager.GetLocal();
        config.bundleId = bundleId;
        config.channel = gameChannelCode;
        config.area = gameArea;
        config.language = gameLanguage;
        config.apiDomain = apiDomain;
        config.mode.SetPackageMode(IsDebugMode(), isOpenGM, IsDebugMode(), useObb);
        config.mode.zipMode = zipMode;
        config.mode.abMode = abMode;
        config.version = new MVersion(mainVersion, bigVersion, innerVersion, 0);
        config.programUpdate.type = programUpdateType;
        config.programUpdate.serverUrl = programUpdateAddress;
        config.programUpdate.preServerUrl = programPreUpdateAddress;
        config.programUpdate.channelId = programUpdateChannelId;
        config.hotUpdate.type = hotUpdateType;
        config.hotUpdate.serverUrl = hotUpdateAddress;
        config.hotUpdate.preServerUrl = hotPreUpdateAddress;
        config.hotUpdate.channelId = hotUpdateChannelId;
        config.SaveLocal();
        return config;
    }

    /// <summary>
    /// 过滤BuildSetting添加的场景,删除相关的 *.unit文件
    /// </summary>
    private static void FilterUnusedScene()
    {
        foreach (EditorBuildSettingsScene e in EditorBuildSettings.scenes)
        {
            if (e == null)
            {
                continue;
            }
            if (!string.IsNullOrEmpty(e.path) && !IsNeedThisScene(e.path))
            {
                AssetDatabaseDeleteAsset(e.path);
            }
        }
    }

    private static void DeleteAsset()
    {
        if (!IsUwaMode())
        {
            DeleteUwaAssets();
        }
        if (!IsHdgMode())
        {
            DeleteHdgAssets();
        }
        if (!enableAutoTest)
        {
            DeleteAutoTestAssets();
        }
        DeleteFmodAssets();
    }

    /// <summary>
    /// 删除fmod相关的Asset文件
    /// </summary>
    private static void DeleteFmodAssets()
    {
#if UNITY_IOS
        //if (IsProfilerMode() || IsUwaMode() || IsDebugMode())
        //{
        //    AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/ios/libfmodstudiounityplugin.a");
        //}
        //else
        //{
        //    AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/ios/libfmodstudiounitypluginL.a");
        //}
        AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/ios/libfmodstudiounitypluginL.a");
#endif
#if UNITY_ANDROID
        if (IsProfilerMode() || IsUwaMode() || IsDebugMode())
        {
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/x86/libfmod.so");
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/x86/libfmodstudio.so");
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/armeabi-v7a/libfmod.so");
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/armeabi-v7a/libfmodstudio.so");
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/arm64-v8a/libfmod.so");
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/arm64-v8a/libfmodstudio.so");
        }
        else
        {
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/x86/libfmodL.so");
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/x86/libfmodstudioL.so");
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/armeabi-v7a/libfmodL.so");
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/armeabi-v7a/libfmodstudioL.so");
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/arm64-v8a/libfmodL.so");
            AssetDatabaseDeleteAsset("Assets/Plugins/FMOD/lib/android/arm64-v8a/libfmodstudioL.so");
        }
#endif
    }

    /// <summary>
    /// 删除uwa相关的Asset文件
    /// </summary>
    private static void DeleteUwaAssets()
    {
        AssetDatabaseDeleteAsset(@"Assets/ThirdParty/UWA");
        AssetDatabaseDeleteAsset(@"Assets/Plugins/Android/libs/x86/libuwa.so");
        AssetDatabaseDeleteAsset(@"Assets/Plugins/Android/libs/armeabi-v7a/libuwa.so");
        AssetDatabaseDeleteAsset(@"Assets/Plugins/Android/libs/arm64-v8a/libuwa.so");
    }

    /// <summary>
    /// 删除autotest相关的Asset文件
    /// </summary>
    private static void DeleteAutoTestAssets()
    {
        AssetDatabaseDeleteAsset(@"Assets/Plugins/Poco-SDK");
    }

    /// <summary>
    /// 删除hdg相关的Asset文件
    /// </summary>
    private static void DeleteHdgAssets()
    {
        AssetDatabaseDeleteAsset(@"Assets/Plugins/HdgRemoteDebug");
    }

    /// <summary>
    /// 删除某个资源
    /// </summary>
    /// <param name="assetPath"></param>
    private static void AssetDatabaseDeleteAsset(string assetPath)
    {
        if (AssetDatabase.DeleteAsset(assetPath))
        {
            MDebug.singleton.AddLogF($"albertyuan AssetDatabase.DeleteAsset:{assetPath}");
        }
        else
        {
            MDebug.singleton.AddLogF($"---albertyuan DeleteAsset failed assetPath:{assetPath}");
        }
    }

    private static void doStreamingAssetsCopy()
    {
        var fullProjPath = MSysEnvHelper.GetEnvParam("MoonClientProjPath");
        var streamingDir = "Assets/StreamingAssets";
        if (IsAndroidPlatform() && exportAS)
        {
            string saPath = DirectoryEx.Combine(strExportPath, "ROAndroidProject/src/main/assets");
            DirectoryEx.DeleteDirectorySafely(DirectoryEx.Combine(saPath, streamingDir));
            DirectoryEx.DirectoryCopy(DirectoryEx.Combine(fullProjPath, streamingDir), saPath, true, overrideFile: true);
        }
        else
        {
            var packProjPath = MSysEnvHelper.GetEnvParam("MoonClientPackProjPath");
            DirectoryEx.DeleteDirectorySafely(DirectoryEx.Combine(packProjPath, streamingDir));
            DirectoryEx.DirectoryCopy(DirectoryEx.Combine(fullProjPath, streamingDir), DirectoryEx.Combine(packProjPath, streamingDir), true, overrideFile: true);
        }
    }

    /// <summary>
    /// 处理打包工程的拷贝
    /// </summary>
    private static void doPackProjCopy()
    {
        if (IsAndroidPlatform() && enableDllHotfix)
        {
            EnableDllHotfix();
        }

        // 拷贝ZipList.json，因为这个json是在打mergebundle时生成的
        var fullProjPath = MSysEnvHelper.GetEnvParam("MoonClientProjPath");
        var packProjPath = MSysEnvHelper.GetEnvParam("MoonClientPackProjPath");
        File.Copy(DirectoryEx.Combine(fullProjPath, "Assets/Resources/ZipList.json"), DirectoryEx.Combine(packProjPath, "Assets/Resources/ZipList.json"), true);

        asyncFModResource();

        AssetDatabase.Refresh();
    }

    public static void asyncFModResource()
    {
        if (!MGameContext.singleton.IsMainChannel)
        {
            var bankPath = PathEx.GetChannelArtPathEx(MGameContext.singleton.CurrentChannel, "_FMod");
            var mobilePath = PathEx.MakePathStandard(DirectoryEx.Combine(bankPath, "Mobile"));
            Debug.Log($"asyncFModResource bankPath:{bankPath} -> {Directory.Exists(bankPath)} mobilePath:{mobilePath} -> {Directory.Exists(mobilePath)}");
            if (Directory.Exists(bankPath) && Directory.Exists(mobilePath))
            {
                // 检查是否存在文件
                var masterBank = "MasterBank";
                if (Directory.GetFiles(mobilePath, "*.bank", SearchOption.TopDirectoryOnly).Any(s => Path.GetFileNameWithoutExtension(s) == masterBank))
                {
                    var realPath = PathEx.MakePathStandard(MakePathRelative(bankPath));
                    Settings.Instance.SourceProjectPath = realPath;
                    Settings.Instance.SourceBankPath = realPath;
                    Debug.Log($"RefreshBanks:{realPath}");
                    EventManager.RefreshBanks();
                }
            }
        }
    }

    private static string MakePathRelative(string path)
    {
        if (string.IsNullOrEmpty(path))
            return "";
        string fullPath = Path.GetFullPath(path);
        string fullProjectPath = Path.GetFullPath(Environment.CurrentDirectory + Path.DirectorySeparatorChar);

        // If the path contains the Unity project path remove it and return the result
        if (fullPath.Contains(fullProjectPath))
        {
            return fullPath.Replace(fullProjectPath, "");
        }
        // If not, attempt to find a relative path on the same drive
        else if (Path.GetPathRoot(fullPath) == Path.GetPathRoot(fullProjectPath))
        {
            // Remove trailing slash from project path for split count simplicity
            if (fullProjectPath.EndsWith(Path.DirectorySeparatorChar.ToString(), StringComparison.CurrentCulture)) fullProjectPath = fullProjectPath.Substring(0, fullProjectPath.Length - 1);

            string[] fullPathSplit = fullPath.Split(Path.DirectorySeparatorChar);
            string[] projectPathSplit = fullProjectPath.Split(Path.DirectorySeparatorChar);
            int minNumSplits = Mathf.Min(fullPathSplit.Length, projectPathSplit.Length);
            int numCommonElements = 0;
            for (int i = 0; i < minNumSplits; i++)
            {
                if (fullPathSplit[i] == projectPathSplit[i])
                {
                    numCommonElements++;
                }
                else
                {
                    break;
                }
            }
            string result = "";
            int fullPathSplitLength = fullPathSplit.Length;
            for (int i = numCommonElements; i < fullPathSplitLength; i++)
            {
                result += fullPathSplit[i];
                if (i < fullPathSplitLength - 1)
                {
                    result += '/';
                }
            }

            int numAdditionalElementsInProjectPath = projectPathSplit.Length - numCommonElements;
            for (int i = 0; i < numAdditionalElementsInProjectPath; i++)
            {
                result = "../" + result;
            }

            return result;
        }
        // Otherwise return the full path
        return fullPath;
    }

    private static void copyOverseasResourceByFolder(string from, string to, StringBuilder sb)
    {
        sb.Append($"copy from {from} to {to}!!!\n");
        var files = Directory.GetFiles(from, "*", SearchOption.AllDirectories);
        foreach (var file in files)
        {
            sb.Append($"oversea file : {file}\n");
        }
        sb.Append("\n");
        DirectoryEx.DirectoryCopy(from, to, true, new[] { "*" }, (file) => !file.FullName.EndsWith("meta"), true);
    }

    private static readonly string SpecialAndroidFolder = "__Android";
    private static readonly string SpecialIOSFolder = "__IOS";

    private static void CopyOverSeaResources(List<string> copyPaths)
    {
        if (MGameContext.singleton.IsMainChannel)
        {
            return;
        }
        //拷贝海外普通proj资源到打包工程
        var sb = SharedStringBuilder.Get();
        foreach (var copyProjResourcesPath in copyPaths)
        {
            var from = PathEx.GetChannelProjPathEx(MGameContext.singleton.CurrentChannel, copyProjResourcesPath);
            if (!Directory.Exists(from)) continue;

            var to = DirectoryEx.Combine(MSysEnvHelper.GetEnvParam(MSysEnvHelper.MOONCLIENT_PACK_PROJ_PATH), "Assets",
                copyProjResourcesPath);

            var folders = Directory.GetDirectories(from);
            if (folders.Length <= 0)
            {
                copyOverseasResourceByFolder(from, to, sb);
                continue;
            }

            foreach (var folder in folders)
            {
                var folderName = Path.GetFileNameWithoutExtension(folder);
                if (string.IsNullOrEmpty(folderName)) continue;
                var target = PathEx.MakePathStandard(Path.Combine(to, folderName));

                if (folderName == SpecialAndroidFolder)
                {
#if UNITY_ANDROID
                    copyOverseasResourceByFolder(folder, to, sb);
#endif
                }
                else if (folderName == SpecialIOSFolder)
                {
#if UNITY_IOS
                    copyOverseasResourceByFolder(folder, to, sb);
#endif
                }
                else
                {
                    copyOverseasResourceByFolder(folder, target, sb);
                }
            }
        }
        MDebug.singleton.AddLog(sb.ToString());
        AssetDatabase.Refresh();
    }

    /// <summary>
    /// 设置游戏名称
    /// </summary>
    private static void SetProductName()
    {
        MDebug.singleton.AddLogF("Step:SetProductName bundleId = {0}", bundleId);
        if (exportAS)
        {
            PlayerSettings.productName = "ROAndroidProject";
        }
        else if (bundleId.Equals("com.tencent.ro") || bundleId.Equals("com.joyyou.ro"))
        {
            PlayerSettings.productName = "仙境传说：爱如初见内测版";
        }
        else if (bundleId.Contains("com.gravity.ragnarokorigin"))
        {
            PlayerSettings.productName = "라그나로크 오리진";
        }
        else if (bundleId.Contains("com.gravity.roo.cbt"))
        {
            PlayerSettings.productName = "(CBT)라그나로크 오리진";
        }
        MDebug.singleton.AddLogF("Step:SetProductName productName = {0}", PlayerSettings.productName);
    }

    /// <summary>
    /// 设置版本信息
    /// </summary>
    private static void SetBundleVersion()
    {
        string version = MPlatformConfigManager.GetLocal().version.To3String();
        PlayerSettings.bundleVersion = version;
        MDebug.singleton.AddLogF("[SetBundleVersion]version={0}", version);
#if UNITY_ANDROID
        PlayerSettings.Android.bundleVersionCode = versionCode;
        if (bundleId.Equals("com.tencent.ro") || bundleId.Equals("com.joyyou.ro"))
        {
            PlayerSettings.Android.minSdkVersion = AndroidSdkVersions.AndroidApiLevel16;
        }
        else if (bundleId.Contains("com.gravity.ragnarokorigin") || bundleId.Contains("com.gravity.roo.cbt"))
        {
            PlayerSettings.Android.minSdkVersion = AndroidSdkVersions.AndroidApiLevel23;
        }
        else
        {
            PlayerSettings.Android.minSdkVersion = AndroidSdkVersions.AndroidApiLevel23;
        }
        MDebug.singleton.AddLogF("[SetBundleVersion]PlayerSettings.Android.bundleVersionCode={0}", versionCode);
#endif
#if UNITY_IOS
        PlayerSettings.iOS.buildNumber = versionCode.ToString();
        MDebug.singleton.AddLogF("[SetBundleVersion]PlayerSettings.iOS.buildNumber={0}", versionCode);
        // --bug=1080364 --user=李斌 【KR.DEV.OBT分支】【适配】【必现】iPad pro开启游戏后适配错误 https://www.tapd.cn/20332331/s/1684390
        PlayerSettings.iOS.SetiPadLaunchScreenType(iOSLaunchScreenType.Default);
#endif
        MDebug.singleton.AddLogF("Step:SetBundleVersion bundleVersion = {0} bundleVersionCode = {1}", version, versionCode);
    }

    /// <summary>
    /// 打包前的公共预处理
    /// </summary>
    private static void CommonPipeline()
    {
        AnalysisParameters();
        GenerateConfig();
        FilterUnusedScene();
        DeleteAsset();
        // 拷贝非StreamingAssets资源
        CopyOverSeaResources(PathEx.CopyProjResourcesPaths);
        doPackProjCopy();
        CopyOverSeaResources(PathEx.CopyProjStreamingAssetsPath);
        doStreamingAssetsCopy();
        GenerateObbConfig();
        AssetDatabase.Refresh();
    }

    private static void GenerateObbConfig()
    {
        if (useObb && IsAndroidPlatform())
        {
            PlayerSettings.Android.useAPKExpansionFiles = true;
            //obb 会找不到一些资源文件,提前加载
            var configJson = AssetDatabase.LoadAssetAtPath<TextAsset>("Assets/Resources/config.json");
            var conditionToGradeDataAndroid = AssetDatabase.LoadAssetAtPath<TextAsset>("Assets/Resources/QualitySetting/ConditionToGradeDataAndroid.asset.json");
            var testMaterial = AssetDatabase.LoadAssetAtPath<Material>("Assets/Resources/Materials/Benchmark.mat");
            var miniStringPool = AssetDatabase.LoadAssetAtPath<TextAsset>($"Assets/Resources/MiniStringPool/{MGameContext.singleton.CurrentLanguage.ToString().ToUpper()}_MINI_STRING_POOL.json");
            var avProAdapterPrefab = AssetDatabase.LoadAssetAtPath<GameObject>("Assets/Resources/Prefabs/AvProAdapter.prefab");

            UnityEngine.Object[] objects = { configJson, conditionToGradeDataAndroid, testMaterial, miniStringPool, avProAdapterPrefab };
            PlayerSettings.SetPreloadedAssets(objects);
        }
    }

    /// <summary>
    /// 退出build并打印错误信息
    /// </summary>
    /// <param name="error"></param>
    private static void PrintErrorLog(UnityEditor.Build.Reporting.BuildResult error)
    {
        if (error == UnityEditor.Build.Reporting.BuildResult.Succeeded)
        {
            EditorApplication.Exit(0);
        }
        else
        {
            MDebug.singleton.AddErrorLog(error.ToString());
            EditorApplication.Exit(1);
        }
    }

    private static bool IsAndroidPlatform()
    {
        if (buildTarget == BuildTarget.Android)
        {
            return true;
        }
        return false;
    }

    private static bool IsIOSPlatform()
    {
        if (buildTarget == BuildTarget.iOS)
        {
            return true;
        }
        return false;
    }

    private static bool IsHdgMode()
    {
        return (mode == EPackageMode.Hdg);
    }

    private static bool IsUwaMode()
    {
        return (IsAndroidPlatform() && mode == EPackageMode.Uwa);
    }

    private static bool IsProfilerMode()
    {
        return mode == EPackageMode.Profiler;
    }

    private static bool IsReleaseMode()
    {
        return mode == EPackageMode.Release;
    }

    public static bool IsDebugMode()
    {
        return mode == EPackageMode.Debug;
    }

    private static void copyBytesToStreamingAssets()
    {
        string configPath = string.Empty;
        if (!MSysEnvHelper.TryGetEnvParam("MoonClientConfigPath", out configPath, MSysEnvHelper.ErrorType.LogError))
        {
            return;
        }

        if (Directory.Exists("../exe/ro_Data/Bytes"))
        {
            Directory.Delete("../exe/ro_Data/Bytes", true);
        }

        // Copy Bytes
        copyDir($"{configPath}/Assets/Resources", "../exe/ro_Data/Bytes", true);

        if (Directory.Exists("../exe/ro_Data/Bytes/LuaSource"))
        {
            Directory.Delete("../exe/ro_Data/Bytes/LuaSource", true);
        }

        // Copy Lua
        copyDir($"{configPath}/LuaGame",
            "../exe/ro_Data/Bytes/LuaSource/Lua64/LuaGame", true);
        copyDir($"{configPath}/LuaClient",
            "../exe/ro_Data/Bytes/LuaSource/Lua64/LuaGame", true);
        copyDir($"{Application.dataPath}/Scripts/Lua",
            "../exe/ro_Data/Bytes/LuaSource/Lua64/Scripts", true);
        copyDir($"{Application.dataPath}/Scripts/LuaEngine/ToLua/Lua",
            "../exe/ro_Data/Bytes/LuaSource/Lua64/ToLua", true);
    }

    private static void copyDir(string srcPath, string destPath, bool cover)
    {
        if (Directory.Exists(srcPath))
        {
            if (!Directory.Exists(destPath))
            {
                Directory.CreateDirectory(destPath);
            }
            string[] files = Directory.GetFiles(srcPath);
            foreach (string file in files)
            {
                string fileName = Path.GetFileName(file);
                string extention = Path.GetExtension(file);
                if (extention == ".meta" || fileName.StartsWith("."))
                {
                    continue;
                }
                try
                {
                    string destFile = DirectoryEx.Combine(destPath, fileName);
                    File.Copy(file, destFile, cover);
                }
                catch (IOException e)
                {
                    MDebug.singleton.AddErrorLog(e.ToString());
                }
            }
            string[] dirs = Directory.GetDirectories(srcPath);
            foreach (string dir in dirs)
            {
                string dirName = Path.GetFileName(dir);
                if (dirName.StartsWith("."))
                {
                    continue;
                }
                string destDir = DirectoryEx.Combine(destPath, dirName);
                copyDir(dir, destDir, cover);
            }
        }
    }

#region PC Pack

    private static void copyBanksForPC()
    {
#if UNITY_EDITOR_WIN
        MDebug.singleton.AddLog("开始拷贝Banks...");
        EditorUtility.DisplayProgressBar("拷贝Banks", "开始拷贝Banks...", 0);
        var srcPath = DirectoryEx.Combine(MoonCommonLib.MSysEnvHelper.GetEnvParam(MSysEnvHelper.MOONCLIENT_ARTRES_PATH), "_FMod/Mobile");
        var destPath = DirectoryEx.Combine(MoonCommonLib.MSysEnvHelper.GetEnvParam(MSysEnvHelper.MOONCLIENT_PROJ_PATH), "Assets/StreamingAssets");
        DirectoryInfo srcDirectoryInfo = new DirectoryInfo(srcPath);
        FileInfo[] fis = srcDirectoryInfo.GetFiles();
        for (int j = 0; j < fis.Length; j++)
        {
            if (fis[j].Extension == ".bank")
            {
                File.Copy(fis[j].FullName, DirectoryEx.Combine(destPath, fis[j].Name), true);
            }
        }
        AssetDatabase.Refresh();
        EditorUtility.ClearProgressBar();
#endif
    }

    private static bool buildDllForPC()
    {
#if UNITY_EDITOR_WIN
        try
        {
            string scriptDir = DirectoryEx.Combine(ToolLib.Util.MoonClientProjPath, "Tools/BuildForPC");
            System.Diagnostics.Process proc = new System.Diagnostics.Process();
            proc.StartInfo.WorkingDirectory = scriptDir;
            proc.StartInfo.FileName = DirectoryEx.Combine(scriptDir, "build_pc_dll.bat");
            proc.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Normal;
            proc.Start();
            proc.WaitForExit();
            if (proc.ExitCode != 0)
            {
                return false;
            }
            return backDllForPC();
        }
        catch (Exception ex)
        {
            MDebug.singleton.AddErrorLog(ex.ToString());
            return false;
        }
#else
        return false;
#endif
    }

    private static bool backDllForPC()
    {
#if UNITY_EDITOR_WIN
        try
        {
            EditorUtility.DisplayProgressBar("备份C# DLL", "开始拷贝MoonClient.dll与MoonCommonLib.dll", 50);
            var srcPath = DirectoryEx.Combine(ToolLib.Util.MoonClientCodePath, "CSProject");
            var destPath = DirectoryEx.Combine(ToolLib.Util.MoonClientProjPath, "Tools/BuildForPC");
            File.Copy(DirectoryEx.Combine(srcPath, "MoonCommonLib/bin/UNITY_PC/MoonCommonLib.dll"), DirectoryEx.Combine(destPath, "MoonCommonLib.dll"), true);
            File.Copy(DirectoryEx.Combine(srcPath, "MoonClient/bin/UNITY_PC/MoonClient.dll"), DirectoryEx.Combine(destPath, "MoonClient.dll"), true);
            var sdkLibPath = DirectoryEx.Combine(ToolLib.Util.MoonSdkLibPath, "SDKLib/bin/UNITY_PC/SDKLib.dll");
            if (File.Exists(sdkLibPath))
            {
                File.Copy(sdkLibPath, DirectoryEx.Combine(destPath, "SDKLib.dll"), true);
            }
            return true;
        }
        catch (Exception ex)
        {
            MDebug.singleton.AddErrorLog(ex.ToString());
            return false;
        }
        finally
        {
            EditorUtility.ClearProgressBar();
        }
#else
        return false;
#endif
    }

    private static bool copyDllForPC(bool isBuildDll)
    {
#if UNITY_EDITOR_WIN
        try
        {
            if (isBuildDll)
            {
                buildDllForPC();
            }

            EditorUtility.DisplayProgressBar("拷贝C# DLL", "开始拷贝MoonClient.dll与MoonCommonLib.dll", 0);
            var srcPath = DirectoryEx.Combine(ToolLib.Util.MoonClientProjPath, "Tools/BuildForPC");
            var destPath = DirectoryEx.Combine(ToolLib.Util.MoonClientProjPath, "Assets/Plugins/GameLibs");
            File.Copy(DirectoryEx.Combine(srcPath, "MoonCommonLib.dll"), DirectoryEx.Combine(destPath, "MoonCommonLib.dll"), true);
            File.Copy(DirectoryEx.Combine(srcPath, "SDKLib.dll"), DirectoryEx.Combine(destPath, "SDKLib.dll"), true);
            File.Copy(DirectoryEx.Combine(srcPath, "MoonClient.dll"), DirectoryEx.Combine(destPath, "MoonClient.dll"), true);
            AssetDatabase.Refresh();
            return true;
        }
        catch (Exception ex)
        {
            MDebug.singleton.AddErrorLog(ex.ToString());
            return false;
        }
        finally
        {
            EditorUtility.ClearProgressBar();
        }
#else
        return false;
#endif
    }

    private static bool buildPC(bool isBuildDll = true)
    {
        if (!copyDllForPC(isBuildDll))
        {
            EditorUtility.DisplayDialog("打包PC", "打包失败， 错误：拷贝dll失败，请先编译PC包dll", "确定");
            return false;
        }

        copyBanksForPC();
        buildTarget = BuildTarget.StandaloneWindows64;
        if (!Directory.Exists("../exe"))
        {
            Directory.CreateDirectory("../exe");
        }
        if (strExportPath == "")
        {
            strExportPath = "../exe/ro.exe";
        }
        var errorReport = BuildPipeline.BuildPlayer(GetBuildScenes(), strExportPath, buildTarget, GetBuildOptions());
        ResetParameters();
        if (errorReport.summary.result == UnityEditor.Build.Reporting.BuildResult.Succeeded)
        {
            copyBytesToStreamingAssets();
            EditorUtility.DisplayDialog("打包PC", "打包成功", "确定");
            return true;
        }
        else
        {
            EditorUtility.DisplayDialog("打包PC", "打包失败， 错误：", "确定");
            return false;
        }
    }

#endregion PC Pack

#endregion 内部使用函数
}