
uniform sampler2D u_texture0;
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
    }
    else
    {
        for(int index = -u_Range ; index <= u_Range ; ++index)
            v4Sum += texture2D(u_texture1, v_texCoords + (u_TexelSize * float(index)));
    }

    v4Sum /= float((u_Range * 2) + 1);
    v4Sum.a = 1.0;

    gl_FragColor = v4Sum;
}