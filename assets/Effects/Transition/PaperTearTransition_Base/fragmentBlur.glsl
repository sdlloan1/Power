uniform sampler2D u_textureSrc;

precision highp float;

uniform vec2 u_TexelSize;
uniform int u_Radius;
uniform float u_GaussianWeight[21];

varying vec2 v_texCoords;

void main(void)
{
    vec4 v4Src = texture2D(u_textureSrc, v_texCoords);

	vec4 sum = v4Src * u_GaussianWeight[0];
	vec2 v2texCoordOffset = u_TexelSize;

    for(int index = 1 ; index <= u_Radius ; ++index)
    {
    	sum += texture2D(u_textureSrc, v_texCoords + v2texCoordOffset) * u_GaussianWeight[index];
    	sum += texture2D(u_textureSrc, v_texCoords - v2texCoordOffset) * u_GaussianWeight[index];
    	v2texCoordOffset += u_TexelSize;
    }

	gl_FragColor = sum;
}