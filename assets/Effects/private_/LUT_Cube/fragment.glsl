#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureLUT;

precision highp float;

uniform vec2 u_LUTTxDimension;
uniform vec2 u_LUTTxBlockNum;
uniform float u_LUTTxBlockSize;
uniform float u_Degree;

varying vec2 v_texCoords;

void main(){

	vec4 v4SrcColor = texture2D(u_texture0, v_texCoords);

	float fBlockIndex1 = floor(v4SrcColor.b * (u_LUTTxBlockSize - 1.0));
	float fBlockIndex2 = ceil(v4SrcColor.b * (u_LUTTxBlockSize - 1.0));

	vec2 v2BlockBegin1, v2BlockBegin2;
	v2BlockBegin1 = vec2(mod(fBlockIndex1, u_LUTTxBlockNum.x), floor(fBlockIndex1 / u_LUTTxBlockNum.x)) * u_LUTTxBlockSize;
	v2BlockBegin2 = vec2(mod(fBlockIndex2, u_LUTTxBlockNum.x), floor(fBlockIndex2 / u_LUTTxBlockNum.x)) * u_LUTTxBlockSize;

	vec2 v2BlockOffset = v4SrcColor.rg * (u_LUTTxBlockSize - 1.0) + vec2(0.5);

	vec4 v4Color1 = texture2D(u_textureLUT, (v2BlockBegin1 + v2BlockOffset) / u_LUTTxDimension);
	vec4 v4Color2 = texture2D(u_textureLUT, (v2BlockBegin2 + v2BlockOffset) / u_LUTTxDimension);

	vec4 v4NewColor = mix(v4SrcColor, mix(v4Color1, v4Color2, fract(v4SrcColor.b * (u_LUTTxBlockSize - 1.0))), u_Degree);

	gl_FragColor = vec4(v4NewColor.rgb, v4SrcColor.a);
}