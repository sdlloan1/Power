#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

varying vec2 v_texCoords;

void main() {

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 v4Gray = vec4(dot(v4Src, vec4(0.299, 0.587, 0.114, 0.0)));

	gl_FragColor = v4Gray;
}