
precision mediump float;

uniform sampler2D u_txStroke[4];
uniform sampler2D u_txMask[2];

varying vec2 v_texCoords;

void main(void)
{
    vec4 v4Stroke1 = texture2D(u_txStroke[0], v_texCoords);
    vec4 v4Stroke2 = texture2D(u_txStroke[1], v_texCoords);
    vec4 v4Stroke3 = texture2D(u_txStroke[2], v_texCoords) - texture2D(u_txStroke[3], v_texCoords);

    float fMask1 = texture2D(u_txMask[0], v_texCoords).a;
    float fMask2 = 1.0 - texture2D(u_txMask[1], v_texCoords).a;

	gl_FragColor = (v4Stroke1 + v4Stroke2 * fMask1 * fMask2 + v4Stroke3 * fMask1);
}