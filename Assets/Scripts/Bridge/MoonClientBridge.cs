using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;
using UnityEngine;

public class MoonClientBridge
{
    private static IMoonClientBridge _bridge;
    public static IMoonClientBridge Bridge
    {
        get
        {
            if (_bridge == null)
            {
                _bridge = MInterfaceMgr.singleton.GetInterface<IMoonClientBridge>("MoonClientBridge");
            }
            return _bridge;
        }
    }
}
