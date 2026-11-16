#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_txSrcOES;
uniform sampler2D u_txSrc;

uniform int u_useOES;
			

precision mediump float;

varying vec2 v_texCoords;

void main(){
    if (u_useOES>0) {
	    gl_FragColor = texture2D(u_txSrcOES, v_texCoords);
	} else {
	    gl_FragColor = texture2D(u_txSrc, v_texCoords);
	}
}