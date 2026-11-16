
#extension GL_OES_EGL_image_external : require

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_textureMask;

precision mediump float;

varying vec2 v_texCoords;
varying vec2 v_maskCoords;

void main(){

    float fMixRate = texture2D(u_textureMask, v_maskCoords).r;
    gl_FragColor = mix(texture2D(u_texture1, v_texCoords), texture2D(u_texture0, v_texCoords), fMixRate);
}
