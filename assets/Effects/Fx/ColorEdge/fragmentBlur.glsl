
uniform sampler2D u_texture0;

precision highp float;

uniform mediump float blurSize;
uniform vec2 u_texelOffset;
varying vec2 v_texCoords;

void main()
{
    vec2 blurOffset;
    vec4 sum = texture2D(u_texture0, v_texCoords);
    float count = 1.0;

    int nSize = int(blurSize);
    for(int index = 1 ; index <= nSize ; index++)
    {
        blurOffset = u_texelOffset * float(index);
        sum += texture2D(u_texture0, v_texCoords + blurOffset);
        sum += texture2D(u_texture0, v_texCoords - blurOffset);
        count += 2.0;
    }

	gl_FragColor = vec4((sum / count).rgb, 1.0);
}