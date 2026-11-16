precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform vec4 u_textColor;

void main(){
	vec4 color = texture2D(u_texture0, v_texCoords);
	vec4 v4Text = color / color.a;
	gl_FragColor = vec4(v4Text.rgb, color.a) * u_textColor;
}