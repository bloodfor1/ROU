using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

public class AtlasMeshTexturePair : ScriptableObject
{
    [Serializable]
    public class Pair
    {
        public Mesh meshOriginal;           //原始网格
        public Material materialOriginal;   //原始材质
        public Texture2D textureOriginal;   //原始纹理
        public Texture2D textureOrgColor;   //原始纹理的颜色部分
        public Texture2D textureOrgAlpha;   //原始纹理的透明部分
        public Vector2[] meshOriginalUVs;   //原始UV位置
        public Rect rectInOriginalAtlas;    //网格在原始图集纹理中的区域
        public Texture2D texturePerMesh;    //UV为0~1时对应的纹理
        public bool useAlpha;               //带有alpha
        public Mesh meshNewRect;            //调整了UV区域的新网格
        public Material materialCombine;    //合并图集的材质
        public Texture2D textureAtlas;      //合并的图集
        public Texture2D textureAtlasColor; //拆分图集的颜色部分
        public Texture2D textureAtlasAlpha; //拆分图集的透明部分
        public Mesh[] meshesInSameAtlas;    //记录同一个图集中的所有原始网格，便于重构时使用
        public Rect rectInNewAtlas;         //调整了的UV在新图集中的区域
        public List<string> referenceScenes = new List<string>();     //场景引用性
    }

    //===========================================================================
    //
    //  保留原始->独立->重构的关联，编辑模式时，切换回原始模式，进行调整后，需要重新生成独立->重构的部分
    //  需要更新重构时，需要找到之前合并的所有网格数据，并重新形成组合一次
    //
    //===========================================================================

    public List<Pair> MaterialRemapPairs = new List<Pair>();
}