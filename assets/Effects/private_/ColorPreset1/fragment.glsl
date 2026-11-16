uniform sampler2D u_textureFrame;
uniform sampler2D u_textureSrc;
uniform sampler2D u_textureBackdrop;
uniform sampler2D u_textureMask;

precision mediump float;

uniform int u_ApplyFrame;
uniform vec4 u_TxGrid;
uniform vec4 u_TargetGrid;
// top, bottom, left, right
//  x     y       z     w

uniform float u_Opacity;

varying vec2 v_texCoords;

void main()
{
    vec4 v4FrameResult;
    if(u_ApplyFrame == 1)
    {
        float fX = v_texCoords.x;
        float fY = v_texCoords.y;
        if (v_texCoords.x <= u_TargetGrid.z)
        {
            fX = v_texCoords.x / u_TargetGrid.z * u_TxGrid.z;
        }
        else if (v_texCoords.x >= u_TargetGrid.w)
        {
            fX = (v_texCoords.x - u_TargetGrid.w) / (1.0 - u_TargetGrid.w) * (1.0 - u_TxGrid.w) + u_TxGrid.w;
        }
        else
        fX = u_TxGrid.z;

        if (v_texCoords.y <= u_TargetGrid.x)
        {
            fY = v_texCoords.y / u_TargetGrid.x * u_TxGrid.x;
        }
        else if (v_texCoords.y >= u_TargetGrid.y)
        {
            fY = (v_texCoords.y - u_TargetGrid.y) / (1.0 - u_TargetGrid.y) * (1.0 - u_TxGrid.y) + u_TxGrid.y;
        }
        else
           fY = u_TxGrid.x;

        vec4 v4ColorSrc = texture2D(u_textureFrame, vec2(fX, fY));
        vec4 v4ColorBackdrop = texture2D(u_textureBackdrop, v_texCoords);

        float fAlphaSrc = v4ColorSrc.a * u_Opacity;
        float fAlphaBackdrop = v4ColorBackdrop.a;
        float fAlphaDst = fAlphaSrc + fAlphaBackdrop - (fAlphaSrc * fAlphaBackdrop);

        vec4 v4ColorBlend = v4ColorSrc;

        float fParam1 = (1.0 - fAlphaSrc) * fAlphaBackdrop;
        float fParam2 = (1.0 - fAlphaBackdrop) * fAlphaSrc;
        float fParam3 = fAlphaSrc * fAlphaBackdrop;

        v4FrameResult = vec4(((v4ColorBackdrop * fParam1 + v4ColorSrc * fParam2 + v4ColorBlend * fParam3) / fAlphaDst).rgb, fAlphaDst);
    }
    else
    {
        v4FrameResult = texture2D(u_textureBackdrop, v_texCoords);
    }

    gl_FragColor = vec4(mix(texture2D(u_textureSrc, v_texCoords), v4FrameResult, texture2D(u_textureMask, v_texCoords).a).rgb, v4FrameResult.a);
}
