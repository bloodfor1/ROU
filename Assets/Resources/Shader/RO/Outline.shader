Shader "RO/Replace/Outline"
{  
	CGINCLUDE

	#include "UnityCG.cginc"

	#if defined(OUTLINE_RGBA)
	#define ENCTEX(t) EncodeFloatRGBA(t)
	#define TEXCNL half4
	#elif defined(OUTLINE_RG)
	#define ENCTEX(t) EncodeFloatRG(t)
	#define TEXCNL half2
	#else
	#define ENCTEX(t) t
	#define TEXCNL half
	#endif

	#ifdef CAMMOTION
	#define CAMPOS _WorldSpaceCameraPos
	#else
	#define CAMPOS half3(0, 1.5, -3.25)
	#endif

	struct v2f
	{
		float z : TEXCOORD0;
		float4 vertex : SV_POSITION;
	};

	v2f vert(float4 vertex : POSITION)
	{
		v2f o;
		float4 worldPos = mul(unity_ObjectToWorld, float4(vertex.xyz, 1));
		float4 viewPos = mul(UNITY_MATRIX_V, worldPos);
		float3 viewDir = normalize(worldPos.xyz - CAMPOS);

		half scale = saturate(720 / _ScreenParams.y);

		o.z = abs(-viewPos.z * lerp(0.089, 0.288, scale));

		//#ifdef OUTLINE_IOS
		worldPos.xyz -= viewDir * 0.02;
		//#endif

		o.vertex = mul(UNITY_MATRIX_VP, worldPos);
		return o;
	}

	TEXCNL frag(v2f i) : SV_Target
	{
		return ENCTEX(exp2(-i.z));
	}

	ENDCG

	SubShader
	{
		Pass
		{ 
			ZWrite On ZTest LEqual Cull Back
			//Offset -1, -1
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile __ OUTLINE_IOS
			#pragma multi_compile __ CAMMOTION
			#pragma multi_compile __ OUTLINE_RG OUTLINE_RGBA
			ENDCG
		}
	}
}