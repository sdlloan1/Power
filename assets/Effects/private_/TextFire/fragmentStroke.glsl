
uniform sampler2D u_txBrush;

precision highp float;

uniform float u_GlobalOffsetY;
varying vec2 v_texCoords;
varying vec2 v_texOffset;

void main(void)
{
    float fRatio = cos(v_texCoords.y * 3.14159265359) * 0.5 + 1.5; // 1 ~ 2
    vec2 v2NewCoord = vec2(clamp((v_texCoords.x - 0.5) * fRatio + 0.5, 0.0, 1.0), v_texCoords.y);
    vec4 v4Res = texture2D(u_txBrush, vec2(v2NewCoord.x * 0.1666667 + v_texOffset.x, mod(v2NewCoord.y + v_texOffset.y + u_GlobalOffsetY, 1.0)));

                     // for color contrast        for fade
	gl_FragColor = vec4((v4Res * v4Res * 1.2 * v_texCoords.y * v_texCoords.y).rgb, 1.0);
}