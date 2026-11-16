
precision mediump float;

uniform sampler2D u_txStroke;

uniform float u_Fade;

varying vec2 v_texCoords;

void main(void)
{
	gl_FragColor = texture2D(u_txStroke, v_texCoords) * u_Fade;
}