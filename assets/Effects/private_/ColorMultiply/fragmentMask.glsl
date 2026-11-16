precision mediump float;
varying vec2 v_texCoords;
varying vec2 v_Position;
uniform sampler2D u_texture0;
uniform sampler2D u_textureMask;
uniform vec4 u_textColor;

void main(){
	vec4 color = texture2D(u_texture0, v_texCoords);
	vec4 v4Mask = texture2D(u_textureMask, v_Position);
	vec4 v4Text = color / color.a;

	gl_FragColor = vec4(v4Text.rgb, color.a * v4Mask.a) * u_textColor;
}