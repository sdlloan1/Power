
uniform sampler2D u_texture0;
uniform sampler2D u_textureSrc;

precision mediump float;
uniform float u_NormalVector;
varying vec2 v_texCoords;


void main(){

	gl_FragColor = vec4((texture2D(u_texture0, v_texCoords) * u_NormalVector).rgb, texture2D(u_textureSrc, v_texCoords).a);
}