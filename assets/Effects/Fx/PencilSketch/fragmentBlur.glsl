
uniform sampler2D u_texture0; 
uniform sampler2D u_texture1;

precision mediump float;

uniform int u_TxIndex;
uniform int u_Radius;
uniform vec2 u_TexelSize;
uniform int u_Inv_Adj;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Sum = vec4(0.0, 0.0, 0.0, 0.0);

    if(u_TxIndex == 0)
    {
        for(int index = -u_Radius ; index <= u_Radius ; ++index)
            v4Sum += texture2D(u_texture0, v_texCoords + (u_TexelSize * float(index)));
    }
    else
    {
        for(int index = -u_Radius ; index <= u_Radius ; ++index)
            v4Sum += texture2D(u_texture1, v_texCoords + (u_TexelSize * float(index)));
    }

    v4Sum /= float((u_Radius * 2) + 1);

    if(u_Inv_Adj > 0)
        v4Sum = vec4(1.0, 1.0, 1.0, 1.0) - v4Sum;

    gl_FragColor = vec4(v4Sum.rgb, 1.0);
}