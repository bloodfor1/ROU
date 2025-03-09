using UnityEngine;
using System;
using System.Reflection;
using System.Collections.Generic;
//using MoonClient;

public class RemoteDebugServerFactory : MonoBehaviour
{
    public int ServerPort = 12000;
    public int BroadcastPort = 12000;
    
    public void Awake()
    {
        // Load the server via reflection, in case the server DLL was never loaded
        // (e.g. if it was disabled, a reference to the type would be a compile error).
#if UNITY_WSA
        var serverType = typeof(Hdg.RemoteDebugServer);
#else
        var assemblies = AppDomain.CurrentDomain.GetAssemblies();

        Type serverType = null;
        Type settingsType = null;

        for (var i = 0; i < assemblies.Length; i++)
        {
            var asm = assemblies[i];
            if (serverType == null)
                serverType = asm.GetType("Hdg.RemoteDebugServer");
            if (settingsType == null)
                settingsType = asm.GetType("Hdg.Settings");
            if (serverType != null && settingsType != null)
                break;
        }

        if (serverType == null)
            return;
#endif

        var server = FindObjectOfType(serverType);
        if (server == null)
        {
            // If there is no server in the scene, then create one.
            if (serverType != null)
            {
#if UNITY_WSA
                Hdg.Settings.DEFAULT_SERVER_PORT = ServerPort == 0 ? 12000 : ServerPort;
                Hdg.Settings.DEFAULT_BROADCAST_PORT = BroadcastPort == 0 ? 12000 : BroadcastPort;
#else
                // Update the default port.
                if (settingsType != null)
                {
                    if (ServerPort == 0)
                        ServerPort = 12000;
                    var fieldInfo = settingsType.GetField("DEFAULT_SERVER_PORT");
                    if (fieldInfo != null)
                        fieldInfo.SetValue(null, ServerPort);
                    if (BroadcastPort == 0)
                        BroadcastPort = 12000;
                    fieldInfo = settingsType.GetField("DEFAULT_BROADCAST_PORT");
                    if (fieldInfo != null)
                        fieldInfo.SetValue(null, BroadcastPort);
                }
#endif
                gameObject.AddComponent(serverType);
            }
        }
        else
        {
            // Otherwise destroy ourselves because we aren't needed.
            Destroy(gameObject);
        }
        
    }
    
    public List<string> listAddGameObjectName = new List<string>()
    {
        "UIRoot"
        , "ResPool"
        , "Cameras"
        , "Reporter"
        , "Cameras"
    };
    public Dictionary<string, GameObject> dictNameToGameObject = new Dictionary<string, GameObject>();
    
    [Header("替换Shader设置")]
    public string targetShaderGo = "";
    public string targetShaderName = "Legacy Shaders/Diffuse";
    public string shaderNameFilter = "";
    public string replaceResult = "";
    
    [Hdg.Button]
    public void CallGC()
    {
        GC.Collect();
        Resources.UnloadUnusedAssets();
    }

    [Hdg.Button]
    public void CallReplaceShader()
    {
        GameObject targetGO = null;
        if (dictNameToGameObject.ContainsKey(targetShaderGo))
        {
            targetGO = dictNameToGameObject[targetShaderGo];
        }
        else
        {
            targetGO = GameObject.Find(targetShaderGo);
        }
        var targetShaderContext = Shader.Find(targetShaderName);
        if (!targetShaderContext)
        {
            replaceResult = "不存在的targetShaderName：" + targetShaderName;
            return;
        }
        if (!targetGO)
        {
            replaceResult = "不存在的targetShaderGoName：" + targetShaderGo;
            return;
        }
        var renderers = targetGO.GetComponents<Renderer>();
        if (null != renderers)
        {
            replaceResult = "不存在的renderers";
            return;
        }
        foreach(var val in renderers)
        {
            if(val 
                && val.sharedMaterial 
                && val.sharedMaterial.shader 
                && (string.IsNullOrWhiteSpace(shaderNameFilter) || val.sharedMaterial.shader.name.Contains(shaderNameFilter))
                )
            {
                val.sharedMaterial.shader = targetShaderContext;
            }
        }
    }

    [Hdg.Button]
    public void BuildGameObj()
    {
        for (int i = 0; i < listAddGameObjectName.Count; i++)
        {
            var goName = listAddGameObjectName[i];
            if(!dictNameToGameObject.ContainsKey(goName))
            {
                var go = GameObject.Find(goName);
                if (go)
                {
                    Hdg.RemoteDebugServer.AddDontDestroyOnLoadObject(go);
                    dictNameToGameObject[goName] = go;
                }
            }
        }
    }
    [Hdg.Button]
    public void ReleaseGameObj()
    {
        foreach(var val in dictNameToGameObject)
        {
            Hdg.RemoteDebugServer.RemoveDontDestroyOnLoadObject(val.Value);
        }
        dictNameToGameObject.Clear();
    }
}

