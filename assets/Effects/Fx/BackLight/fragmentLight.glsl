#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_textureScale;

precision mediump float;

uniform int u_Degree;
uniform vec2 u_Center;

varying vec2 v_texCoords;

void main()
{
    float fSum = 0.0;
    vec4 v4ScaleMask;
    vec2 v2Scale;
    vec2 v2TxCoord;

    float fPrevVal = dot(texture2D(u_texture0, v_texCoords), vec4(0.333333, 0.333333, 0.333333, 0.0));
    float fCurVal;

    for(int index = 0 ; index < u_Degree ; ++index)
    {
        v4ScaleMask = texture2D(u_textureScale, vec2(float(index) * 0.001 + 0.0005, 0.0005));
        v2Scale = vec2(v4ScaleMask.r + v4ScaleMask.g / 256.0, v4ScaleMask.b + v4ScaleMask.a / 256.0);
        v2TxCoord = (v_texCoords - u_Center) * v2Scale + u_Center;

        fCurVal = dot(texture2D(u_texture0, v2TxCoord), vec4(0.333333, 0.333333, 0.333333, 0.0));

        if((fPrevVal - fCurVal) < 0.07843137255)
            fPrevVal = fCurVal;

        fSum += fPrevVal;
    }

    fSum /= float(u_Degree);

	gl_FragColor = vec4(fSum, fSum, fSum, 1.0);
}