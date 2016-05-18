Shader "Alan/ShaderSmoke"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Pixels ("Pixels", float) = 2048
		_Dissipation ("Dissipation", float) = 0.5

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
			half _Pixels;
			half _Dissipation;
			
			fixed4 frag (v2f_img i) : COLOR
			{
				fixed2 uv = round(i.uv * _Pixels) / _Pixels;
				half s = 1 / _Pixels;

				float cl = tex2D(_MainTex, uv + fixed2(-s,  0)).a;
				float tc = tex2D(_MainTex, uv + fixed2( 0, -s)).a;
				float cc = tex2D(_MainTex, uv + fixed2( 0,  0)).a;
				float bc = tex2D(_MainTex, uv + fixed2( 0, +s)).a;
				float cr = tex2D(_MainTex, uv + fixed2(+s,  0)).a;

				#define ARRAY(T,X,Y) (tex2D(T), uv + fixed2(s*(X), s*(Y)))
				//float cc = ARRAY(_MainTex, 0, 0).a; // F[x+0, y+0]: Center Center

				float factor = _Dissipation * ( 0.25*(cl+tc+bc+cr) - cc );
				cc += factor;

				return float4(1,1,1,cc);
			}
			ENDCG
		}
	}
}
