uniform sampler2D u_texture0; 

precision mediump float;

uniform float u_fBKG_R;
uniform float u_fBKG_G;
uniform float u_fBKG_B;
uniform float u_fBKG_A;

varying vec2 v_texCoords;

void main(){

    gl_FragColor = vec4(mix(texture2D(u_texture0, v_texCoords), vec4(u_fBKG_R, u_fBKG_G, u_fBKG_B, 1.0), u_fBKG_A).rgb, 1.0);
}