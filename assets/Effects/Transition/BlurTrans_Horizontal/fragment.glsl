
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

precision mediump float;

varying vec2 v_texCoords;

uniform float u_MixRate;
uniform float u_Lighten;

void main() {

	vec4 v4Result = mix(texture2D(u_texture0, v_texCoords), texture2D(u_texture1, v_texCoords), u_MixRate);
	gl_FragColor = v4Result * u_Lighten;
}