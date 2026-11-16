
#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_texture1;

precision mediump float;

uniform int u_TxIndex;
uniform int u_Range;
uniform vec2 u_TexelSize;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Sum = vec4(0.0, 0.0, 0.0, 0.0);

    if(u_TxIndex == 0)
    {
        for(int index = -u_Range ; index <= u_Range ; ++index)
            v4Sum += texture2D(u_texture0, v_texCoords + (u_TexelSize * float(index)));

        v4Sum /= float((u_Range * 2) + 1);
        v4Sum.a = 1.0;
    }
    else
    {
        for(int index = -u_Range ; index <= u_Range ; ++index)
            v4Sum += texture2D(u_texture1, v_texCoords + (u_TexelSize * float(index)));

        v4Sum /= float((u_Range * 2) + 1);
        float fGrey = dot(v4Sum, vec4(0.333333, 0.333333, 0.333333, 0.0));
        v4Sum = vec4(fGrey, fGrey, fGrey, 1.0);
    }


    gl_FragColor = v4Sum;
}