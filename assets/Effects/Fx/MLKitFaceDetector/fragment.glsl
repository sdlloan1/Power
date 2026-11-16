#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif

uniform sampler2D u_textureMask;

precision mediump float;

varying vec2 v_texCoords;

void main() {
	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 v4Mask = texture2D(u_textureMask, v_texCoords);

	gl_FragColor = vec4(mix(v4Src.rgb, v4Mask.rgb-v4Src.rgb, v4Mask.a), v4Src.a);
}