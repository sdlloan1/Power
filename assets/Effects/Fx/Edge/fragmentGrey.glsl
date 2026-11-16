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
	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	float fAlpha = v4Src.a;
	v4Src.a = 1.0;

    float fGrey = dot(v4Src, vec4(0.257, 0.504, 0.098, 0.062745));

	gl_FragColor = vec4(fGrey, fGrey, fGrey, fAlpha);
}