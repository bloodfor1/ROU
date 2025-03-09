using UnityEditor;
using UnityEngine;

namespace Cinemachine.Editor
{
    [CustomEditor(typeof(CinemachineDollyCart))]
    internal sealed class CinemachineDollyCartEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            if (serializedObject == null || serializedObject.targetObject == null) return;

            var dolly = serializedObject.targetObject as CinemachineDollyCart;
            if (dolly == null) return;

            EditorGUILayout.PropertyField(serializedObject.FindProperty("m_Path"), new GUIContent("轨道资源"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("m_UpdateMethod"), new GUIContent("更新方式"));
            var positionUnitProperty = serializedObject.FindProperty("m_PositionUnits");
            EditorGUILayout.PropertyField(positionUnitProperty, new GUIContent("PositionUnits"));
            if (positionUnitProperty.intValue == (int) CinemachinePathBase.PositionUnits.Distance)
            {
                var activeProperty = serializedObject.FindProperty("ActiveCurveCtrl");
                EditorGUILayout.PropertyField(activeProperty, new GUIContent("曲线控制"));
                if (activeProperty.boolValue)
                {
                    EditorGUILayout.PropertyField(serializedObject.FindProperty("CurveCtrl"), new GUIContent("CurveCtrl"), true);
                }
            }
            else
            {
                EditorGUILayout.PropertyField(serializedObject.FindProperty("m_Speed"), new GUIContent("速率"));
            }

            EditorGUILayout.PropertyField(serializedObject.FindProperty("Signal"), new GUIContent("信号"));

            serializedObject?.ApplyModifiedProperties();
        }
    }
}
