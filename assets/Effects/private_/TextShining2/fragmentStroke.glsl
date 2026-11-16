
precision mediump float;

uniform sampler2D u_txBrush[3];
uniform int u_txID;

varying vec2 v_texCoords;

void main(void)
{
	gl_FragColor = vec4(texture2D(u_txBrush[u_txID], v_texCoords).rgb, 1.0);
}