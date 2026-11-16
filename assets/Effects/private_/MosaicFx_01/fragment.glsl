#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureBlurSrc;
uniform sampler2D u_textureMask;

precision highp float;

uniform vec2 u_BlockSize;
//uniform int u_InverseArea;

varying vec2 v_texCoords;

void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 v4BlurSrc = texture2D(u_textureBlurSrc, v_texCoords);
	float fMask = texture2D(u_textureMask, v_texCoords).r;

//	if(u_InverseArea > 0)
//		fMask = 1.0 - fMask;

	vec2 v2BlockIndex = floor(v_texCoords / u_BlockSize);
	vec2 v2TxCoord = v2BlockIndex * u_BlockSize;
	vec2 v2fract = fract(v_texCoords / u_BlockSize);
	vec2 v2CoordShift = v2fract - vec2(0.5);
	vec4 fragColor = vec4(1.0);

	if((v_texCoords.x < 0.5 && v_texCoords.y < 0.5) || (v_texCoords.x > 0.5 && v_texCoords.y > 0.5))
	{
		float fProj = dot(v2CoordShift, vec2(1.0));
		if (v2CoordShift.x > v2CoordShift.y)
		{
			if (fProj > 0.0)
				v2CoordShift.y += pow(2.0, 10.0 * abs(v2CoordShift.x * 2.0) - 10.0);
			else
				v2CoordShift.x -= pow(2.0, 10.0 * abs(v2CoordShift.y * 2.0) - 10.0);
		}
		else
		{
			if (fProj > 0.0)
				v2CoordShift.x += pow(2.0, 10.0 * abs(v2CoordShift.y * 2.0) - 10.0);
			else
				v2CoordShift.y -= pow(2.0, 10.0 * abs(v2CoordShift.x * 2.0) - 10.0);
		}
	}
	else
	{
		float fProj = dot(v2CoordShift, vec2(1.0));
		if (v2CoordShift.x > v2CoordShift.y)
		{
			if (fProj > 0.0)
				v2CoordShift.y += pow(2.0, 10.0 * abs(v2CoordShift.x * 2.0) - 10.0);
			else
				v2CoordShift.x += pow(2.0, 10.0 * abs(v2CoordShift.y * 2.0) - 10.0);
		}
		else
		{
		if (fProj > 0.0)
				v2CoordShift.y -= pow(2.0, 10.0 * abs(v2CoordShift.x * 2.0) - 10.0);
			else
				v2CoordShift.x -= pow(2.0, 10.0 * abs(v2CoordShift.y * 2.0) - 10.0);
		}
	}

	vec2 v2Coord = v2TxCoord + (v2CoordShift + vec2(0.5)) * u_BlockSize;

	vec4 v4GlassTile;
	if(mod((v2BlockIndex.x * 19741975.0 + v2BlockIndex.y * 13572468.0), 100.0) > 12.0)
		v4GlassTile = texture2D(u_texture0, v2Coord);
	else
		v4GlassTile = texture2D(u_textureBlurSrc, v2Coord);

	gl_FragColor = vec4(mix(v4Src, v4GlassTile, fMask).rgb, v4Src.a);
}
