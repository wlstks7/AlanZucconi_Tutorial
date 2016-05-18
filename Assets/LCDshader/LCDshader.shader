Shader "Custom/LCDshader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Pixels("Pixels", Vector) = (10,10,0,0)

		_LCDTex("LCD (RGB)", 2D) = "white"{}
		_LCDPixels("LCD pixels", Vector) = (3,3,0,0)

		_DistanceOne  ("Distance of full effect", float) = 0.5
		_DistanceZero ("Distance of zero effect", float) = 1

		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		float4 _Pixels;
		sampler2D _MainTex;

		sampler2D _LCDTex;
		float4 _LCDPixels;

		float _DistanceOne;
		float _DistanceZero;

		half _Glossiness;
		half _Metallic;


		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float2 uv = round(IN.uv_MainTex * _Pixels.xy + 0.5) / _Pixels.xy;
			fixed4 c = tex2D (_MainTex, uv);
			float2 uv_lcd = IN.uv_MainTex * _Pixels.xy / _LCDPixels;
			fixed4 d = tex2D(_LCDTex, uv_lcd);

			float dist = distance(_WorldSpaceCameraPos, IN.worldPos);
			float alpha = saturate( (dist - _DistanceOne) / (_DistanceZero - _DistanceOne) );

			o.Albedo = lerp(c * d, c, alpha);
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
