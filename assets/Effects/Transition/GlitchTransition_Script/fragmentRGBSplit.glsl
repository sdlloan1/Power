
precision mediump float;

uniform sampler2D u_textureSrc;

uniform vec2 u_OffsetR;
uniform vec2 u_OffsetG;
uniform vec2 u_OffsetB;

varying vec2 v_texCoords;

void main()
{
    float fRed = texture2D(u_textureSrc, v_texCoords + u_OffsetR).r;
    float fGreen = texture2D(u_textureSrc, v_texCoords + u_OffsetG).g;
    float fBlue = texture2D(u_textureSrc, v_texCoords + u_OffsetB).b;
    float fAlpha = texture2D(u_textureSrc, v_texCoords).a;

    gl_FragColor = vec4(fRed, fGreen, fBlue, fAlpha);
}
