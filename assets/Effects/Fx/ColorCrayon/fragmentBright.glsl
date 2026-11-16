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

varying vec2 v_texCoords;

void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fBrightness = dot(v4Src.rgb, vec3(0.2125, 0.7154, 0.0721)) + 0.0001;

    gl_FragColor = vec4(v4Src.rgb, fBrightness);
}
