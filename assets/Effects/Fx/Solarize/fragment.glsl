#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;
uniform vec4 u_Threshold;

varying vec2 v_texCoords;

void main()
{
	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 v4Inv = vec4(1.0, 1.0, 1.0, 1.0) - v4Src;
	vec4 v4Mask = max(vec4(0.0, 0.0, 0.0, 0.0), ceil(v4Src + vec4(0.0001, 0.0001, 0.0001, 0.0001) - u_Threshold));
	vec4 v4MaskInv = vec4(1.0, 1.0, 1.0, 1.0) - v4Mask;
	vec4 v4Result = (v4Inv * v4Mask) + (v4Src * v4MaskInv);

	gl_FragColor = vec4(v4Result.rgb, v4Src.a);
}