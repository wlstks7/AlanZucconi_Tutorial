Shader "Hidden/ImageEffectBasics"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Weight ("Weight", float) = 0.1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			fixed _Weight;

			fixed4 frag (v2f_img i) : COLOR {
				fixed2 uv = i.uv;
				fixed4 col = tex2D(_MainTex, i.uv);

				// GreyScale
				fixed grey = dot(col.rgb, fixed3(0.299, 0.587, 0.114));

				// Sepia Tone
				fixed4 sepia = fixed4(grey * fixed3(1.2, 1.0, 0.8),1.0);

				// Negative
				fixed4 negative = 1 - col;

				// Blur (gaussian)
				fixed4 sample[25];
				fixed w = _Weight*0.01;
				fixed2 tcOffset[25]; 
			    tcOffset[0]  = fixed2(-w-w, -w-w);
			    tcOffset[1]  = fixed2(-w-0, -w-w);
			    tcOffset[2]  = fixed2(-0-0, -w-w);
			    tcOffset[3]  = fixed2(+w+0, -w-w);
			    tcOffset[4]  = fixed2(+w+w, -w-w);
			    tcOffset[5]  = fixed2(-w-w,   -w);
			    tcOffset[6]  = fixed2(-w-0,   -w);
			    tcOffset[7]  = fixed2(-0-0,   -w);
			    tcOffset[8]  = fixed2(+w+0,   -w);
			    tcOffset[9]  = fixed2(+w+w,   -w);
			    tcOffset[10] = fixed2(-w-w,    0);
			    tcOffset[11] = fixed2(-w-0,    0);
			    tcOffset[12] = fixed2(-0-0,    0);
			    tcOffset[13] = fixed2(+w+0,    0);
			    tcOffset[14] = fixed2(+w+w,    0);
			    tcOffset[15] = fixed2(-w-w,   +w);
			    tcOffset[16] = fixed2(-w-0,   +w);
			    tcOffset[17] = fixed2(-0-0,   +w);
			    tcOffset[18] = fixed2(+w+0,   +w);
			    tcOffset[19] = fixed2(+w+w,   +w);
			    tcOffset[20] = fixed2(-w-w, +w+w);
			    tcOffset[21] = fixed2(-w-0, +w+w);
			    tcOffset[22] = fixed2(-0-0, +w+w);
			    tcOffset[23] = fixed2(+w+0, +w+w);
			    tcOffset[24] = fixed2(+w+w, +w+w);

				for(int i=0; i<25; i++){
					// Sample a grid around and including our texel
					sample[i] = tex2D(_MainTex, uv + tcOffset[i] );
				}
				//Gaussian weighting:
				// 1  4  7  4 1
				// 4 16 26 16 4
				// 7 26 41 26 7   / 273 (i.e. divide by total of weightings)
				// 4 16 26 16 4
				// 1  4  7  4 1
				fixed4 gaus = ( ( 1.0 * (sample[ 0] + sample[ 4] + sample[20] + sample[24]) ) +
							    ( 4.0 * (sample[ 1] + sample[ 3] + sample[ 5] + sample[ 9] + 
							             sample[15] + sample[19] + sample[21] + sample[23]) ) +
							    ( 7.0 * (sample[ 2] + sample[10] + sample[14] + sample[22]) ) + 
							    (16.0 * (sample[ 6] + sample[ 8] + sample[16] + sample[18]) ) +
							    (26.0 * (sample[ 7] + sample[11] + sample[13] + sample[17]) ) +
							    (41.0 *  sample[12]) ) / 273.0;
			    

			    // Blur (mean filter)
			    fixed4 mean = 0;
			    for(int i=0; i<25; i++){
			    	mean += tex2D(_MainTex, uv + tcOffset[i]);
			    }
			    mean /= 25;

			    // Sharpen
			    // Sharpen weighting:
			    // -1 -1 -1 -1 -1
			    // -1 -1 -1 -1 -1
			    // -1 -1 25 -1 -1
			    // -1 -1 -1 -1 -1
			    // -1 -1 -1 -1 -1
			    fixed4 sharp = 0.0;
			    sharp += sample[12] * 26.0;
			    for(int i=0; i<25; i++){
			    	sharp -= sample[i];
			    }

			    //Dilate
			    fixed4 maxValue = 0;
			    for(int i=0; i<25; i++){
			    	sample[i] = tex2D(_MainTex, uv + tcOffset[i]);
			    	maxValue = max(sample[i], maxValue);
			    }

			    // Erode
			    fixed4 minValue = 1;
			    for(int i=0; i<25; i++){
			    	sample[i] = tex2D(_MainTex, uv + tcOffset[i]);
			    	minValue = min(sample[i], minValue);
			    }

			    // Laplacian Edge Detection (Very, very similar to sharpen filter)
			    // Laplacian Weighting:
			    // -1 -1 -1 -1 -1
			    // -1 -1 -1 -1 -1
			    // -1 -1 24 -1 -1
			    // -1 -1 -1 -1 -1
			    // -1 -1 -1 -1 -1
			    fixed4 lapla = 0;
			    lapla = sample[12] * 25.0;
			    for(int i=0; i<25; i++){
			    	lapla -= sample[i];
			    }


				return lapla;
			}
			ENDCG
		}
	}
}
