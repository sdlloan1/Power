
precision mediump float;

uniform sampler2D u_txStroke;

uniform float u_Fade;
uniform float u_Brightness;

varying vec2 v_texCoords;

void main(void)
{
    vec4 v4Stroke = texture2D(u_txStroke, v_texCoords);
	gl_FragColor = v4Stroke * u_Brightness * u_Fade;
}