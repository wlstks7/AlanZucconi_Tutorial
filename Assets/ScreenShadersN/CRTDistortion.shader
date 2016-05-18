Shader "Unlit/CRTDistortion"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DisplacementTex("Displacement Texture", 2D) = "white"{}
		_Strength ("Strength", float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"


			sampler2D _MainTex;
			sampler2D _DisplacementTex;
			half _Strength;

			fixed4 frag (v2f_img i) : SV_Target
			{
				half2 n = tex2D(_DisplacementTex, i.uv);
				n = n * 2 - 1;
				i.uv += n * _Strength;
				i.uv = saturate(i.uv);

				float4 c = tex2D(_MainTex, i.uv);
				return c;
			}
			ENDCG
		}
	}
}
