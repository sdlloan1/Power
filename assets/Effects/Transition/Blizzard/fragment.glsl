#extension GL_OES_EGL_image_external : require

precision mediump float;

varying vec2 v_texCoords;
varying float v_Threshold;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;

void main(){

    if(fProgress < v_Threshold)
   	    gl_FragColor = texture2D(u_texture0, v_texCoords);
    else
   	    gl_FragColor = texture2D(u_texture1, v_texCoords);

}