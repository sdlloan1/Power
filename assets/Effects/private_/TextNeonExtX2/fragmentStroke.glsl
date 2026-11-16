
uniform sampler2D u_txBrush[2];

precision mediump float;

varying vec2 v_texCoords;
varying float v_texID;
varying float v_brightness;

void main(void)
{
	gl_FragColor = vec4(texture2D(u_txBrush[int(v_texID)], v_texCoords).rgb * v_brightness, 1.0);
}