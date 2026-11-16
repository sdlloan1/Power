uniform sampler2D u_background0;

precision mediump float;
varying vec2 v_texCoords;

void main(){
	vec2 v1 = v_texCoords;
	gl_FragColor = texture2D(u_background0, v1);
}
