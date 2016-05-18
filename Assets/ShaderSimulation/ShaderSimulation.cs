using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ShaderSimulation : MonoBehaviour {

	public Material mat; // Wraps the shader
	public Texture initialTex;

	public RenderTexture tex;
	private RenderTexture buffer;

	private float lastUpateTime = 0;
	public float updateInterval = 0.1f; // Seconds

	void Start(){
		Graphics.Blit (initialTex, tex);
		buffer = new RenderTexture (tex.width, tex.height, tex.depth, tex.format);
	}

	public void UpdateTexture(){
		Graphics.Blit (tex, tex, mat);
		//Graphics.Blit (tex, buffer, mat);
		//Graphics.Blit (buffer, tex);
	}

	public void Update(){
		if (Time.time > lastUpateTime + updateInterval) {
			UpdateTexture ();
			lastUpateTime = Time.time;
		}
		mat.SetVector("_SmokeCentre", new Vector4(Mathf.Cos(Time.time)*0.3f+0.5f, Mathf.Sin(Time.time)*0.3f+0.5f, 0,0));
	}

}
