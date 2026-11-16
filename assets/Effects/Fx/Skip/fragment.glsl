#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0;
#endif 

uniform sampler2D u_texture1;
uniform int u_TxIndex;

precision mediump float;
varying vec2 v_texCoords;

void main(){

    if(u_TxIndex > 0)
    	gl_FragColor = texture2D(u_texture1, v_texCoords);
    else
    	gl_FragColor = texture2D(u_texture0, v_texCoords);
}