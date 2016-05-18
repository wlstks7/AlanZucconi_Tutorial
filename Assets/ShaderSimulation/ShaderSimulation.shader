Shader "Unlit/ShaderSimulation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		ZTest Always
		Cull Off
		ZWrite Off
		Fog { Mode off }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			
			fixed4 frag (v2f_img i) : COLOR {
				fixed4 c = tex2D(_MainTex, i.uv);
				return 1-c;
			}
			ENDCG
		}
	}
}
