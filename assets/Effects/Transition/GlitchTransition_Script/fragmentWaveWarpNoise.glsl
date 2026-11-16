
uniform sampler2D u_textureSrc;
uniform sampler2D u_txNoiseOffset;

precision highp float;

uniform vec2 u_Direction;
uniform float u_Offset;
uniform float u_Intensity;
uniform float u_Width;

varying vec2 v_texCoords;

void main()
{
	float fCurPos = mod(dot(v_texCoords.yx, u_Direction) + u_Offset, u_Width);
	if(fCurPos <= 0.0)
    	fCurPos += u_Width;

    float fProporOffset = fCurPos / u_Width;
    vec4 v4Offset = texture2D(u_txNoiseOffset, vec2(fProporOffset, 0.5));
    float fOffset = v4Offset.r + v4Offset.g / 256.0 - 0.5;
	vec2 v2SampleOffset = u_Direction * u_Intensity * fOffset;

	gl_FragColor = texture2D(u_textureSrc, v_texCoords + v2SampleOffset);
}
