
precision highp float;

uniform sampler2D u_textureSrc;
uniform vec2 u_Block1;
uniform vec2 u_Block2;
uniform float u_Intensity;
uniform float u_TimeSeed;

varying vec2 v_texCoords;

float randomNoise2(vec2 seed, float time)
{
	return fract(sin(dot(seed * floor(time * 30.0), vec2(127.1, 311.7))) * 43758.5453);
}

void main()
{
    vec2 blockLayer1 = floor(v_texCoords * u_Block1);
    vec2 blockLayer2 = floor(v_texCoords * u_Block2);

    float lineNoise1 = pow(randomNoise2(blockLayer1, u_TimeSeed), 10.0);
    float lineNoise2 = pow(randomNoise2(blockLayer2, u_TimeSeed), 5.0);
    float lineNoise = lineNoise1 * lineNoise2 * u_Intensity;

	gl_FragColor = texture2D(u_textureSrc, fract(v_texCoords + vec2(lineNoise * 0.5 * randomNoise2(vec2(23.0, 1.0), u_TimeSeed), 0.0) + vec2(1.0)));
}
