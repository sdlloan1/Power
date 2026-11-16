
uniform sampler2D u_texture0; 

precision mediump float;

uniform vec2 uOffset0;
uniform vec2 uOffset1;
uniform vec2 uOffset2;
uniform vec2 uOffset3;
uniform vec2 uOffset4;
uniform vec2 uOffset5;
uniform vec2 uOffset6;
uniform vec2 uOffset7;
uniform vec2 uOffset8;

varying vec2 v_texCoords;

vec4 v4Src[9];

void main(){

	v4Src[0] = texture2D(u_texture0, v_texCoords + uOffset0);
	v4Src[1] = texture2D(u_texture0, v_texCoords + uOffset1);
	v4Src[2] = texture2D(u_texture0, v_texCoords + uOffset2);
	v4Src[3] = texture2D(u_texture0, v_texCoords + uOffset3);
	v4Src[4] = texture2D(u_texture0, v_texCoords + uOffset4);
	v4Src[5] = texture2D(u_texture0, v_texCoords + uOffset5);
	v4Src[6] = texture2D(u_texture0, v_texCoords + uOffset6);
	v4Src[7] = texture2D(u_texture0, v_texCoords + uOffset7);
	v4Src[8] = texture2D(u_texture0, v_texCoords + uOffset8);

    int index;

    float fMax = v4Src[0].a;
    int nMax = 0;
    for(index = 1 ; index < 9 ; ++index)
    {
        if(v4Src[index].a > fMax)
        {
            fMax = v4Src[index].a;
            nMax = index;
        }
    }
    v4Src[nMax].a = 0.0;

    fMax = v4Src[0].a;
    nMax = 0;
    for(index = 1 ; index < 9 ; ++index)
    {
        if(v4Src[index].a > fMax)
        {
            fMax = v4Src[index].a;
            nMax = index;
        }
    }
    v4Src[nMax].a = 0.0;

    fMax = v4Src[0].a;
    nMax = 0;
    for(index = 1 ; index < 9 ; ++index)
    {
        if(v4Src[index].a > fMax)
        {
            fMax = v4Src[index].a;
            nMax = index;
        }
    }
    v4Src[nMax].a = 0.0;

    fMax = v4Src[0].a;
    nMax = 0;
    for(index = 1 ; index < 9 ; ++index)
    {
        if(v4Src[index].a > fMax)
        {
            fMax = v4Src[index].a;
            nMax = index;
        }
    }
    v4Src[nMax].a = 0.0;

    fMax = v4Src[0].a;
    nMax = 0;
    for(index = 1 ; index < 9 ; ++index)
    {
        if(v4Src[index].a > fMax)
        {
            fMax = v4Src[index].a;
            nMax = index;
        }
    }

    gl_FragColor = v4Src[nMax];
}
