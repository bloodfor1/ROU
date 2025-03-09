
#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMODUnity;

public class EditorListenerHooker : MonoBehaviour {

    public GameObject player;
    public GameObject playerListenerGO;
    FMODUnity.StudioListener listener;
	// Use this for initialization
	void Start () {
        if (player == null)
        {
            player = GameObject.Find("player");
        }
        
        playerListenerGO = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        GameObject.Destroy(playerListenerGO.GetComponent<MeshRenderer>());
        listener = playerListenerGO.AddComponent<FMODUnity.StudioListener>();

    }
	
	// Update is called once per frame
	void Update () {

        playerListenerGO.transform.position = player.transform.position;
        playerListenerGO.transform.rotation = gameObject.transform.rotation;

    }
}
#endif