precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform vec4 u_textColor;

void main(){
	vec4 color = texture2D(u_texture0, v_texCoords);
	gl_FragColor = color * u_textColor;
}