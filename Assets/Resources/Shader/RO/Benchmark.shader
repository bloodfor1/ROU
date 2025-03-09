/*
*      Author: Starking.
*      Version: 18.07.28
*/

Shader "RO/Replace/Benchmark"
{
	Properties
	{ 
		_MainTex ("主纹理", 2D) = "white" {}
		_Color("技能颜色",Color) = (0.5,0.5,0.5,1)
		_Branch("分支判断", range(0, 1)) = 1 
	}

	SubShader
	{
		Tags { "RenderType" = "Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent" }
		LOD 100

		Pass
		{
			Tags{ "LightMode" = "Always" }
			ZWrite Off ZTest LEqual Cull Back
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				fixed4 color : COLOR;
			};

			fixed4 _Color;
			sampler2D _MainTex;
			half4 _MainTex_ST;
			half _Branch;

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				half3 normal : TEXCOORD1;
				half3 tangent : TEXCOORD2;
				half3 binormal : TEXCOORD3;
				fixed4 color : TEXCOORD4;
				half3 worldPos : TEXCOORD5;				
			};

			v2f vert(a2v v)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv * _MainTex_ST.xy + sin(_Time.xy * _MainTex_ST.zw);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
				o.binormal = cross(o.normal, o.tangent) * v.tangent.w * unity_WorldTransformParams.w;
				o.color = v.color;
				o.worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)).xyz;

				return o;
			}

			fixed3 RGB2HSV(fixed3 c) 
			{
				half4 k = half4(0.0, -0.33333333, 0.66666667, -1.0);

				bool pTh = c.g > c.b;
				half4 p = pTh ? half4(c.gb, k.xy) : half4(c.bg, k.wz);

				bool qTh = c.r > p.x;
				half4 q = qTh ? half4(c.r, p.yzx) : half4(p.xyw, c.r);
				
				half d = q.x - min(q.w, q.y);
				half e = 1.0e-10;
				return fixed3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			fixed3 HSV2RGB(fixed3 c) 
			{
				half4 k = half4(1.0, 0.66666667, 0.33333333, 3.0);
				half3 p = abs(frac(c.xxx + k.xyz) * 6.0 - k.www);
				return c.z * lerp(k.xxx, saturate(p - k.xxx), c.y);
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				fixed4 col = i.color * _Color;			
				col = (col + tex2D(_MainTex, i.uv)) * 0.5f;
				col = (col + tex2D(_MainTex, i.uv + _Time.xx)) * 0.5f;
				col = (col + tex2D(_MainTex, i.uv + 2 * _Time.xx)) * 0.5f;
				col = (col + tex2D(_MainTex, i.uv + 3 * _Time.xx)) * 0.5f;
				col = (col + tex2D(_MainTex, i.uv + 4 * _Time.xx)) * 0.5f;
				col = (col + tex2D(_MainTex, i.uv + 5 * _Time.xx)) * 0.5f;
				col = (col + tex2D(_MainTex, i.uv + 6 * _Time.xx)) * 0.5f;
				col = (col + tex2D(_MainTex, i.uv + 7 * _Time.xx)) * 0.5f;
				col = pow(col, 4);
				col = max(0.1, exp(-col));
				col *= dot(normalize(col), normalize(_Color));			
				col = saturate(col);

				UNITY_BRANCH
				if(_Branch > 0.5)
				{
					col.rgb = RGB2HSV(col.rgb);
					col.r += 25 / 360;
					col.r = fmod(col.r, 1); 
					col.g *= 2;
					col.b = 0.7;
					col.rgb = HSV2RGB(col.rgb);
					col = abs(sin(col));
					col = pow(col, 128);
					col *= exp(4);
				}
				else
				{
					col = abs(sin(col));
					col = pow(col, 4);
					col = exp(-col);
				}

				col = smoothstep(-1, 1, col);
				col = lerp(col, 1 - col, col);
				col.a = 0;
				//clip(col.a - 0.5);				

				return col;
			}

			ENDCG
		}
	}
}
