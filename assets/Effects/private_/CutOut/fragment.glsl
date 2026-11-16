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

uniform sampler2D u_textureMask;
uniform int u_maskOnly;

precision mediump float;

varying vec2 v_texCoords;

uniform int u_FlipHorizontal;
uniform int u_FlipVertical;

void main(){
	vec2 srcCoords = v_texCoords;

	if (u_FlipHorizontal > 0) {
		srcCoords.x = 1.0 - srcCoords.x;
	}
	if (u_FlipVertical > 0) {
		srcCoords.y = 1.0 - srcCoords.y;
	}

	vec4 v4Mask = texture2D(u_textureMask, srcCoords);

	if (u_maskOnly > 0) {
		gl_FragColor = v4Mask;
	} else {
		vec4 v4Src = texture2D(u_texture0, v_texCoords);
		gl_FragColor = vec4(v4Src.rgb, v4Src.a * v4Mask.a);
	}
}
