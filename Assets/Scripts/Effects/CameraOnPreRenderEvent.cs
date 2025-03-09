using UnityEngine;

[RequireComponent(typeof(Camera))]
public class CameraOnPreRenderEvent : MonoBehaviour {

    public System.Action onPreRenderAction;

    private void OnPreRender()
    {
        onPreRenderAction?.Invoke();
    }

    public static CameraOnPreRenderEvent GetScriptComponent(Camera camera)
    {
        if (camera)
        {
            var target = camera.GetComponent<CameraOnPreRenderEvent>();
            if (!target)
                target = camera.gameObject.AddComponent<CameraOnPreRenderEvent>();
            return target;
        }
        else
            return null;
    }

    public static void RemoveComponent(Camera camera)
    {
        var target = camera.GetComponent<CameraOnPreRenderEvent>();
        if (target) Destroy(target);
    }
}
