#ifndef HAS_OFFSCREEN_TEXTURE
	#ifdef INPUT_IS_OES_TEXTURE
	#extension GL_OES_EGL_image_external : require
		uniform samplerExternalOES u_texture0;
	#else
		uniform sampler2D u_texture0;
	#endif
#else
uniform sampler2D u_texture0;
#endif

precision mediump float;

uniform sampler2D u_txMask;

varying vec2 v_texCoords;
varying vec2 v_texMaskCoords;

void main(){
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    vec4 v4Mask = texture2D(u_txMask, v_texMaskCoords);
    vec4 v4Result = v4Src + (v4Mask.r - 0.5);

	gl_FragColor = vec4(v4Result.rgb, v4Src.a);
}
