
uniform sampler2D u_textureGrayScale;
uniform sampler2D u_textureMinMax;

precision highp float;

uniform vec2 u_BlockSize;
uniform float u_MaxAdjust;

varying vec2 v_texCoords;

void main() {

	float fGrayVal = texture2D(u_textureGrayScale, v_texCoords).r;

	vec2 v2TxBlock = v_texCoords / u_BlockSize;
	vec2 v2TxBlockFract = fract(v2TxBlock);
	vec2 v2TxBlockFloor = floor(v2TxBlock);

	float fCoordX1, fCoordX2, fCoordY1, fCoordY2;
	if(v2TxBlockFract.x >= 0.5)
	{
		fCoordX1 = (v2TxBlockFloor.x + 0.5) * u_BlockSize.x;
		fCoordX2 = (v2TxBlockFloor.x + 1.5) * u_BlockSize.x;
	}
	else
	{
		fCoordX1 = (v2TxBlockFloor.x - 0.5) * u_BlockSize.x;
		fCoordX2 = (v2TxBlockFloor.x + 0.5) * u_BlockSize.x;
	}

	if(v2TxBlockFract.y >= 0.5)
	{
		fCoordY1 = (v2TxBlockFloor.y + 0.5) * u_BlockSize.y;
		fCoordY2 = (v2TxBlockFloor.y + 1.5) * u_BlockSize.y;
	}
	else
	{
		fCoordY1 = (v2TxBlockFloor.y - 0.5) * u_BlockSize.y;
		fCoordY2 = (v2TxBlockFloor.y + 0.5) * u_BlockSize.y;
	}

	float fWeightX = cos((v_texCoords.x - fCoordX1) / u_BlockSize.x * 3.14159265359) * 0.5 + 0.5;
	float fWeightY = cos((v_texCoords.y - fCoordY1) / u_BlockSize.y * 3.14159265359) * 0.5 + 0.5;

	vec4 v4MinMaxY1 = mix(texture2D(u_textureMinMax, vec2(fCoordX2, fCoordY1)), texture2D(u_textureMinMax, vec2(fCoordX1, fCoordY1)), fWeightX);
	vec4 v4MinMaxY2 = mix(texture2D(u_textureMinMax, vec2(fCoordX2, fCoordY2)), texture2D(u_textureMinMax, vec2(fCoordX1, fCoordY2)), fWeightX);
	vec4 v4MinMax = mix(v4MinMaxY2, v4MinMaxY1, fWeightY);

	v4MinMax.r = v4MinMax.r * u_MaxAdjust;
	v4MinMax.g = (1.0 - v4MinMax.g) * (1.0 - u_MaxAdjust) + v4MinMax.g;

	v4MinMax = max(v4MinMax, vec4(0.0, 0.004, 0.0, 0.0));
	float fNewGrayVal = clamp((fGrayVal - v4MinMax.r) / (v4MinMax.g - v4MinMax.r), 0.0, 1.0);

//	Log process cause un-expected result on small value with different platform.
//	v4MinMax = max(v4MinMax, vec4(0.01, 0.02, 0.0, 0.0));
//	float fLogMin = log(v4MinMax.r);
//	float fLogMax = log(v4MinMax.g);
//	float fLogGrayVal = log(clamp(fGrayVal, v4MinMax.r, v4MinMax.g));
//	float fNewGrayVal = clamp((fLogGrayVal - fLogMin) / (fLogMax - fLogMin), 0.0, 1.0);

	gl_FragColor = vec4(fNewGrayVal);
}