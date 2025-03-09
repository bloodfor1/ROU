using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ProjectorCacheMaterial : MonoBehaviour {

//#if UNITY_EDITOR
//    [UnityEditor.MenuItem("Assets/Batch Add Proj Cache Material")]
//    public static void AddToProjector()
//    {
//        foreach (var s in UnityEditor.Selection.gameObjects)
//        {
//            var p = s.GetComponentInChildren<Projector>(true);
//            if (p && p.material && p.material.shader.name.IndexOf("Caution") > 0)
//            {
//                p.gameObject.AddComponent<ProjectorCacheMaterial>();
//                UnityEditor.EditorUtility.SetDirty(s);
//            }
//        }
//    }
//#endif

//    private Material orgMaterial;
//    private Material cacheMaterial;
//    private Projector projector;

    //private void OnEnable()
    //{

        //projector = GetComponent<Projector>();
        //orgMaterial = projector.material;
        //if (orgMaterial)
        //{
        //    cacheMaterial = Instantiate(orgMaterial);
        //    projector.material = cacheMaterial;
        //}
    //}

    private void OnEnable()
    {
        DestroyImmediate(this);
    }

    //private void OnDestroy()
    //{
    //    if (projector)
    //    {
    //        projector.material = orgMaterial;
    //    }
    //    if (cacheMaterial)
    //    {
    //        Destroy(cacheMaterial);
    //        cacheMaterial = null;
    //    }
    //}
}
