using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MGameUwaLaunch : MonoBehaviour {
	void Awake ()
    {
#if UWA_TEST
        UWAEngine.StaticInit();
#endif
    }

}
