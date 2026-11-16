
uniform sampler2D u_txBrush;

precision mediump float;

varying vec2 v_texCoords;
varying vec4 v_Colors;

void main(void)
{
    vec4 v4Center = vec4(texture2D(u_txBrush, v_texCoords).rgb, 1.0);
    vec4 v4Fade = vec4(texture2D(u_txBrush, v_texCoords + vec2(0.5, 0.0)).rgb, 1.0);
	gl_FragColor = vec4((v4Center + v_Colors * v4Fade.r * 1.2).rgb, 1.0);
}