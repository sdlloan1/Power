
uniform sampler2D u_txLight;

precision mediump float;

uniform float u_Strength;

varying vec2 v_texCoords;
varying vec4 v_Color;

void main(void)
{
	gl_FragColor = v_Color * u_Strength * texture2D(u_txLight, v_texCoords).g;
}
