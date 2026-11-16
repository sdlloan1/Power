#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureBlurSrc;
uniform sampler2D u_textureMask;

precision highp float;

uniform vec2 u_BlockNumber;
uniform vec2 u_BlockSize;
uniform int u_InverseArea;

varying vec2 v_texCoords;

void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	float fMask = texture2D(u_textureMask, v_texCoords).r;

	vec2 v2TxCoord = floor(v_texCoords * u_BlockNumber) / u_BlockNumber;
	vec2 v2fract2Block = fract(v_texCoords / u_BlockSize / 2.0);
	vec2 v2fract = fract(v_texCoords / u_BlockSize);

	if(v2fract2Block.y < 0.5)
	{
		if(v2fract2Block.x < 0.5)
		{
			if(v2fract.x > v2fract.y)
				v2TxCoord += u_BlockSize * vec2(1.0, 0.5);
			else
				v2TxCoord += u_BlockSize * vec2(0.5, 1.0);
		}
		else
		{
			if((v2fract.x + v2fract.y) > 1.0)
				v2TxCoord += u_BlockSize * vec2(0.5, 1.0);
			else
				v2TxCoord += u_BlockSize * vec2(0.0, 0.5);
		}
	}
	else
	{
		if(v2fract2Block.x < 0.5)
		{
			if((v2fract.x + v2fract.y) > 1.0)
				v2TxCoord += u_BlockSize * vec2(1.0, 0.5);
			else
				v2TxCoord += u_BlockSize * vec2(0.5, 0.0);
		}
		else
		{
			if(v2fract.x > v2fract.y)
				v2TxCoord += u_BlockSize * vec2(0.5, 0.0);
			else
				v2TxCoord += u_BlockSize * vec2(0.0, 0.5);
		}
	}

	vec4 v4Mosaic = texture2D(u_textureBlurSrc, v2TxCoord);

	if(u_InverseArea > 0)
		fMask = 1.0 - fMask;

	gl_FragColor = vec4(mix(v4Src, v4Mosaic, fMask).rgb, v4Src.a);
}
