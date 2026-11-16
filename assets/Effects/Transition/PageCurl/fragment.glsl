precision mediump float;

varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;

void main(){
	gl_FragColor = texture2D(u_texture1, v_texCoords);
}
