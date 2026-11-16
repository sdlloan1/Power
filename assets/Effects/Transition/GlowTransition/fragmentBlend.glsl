#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fAlpha;

void main(){

    gl_FragColor = mix(texture2D(u_texture0, v_texCoords), texture2D(u_texture1, v_texCoords), fAlpha);
}