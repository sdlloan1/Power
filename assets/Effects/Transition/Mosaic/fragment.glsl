#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform float fProgress;
uniform float u_fMosaicBufferMappingX;
uniform float u_fMosaicBufferMappingY;
uniform float u_fBKG_R;
uniform float u_fBKG_G;
uniform float u_fBKG_B;
uniform float u_fBKG_A;

void main(){

    vec4 v4Result = texture2D(u_texture0, v_texCoords * vec2(u_fMosaicBufferMappingX, u_fMosaicBufferMappingY));
    gl_FragColor = vec4(mix(v4Result, vec4(u_fBKG_R, u_fBKG_G, u_fBKG_B, 1.0), u_fBKG_A).rgb, 1.0);
}