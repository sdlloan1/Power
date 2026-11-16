
precision mediump float;

uniform sampler2D u_textureSrc;
uniform sampler2D u_txStripeOffset;

uniform vec2 u_Offset;
uniform float u_Intensity;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Noise = texture2D(u_txStripeOffset, v_texCoords * 0.5 + u_Offset);
    float fThreshold = 1.001 * (1.0 - u_Intensity);

	vec2 v2TxCoordShift = v4Noise.gb * step(fThreshold, pow(abs(v4Noise.r), 3.0));
    gl_FragColor = texture2D(u_textureSrc, fract(v_texCoords + v2TxCoordShift + vec2(1.0)));
}
