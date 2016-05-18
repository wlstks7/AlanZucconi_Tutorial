Shader "Unlit/ImgEF_Pixelate"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Pixels ("Pixels", Vector) = (20,20,0,0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			//#pragma vertex vert_img
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			//struct appdata {
			//	float4 vertex : POSITION;
			//	float2 uv : TEXCOORD0;
			//};

			struct v2f {
				//float4 pos : POSITION
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			int4 _Pixels;
			
			v2f vert (appdata_img v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv = MultiplyUV (UNITY_MATRIX_TEXTURE0, v.texcoord.xy);
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR {
				fixed2 uv = round(i.uv * _Pixels.xy + 0.5) / _Pixels.xy;
				fixed4 col = tex2D(_MainTex, uv);
				return col;
			}
			ENDCG
		}
	}
}
