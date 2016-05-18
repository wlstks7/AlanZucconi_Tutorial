using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class myImageEffect : MonoBehaviour {

	public Shader CustomShader;
	public Material curMat;

	Material mat{
		get{
			if (curMat == null) {
				curMat = new Material (CustomShader);
				curMat.hideFlags = HideFlags.HideAndDontSave;
			}
			return curMat;
		}
	}
	
	void OnRenderImage(RenderTexture srcTex, RenderTexture destTex){
		if (CustomShader != null) {
			Graphics.Blit (srcTex, destTex, mat);
		} else {
			Graphics.Blit (srcTex, destTex);
		}
	}

	/*
	void OnDisable(){
		if (curMat) {
			DestroyImmediate (curMat);
		}
	}
	*/

}
