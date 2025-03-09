using System.Collections.Generic;
using UnityEngine;

namespace PlayerMaskColor
{
    [System.Serializable]
    public class ColorAsset : ScriptableObject
    {
        public List<ColorData> datas = new List<ColorData>();
    }

    [System.Serializable]
    public class ColorData
    {
        public string tag;
        public Color lighColor;
        public Color mainColor;
        public Color darkColor;
        public Vector4 range;
        public float[] ToParams()
        {
            return new float[]
            {
                lighColor.r, lighColor.g, lighColor.b,
                mainColor.r, mainColor.g, mainColor.b,
                darkColor.r, darkColor.g, darkColor.b,
                range.x, range.y,
                range.z, range.w
            };
        }
    }
}
