
precision mediump float;

uniform sampler2D u_textureSrc;

uniform vec2 u_Direction;
uniform float u_Offset;
uniform float u_Intensity;
uniform float u_Width;

varying vec2 v_texCoords;

void main()
{
	float fCurPos = mod(dot(v_texCoords.yx, u_Direction) - u_Offset, u_Width);
	if(fCurPos <= 0.0)
    	fCurPos += u_Width;

    float fProporOffset = fCurPos / u_Width;
	float fSampleOffset = fProporOffset < 0.5 ? u_Intensity : -u_Intensity;

	gl_FragColor = texture2D(u_textureSrc, v_texCoords + u_Direction * vec2(fSampleOffset));
}
