#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform int u_Degree;
uniform vec2 u_TexelSize;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    vec4 v4Sum = vec4(0.0, 0.0, 0.0, 0.0);

    {
        vec2 v2TxCoord;
        for(int index = 1 ; index < u_Degree + 1 ; ++index)
        {
            v2TxCoord = v_texCoords - (u_TexelSize * float(index));
            v4Sum += texture2D(u_texture0, v2TxCoord);
        }

        v4Sum = v4Sum / float(u_Degree);
        v4Sum = max(v4Sum, v4Src) * 0.75 + v4Src * 0.25;
        v4Sum.r *= 0.72;

        gl_FragColor = vec4(v4Sum.rgb, v4Src.a);
    }
}