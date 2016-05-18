Shader "Custom/ChannelMixerWK" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_R ("Red Mixing", Color)   = (1,0,0,1)
		_G ("Green Mixing", Color) = (0,1,0,1)
		_B ("Blue Mixing", Color)  = (0,0,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		float _R;
		float _G;
		float _B;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
