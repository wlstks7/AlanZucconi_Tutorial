using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class CRTEffect_Dist : MonoBehaviour {

	public Material material;

	void OnRenderImage(RenderTexture src, RenderTexture dest){
		Graphics.Blit (src, dest, material);
	}
}
