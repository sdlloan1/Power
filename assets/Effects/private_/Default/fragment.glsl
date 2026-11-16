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

uniform int u_handleAlphaRecovery;

void main(){
	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	if((u_handleAlphaRecovery>0)&&(v4Src.a>0.0)){
        v4Src.rgb /= v4Src.a;
    }
	gl_FragColor = v4Src;
}
