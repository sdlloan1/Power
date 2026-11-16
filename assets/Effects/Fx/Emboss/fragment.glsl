#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;
varying vec2 v_texCoords;

uniform float fLeft;
uniform float fTop;
uniform float fRight;
uniform float fBottom;
uniform float fInverse;
uniform float fOffsetX1;
uniform float fOffsetY1;
uniform float fOffsetX2;
uniform float fOffsetY2;
uniform float fGradientDepth;
uniform float fSqrWidth;
uniform float fSqrHeight;
uniform float fMaskType;
const float fDepth = 0.5;

void main(void)
{
	// Return order -- float4(B, G, R, A)
	// f4.x = R , f4.y = G , f4.z = B , f4.w = A
	vec4 f4Texture = texture2D(u_texture0, v_texCoords);
	vec4 f4GrayConvert = vec4(0.114, 0.587, 0.299, 0.0);

    if((fOffsetX2 == 0.0) && (fOffsetY2 == 0.0))
    {
        gl_FragColor = f4Texture;
        return;
    }

	float fGray1 = dot(texture2D(u_texture0, v_texCoords + vec2(fOffsetX1, fOffsetY1)), f4GrayConvert);
	float fGray2 = dot(texture2D(u_texture0, v_texCoords + vec2(fOffsetX2, fOffsetY2)), f4GrayConvert);
	float fGrayResult = (fGray1 - fGray2 + 0.5);

	if(fInverse > 0.5) // Inverse == TRUE
	{
		if((v_texCoords.x < fRight) && (v_texCoords.x > fLeft) && (v_texCoords.y < fBottom) && (v_texCoords.y > fTop))
		{
			if(fMaskType > 0.5) // Circle
			{
				float fDisX = v_texCoords.x - ((fLeft + fRight) / 2.0);
				float fDisY = v_texCoords.y - ((fTop + fBottom) / 2.0);
				float fRadius = (fDisX * fDisX / fSqrWidth) + (fDisY * fDisY / fSqrHeight);
				if(fRadius < 1.0)
				{
					if(fRadius > (1.0 - fGradientDepth))
					{
						float fSat = (1.0 - fRadius) / fGradientDepth;
						gl_FragColor = vec4(fGrayResult * (1.0 - fSat) + f4Texture.x * fSat, fGrayResult * (1.0 - fSat) + f4Texture.y * fSat, fGrayResult * (1.0 - fSat) + f4Texture.z * fSat, f4Texture.a);
 						return;
 					}
					else
					{
						gl_FragColor = f4Texture;
						return;
					}
				}
			}
			else // Box
			{
				if(fGradientDepth > 0.0001)
				{
					float fDistance = min(min(v_texCoords.x - fLeft, fRight - v_texCoords.x), min(v_texCoords.y - fTop, fBottom - v_texCoords.y));
					if(fDistance < fDepth)
					{
						float fSat = fDistance / fDepth;
						gl_FragColor = vec4(fGrayResult * (1.0 - fSat) + f4Texture.x * fSat, fGrayResult * (1.0 - fSat) + f4Texture.y * fSat, fGrayResult * (1.0 - fSat) + f4Texture.z * fSat, f4Texture.a);
						return;
					}
					else
					{
						gl_FragColor = f4Texture;
						return;
					}
				}
				else
				{
					gl_FragColor = f4Texture;
					return;
				}
			}
		}
	}
	else {
		if((v_texCoords.x > fRight) || (v_texCoords.x < fLeft) || (v_texCoords.y > fBottom) || (v_texCoords.y < fTop)){
			gl_FragColor = f4Texture;
			return;
		}

		if(fMaskType > 0.5)
		{
			float fDisX = v_texCoords.x - ((fLeft + fRight) / 2.0);
			float fDisY = v_texCoords.y - ((fTop + fBottom) / 2.0);
			float fRadius = (fDisX * fDisX / fSqrWidth) + (fDisY * fDisY / fSqrHeight);
			if(fRadius > 1.0)
			{
				gl_FragColor = f4Texture;
				return;
			}

			if(fRadius > (1.0 - fGradientDepth))
			{
				float fSat = (1.0 - fRadius) / fGradientDepth;
				gl_FragColor = vec4(fGrayResult * fSat + f4Texture.x * (1.0 - fSat), fGrayResult * fSat + f4Texture.y * (1.0 - fSat), fGrayResult * fSat + f4Texture.z * (1.0 - fSat), f4Texture.a);
 				return;
 			}
		}
		else // Box
		{
			if(fGradientDepth > 0.0001)
			{
				float fDistance = min(min(v_texCoords.x - fLeft, fRight - v_texCoords.x), min(v_texCoords.y - fTop, fBottom - v_texCoords.y));
				if(fDistance < fDepth)
				{
					float fSat = fDistance / fDepth;
					gl_FragColor = vec4(fGrayResult * fSat + f4Texture.x * (1.0 - fSat), fGrayResult * fSat + f4Texture.y * (1.0 - fSat), fGrayResult * fSat + f4Texture.z * (1.0 - fSat), f4Texture.a);
					return;
				}
			}
		}
	}

	gl_FragColor = vec4(fGrayResult, fGrayResult, fGrayResult, f4Texture.a);
}