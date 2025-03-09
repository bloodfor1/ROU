using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;
using UnityEditor;
using UnityEngine;
using System;

public class PlatformConfigEditorWindow : EditorWindow {

    private MPlatformConfig _tempConfig = new MPlatformConfig();
    private string _tempVersionStr;

    [MenuItem("ROTools/Hotfix Tools/Config Editor")]
    public static PlatformConfigEditorWindow GetEditorWindow()
    {
        var window = GetWindow<PlatformConfigEditorWindow>();
        window.Show();
        return window;
    }

    void OnGUI()
    {
        bool isDebug = EditorGUILayout.Toggle("开启Debug", (_tempConfig.mode.packageMode & 1) > 0);
        bool isGm = EditorGUILayout.Toggle("开启GM", (_tempConfig.mode.packageMode & 2) > 0);
        _tempConfig.mode.SetPackageMode(isDebug, isGm, false, false);
        _tempConfig.mode.zipMode = (EMZipMode)EditorGUILayout.EnumPopup("zip模式", _tempConfig.mode.zipMode);
        _tempConfig.mode.abMode = (EMABMode)EditorGUILayout.EnumPopup("ab打包模式", _tempConfig.mode.abMode);
        _tempVersionStr = EditorGUILayout.TextField("版本号", _tempVersionStr);
        _tempConfig.fileServer = EditorGUILayout.TextField("文件服务器", _tempConfig.fileServer);
        _tempConfig.hotUpdate.type = (MUpdateWay)EditorGUILayout.EnumPopup("热更类型", _tempConfig.hotUpdate.type);
        _tempConfig.hotUpdate.serverUrl = EditorGUILayout.TextField("热更下载服", _tempConfig.hotUpdate.serverUrl);
        _tempConfig.hotUpdate.preServerUrl = EditorGUILayout.TextField("热更预发布下载服", _tempConfig.hotUpdate.preServerUrl);
        _tempConfig.hotUpdate.channelId = EditorGUILayout.TextField("热更渠道号", _tempConfig.hotUpdate.channelId);
        _tempConfig.programUpdate.type = (MUpdateWay)EditorGUILayout.EnumPopup("强更类型", _tempConfig.programUpdate.type);
        _tempConfig.programUpdate.serverUrl = EditorGUILayout.TextField("强更下载服", _tempConfig.programUpdate.serverUrl);
        _tempConfig.programUpdate.preServerUrl = EditorGUILayout.TextField("强更预发布下载服", _tempConfig.programUpdate.preServerUrl);
        _tempConfig.programUpdate.channelId = EditorGUILayout.TextField("强更渠道号", _tempConfig.programUpdate.channelId);

        if (GUILayout.Button("Save"))
        {
            if (!MVersion.TryParse(_tempVersionStr, out _tempConfig.version))
            {
                EditorGUILayout.HelpBox("Bad Version Id", MessageType.Error);
            }
            else
            {
                _tempConfig.SaveLocal();
            }
        }
    }

}
