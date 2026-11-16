
precision highp float;

uniform sampler2D u_textureSrc;
uniform vec2 u_Direction;
uniform float u_TimeSeed;
uniform float u_Width;
uniform float u_Intensity;

varying vec2 v_texCoords;

float rand(vec2 n)
{
	return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

float trunc(float x, float num_levels)
{
    return floor(x * num_levels) / num_levels;
}

vec2 trunc(vec2 x, vec2 num_levels)
{
    return floor(x * num_levels) / num_levels;
}

void main()
{
    float truncTime = trunc(u_TimeSeed, 4.0);
    float fixCoord = dot(v_texCoords, (vec2(1.0) - u_Direction));
    float trucTxCoord = rand(trunc(vec2(fixCoord), vec2(8.0)) + 100.0 * truncTime);
    float randomTruncTxCoord = 6.0 * trunc(u_TimeSeed, 24.0 * trucTxCoord);

    float blockLine_random = 0.5 * rand(trunc(vec2(fixCoord) + vec2(randomTruncTxCoord), vec2(u_Width * 8.0)));
    blockLine_random += 0.5 * rand(trunc(vec2(fixCoord) + vec2(randomTruncTxCoord), vec2(7.0)));
    blockLine_random = blockLine_random * 2.0 - 1.0;
    blockLine_random = sign(blockLine_random) * clamp((u_Intensity - abs(blockLine_random) ) / 0.4, 0.0, 1.0);

	gl_FragColor = texture2D(u_textureSrc, v_texCoords + (0.1 * blockLine_random) * u_Direction);
}
