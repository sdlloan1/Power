
uniform sampler2D u_txBrush;

precision mediump float;

varying vec2 v_texCoords;
varying float v_Fade;

void main(void)
{
	gl_FragColor = vec4(texture2D(u_txBrush, v_texCoords).rgb * v_Fade, 1.0);
}