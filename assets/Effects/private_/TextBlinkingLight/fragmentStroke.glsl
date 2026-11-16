
uniform sampler2D u_txBrush;

precision mediump float;

uniform vec3 u_Color;
varying vec2 v_texCoords;
varying float v_Fade;

void main(void)
{
    vec3 v3Res = texture2D(u_txBrush, v_texCoords).r * u_Color * v_Fade;
	gl_FragColor = vec4(v3Res, 1.0);
}