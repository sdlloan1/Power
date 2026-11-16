#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;
uniform float fAdjust;
varying vec2 v_texCoords;

void main(void)
{
	// Return order -- float4(B, G, R, A)
	// f4.x = R , f4.y = G , f4.z = B , f4.w = A

    vec4 v4Src = texture2D(u_texture0, v_texCoords);
	gl_FragColor = vec4((v4Src + fAdjust).rgb, v4Src.a);
}