﻿using UnityEngine;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using System;

namespace FMODUnity
{
    [CustomEditor(typeof(Settings))]
    public class SettingsEditor : Editor
    {
        string[] ToggleParent = new string[] { "Disabled", "Enabled", "Development Build Only",  };

        string[] ToggleEditor = new string[] { "Enabled", "Disabled", };

        string[] FrequencyDisplay = new string[] { "Platform Default", "22050", "24000", "32000", "44100", "48000"};
        int[] FrequencyValues = new int[] { 0, 22050, 24000, 32000, 44100, 48000 };

        string[] SpeakerModeDisplay = new string[] {
            "Stereo",
            "5.1",
            "7.1" };

        int[] SpeakerModeValues = new int[] {
            (int)FMOD.SPEAKERMODE.STEREO,
            (int)FMOD.SPEAKERMODE._5POINT1,
            (int)FMOD.SPEAKERMODE._7POINT1};

        bool[] foldoutState = new bool[(int)FMODPlatform.Count];

        bool hasBankSourceChanged = false;
        string targetAssetPath;
        bool focused = false;
        
        enum SourceType : uint
        {
            Project = 0,
            Single,
            Multi
        }

        string PlatformLabel(FMODPlatform platform)
        {
            switch(platform)
            {
                case FMODPlatform.Linux:
                    return "Linux";
                case FMODPlatform.Desktop:
                    return "Desktop";
                case FMODPlatform.Console:
                    return "Console";
                case FMODPlatform.iOS:
                    return "iOS";
                case FMODPlatform.Mac:
                    return "OSX";
                case FMODPlatform.Mobile:
                    return "Mobile";
                case FMODPlatform.PS4:
                    return "PS4";
                case FMODPlatform.Windows:
                    return "Windows";
                case FMODPlatform.WindowsPhone:
                    return "Windows Phone 8.1";
                case FMODPlatform.UWP:
                    return "UWP";
                case FMODPlatform.XboxOne:
                    return "XBox One";
                case FMODPlatform.WiiU:
                    return "Wii U";
                case FMODPlatform.PSVita:
                    return "PS Vita";
                case FMODPlatform.Android:
                    return "Android";
                case FMODPlatform.AppleTV:
                    return "Apple TV";
                case FMODPlatform.MobileHigh:
                    return "High-End Mobile";
                case FMODPlatform.MobileLow:
                    return "Low-End Mobile";
                case FMODPlatform.Stadia:
                    return "Stadia";
            }
            return "Unknown";
        }

        void DisplayEditorBool(string label, List<PlatformBoolSetting> settings, FMODPlatform platform)
        {
            int current = Settings.GetSetting(settings, platform, TriStateBool.Disabled) != TriStateBool.Disabled ? 0 : 1;            
            int next = EditorGUILayout.Popup(label, (int)current, ToggleEditor);
            Settings.SetSetting(settings, platform, next == 0 ? TriStateBool.Enabled : TriStateBool.Disabled);
        }

        void DisplayParentBool(string label, List<PlatformBoolSetting> settings, FMODPlatform platform)
        {
            TriStateBool current = Settings.GetSetting(settings, platform, TriStateBool.Disabled);
            int next = EditorGUILayout.Popup(label, (int)current, ToggleParent);
            Settings.SetSetting(settings, platform, (TriStateBool)next);
        }

        void DisplayChildBool(string label, List<PlatformBoolSetting> settings, FMODPlatform platform)
        {
            bool overriden = Settings.HasSetting(settings, platform);
            TriStateBool parent = Settings.GetSetting(settings, Settings.GetParent(platform), TriStateBool.Disabled);
            TriStateBool current = Settings.GetSetting(settings, platform, TriStateBool.Disabled);

            string[] toggleChild = new string[ToggleParent.Length + 1];
            Array.Copy(ToggleParent, 0, toggleChild, 1, ToggleParent.Length);
            toggleChild[0] = String.Format("Inherit ({0})", ToggleParent[(int)parent]);

            int next = EditorGUILayout.Popup(label, overriden ? (int)current  + 1: 0, toggleChild);
            if (next == 0)
            {
                if (overriden)
                {
                    Settings.RemoveSetting(settings, platform);
                }
            }
            else
            {
                Settings.SetSetting(settings, platform, (TriStateBool)(next-1));
            }
        }

        void DisplayParentInt(string label, List<PlatformIntSetting> settings, FMODPlatform platform, int min, int max)
        {
            int current = Settings.GetSetting(settings, platform, 0);
            int next = EditorGUILayout.IntSlider(label, current, min, max);
            Settings.SetSetting(settings, platform, next);
        }

        void DisplayChildInt(string label, List<PlatformIntSetting> settings, FMODPlatform platform, int min, int max)
        {
            bool overriden = Settings.HasSetting(settings, platform);
            int current = Settings.GetSetting(settings, platform, 0);

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.PrefixLabel(label);
            overriden = !GUILayout.Toggle(!overriden, "Inherit");
            EditorGUI.BeginDisabledGroup(!overriden);
            int next = EditorGUILayout.IntSlider(current, min, max);
            EditorGUI.EndDisabledGroup();
            EditorGUILayout.EndHorizontal();

            if (overriden)
            {
                Settings.SetSetting(settings, platform, next);
            }
            else
            {
                Settings.RemoveSetting(settings, platform);
            }
        }

        void DisplayParentFreq(string label, List<PlatformIntSetting> settings, FMODPlatform platform)
        {
            int current = Settings.GetSetting(settings, platform, 0);
            int index = Array.IndexOf(FrequencyValues, current);
            int next = EditorGUILayout.Popup(label, index, FrequencyDisplay);
            Settings.SetSetting(settings, platform, FrequencyValues[next]);
        }

        void DisplayChildFreq(string label, List<PlatformIntSetting> settings, FMODPlatform platform)
        {
            bool overriden = Settings.HasSetting(settings, platform);
            int current = Settings.GetSetting(settings, platform, 0);
            int inherit = Settings.GetSetting(settings, Settings.GetParent(platform), 0);
            int currentIndex = Array.IndexOf(FrequencyValues, current);
            int inheritIndex = Array.IndexOf(FrequencyValues, inherit);

            string[] valuesChild = new string[FrequencyDisplay.Length + 1];
            Array.Copy(FrequencyDisplay, 0, valuesChild, 1, FrequencyDisplay.Length);
            valuesChild[0] = String.Format("Inherit ({0})", FrequencyDisplay[inheritIndex]);

            int next = EditorGUILayout.Popup(label, overriden ? currentIndex + 1 : 0, valuesChild);
            if (next == 0)
            {
                Settings.RemoveSetting(settings, platform);
            }
            else
            {
                Settings.SetSetting(settings, platform, FrequencyValues[next-1]);
            }
        }

        void DisplayParentSpeakerMode(string label, List<PlatformIntSetting> settings, FMODPlatform platform)
        {
            int current = Settings.GetSetting(settings, platform, (int)FMOD.SPEAKERMODE.STEREO);
            int index = Array.IndexOf(SpeakerModeValues, current);
            int next = EditorGUILayout.Popup(label, index, SpeakerModeDisplay);
            Settings.SetSetting(settings, platform, SpeakerModeValues[next]);
        }

        void DisplayPIESpeakerMode(string label, List<PlatformIntSetting> settings, FMODPlatform platform)
        {
            int buildTargetSetting = Settings.GetSetting(settings, RuntimeUtils.GetEditorFMODPlatform(), (int)FMOD.SPEAKERMODE.STEREO);
            int buildTargetIndex = Array.IndexOf(SpeakerModeValues, buildTargetSetting);
            string[] speakerModes = new string[SpeakerModeDisplay.Length + 1];
            Array.Copy(SpeakerModeDisplay, 0, speakerModes, 1, SpeakerModeDisplay.Length);
            speakerModes[0] = String.Format("Current Unity Platform ({0})", SpeakerModeDisplay[buildTargetIndex]);

            bool useCurrentUnity = !Settings.HasSetting(settings, platform);
            
            int current = Settings.GetSetting(settings, platform, (int)FMOD.SPEAKERMODE.STEREO);
            int index = Array.IndexOf(SpeakerModeValues, current) + 1;
            if (useCurrentUnity || index < 0) index = 0;
            int next = EditorGUILayout.Popup(label, index, speakerModes);
            if (next != 0)
            {
                Settings.SetSetting(settings, platform, SpeakerModeValues[next - 1]);
            }
            else
            {
                Settings.RemoveSetting(settings, platform);
            }
        }

        void DisplayChildSpeakerMode(string label, List<PlatformIntSetting> settings, FMODPlatform platform)
        {
            bool overriden = Settings.HasSetting(settings, platform);
            int current = Settings.GetSetting(settings, platform, 0);
            int inherit = Settings.GetSetting(settings, Settings.GetParent(platform), 0);
            int currentIndex = Array.IndexOf(SpeakerModeValues, current);
            int inheritIndex = Array.IndexOf(SpeakerModeValues, inherit);

            string[] valuesChild = new string[SpeakerModeDisplay.Length + 1];
            Array.Copy(SpeakerModeDisplay, 0, valuesChild, 1, SpeakerModeDisplay.Length);
            valuesChild[0] = String.Format("Inherit ({0})", SpeakerModeDisplay[inheritIndex]);

            int next = EditorGUILayout.Popup(label, overriden ? currentIndex + 1 : 0, valuesChild);
            if (next == 0)
            {
                Settings.RemoveSetting(settings, platform);
            }
            else
            {
                Settings.SetSetting(settings, platform, SpeakerModeValues[next - 1]);
            }
        }

        void DisplayParentBuildDirectory(string label, List<PlatformStringSetting> settings, FMODPlatform platform)
        {
            string[] buildDirectories = EditorUtils.GetBankPlatforms();
            
            String current = Settings.GetSetting(settings, platform, "Desktop");
            int index = Array.IndexOf(buildDirectories, current);
            if (index < 0) index = 0;

            int next = EditorGUILayout.Popup(label, index, buildDirectories);            
            Settings.SetSetting(settings, platform, buildDirectories[next]);
        }


        void DisplayPIEBuildDirectory(string label, List<PlatformStringSetting> settings, FMODPlatform platform)
        {
            String buildTargetSetting = Settings.GetSetting(settings, RuntimeUtils.GetEditorFMODPlatform(), "Desktop");
            string[] buildDirectories = new string[EditorUtils.GetBankPlatforms().Length + 1];
            Array.Copy(EditorUtils.GetBankPlatforms(), 0, buildDirectories, 1, EditorUtils.GetBankPlatforms().Length);
            buildDirectories[0] = String.Format("Current Unity Platform ({0})", buildTargetSetting);

            bool useCurrentUnity = !Settings.HasSetting(settings, platform);
            String current = Settings.GetSetting(settings, platform, "Desktop");
            int index = Array.IndexOf(buildDirectories, current);
            if (useCurrentUnity || index < 0) index = 0;

            int next = EditorGUILayout.Popup(label, index, buildDirectories);
            if (next != 0)
            {
                Settings.SetSetting(settings, platform, buildDirectories[next]);
            }
            else
            {
                Settings.RemoveSetting(settings, platform);
            }
        }

        void DisplayChildBuildDirectories(string label, List<PlatformStringSetting> settings, FMODPlatform platform)
        {
            string[] buildDirectories = EditorUtils.GetBankPlatforms();

            bool overriden = Settings.HasSetting(settings, platform);
            string current = Settings.GetSetting(settings, platform, "Desktop");
            string inherit = Settings.GetSetting(settings, Settings.GetParent(platform), "Desktop");
            int index = Array.IndexOf(buildDirectories, current);
            if (index < 0) index = 0;

            string[] valuesChild = new string[buildDirectories.Length + 1];
            Array.Copy(buildDirectories, 0, valuesChild, 1, buildDirectories.Length);
            valuesChild[0] = String.Format("Inherit ({0})", inherit);

            int next = EditorGUILayout.Popup(label, overriden ? index + 1 : 0, valuesChild);
            if (next == 0)
            {
                Settings.RemoveSetting(settings, platform);
                Settings.RemoveSetting(((Settings)target).SpeakerModeSettings, platform);
            }
            else
            {
                Settings.SetSetting(settings, platform, buildDirectories[next - 1]);
            }
        }

        void DisplayPlatform(FMODPlatform platform, FMODPlatform[] children = null)
        {
            Settings settings = target as Settings;

            var label = new global::System.Text.StringBuilder();
            label.AppendFormat("<b>{0}</b>", (PlatformLabel(platform)));
            if (children != null)
            {
                label.Append(" (");
                foreach (var child in children)
                {
                    label.Append(PlatformLabel(child));
                    label.Append(", ");
                }
                label.Remove(label.Length - 2, 2);
                label.Append(")");
            }
            
            GUIStyle style = new GUIStyle(GUI.skin.FindStyle("Foldout"));
            style.richText = true;
            
            foldoutState[(int)platform] = EditorGUILayout.Foldout(foldoutState[(int)platform], new GUIContent(label.ToString()), style);
            if (foldoutState[(int)platform])
            {
                EditorGUI.indentLevel++;
                DisplayChildBool("Live Update", settings.LiveUpdateSettings, platform);
                if (settings.IsLiveUpdateEnabled(platform))
                {
                    GUIStyle style2 = new GUIStyle(GUI.skin.label);
                    style2.richText = true;
                    EditorGUILayout.BeginHorizontal();
                    EditorGUILayout.PrefixLabel(" ");
                    #if UNITY_5_0 || UNITY_5_1
                    GUILayout.Label("Unity 5.0 or 5.1 detected: Live update will listen on port <b>9265</b>", style2);
                    #else
                    GUILayout.Label("Live update will listen on port <b>9264</b>", style2);
                    #endif
                    EditorGUILayout.EndHorizontal();
                }
                DisplayChildBool("Debug Overlay", settings.OverlaySettings, platform);
                DisplayChildFreq("Sample Rate", settings.SampleRateSettings, platform);
                if (settings.HasPlatforms && AllowBankChange(platform))
                {
                    bool prevChanged = GUI.changed;
                    DisplayChildBuildDirectories("Bank Platform", settings.BankDirectorySettings, platform);
                    hasBankSourceChanged |= !prevChanged && GUI.changed;

                    if (Settings.HasSetting(settings.BankDirectorySettings, platform))
                    {
                        DisplayChildSpeakerMode("Speaker Mode", settings.SpeakerModeSettings, platform);
                        EditorGUILayout.HelpBox(String.Format("Match the speaker mode to the setting of the platform <b>{0}</b> inside FMOD Studio", settings.GetBankPlatform(platform)), MessageType.Info, false);
                    }
                    else
                    {
                        EditorGUI.BeginDisabledGroup(true);
                        DisplayChildSpeakerMode("Speaker Mode", settings.SpeakerModeSettings, platform);
                        EditorGUI.EndDisabledGroup();
                    }
                }

                DisplayChildInt("Virtual Channel Count", settings.VirtualChannelSettings, platform, 1, 2048);
                DisplayChildInt("Real Channel Count", settings.RealChannelSettings, platform, 1, 256);

                if (children != null)
                {
                    foreach (var child in children)
                    {
                        DisplayPlatform(child);
                    }
                }

                EditorGUI.indentLevel--;
            }
        }

        private bool AllowBankChange(FMODPlatform platform)
        {
            // Can't do these settings on pseudo-platforms
            if (platform == FMODPlatform.MobileLow || platform == FMODPlatform.MobileHigh)
            {
                return false;
            }

            return true;
        }
        
        public override void OnInspectorGUI()
        {
            Settings settings = target as Settings;
            
            EditorGUI.BeginChangeCheck();

            hasBankSourceChanged = false;
            bool hasBankTargetChanged = false;

            GUIStyle style = new GUIStyle(GUI.skin.label);
            style.richText = true;

            GUI.skin.FindStyle("HelpBox").richText = true;

            SourceType sourceType = settings.HasSourceProject ? SourceType.Project : (settings.HasPlatforms ? SourceType.Multi : SourceType.Single);

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.BeginVertical();
            sourceType = GUILayout.Toggle(sourceType == SourceType.Project, "Project", "Button") ? 0 : sourceType;
            sourceType = GUILayout.Toggle(sourceType == SourceType.Single, "Single Platform Build", "Button") ? SourceType.Single : sourceType;
            sourceType = GUILayout.Toggle(sourceType == SourceType.Multi, "Multiple Platform Build", "Button") ? SourceType.Multi : sourceType;
            EditorGUILayout.EndVertical();
            EditorGUILayout.BeginVertical();

            EditorGUILayout.HelpBox(
                "<size=11>Select the way you wish to connect Unity to the FMOD Studio content:\n" +
                "<b>• Project</b>\t\tIf you have the complete FMOD Studio project avaliable\n" +
                "<b>• Single Platform</b>\tIf you have only the contents of the <i>Build</i> folder for a single platform\n" +
                "<b>• Multiple Platforms</b>\tIf you have only the contents of the <i>Build</i> folder for multiple platforms, each platform in it's own sub directory\n" + 
                "</size>"
                , MessageType.Info, true);
            EditorGUILayout.EndVertical();
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.Space();

            
            if (sourceType == SourceType.Project)
            {
                EditorGUILayout.BeginHorizontal();
                string oldPath = settings.SourceProjectPath;
                EditorGUILayout.PrefixLabel("Studio Project Path", GUI.skin.textField, style);

                EditorGUI.BeginChangeCheck();
                string newPath = EditorGUILayout.TextField(GUIContent.none, settings.SourceProjectPath);
                if (EditorGUI.EndChangeCheck())
                {
                    if (newPath.EndsWith(".fspro"))
                    {
                        settings.SourceProjectPath = newPath;
                    }
                }

                if (GUILayout.Button("Browse", GUILayout.ExpandWidth(false)))
                {
                    GUI.FocusControl(null);
                    string path = EditorUtility.OpenFilePanel("Locate Studio Project", oldPath, "fspro");
                    if (!String.IsNullOrEmpty(path))
                    {
                        settings.SourceProjectPath = MakePathRelative(path);
                        this.Repaint();
                    }
                }
                EditorGUILayout.EndHorizontal();

                // Cache in settings for runtime access in play-in-editor mode
                string bankPath = EditorUtils.GetBankDirectory();
                settings.SourceBankPath = bankPath;
                settings.HasPlatforms = true;
                settings.HasSourceProject = true;

                // First time project path is set or changes, copy to streaming assets
                if (settings.SourceProjectPath != oldPath)
                {
                    hasBankSourceChanged = true;
                }
            }

            if (sourceType == SourceType.Single || sourceType == SourceType.Multi)
            {
                EditorGUILayout.BeginHorizontal();
                string oldPath = settings.SourceBankPath;
                EditorGUILayout.PrefixLabel("Build Path", GUI.skin.textField, style);

                EditorGUI.BeginChangeCheck();
                string newPath = EditorGUILayout.TextField(GUIContent.none, settings.SourceBankPath);
                if (EditorGUI.EndChangeCheck())
                {
                    settings.SourceBankPath = newPath;
                }

                if (GUILayout.Button("Browse", GUILayout.ExpandWidth(false)))
                {
                    GUI.FocusControl(null);
                    var path = EditorUtility.OpenFolderPanel("Locate Build Folder", oldPath, null);
                    if (!String.IsNullOrEmpty(path))
                    {
                        path = MakePathRelative(path);
                        settings.SourceBankPath = path;
                    }
                }
                EditorGUILayout.EndHorizontal();

                settings.HasPlatforms = (sourceType == SourceType.Multi);
                settings.HasSourceProject = false;

                // First time project path is set or changes, copy to streaming assets
                if (settings.SourceBankPath != oldPath)
                {
                    hasBankSourceChanged = true;
                }
            }

            bool validBanks;
            string failReason;
            EditorUtils.ValidateSource(out validBanks, out failReason);
            if (!validBanks)
            {
                EditorGUILayout.HelpBox(failReason, MessageType.Error, true);
                if (EditorGUI.EndChangeCheck())
                {
                    EditorUtility.SetDirty(settings);
                }
                return;
            }

            ImportType importType = (ImportType)EditorGUILayout.EnumPopup("Import Type", settings.ImportType);
            if (importType != settings.ImportType)
            {
                hasBankTargetChanged = true;
                settings.ImportType = importType;

                bool deleteBanks = EditorUtility.DisplayDialog(
                    "FMOD Bank Import Type Changed", "Do you want to delete the " + (importType == ImportType.AssetBundle ? "StreamingAssets" : "AssetBundle") + " banks in " + (importType == ImportType.AssetBundle ? Application.streamingAssetsPath : Application.dataPath + '/' + settings.TargetAssetPath)
                    , "Yes", "No");
                if (deleteBanks)
                {
                    // Delete the old banks
                    EventManager.removeBanks = true;
                    EventManager.RefreshBanks();
                }
            }

            // ----- Text Assets -------------
            if (settings.ImportType == ImportType.AssetBundle)
            {
                GUI.SetNextControlName("targetAssetPath");
                targetAssetPath = EditorGUILayout.TextField("FMOD Asset Folder", string.IsNullOrEmpty(targetAssetPath) ? settings.TargetAssetPath : targetAssetPath);
                if (GUI.GetNameOfFocusedControl() == "targetAssetPath")
                {
                    focused = true;
                    if (Event.current.isKey)
                    {
                        switch (Event.current.keyCode)
                        {
                            case KeyCode.Return:
                            case KeyCode.KeypadEnter:
                                settings.TargetAssetPath = targetAssetPath;
                                hasBankTargetChanged = true;
                                break;
                        }
                    }
                }
                else if (focused)
                {
                    settings.TargetAssetPath = targetAssetPath;
                    hasBankTargetChanged = true;
                    focused = false;
                }
            }

            // ----- Logging -----------------
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField("<b>Logging</b>", style);
            EditorGUI.indentLevel++;
            settings.LoggingLevel = (FMOD.DEBUG_FLAGS)EditorGUILayout.EnumPopup("Logging Level", settings.LoggingLevel);
            EditorGUI.indentLevel--;

            // ----- Loading -----------------
            EditorGUI.BeginDisabledGroup(settings.ImportType == ImportType.AssetBundle);
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField("<b>Loading</b>", style);
            EditorGUI.indentLevel++;
            settings.AutomaticEventLoading = EditorGUILayout.Toggle("Load All Event Data at Initialization", settings.AutomaticEventLoading);
            EditorGUI.BeginDisabledGroup(!settings.AutomaticEventLoading);
            settings.AutomaticSampleLoading = EditorGUILayout.Toggle("Load All Sample Data at Initialization", settings.AutomaticSampleLoading);
            EditorGUI.EndDisabledGroup();
            EditorGUI.indentLevel--;
            EditorGUI.EndDisabledGroup();

            // ----- PIE ----------------------------------------------
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField("<b>Play In Editor Settings</b>", style);
            EditorGUI.indentLevel++;
            DisplayEditorBool("Live Update", settings.LiveUpdateSettings, FMODPlatform.PlayInEditor);
            if (settings.IsLiveUpdateEnabled(FMODPlatform.PlayInEditor))
            {
                EditorGUILayout.BeginHorizontal();
                settings.LiveUpdatePort = ushort.Parse(EditorGUILayout.TextField("Live Update Port:", settings.LiveUpdatePort.ToString()));
                if (GUILayout.Button("Reset", GUILayout.ExpandWidth(false)))
                {
                    #if UNITY_5_0 || UNITY_5_1
                    settings.LiveUpdatePort = 9265;
                    #else
                    settings.LiveUpdatePort = 9264;
                    #endif
                }
                EditorGUILayout.EndHorizontal();
                #if UNITY_5_0 || UNITY_5_1
                EditorGUILayout.HelpBox("Unity 5.0 or 5.1 detected: Live update will not be able to use port <b>9264</b>", MessageType.Warning, false);
                #endif
            }
            DisplayEditorBool("Debug Overlay", settings.OverlaySettings, FMODPlatform.PlayInEditor);
            DisplayChildFreq("Sample Rate", settings.SampleRateSettings, FMODPlatform.PlayInEditor);
            if (settings.HasPlatforms)
            {
                DisplayPIEBuildDirectory("Bank Platform", settings.BankDirectorySettings, FMODPlatform.PlayInEditor);
            }

            DisplayPIESpeakerMode("Speaker Mode", settings.SpeakerModeSettings, FMODPlatform.PlayInEditor);
            if (settings.HasPlatforms)
            {
                EditorGUILayout.HelpBox(String.Format("Match the speaker mode to the setting of the platform <b>{0}</b> inside FMOD Studio", settings.GetBankPlatform(FMODPlatform.PlayInEditor)), MessageType.Info, false);
            }
            else
            {
                EditorGUILayout.HelpBox("Match the speaker mode to the setting inside FMOD Studio", MessageType.Info, false);
            }

            EditorGUI.indentLevel--;

            // ----- Default ----------------------------------------------
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField("<b>Default Settings</b>", style);
            EditorGUI.indentLevel++;
            DisplayParentBool("Live Update", settings.LiveUpdateSettings, FMODPlatform.Default);
            if (settings.IsLiveUpdateEnabled(FMODPlatform.Default))
            {
                #if UNITY_5_0 || UNITY_5_1
                EditorGUILayout.HelpBox("Unity 5.0 or 5.1 detected: Live update will listen on port <b>9265</b>", MessageType.Warning, false);
                #else
                EditorGUILayout.HelpBox("Live update will listen on port <b>9264</b>", MessageType.Info, false);
                #endif
            }
            DisplayParentBool("Debug Overlay", settings.OverlaySettings, FMODPlatform.Default);
            DisplayParentFreq("Sample Rate", settings.SampleRateSettings, FMODPlatform.Default);
            if (settings.HasPlatforms)
            {
                bool prevChanged = GUI.changed;
                DisplayParentBuildDirectory("Bank Platform", settings.BankDirectorySettings, FMODPlatform.Default);
                hasBankSourceChanged |= !prevChanged && GUI.changed;
            }

            DisplayParentSpeakerMode("Speaker Mode", settings.SpeakerModeSettings, FMODPlatform.Default);
            if (settings.HasPlatforms)
            {
                EditorGUILayout.HelpBox(String.Format("Match the speaker mode to the setting of the platform <b>{0}</b> inside FMOD Studio", settings.GetBankPlatform(FMODPlatform.Default)), MessageType.Info, false);
            }
            else
            {
                EditorGUILayout.HelpBox("Match the speaker mode to the setting inside FMOD Studio", MessageType.Info, false);
            }
            DisplayParentInt("Virtual Channel Count", settings.VirtualChannelSettings, FMODPlatform.Default, 1, 2048);
            DisplayParentInt("Real Channel Count", settings.RealChannelSettings, FMODPlatform.Default, 1, 256);
            EditorGUI.indentLevel--;


            // ----- Plugins ----------------------------------------------
            EditorGUILayout.Separator();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.PrefixLabel("<b>Plugins</b>", GUI.skin.button, style);
            if (GUILayout.Button("Add Plugin", GUILayout.ExpandWidth(false)))
            {
                settings.Plugins.Add("");
            }
            EditorGUILayout.EndHorizontal();

            EditorGUI.indentLevel++;
            for (int count = 0; count < settings.Plugins.Count; count++)
            {
                EditorGUILayout.BeginHorizontal();
                settings.Plugins[count] = EditorGUILayout.TextField("Plugin " + (count + 1).ToString() + ":", settings.Plugins[count]);

                if (GUILayout.Button("Delete Plugin", GUILayout.ExpandWidth(false)))
                {
                    settings.Plugins.RemoveAt(count);
                }
                EditorGUILayout.EndHorizontal();
            }
            EditorGUI.indentLevel--;


            // ----- Windows ----------------------------------------------
            DisplayPlatform(FMODPlatform.Desktop, null);
            DisplayPlatform(FMODPlatform.Mobile, new FMODPlatform[] { FMODPlatform.MobileHigh, FMODPlatform.MobileLow, FMODPlatform.PSVita, FMODPlatform.AppleTV });
            DisplayPlatform(FMODPlatform.Console, new FMODPlatform[] { FMODPlatform.XboxOne, FMODPlatform.PS4, FMODPlatform.WiiU, FMODPlatform.Stadia });

            if (EditorGUI.EndChangeCheck())
            {
                EditorUtility.SetDirty(settings);
            }

            /*
            if (hasBankSourceChanged)
            {
                EventManager.UpdateCache();
            }
            if (hasBankTargetChanged)
            {
                EventManager.CopyToStreamingAssets();
            }*/
        }

        private string MakePathRelative(string path)
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
    }
}
