﻿using System;
using MoonCommonLib;
using UnityEngine;
using UnityEngine.Serialization;

namespace Cinemachine
{
    [Serializable]
    public class CinemachineDollyCartCtrlCurve
    {
        public AnimationCurve Curve;
        [NonSerialized]
        public float Time;
        public float TotalTime;
    }

    /// <summary>
    /// This is a very simple behaviour that constrains its transform to a CinemachinePath.  
    /// It can be used to animate any objects along a path, or as a Follow target for 
    /// Cinemachine Virtual Cameras.
    /// </summary>
    [DocumentationSorting(21f, DocumentationSortingAttribute.Level.UserRef)]
    [ExecuteInEditMode]
    public class CinemachineDollyCart : MonoBehaviour
    {
        /// <summary>The path to follow</summary>
        [Tooltip("The path to follow")]
        public CinemachinePathBase m_Path;

        /// <summary>This enum defines the options available for the update method.</summary>
        public enum UpdateMethod
        {
            /// <summary>Updated in normal MonoBehaviour Update.</summary>
            Update,
            /// <summary>Updated in sync with the Physics module, in FixedUpdate</summary>
            FixedUpdate
        };

        /// <summary>When to move the cart, if Velocity is non-zero</summary>
        [Tooltip("When to move the cart, if Velocity is non-zero")]
        public UpdateMethod m_UpdateMethod = UpdateMethod.Update;

        /// <summary>How to interpret the Path Position</summary>
        [Tooltip("How to interpret the Path Position.  If set to Path Units, values are as follows: 0 represents the first waypoint on the path, 1 is the second, and so on.  Values in-between are points on the path in between the waypoints.  If set to Distance, then Path Position represents distance along the path.")]
        public CinemachinePathBase.PositionUnits m_PositionUnits = CinemachinePathBase.PositionUnits.Distance;

        /// <summary>Move the cart with this speed</summary>
        [Tooltip("Move the cart with this speed along the path.  The value is interpreted according to the Position Units setting.")]
        [FormerlySerializedAs("m_Velocity")]
        public float m_Speed;

        /// <summary>The cart's current position on the path, in distance units</summary>
        [Tooltip("The position along the path at which the cart will be placed.  This can be animated directly or, if the velocity is non-zero, will be updated automatically.  The value is interpreted according to the Position Units setting.")]
        [FormerlySerializedAs("m_CurrentDistance")]
        public float m_Position;

        public bool Signal = true;

        public bool ActiveCurveCtrl;
        public CinemachineDollyCartCtrlCurve CurveCtrl;

        private void Start()
        {
            SetCartPosition(m_Position);

            Signal = true;
            if (!ActiveCurveCtrl || CurveCtrl == null) return;

            CurveCtrl.Time = 0f;
            if (Signal && m_PositionUnits == CinemachinePathBase.PositionUnits.Distance)
            {
                Signal = false;
            }
        }

        void FixedUpdate()
        {
            if (!Signal) return;

            if (m_UpdateMethod == UpdateMethod.FixedUpdate)
            {
                SetCartPositionByDeltaTime(Time.deltaTime);
            }
        }

        void Update()
        {
            if (!Signal) return;

            if (!Application.isPlaying)
            {
                SetCartPosition(m_Position);
            }
            else if (m_UpdateMethod == UpdateMethod.Update)
            {
                SetCartPositionByDeltaTime(Time.deltaTime);
            }
        }

        public void SetCartPosition(float distanceAlongPath)
        {
            if (m_Path != null)
            {
                m_Position = m_Path.NormalizeUnit(distanceAlongPath, m_PositionUnits);
                transform.position = m_Path.EvaluatePositionAtUnit(m_Position, m_PositionUnits);
                transform.rotation = m_Path.EvaluateOrientationAtUnit(m_Position, m_PositionUnits);
            }
        }

        public void SetCartPositionByDeltaTime(float deltaTime)
        {
            if (ActiveCurveCtrl && m_PositionUnits == CinemachinePathBase.PositionUnits.Distance && CurveCtrl != null)
            {
                CurveCtrl.Time += deltaTime;
                float v = CurveCtrl.Curve?.Evaluate(CurveCtrl.Time / CurveCtrl.TotalTime) ?? 1;
                m_Position = m_Path.PathLength * v;
                SetCartPosition(m_Position);
            }
            else
            {
                SetCartPosition(m_Position += m_Speed * deltaTime);
            }
        }
    }
}
