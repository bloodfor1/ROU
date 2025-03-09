using UnityEngine;
using UnityEditor;
using UnityEditor.XCodeEditor;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class DeployIOS {
    static MsdkEnv env = MsdkEnv.Instance;
    static string iosConfigPath = env.PATH_IOS_PLIST;

	static readonly string weixin =
	@"                <string>weixin</string>
                <key>CFBundleURLSchemes</key>
                <array>";
	static readonly string tencentopenapi =
	@"                <string>tencentopenapi</string>
                <key>CFBundleURLSchemes</key>
                <array>";
	static readonly string QQ =
	@"                <string>QQ</string>
                <key>CFBundleURLSchemes</key>
                <array>";
	static readonly string QQLaunch =
	@"                <string>QQLaunch</string>
                <key>CFBundleURLSchemes</key>
                <array>";
    static readonly string tencentVideo =
@"                <string>tencentvideo</string>
                <key>CFBundleURLSchemes</key>
                <array>";
	static readonly string offerId =
	@"        <key>MSDK_OfferId</key>";
	static readonly string qqAppId =
	@"        <key>QQAppID</key>";
	static readonly string qqAppKey =
	@"        <key>QQAppKey</key>";
	static readonly string wxAppId =
	@"        <key>WXAppID</key>";
	static readonly string msdkKey =
	@"        <key>MSDKKey</key>";


	public static void Deploy() {
		UpdateBaseInfo();
	}

    public static void Deploy(string projectPath)
    {
        string path = Path.GetFullPath(projectPath);
        string sdkManagerLoadStr = "";
        if (AutoBuild.ENABLE_LEIBIAN)
        {
            sdkManagerLoadStr = sdkManagerLoadStr + "ROLebian,";
            EditorLebianCode(projectPath);
        }
        if (AutoBuild.ENABLE_KOREASDK)
        {
            sdkManagerLoadStr = sdkManagerLoadStr + "ROOverSea,ROFirebase,";
            EditorKoreaSdkCode(path);
        }
        if(AutoBuild.ENABLE_MSDK)
        {
            //动态修改 MSDKXcodeConfig.projmods 文件的配置
            // CopyFrameworks(path, ConfigSettings.Instance.UseC11);
            // CopyOtherFiles(path);

            // EditorMod(path);

            // 修改 plist 文件
            UpdateBaseInfo();
            EditorPlist(path);

            // 修改 xcode 代码(UnityAppController.mm)
            EditorMsdkCode(path);

            // 更新Config
            ConfigSettings.Instance.Update();
        }

        EditorCommonCode(path, sdkManagerLoadStr);
    }

    private static void CopyFrameworks(string pathToBuiltProject, bool isC11)
    {
        string destDir = pathToBuiltProject + "/MSDK";
        if (!Directory.Exists(destDir)) {
            Directory.CreateDirectory(destDir);
        }
        Debug.Log("isC11:" + isC11);
        string tail = "";
        if (isC11) {
            tail = "_C11";
        }
        MsdkUtil.ReplaceDir(env.PATH_LIBRARYS_IOS + "/Library/MSDK" + tail + "/MSDK.framework",
                            destDir + "/MSDK.framework");
        MsdkUtil.ReplaceDir(env.PATH_LIBRARYS_IOS + "/Library/MSDK" + tail + "/MSDKResources" + tail + ".bundle",
                            destDir + "/MSDKResources.bundle");
		MsdkUtil.ReplaceDir(env.PATH_LIBRARYS_IOS + "/Library/MSDK" + tail + "/WGPlatformResources"+ tail +".bundle",
							destDir + "/WGPlatformResources.bundle");

        MsdkUtil.ReplaceDir(env.PATH_LIBRARYS_IOS + "/MSDKAdapter" + tail + "/MSDKAdapter" + tail + ".framework",
                            destDir + "/MSDKAdapter.framework");
        if (!isC11) {
            return;
        }
        DirectoryInfo xcodeMsdk = new DirectoryInfo(destDir);
        DirectoryInfo[] frameworks = xcodeMsdk.GetDirectories("*.framework");
        foreach (DirectoryInfo framework in frameworks) {
            FileInfo[] files = framework.GetFiles("*_C11");
            foreach (FileInfo file in files) {
                file.MoveTo(file.DirectoryName + "/" + file.Name.Replace("_C11", ""));
            }
        }
    }

    private static void CopyOtherFiles(string pathToBuiltProject)
    {
        if (!MsdkUtil.isUnityEarlierThan("5.0")) {
            return;
        }

        string destDir = pathToBuiltProject + "/MSDK";
        if (!Directory.Exists(destDir)) {
            Directory.CreateDirectory(destDir);
        }

        //MsdkUtil.CopyDir(env.PATH_ADAPTER_IOS + "/oc", destDir + "/oc", true);
        MsdkUtil.CopyDir(env.PATH_BUGLY + "/iOS", destDir + "/bugly", true);
    }

    private static void EditorMod(string pathToBuiltProject)
    {
        Dictionary<string, string> modFileRules = new Dictionary<string, string>()
        {
            {".*/MSDK/MSDK.framework"            , "        \"" + pathToBuiltProject + "/MSDK/MSDK.framework\","},
            {".*/MSDK/WGPlatformResources.bundle", "        \"" + pathToBuiltProject + "/MSDK/WGPlatformResources.bundle\","},
            {".*/MSDK/MSDKResources.bundle"      , "        \"" + pathToBuiltProject + "/MSDK/MSDKResources.bundle\","},
			{".*/MSDK/MSDKAdapter.framework"     , "        \"" + pathToBuiltProject + "/MSDK/MSDKAdapter.framework\","},
        };

        MsdkUtil.ReplaceTextWithRegex(env.PATH_EDITOR + "/Resources/MSDKXcodeConfig.projmods", modFileRules);
    }

    public static void EditorPlist(string filePath)
    {
        XCPlist list = new XCPlist(filePath + "/Info.plist");
        Debug.Log (MsdkEnv.Instance.PATH_IOS_PLIST_FINAL);
        Dictionary<string,object> dict =(Dictionary<string,object>)PlistCS.Plist.readPlist(MsdkEnv.Instance.PATH_IOS_PLIST_FINAL);
        list.Process(dict);
    }

    private static void EditorKoreaSdkCode(string projectPath)
    {
        string ocFile = projectPath + "/Classes/UnityAppController.mm";
        StreamReader streamReader = new StreamReader(ocFile);
        string text_all = streamReader.ReadToEnd();
        streamReader.Close();
        if (string.IsNullOrEmpty(text_all))
        {
            return;
        }

        MsdkUtil.WriteBelow(ocFile, KoreaSDKNativeCode.IOS_SRC_KOREA_HEADER, KoreaSDKNativeCode.IOS_KOREA_HEADER);
        MsdkUtil.WriteBelow(ocFile, "//firebase_config_insert", KoreaSDKNativeCode.IOS_KOREA_FIR_CONFIG);
        MsdkUtil.WriteBelow(ocFile, "//firebase_messageing_insert", KoreaSDKNativeCode.IOS_KOREA_FIR_MESSAGEING);
    }

    private static void EditorMsdkCode(string projectPath)
    {
        string ocFile = projectPath + "/Classes/UnityAppController.mm";

        StreamReader streamReader = new StreamReader(ocFile);
        string text_all = streamReader.ReadToEnd();
        streamReader.Close();
        if (string.IsNullOrEmpty(text_all)) {
            return;
        }
        if (text_all.Contains(MsdkNativeCode.IOS_HEADER)) {
            Debug.LogWarning("You are appending to XCode project, would not modified <Classes/UnityAppController.mm>");
            return;
        }

        MsdkUtil.WriteBelow(ocFile, "//msdk_xg_push", MsdkNativeCode.IOS_XG_PUSH_DETAIL);
        MsdkUtil.WriteBelow(ocFile, "//msdk_xg_push_ios10_foreground", MsdkNativeCode.IOS_XG_PUSH_iOS10_FORE_DETAIL);
        MsdkUtil.WriteBelow(ocFile, "//msdk_xg_push_ios10_background", MsdkNativeCode.IOS_XG_PUSH_iOS10_BACK_DETAIL);
        MsdkUtil.WriteBelow(ocFile, MsdkNativeCode.IOS_SRC_HEADER, MsdkNativeCode.IOS_HEADER);
        MsdkUtil.WriteBelow(ocFile, "//msdk_xg_push_register", MsdkNativeCode.IOS_XG_REGISTER);
        MsdkUtil.ReplaceLineBelow(ocFile, MsdkNativeCode.IOS_SRC_OPENURL_9_0, "return YES;", MsdkNativeCode.IOS_HANDLE_URL);
        MsdkUtil.WriteBelow(ocFile, MsdkNativeCode.IOS_SRC_REGISTER, MsdkNativeCode.IOS_XG_SUCC);
        MsdkUtil.WriteBelow(ocFile, MsdkNativeCode.IOS_SRC_REGISTER_FAIL, MsdkNativeCode.IOS_XG_FAIL);
        MsdkUtil.WriteBelow(ocFile, MsdkNativeCode.IOS_SRC_RECEIVE, MsdkNativeCode.IOS_XG_RECEIVE);
        MsdkUtil.WriteBelow(ocFile, MsdkNativeCode.IOS_SRC_ACTIVE, MsdkNativeCode.IOS_XG_CLEAR + MsdkNativeCode.IOS_BECAME_ACTIVE);
 
    }

    public static void EditorLebianCode(string projectPath){
        string ocFile = projectPath + "/Classes/UnityAppController.mm";

        StreamReader streamReader = new StreamReader(ocFile);
        string text_all = streamReader.ReadToEnd();
        streamReader.Close();
        if (string.IsNullOrEmpty(text_all)) {
            return;
        }

        MsdkUtil.WriteBelow(ocFile, LebianNativeCode.IOS_SRC_LEBIAN_HEADER, LebianNativeCode.IOS_LEBIAN_HEADER);
        MsdkUtil.WriteBelow(ocFile, LebianNativeCode.IOS_SRC_LEBIAN_FINISH, LebianNativeCode.IOS_LEBIAN_FINISH);
    }

    public static void EditorCommonCode(string projectPath, string sdkManagerLoadStr)
    {
        string ocFile = projectPath + "/Classes/UnityAppController.mm";

        StreamReader streamReader = new StreamReader(ocFile);
        string text_all = streamReader.ReadToEnd();
        streamReader.Close();
        if (string.IsNullOrEmpty(text_all))
        {
            return;
        }
        MsdkUtil.WriteBelow(ocFile, CommonNativeCode.IOS_SRC_HEADER, CommonNativeCode.IOS_HEADER);
        MsdkUtil.WriteBelow(ocFile, CommonNativeCode.IOS_SRC_SDK_MANAGER_LOAD, CommonNativeCode.IOS_SDK_MANAGER_LOAD.Replace("need_replace", sdkManagerLoadStr));

        //--story=1068598 --user=张建明 【ios机型适配】home indicator处理 https://www.tapd.cn/20332331/s/1659221
        string viewControllerBasePath = projectPath + "/Classes/UI/UnityViewControllerBase+iOS.mm";
        string content = File.ReadAllText(viewControllerBasePath);
        content = Regex.Replace(content, CommonNativeCode.IOS_SRC_HOME_INDICATOR, CommonNativeCode.IOS_TARGET_HOME_INDICATOR);
        File.WriteAllText(viewControllerBasePath, content);
    }

    public static void UpdateBaseInfo() {
		MsdkUtil.ReplaceBelow (iosConfigPath, weixin,
		                       "                    <string>" + DeploySettings.Instance.WxAppId + "</string>");
		MsdkUtil.ReplaceBelow (iosConfigPath, tencentopenapi,
		                       "                    <string>tencent" + DeploySettings.Instance.QqAppId + "</string>");
		MsdkUtil.ReplaceBelow (iosConfigPath, QQ,
			                    "                    <string>" + DeploySettings.Instance.QqScheme + "</string>");
		MsdkUtil.ReplaceBelow (iosConfigPath, QQLaunch,
		                       "                    <string>tencentlaunch" + DeploySettings.Instance.QqAppId + "</string>");
        MsdkUtil.ReplaceBelow(iosConfigPath, tencentVideo,
                               "                    <string>tencentvideo" + DeploySettings.Instance.QqAppId + "</string>");
		MsdkUtil.ReplaceBelow (iosConfigPath, offerId,
		                       "        <string>" + DeploySettings.Instance.IOSOfferId + "</string>");
		MsdkUtil.ReplaceBelow (iosConfigPath, qqAppId,
		                       "        <string>" + DeploySettings.Instance.QqAppId + "</string>");
		MsdkUtil.ReplaceBelow (iosConfigPath, wxAppId,
		                       "        <string>" + DeploySettings.Instance.WxAppId + "</string>");
		MsdkUtil.ReplaceBelow (iosConfigPath, msdkKey,
		                       "        <string>" + DeploySettings.Instance.MsdkKey + "</string>");
	}

}
