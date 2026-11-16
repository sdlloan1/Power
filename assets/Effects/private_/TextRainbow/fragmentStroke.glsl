
uniform sampler2D u_txBrush;

precision mediump float;

varying vec2 v_texCoords;

void main(void)
{
	gl_FragColor = vec4(texture2D(u_txBrush, v_texCoords).rgb, 1.0);
}