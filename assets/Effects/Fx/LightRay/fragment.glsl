#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform int u_Degree;
uniform vec2 u_Center;
uniform float u_ScaleX[35];
uniform float u_ScaleY[35];

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    vec4 v4Sum = vec4(0.0, 0.0, 0.0, 0.0);
    vec4 v4One = vec4(1.0, 1.0, 1.0, 1.0);

    if(u_Degree == 0)
    {
        gl_FragColor = v4Src;
    }
    else
    {
        vec2 v2TxCoord;
        for(int index = 0 ; index < u_Degree ; ++index)
        {
            v2TxCoord = (v_texCoords - u_Center) * vec2(u_ScaleX[index], u_ScaleY[index]) + u_Center;
            v4Sum += texture2D(u_texture0, v2TxCoord);
        }

        v4Sum /= float(u_Degree);

        gl_FragColor = vec4((v4One - (v4One - v4Sum) * (v4One - v4Src)).rgb, v4Src.a);
    }
}