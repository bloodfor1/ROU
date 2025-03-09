using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.XCodeEditor;
#endif
#if UNITY_IOS
using UnityEditor.iOS.Xcode;
#endif
using System.IO;

public static class XCodePostProcess
{
#if UNITY_EDITOR
    [PostProcessBuild(999)]
    public static void OnPostProcessBuild( BuildTarget target, string pathToBuiltProject)
    {

#if UNITY_5||UNITY_2017||UNITY_2017_1_OR_NEWER
        if (target == BuildTarget.iOS) {
#else
        if (target == BuildTarget.iPhone) {
#endif
            Debug.Log ("Run XCodePostProcess to Config Xcode project.");
        } else {
            return;
        }
        string path = Path.GetFullPath(pathToBuiltProject);
        File.Copy(Path.Combine(Application.dataPath, "Editor/XUPorter/Mods/ROLib/UnityAppController.mm"), Path.Combine(path, "Classes/UnityAppController.mm"), true);
        DeployIOS.Deploy(pathToBuiltProject);

        string projectPath = pathToBuiltProject + "/Unity-iPhone.xcodeproj/project.pbxproj";
#if UNITY_IOS
        UnityEditor.iOS.Xcode.PBXProject pbxProject = new UnityEditor.iOS.Xcode.PBXProject();
        pbxProject.ReadFromFile(projectPath);
        string targetGuid = pbxProject.TargetGuidByName("Unity-iPhone");

        pbxProject.SetBuildProperty(targetGuid, "ENABLE_BITCODE", "NO");
        pbxProject.SetBuildProperty(targetGuid, "DEPLOYMENT_POSTPROCESSING", "YES");
        pbxProject.SetBuildProperty(targetGuid, "DEBUG_INFORMATION_FORMAT", "DWARF with dSYM File");
        pbxProject.SetBuildProperty(targetGuid, "STRIP_DEBUG_SYMBOLS_DURING_COPY", "YES");
        pbxProject.SetBuildProperty(targetGuid, "ARCHS", "arm64");
        pbxProject.SetBuildProperty(targetGuid, "VALID_ARCHS", "arm64 arm64e");
        string bundleId = PlayerSettings.GetApplicationIdentifier(BuildTargetGroup.iOS);
        Debug.LogWarning("bundleId: " + bundleId);
        if (bundleId.Equals("com.tencent.ro"))
        {
            // 设置签名
            pbxProject.SetBuildProperty(targetGuid, "CODE_SIGN_STYLE", "Manual");
            pbxProject.SetBuildProperty(targetGuid, "DEVELOPMENT_TEAM", "9TV4ZYSS4J");
            pbxProject.SetBuildProperty(targetGuid, "PROVISIONING_PROFILE", "14dbabb2-95d7-4045-a45b-5287cd84c69d");
            pbxProject.AddCapability(targetGuid, UnityEditor.iOS.Xcode.PBXCapabilityType.PushNotifications, 
                Path.Combine(Application.dataPath, "ro.entitlements"));
            pbxProject.AddCapability(targetGuid, UnityEditor.iOS.Xcode.PBXCapabilityType.BackgroundModes);
        } 
        else if(bundleId.Equals("com.joyyou.ro"))
        {
            pbxProject.SetBuildProperty(targetGuid, "CODE_SIGN_STYLE", "Automatic");
            pbxProject.SetBuildProperty(targetGuid, "DEVELOPMENT_TEAM", "8VLYWLCLEX");
            pbxProject.SetBuildProperty(targetGuid, "PROVISIONING_PROFILE", "");
            pbxProject.AddCapability(targetGuid, UnityEditor.iOS.Xcode.PBXCapabilityType.PushNotifications,
                Path.Combine(Application.dataPath, "ro.entitlements"));
            pbxProject.AddCapability(targetGuid, PBXCapabilityType.BackgroundModes);
            
            // editor plist
            string plistPath = pathToBuiltProject + "/Info.plist";
            PlistDocument plist = new PlistDocument();
            plist.ReadFromString(File.ReadAllText(plistPath));
            PlistElementDict rootDict = plist.root;
            rootDict.SetString("FacebookAppID", "541607759680937");
            rootDict.SetString("FacebookDisplayName", "仙境传说：爱如初见内测版");

            PlistElementArray urlArray = null;
            if (!rootDict.values.ContainsKey("CFBundleURLTypes"))
            {
                urlArray = rootDict.CreateArray("CFBundleURLTypes");
            }
            else
            {
                urlArray = rootDict.values["CFBundleURLTypes"].AsArray();
            }
            var FBUrlTypeDict = urlArray.AddDict();
            FBUrlTypeDict.SetString("CFBundleURLName", "facebook");
            var FBUrlScheme = FBUrlTypeDict.CreateArray("CFBundleURLSchemes");
            FBUrlScheme.AddString("fb541607759680937");

            var GoogleUrlTypeDict = urlArray.AddDict();
            GoogleUrlTypeDict.SetString("CFBundleURLName", "firebase");
            var GoogleUrlScheme = GoogleUrlTypeDict.CreateArray("CFBundleURLSchemes");
            GoogleUrlScheme.AddString("com.googleusercontent.apps.616946639310-o4vrkgnn5o9r3datm75ita3k6bn3u528");

            if (!rootDict.values.ContainsKey("LSApplicationQueriesSchemes"))
            {
                urlArray = rootDict.CreateArray("LSApplicationQueriesSchemes");
            }
            else
            {
                urlArray = rootDict["LSApplicationQueriesSchemes"].AsArray();
            }
            urlArray.AddString("fbapi");
            urlArray.AddString("fb-messenger-share-api");
            urlArray.AddString("fbauth2");
            urlArray.AddString("fbshareextension");

            if (!rootDict.values.ContainsKey("UIBackgroundModes"))
            {
                urlArray = rootDict.CreateArray("UIBackgroundModes");
            }
            else
            {
                urlArray = rootDict["UIBackgroundModes"].AsArray();
            }
            urlArray.AddString("remote-notification");
            File.WriteAllText(plistPath, plist.WriteToString());
        }
        else if(bundleId.Equals("com.gravity.ragnarokorigin.ios") 
            || bundleId.Equals("com.gravity.roo.cbt.ios"))
        {
            string provisioning_profile = "";
            string code_sign_identity = "";
            if (AutoBuild.iOSDistribution)
            {
                provisioning_profile = bundleId.Equals("com.gravity.ragnarokorigin.ios") ? "c4019554-c0b2-406b-b62b-d70af7a594fe" : "d3f7feb0-6f0d-4965-ae86-430863e3d2a8";
                code_sign_identity = "iPhone Distribution";
            }
            else
            {
                provisioning_profile = bundleId.Equals("com.gravity.ragnarokorigin.ios") ? "72d3e9e5-2f00-41c6-93fe-1652e3622303" : "960a8eaf-6681-4548-a2fe-a41ba431f954";
                code_sign_identity = "iPhone Developer";

            }
            Debug.LogWarning("XCodePostProcess provisioning_profile: " + provisioning_profile);
            Debug.LogWarning("XCodePostProcess code_sign_identity: " + code_sign_identity);
            string facebookDisplayName = bundleId.Equals("com.gravity.ragnarokorigin.ios") ? "라그나로크 오리진" : "(CBT) 라그나로크 오리진";
            string googleUrlScheme = bundleId.Equals("com.gravity.ragnarokorigin.ios") ? "com.googleusercontent.apps.887967835616-ogq23di042qri2cg23r24drlqq5oscuu" : "com.googleusercontent.apps.887967835616-506pojkb3fcaqt3p95lag6ii13tlitet";
            //string kakaoAppKey = bundleId.Equals("com.gravity.ragnarokorigin.ios") ? "c297a5bf6a22a685c4d2bca055233e80" : "49ed4ec23f9b809381975999ef3272f4";
            pbxProject.SetBuildProperty(targetGuid, "GCC_ENABLE_OBJC_EXCEPTIONS", "YES");
            pbxProject.SetBuildProperty(targetGuid, "CODE_SIGN_STYLE", "Manual");
            pbxProject.SetBuildProperty(targetGuid, "DEVELOPMENT_TEAM", "W75HG47R5U");
            pbxProject.SetBuildProperty(targetGuid, "PROVISIONING_PROFILE", provisioning_profile);
            pbxProject.SetBuildProperty(targetGuid, "CODE_SIGN_IDENTITY[sdk=iphoneos*]", code_sign_identity);
            pbxProject.AddCapability(targetGuid, UnityEditor.iOS.Xcode.PBXCapabilityType.PushNotifications, 
                Path.Combine(Application.dataPath, "ro_kor.entitlements"));
            pbxProject.AddCapability(targetGuid, PBXCapabilityType.GameCenter);
            pbxProject.AddCapability(targetGuid, PBXCapabilityType.InAppPurchase);
            pbxProject.AddCapability(targetGuid, UnityEditor.iOS.Xcode.PBXCapabilityType.BackgroundModes);

            // editor plist
            string plistPath = pathToBuiltProject + "/Info.plist";
            PlistDocument plist = new PlistDocument ();
            plist.ReadFromString (File.ReadAllText (plistPath));
            PlistElementDict rootDict = plist.root;
            rootDict.SetString ("FacebookAppID", "474389699860750");
            rootDict.SetString ("FacebookDisplayName", facebookDisplayName);
            //rootDict.SetString("KAKAO_APP_KEY", kakaoAppKey);

            PlistElementArray urlArray = null;
            if (!rootDict.values.ContainsKey("CFBundleURLTypes")) {
                urlArray = rootDict.CreateArray("CFBundleURLTypes");
            } else {
                urlArray = rootDict.values["CFBundleURLTypes"].AsArray();
            }
            var FBUrlTypeDict = urlArray.AddDict();
            FBUrlTypeDict.SetString("CFBundleURLName", "facebook");
            var FBUrlScheme = FBUrlTypeDict.CreateArray("CFBundleURLSchemes");
            FBUrlScheme.AddString("fb474389699860750");

            var GoogleUrlTypeDict = urlArray.AddDict();
            GoogleUrlTypeDict.SetString("CFBundleURLName", "firebase");
            var GoogleUrlScheme = GoogleUrlTypeDict.CreateArray("CFBundleURLSchemes");
            GoogleUrlScheme.AddString(googleUrlScheme);
            
            //var KakaoUrlTypeDict = urlArray.AddDict();
            //KakaoUrlTypeDict.SetString("CFBundleURLName", "kakaotalk");
            //var KakaoUrlScheme = KakaoUrlTypeDict.CreateArray("CFBundleURLSchemes");
            //KakaoUrlScheme.AddString("kakao" + kakaoAppKey);

            if (!rootDict.values.ContainsKey("LSApplicationQueriesSchemes")) {
                urlArray = rootDict.CreateArray("LSApplicationQueriesSchemes");
            } else {
                urlArray = rootDict["LSApplicationQueriesSchemes"].AsArray();
            }
            urlArray.AddString("fbapi");
            urlArray.AddString("fb-messenger-share-api");
            urlArray.AddString("fbshareextension");
            //urlArray.AddString("storylink");
            //urlArray.AddString("kakaolink");
            //urlArray.AddString("kakaotalk-5.9.7");
            //urlArray.AddString("kakao" + kakaoAppKey);

            if (rootDict.values.ContainsKey ("UIRequiredDeviceCapabilities")) {
                rootDict.values.Remove ("UIRequiredDeviceCapabilities");
            }
            var arr = rootDict.CreateArray ("UIRequiredDeviceCapabilities");
            arr.AddString ("arm64");
            arr.AddString ("gamekit"); //Gamecenter

            if (!rootDict.values.ContainsKey("UIBackgroundModes")) {
                urlArray = rootDict.CreateArray("UIBackgroundModes");
            } else {
                urlArray = rootDict["UIBackgroundModes"].AsArray();
            }
            urlArray.AddString("remote-notification");

            File.WriteAllText (plistPath, plist.WriteToString ());
        }
        pbxProject.WriteToFile(projectPath);
#endif

        XCProject project = new XCProject( pathToBuiltProject );
        // Find and run through all projmods files to patch the project.
        // Please pay attention that ALL projmods files in your project folder will be excuted!
        string[] files = Directory.GetFiles( Application.dataPath + "/Editor/XUPorter/Mods", "*.projmods", SearchOption.AllDirectories );
        foreach( string file in files ) {
            project.ApplyMod( file );
        }
        project.Save();
    }
#endif

    public static void Log(string message)
    {
        UnityEngine.Debug.Log("PostProcess: "+message);
    }
}
