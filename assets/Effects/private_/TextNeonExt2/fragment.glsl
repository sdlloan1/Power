
precision mediump float;

uniform sampler2D u_txStroke;
uniform sampler2D u_txFace;

uniform vec2 u_ShadowOffset;
uniform float u_ShadowOpacity;
uniform float u_Brightness;
uniform float u_Fade;
uniform float u_ApplyMask;
uniform int u_Round;

varying vec2 v_texCoords;

void main(void)
{
    if(u_Round == 0)
    {
        gl_FragColor = texture2D(u_txStroke, v_texCoords - u_ShadowOffset) * u_ShadowOpacity * u_Fade;
    }
    else if(u_Round == 1)
    {
        float faceMask = 1.0 - texture2D(u_txFace, v_texCoords).r * u_ApplyMask;
        gl_FragColor = texture2D(u_txStroke, v_texCoords) * u_Brightness * u_Fade * faceMask;
    }
    else
    {
        gl_FragColor = texture2D(u_txFace, v_texCoords) * 0.15 * u_Fade;
    }
}