using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterRealtimeReflact : MonoBehaviour {

    Camera mRefCam;
    Vector3 refPos;
    Vector3 refRot;
    RenderTexture mRefTex;

    private void OnWillRenderObject()
    {
        if (!Camera.main || Camera.current != Camera.main)
            return;

        if (mRefCam)
        {
            UpdateCamera(Camera.main);
        }
        else
        {
            GameObject go = new GameObject("RefCam");
            mRefCam = go.AddComponent<Camera>();
            mRefCam.CopyFrom(Camera.current);
            UpdateCamera(Camera.main);
            if (!mRefTex)
            {
                mRefTex = RenderTexture.GetTemporary(Screen.width, Screen.height, 0);
                mRefCam.targetTexture = mRefTex;
                GetComponent<Renderer>().material.SetTexture("_ReflectionTex", mRefTex);
            }
        }
    }

    private void OnDestroy()
    {
        if (mRefTex) Destroy(mRefTex);
        if (mRefCam) Destroy(mRefCam.gameObject);
    }

    void UpdateCamera(Camera main)
    {
        Vector3 normal = transform.up;
        Vector3 pos = transform.position;
        Vector4 reflectionPlane = new Vector4(normal.x, normal.y, normal.z, -Vector3.Dot(normal, pos) - 0.07f);

        Matrix4x4 reflection = Matrix4x4.zero;
        CalculateReflectionMatrix(ref reflection, reflectionPlane);
        mRefCam.worldToCameraMatrix = main.worldToCameraMatrix * reflection;

        // Setup oblique projection matrix so that near plane is our reflection
        // plane. This way we clip everything below/above it for free.
        Vector4 clipPlane = CameraSpacePlane(mRefCam, pos, normal, 1.0f);
        mRefCam.projectionMatrix = main.CalculateObliqueMatrix(clipPlane);

        // Set custom culling matrix from the current camera
        mRefCam.cullingMatrix = main.projectionMatrix * main.worldToCameraMatrix;
    }

    Vector4 CameraSpacePlane(Camera cam, Vector3 pos, Vector3 normal, float sideSign)
    {
        Vector3 offsetPos = pos + normal * 0.07f;
        Matrix4x4 m = cam.worldToCameraMatrix;
        Vector3 cpos = m.MultiplyPoint(offsetPos);
        Vector3 cnormal = m.MultiplyVector(normal).normalized * sideSign;
        return new Vector4(cnormal.x, cnormal.y, cnormal.z, -Vector3.Dot(cpos, cnormal));
    }

    static void CalculateReflectionMatrix(ref Matrix4x4 reflectionMat, Vector4 plane)
    {
        reflectionMat.m00 = (1F - 2F * plane[0] * plane[0]);
        reflectionMat.m01 = (-2F * plane[0] * plane[1]);
        reflectionMat.m02 = (-2F * plane[0] * plane[2]);
        reflectionMat.m03 = (-2F * plane[3] * plane[0]);

        reflectionMat.m10 = (-2F * plane[1] * plane[0]);
        reflectionMat.m11 = (1F - 2F * plane[1] * plane[1]);
        reflectionMat.m12 = (-2F * plane[1] * plane[2]);
        reflectionMat.m13 = (-2F * plane[3] * plane[1]);

        reflectionMat.m20 = (-2F * plane[2] * plane[0]);
        reflectionMat.m21 = (-2F * plane[2] * plane[1]);
        reflectionMat.m22 = (1F - 2F * plane[2] * plane[2]);
        reflectionMat.m23 = (-2F * plane[3] * plane[2]);

        reflectionMat.m30 = 0F;
        reflectionMat.m31 = 0F;
        reflectionMat.m32 = 0F;
        reflectionMat.m33 = 1F;
    }
}
