using System;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ColliderShow : MonoBehaviour
{
#if UNITY_EDITOR
    void OnDrawGizmos()
    {
        Gizmos.color = Color.green;

        Collider[] allCollider = gameObject.GetComponentsInChildren<Collider>();

        foreach (Collider collider in allCollider)
        {
            BoxCollider b = collider as BoxCollider;

            if (b != null)
            {
                Transform go = b.transform;

                Matrix4x4 rotationMatrix = go.localToWorldMatrix;
                Gizmos.matrix = rotationMatrix;
                Gizmos.DrawWireCube(Vector3.zero, Vector3.one);
            }

            CapsuleCollider c = collider as CapsuleCollider;
            if (c != null)
            {
                Transform go = c.transform;
                Gizmos.DrawWireSphere(go.position + Vector3.up, go.localScale.x * c.radius);
            }
        }
    }
#endif
}
