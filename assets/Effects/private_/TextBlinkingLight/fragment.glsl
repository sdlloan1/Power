
precision mediump float;

uniform sampler2D u_txStroke;
uniform sampler2D u_txFace;

uniform float u_Fade;
uniform float u_Brightness;

varying vec2 v_texCoords;

void main(void)
{
    vec4 v4Stroke = texture2D(u_txStroke, v_texCoords);
    vec4 v4Face = texture2D(u_txFace, v_texCoords);

	gl_FragColor = max(v4Stroke * u_Brightness, v4Face) * u_Fade;
}