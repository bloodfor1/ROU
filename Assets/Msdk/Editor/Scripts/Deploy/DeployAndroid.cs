using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

public class DeployAndroid {

	static MsdkEnv env = MsdkEnv.Instance;
	static DeploySettings game = DeploySettings.Instance;
	static readonly string DIR_MSDKLIBRARY = env.PATH_LIBRARYS_ANDROID + "/MSDKLibrary";
	static readonly string DIR_LIBS = env.PATH_LIBRARYS_ANDROID + "/libs";
	static readonly string DIR_ASSETS = env.PATH_LIBRARYS_ANDROID + "/assets";
	//static readonly string FILE_CONFIG = DIR_ASSETS + "/msdkconfig.ini";
	static readonly string FILE_PROPERTY = env.PATH_LIBRARYS_ANDROID + "/project.properties";
	static readonly string FILE_MANIFEST = env.PATH_LIBRARYS_ANDROID + "/AndroidManifest.xml";

    static readonly string ADAPTER_JARFILE_PREFIX = "msdk_unity_adapter_";

	static readonly Dictionary<string, string> srcFileRules = new Dictionary<string, string>()
	{
		{"com.example.wegame"			, "package " + game.BundleId + ";"},
		{@"baseInfo\.qqAppId = "		, "        baseInfo.qqAppId = \"" + game.QqAppId + "\";"},
		{@"baseInfo\.wxAppId = "		, "        baseInfo.wxAppId = \"" + game.WxAppId + "\";"},
		{@"baseInfo\.msdkKey = "		, "        baseInfo.msdkKey = \"" + game.MsdkKey + "\";"},
		{@"baseInfo\.offerId = "		, "        baseInfo.offerId = \"" + game.AndroidOfferId + "\";"}
	};

	static readonly Dictionary<string, string> manifestRules = new Dictionary<string, string>()
	{
		{"scheme=\"tencent10003379"				, "                <data android:scheme=\"tencent" + game.QqAppId + "\" />"},
		{"scheme=\"tencentvideo100703379"				, "                <data android:scheme=\"tencentvideo" + game.QqAppId + "\" />"},
        {"scheme=\"wxcde873f99466f74a\"", "                <data android:scheme=\"" + game.WxAppId + "\" />"}
	};


	public static void Deploy() {
		if (Directory.Exists (env.PATH_TEMP)) {
			Directory.Delete(env.PATH_TEMP, true);
		}
		Directory.CreateDirectory (env.PATH_TEMP);

		/* 1) MSDKLibrary */
		DeployLibrary ();

		/* 2) assets */
		if (!Directory.Exists (env.PATH_PUGLIN_ANDROID + "/assets")) {
			Directory.CreateDirectory(env.PATH_PUGLIN_ANDROID + "/assets");
		}
        MsdkUtil.CopyDir (DIR_ASSETS, env.PATH_PUGLIN_ANDROID + "/assets", true);

		/* 3) libs */
		MsdkUtil.CopyDir(DIR_LIBS, env.PATH_PUGLIN_ANDROID + "/libs", true);
        #if UNITY_5
		// Editor目录处的jar包不需要到 Android/libs 下
        #else
        MsdkUtil.CopyDir(env.PATH_BUGLY + "/Android/libs", env.PATH_PUGLIN_ANDROID + "/libs", true);
        #endif

		/* 4) files */
		MsdkUtil.CopyFile (FILE_PROPERTY, env.PATH_PUGLIN_ANDROID + "/project.properties", true);
		string manifestFile = MsdkUtil.CopyFile (FILE_MANIFEST,
		                                             env.PATH_PUGLIN_ANDROID + "/AndroidManifest.xml", true);
		MsdkUtil.ReplaceTextWithRegex (manifestFile, manifestRules);
		MsdkUtil.ReplaceText (manifestFile, "com.example.wegame", game.BundleId);

		/* 5) adapter.jar */
		GenerateAdapter ();

        // 更新Config
        ConfigSettings.Instance.Update();
	}

	static void DeployLibrary() {
		bool needReplace = true;
        Debug.Log("DIR_MSDKLIBRARY:" + DIR_MSDKLIBRARY);
		string[] msdkJarFile = Directory.GetFiles (DIR_MSDKLIBRARY + "/libs", "MSDK_Android_*.jar");
		/* 此目录中应只有一个 MSDK jar 包 */
		if (msdkJarFile.Length != 1) {
			env.Error ("Get MSDK jar file error! Check jar file in " + DIR_MSDKLIBRARY + "/libs");
			return;
		}
		string srcJar = msdkJarFile [0];

		string destJar = env.PATH_PUGLIN_ANDROID + "/MSDKLibrary/libs/" + Path.GetFileName (srcJar);
		if (destJar != null && destJar.Length != 0 && File.Exists(destJar)) {
			string srcMd5 = MsdkUtil.GetFileMd5(srcJar);
			string destMd5 = MsdkUtil.GetFileMd5(destJar);
			if (srcMd5 == destMd5) {
				needReplace = false;
			}
		}

		if (needReplace) {
			Debug.Log ("Would replace MSDKLibrary.\n" + srcJar + " is not equale to " + destJar);
			MsdkUtil.ReplaceDir (DIR_MSDKLIBRARY, env.PATH_PUGLIN_ANDROID + "/MSDKLibrary");
            // Unity只会打 armeabi-v7a x86 的so，删除多余指令集的so解决机型兼容问题
            string[] abis = Directory.GetDirectories(env.PATH_PUGLIN_ANDROID + "/MSDKLibrary/libs");
            foreach(string abi in abis) {
                string abiName = Path.GetFileName(abi);
                // 3.3.7u 需要支持 64 位，需要打 x86_64 和 arm64-v8a so
                if (abiName.Equals("armeabi-v7a") || abiName.Equals("x86") || abiName.Equals("x86_64") || abiName.Equals("arm64-v8a")) {
                    continue;
                }
                if (Directory.Exists(abi)) {
                    try {
                        Directory.Delete(abi, true);
                    } catch (IOException e) {
                        Debug.LogException(e);
                    }
                }
            }
		} else {
			Debug.Log ("Would not replace MSDKLibrary.\n" + srcJar + " is equale to " + destJar);
		}
	}

	static void GenerateAdapter() {
		MsdkUtil.ReplaceDir(env.PATH_ADAPTER_ANDROID + "/java", env.PATH_TEMP + "/java");
		MsdkUtil.ReplaceTextWithRegex (env.PATH_TEMP + "/java/src/com/tencent/msdk/adapter/MsdkActivity.java", srcFileRules);
        MsdkUtil.ReplaceText (env.PATH_TEMP + "/java/src/com/example/wegame/MGameActivity.java", "com.example.wegame", game.BundleId);
        MsdkUtil.ReplaceText (env.PATH_TEMP + "/java/src/com/example/wegame/wxapi/WXEntryActivity.java", "com.example.wegame", game.BundleId);

        File.Move(env.PATH_TEMP + "/java/src/com/example/wegame/MGameActivity.java", env.PATH_TEMP + "/java/src/MGameActivity.java");
		File.Move (env.PATH_TEMP + "/java/src/com/example/wegame/wxapi/WXEntryActivity.java",
				   env.PATH_TEMP + "/java/src/WXEntryActivity.java");
		Directory.Delete(env.PATH_TEMP + "/java/src/com/example", true);
		string packagePath = game.BundleId.Replace (".", "/");
		packagePath = packagePath.Trim ();
		Directory.CreateDirectory (env.PATH_TEMP + "/java/src/" + packagePath);
        File.Move(env.PATH_TEMP + "/java/src/MGameActivity.java", env.PATH_TEMP + "/java/src/" + packagePath + "/MGameActivity.java");
		Directory.CreateDirectory (env.PATH_TEMP + "/java/src/" + packagePath + "/wxapi");
		File.Move (env.PATH_TEMP + "/java/src/WXEntryActivity.java",
		           env.PATH_TEMP + "/java/src/" + packagePath + "/wxapi/WXEntryActivity.java");

        string msdkUnityJar = ADAPTER_JARFILE_PREFIX + "3.3.7u.jar";

		string androidSdkJar = "";
		string androidSdkRoot = EditorPrefs.GetString("AndroidSdkRoot");
		if (!Directory.Exists (androidSdkRoot)) {
			env.Error ("Android Sdk Location Error! Check on \"Preferences->External Tools \"");
			return;
		}

		string[] platforms = Directory.GetDirectories (androidSdkRoot + "/platforms");
        string[] platformsTemp = platforms.Where(str => Regex.IsMatch(str, @"android-\d\d$")).ToArray();
        if (platformsTemp.Length != 0) {
            platforms = platformsTemp;
        } else {
            platforms = platforms.Where(str => Regex.IsMatch(str, @"android-\d$")).ToArray();
        }
        System.Array.Sort(platforms, System.StringComparer.Ordinal);
		for (int i=1; i<=platforms.Length; i++) {
			androidSdkJar = platforms[platforms.Length - i] + "/android.jar";
            if (File.Exists(androidSdkJar)) {
                break;
            }
		}
        if (!File.Exists(androidSdkJar)) {
            env.Error("Find android.jar error in " + androidSdkRoot + "/platforms");
        }

		string[] msdkJarFile = Directory.GetFiles (DIR_MSDKLIBRARY + "/libs", "MSDK_Android_*.jar");
		/* 此目录中应只有一个 MSDK jar 包 */
		if (msdkJarFile.Length != 1) {
			env.Error ("Get MSDK jar file error! Check jar file in " + DIR_MSDKLIBRARY + "/libs");
			return;
		}
		string msdkLibraryJar = msdkJarFile [0];

#if UNITY_EDITOR_WIN
		string shellFile = env.PATH_TEMP + "/java/MsdkAdapter.bat";
		string dirRoot = Path.GetPathRoot(env.PATH_TEMP);
		dirRoot = dirRoot.Replace("\\", "");
        dirRoot = dirRoot.Replace("/", "");
        MsdkUtil.ReplaceText (shellFile, "DirRoot", dirRoot);
#elif UNITY_EDITOR_OSX
		string shellFile = env.PATH_TEMP + "/java/MsdkAdapter.sh";
#else
		string shellFile = "";
#endif
		MsdkUtil.ReplaceText (shellFile, "MSDKUnityLibrary", env.PATH_TEMP + "/java");
		MsdkUtil.ReplaceText (shellFile, "MSDKUnityJar", msdkUnityJar);
		MsdkUtil.ReplaceText (shellFile, "MSDKLibraryJar", msdkLibraryJar);
		MsdkUtil.ReplaceText (shellFile, "AndroidSdkJar", androidSdkJar);
		MsdkUtil.ReplaceText (shellFile, "UnityJar", env.PATH_LIBRARYS_ANDROID + "/UnityClasses.jar");
		MsdkUtil.ReplaceText (shellFile, "GamePackage", packagePath);
        Debug.Log(File.ReadAllText(shellFile));
		shellFile = "\"" + shellFile + "\"";

		Encoding utf8WithoutBom = new UTF8Encoding (false);
		System.Diagnostics.Process shell = new System.Diagnostics.Process ();
		#if UNITY_EDITOR_WIN
		shell.StartInfo.FileName = "cmd.exe";
		#elif UNITY_EDITOR_OSX
		shell.StartInfo.FileName = "sh";
		#endif
		shell.StartInfo.UseShellExecute = false;
		shell.StartInfo.RedirectStandardInput = true;
		shell.StartInfo.RedirectStandardOutput = true;
		shell.StartInfo.RedirectStandardError = true;
		#if UNITY_EDITOR_WIN
		Encoding gb = Encoding.GetEncoding ("gb2312");
		shell.StartInfo.StandardOutputEncoding = gb;
		shell.StartInfo.StandardErrorEncoding = gb;
		#endif
		shell.StartInfo.CreateNoWindow = true;
		shell.Start ();

		Stream input = shell.StandardInput.BaseStream;
		StreamWriter myIn = new StreamWriter (input, utf8WithoutBom);

		#if UNITY_EDITOR_OSX
		myIn.WriteLine ("chmod a+x " + shellFile);
		#endif
		myIn.WriteLine (shellFile);
		myIn.WriteLine ("exit");
		myIn.AutoFlush = true;
		myIn.Close ();

		if (!shell.WaitForExit (5000)) {
			env.Error ("Execute shell command out time! Check Console for Detail");
		}
		if (shell.StandardError.Peek() != -1) {
			env.Error ("Execute shell command return error! Check Console for Detail");
			env.Error (shell.StandardError.ReadToEnd ());
		}
		shell.Close ();

		string outputJar = env.PATH_TEMP + "/java/classes/" + msdkUnityJar;
		if (!File.Exists (outputJar)) {
			env.Error ("Generate " + msdkUnityJar + " error! Check Console for Detail");
		} else {
            string[] adapterJars = Directory.GetFiles(env.PATH_PUGLIN_ANDROID + "/libs/");
            foreach (string file in adapterJars) {
                if (file.IndexOf(ADAPTER_JARFILE_PREFIX) >= 0) {
                    File.Delete(file);
                }
            }
			string targetJar = env.PATH_PUGLIN_ANDROID + "/libs/" + msdkUnityJar;
			File.Move (outputJar, targetJar);
		}
	}
}