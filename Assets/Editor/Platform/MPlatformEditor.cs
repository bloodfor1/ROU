using MoonCommonLib;
using System.IO;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(MPlatform))]
public class MPlatformEditor : Editor
{
    private bool dllversionFold = false;

    private bool _enableCutScene;
    private bool _enableTranslateDebug;
    private MGameArea _gameArea;
    private MGameLanguage _gameLanguage;

    private void OnEnable()
    {
        _enableCutScene = PlayerPrefs.GetInt("ENABLE_CUTSCENE", 1) > 0;
        _enableTranslateDebug = PlayerPrefs.GetInt("ENABLE_TRANSLATE_DEBUG", 0) > 0;
        var config = MPlatformConfigManager.GetLocal(true);
        _gameArea = config.area;
        _gameLanguage = config.language;
    }

    public override void OnInspectorGUI()
    {
        dllversionFold = EditorGUILayout.Foldout(dllversionFold, "dll列表");
        if (dllversionFold)
        {
            var dllRoot = DirectoryEx.Combine(Application.dataPath, "Plugins/GameLibs");
            var dlls = Directory.GetFiles(dllRoot, "*.dll", SearchOption.AllDirectories);
            foreach (var dll in dlls)
            {
                var dllName = Path.GetFileNameWithoutExtension(dll);
                var hash = HashUtil.GetFileHash(dll);
                EditorGUILayout.LabelField(dllName, hash);
            }
        }
       
        GUILayout.Space(20);

        base.OnInspectorGUI();

        GUILayout.BeginHorizontal();
        GUILayout.Label("开启CutScene");
        var tmp = _enableCutScene;
        tmp = GUILayout.Toggle(tmp, "");
        if (tmp != _enableCutScene)
        {
            _enableCutScene = tmp;
            PlayerPrefs.SetInt("ENABLE_CUTSCENE", _enableCutScene ? 1 : 0);
        }
        GUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();
        GUILayout.Label("开启翻译Debug");
        var tmp1 = _enableTranslateDebug;
        tmp1 = GUILayout.Toggle(tmp1, "");
        if (tmp1 != _enableTranslateDebug)
        {
            _enableTranslateDebug = tmp1;
            PlayerPrefs.SetInt("ENABLE_TRANSLATE_DEBUG", _enableTranslateDebug ? 1 : 0);
        }
        GUILayout.EndHorizontal();

        if (!DirectoryEx.IsDirectoryEmpty(PathEx.GetHotUpdatePath())
            || File.Exists(MPlatformConfigManager.configCachePath))
        {
            if (GUILayout.Button("清除缓存文件"))
            {
                DirectoryEx.DeleteDirectorySafely(PathEx.GetHotUpdatePath());
                FileEx.DeleteFileSafely(MPlatformConfigManager.configCachePath);
            }
        }
        if (GUILayout.Button("清除本地Key(PlayerPrefs)"))
        {
            PlayerPrefs.DeleteAll();
        }

        EditorGUILayout.Space();
        EditorGUILayout.Space();

        var area = (MGameArea) EditorGUILayout.EnumPopup("地区:", _gameArea);
        var language = (MGameLanguage) EditorGUILayout.EnumPopup("语言:", _gameLanguage);
        if (_gameArea != area || _gameLanguage != language)
        {
            var config = MPlatformConfigManager.GetLocal(true);
            config.area = area;
            config.language = language;
            config.SaveLocal();

            _gameArea = area;
            _gameLanguage = language;

            AssetDatabase.Refresh();
        }
    }
}

