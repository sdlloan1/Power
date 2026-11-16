
precision mediump float;

uniform sampler2D u_textureSrc;
uniform vec2 u_Intensity;
uniform float u_Offset;

varying vec2 v_texCoords;

void main()
{
    vec2 v2JumpOffset = fract(v_texCoords - vec2(u_Offset));
    vec2 v2TxCoord = fract(mix(v_texCoords, v2JumpOffset, u_Intensity));

	gl_FragColor = texture2D(u_textureSrc, fract(mix(v_texCoords, v2JumpOffset, u_Intensity) + vec2(1.0)));
}
