using MoonCommonLib;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Cinemachine.Timeline
{
    internal sealed class CinemachineShotPlayable : PlayableBehaviour
    {
        public CinemachineVirtualCameraBase VirtualCamera;

        private ICutSceneShotHelper _helper;
        private IMCinemachine _proxy;

        public override void OnBehaviourPlay(Playable playable, FrameData info)
        {
            base.OnBehaviourPlay(playable, info);

            _proxy = MInterfaceMgr.singleton.GetInterface<IMCinemachine>(MCommonFunctions.GetHash("MCinemachine"));

            if (Application.isPlaying)
            {
                _proxy.OnCinemachineShotStart(VirtualCamera.gameObject);
            }
            else
            {
                _helper = MInterfaceMgr.singleton.GetInterface<ICutSceneShotHelper>(
                    MCommonFunctions.GetHash("MCutSceneShotHelper"));
                _helper?.ResetCinemachineDollyCart(VirtualCamera.transform, (float)(playable.GetTime()));
            }
        }

        public override void PrepareFrame(Playable playable, FrameData info)
        {
            base.PrepareFrame(playable, info);
            if (Application.isPlaying) return;

            _helper?.UpdateCinemachineDollyCart(VirtualCamera.transform, (float)(playable.GetTime() - playable.GetPreviousTime()));
        }

        public override void OnBehaviourPause(Playable playable, FrameData info)
        {
            base.OnBehaviourPause(playable, info);
            _helper = null;
            _proxy = null;
        }
    }

    public sealed class CinemachineShot : PlayableAsset, IPropertyPreview
    {
        public ExposedReference<CinemachineVirtualCameraBase> VirtualCamera;

        public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
        {
            var playable = ScriptPlayable<CinemachineShotPlayable>.Create(graph);
            playable.GetBehaviour().VirtualCamera = VirtualCamera.Resolve(graph.GetResolver());
            return playable;
        }

        // IPropertyPreview implementation
        public void GatherProperties(PlayableDirector director, IPropertyCollector driver)
        {
            driver.AddFromName<Transform>("m_LocalPosition.x");
            driver.AddFromName<Transform>("m_LocalPosition.y");
            driver.AddFromName<Transform>("m_LocalPosition.z");
            driver.AddFromName<Transform>("m_LocalRotation.x");
            driver.AddFromName<Transform>("m_LocalRotation.y");
            driver.AddFromName<Transform>("m_LocalRotation.z");

            driver.AddFromName<Camera>("field of view");
            driver.AddFromName<Camera>("near clip plane");
            driver.AddFromName<Camera>("far clip plane");
        }
    }
}
