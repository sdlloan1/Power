
precision highp float;

uniform sampler2D u_textureSrc;

uniform float u_Radius;
uniform vec2 u_texelSize;
varying vec2 v_texCoords;

void main()
{
    vec2 blurOffset;
    vec4 sum = texture2D(u_textureSrc, v_texCoords);
    float count = 1.0;

    int radius = int(u_Radius);
    for(int index = 1 ; index <= radius ; index++)
    {
        blurOffset = u_texelSize * float(index);
        sum += texture2D(u_textureSrc, v_texCoords + blurOffset);
        sum += texture2D(u_textureSrc, v_texCoords - blurOffset);
        count += 2.0;
    }

	gl_FragColor = sum / count;
}