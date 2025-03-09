using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;
using UnityEngine;

public class ActiveOnlyRes : MonoBehaviour {

	// Use this for initialization
	void Start ()
    {
        bool isRes = MGameContext.singleton.IsGameEditorMode;
        if (gameObject.activeInHierarchy != isRes)
        {
            gameObject.SetActive(isRes);
        }
    }
}
