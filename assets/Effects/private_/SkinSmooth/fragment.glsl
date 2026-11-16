#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

varying vec2 v_texCoords;

void main()
{
	// Return order -- float4(B, G, R, A)
	// f4.x = R , f4.y = G , f4.z = B , f4.w = A
	vec4 f4Result = texture2D(u_texture0, v_texCoords);

   	gl_FragColor = vec4(f4Result.rgb, 1.0);
}