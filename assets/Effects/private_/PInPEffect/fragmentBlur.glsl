
uniform sampler2D u_textureSrc;

precision highp float;

uniform vec2 u_texelSize;
uniform int u_blurRadius;

uniform float u_GaussianWeight[100];

varying vec2 v_texCoords;

void main()
{
    vec2 sampleOffset = vec2(0.0);
    vec4 sum = vec4(0.0);
    sum = texture2D(u_textureSrc, v_texCoords) * u_GaussianWeight[0];

    for(int index = 1 ; index <= u_blurRadius ; index++)
    {
        sampleOffset += u_texelSize;
        sum += texture2D(u_textureSrc, v_texCoords + sampleOffset) * u_GaussianWeight[index];
        sum += texture2D(u_textureSrc, v_texCoords - sampleOffset) * u_GaussianWeight[index];
    }

    gl_FragColor = sum;
}