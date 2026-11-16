
uniform sampler2D u_textureSrcA;
uniform sampler2D u_textureSrcB;

uniform sampler2D u_textureBlurA;
uniform sampler2D u_textureBlurB;

precision highp float;

uniform vec2 u_BlockNumber;
uniform vec2 u_BlockSize;
uniform vec2 u_AspectRatio;
uniform vec2 u_Center;
uniform float u_Range;
uniform float u_Distance;
uniform float u_Progress;

varying vec2 v_texCoords;

void main() {

	// Eclipse
	vec2 v2TxCoord = floor(v_texCoords * u_BlockNumber) / u_BlockNumber;
	vec2 v2fract = fract(v_texCoords / u_BlockSize);
	vec2 v2Center = v2TxCoord + u_BlockSize * 0.5;
	vec2 v2XY = v_texCoords - v2Center;

	float ellipseVal = dot((v2XY * v2XY) / (u_BlockSize * u_BlockSize * 0.25), vec2(1.0));

	vec2 v2fract4Block = fract(v_texCoords / u_BlockSize / 4.0);
	vec2 v2EclipseCenter;
	if(v2fract4Block.y < 0.25)
	{
		if(v2fract4Block.x < 0.25)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.5, 0.15);
		else if(v2fract4Block.x < 0.5)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.85, 0.5);
		else if(v2fract4Block.x < 0.75)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.5, 0.85);
		else
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.15, 0.5);
	}
	else if(v2fract4Block.y < 0.5)
	{
		if(v2fract4Block.x < 0.25)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.15, 0.5);
		else if(v2fract4Block.x < 0.5)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.5, 0.15);
		else if(v2fract4Block.x < 0.75)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.85, 0.5);
		else
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.5, 0.85);
	}
	else if(v2fract4Block.y < 0.75)
	{
		if(v2fract4Block.x < 0.25)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.5, 0.85);
		else if(v2fract4Block.x < 0.5)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.15, 0.5);
		else if(v2fract4Block.x < 0.75)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.5, 0.15);
		else
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.85, 0.5);
	}
	else
	{
		if(v2fract4Block.x < 0.25)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.85, 0.5);
		else if(v2fract4Block.x < 0.5)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.5, 0.85);
		else if(v2fract4Block.x < 0.75)
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.15, 0.5);
		else
			v2EclipseCenter = v2TxCoord + u_BlockSize * vec2(0.5, 0.15);
	}

	v2XY = v_texCoords - v2EclipseCenter;
	float eclipseVal = dot((v2XY * v2XY) / (u_BlockSize * u_BlockSize * 0.1), vec2(1.0));

	if((ellipseVal <= 1.0) && (eclipseVal > 1.0))
		v2TxCoord = v2Center;
	else
		v2TxCoord = v_texCoords;

	vec2 v2Vector = (v2TxCoord - u_Center) * u_AspectRatio;
	float fCurDistanceBound = u_Progress * (u_Distance + u_Range);
	float fCurDistance = length(v2Vector);
	if(fCurDistance > fCurDistanceBound)
	{
		gl_FragColor = texture2D(u_textureSrcA, v_texCoords);
	}
	else
	{
		vec4 v4SrcA = texture2D(u_textureSrcA, v_texCoords);
		vec4 v4SrcB = texture2D(u_textureSrcB, v_texCoords);
		vec4 v4MosaicA = texture2D(u_textureBlurA, v2TxCoord);
		vec4 v4MosaicB = texture2D(u_textureBlurB, v2TxCoord);

		float fMixProgress = min((fCurDistanceBound - fCurDistance) / u_Range, 1.0);
		float fSrcMixRate = 0.5 - cos(fMixProgress * 3.14159265359) * 0.5;
		float fMosaicMixRate;
		if(fMixProgress < 0.3)
			fMosaicMixRate = sin(((fMixProgress / 0.3) - 0.5) * 3.14159265359) * 0.5 + 0.5;
		else
			fMosaicMixRate = sin((((fMixProgress - 0.3) / 0.7) + 0.5) * 3.14159265359) * 0.5 + 0.5;

		float fLighten = 1.0 + fMosaicMixRate * fMosaicMixRate * fMosaicMixRate * 0.7;

		gl_FragColor = mix(mix(v4SrcA, v4SrcB, fSrcMixRate), mix(v4MosaicA, v4MosaicB, fSrcMixRate), fMosaicMixRate) * vec4(fLighten, fLighten, fLighten, 1.0);
	}
}