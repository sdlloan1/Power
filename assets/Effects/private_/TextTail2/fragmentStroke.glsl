
uniform sampler2D u_txBrush;

precision mediump float;

uniform float u_Brightness;

varying vec2 v_texCoords;

void main(void)
{
	gl_FragColor = vec4(texture2D(u_txBrush, v_texCoords).rgb * u_Brightness, 1.0);
}