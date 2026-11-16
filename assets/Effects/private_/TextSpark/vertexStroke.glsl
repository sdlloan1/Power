
attribute vec4 a_position;
attribute vec2 a_Offset;
attribute vec2 a_texCoords;
attribute vec4 a_SparkInfo;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Thickness;
uniform float u_LoopingProgress;

varying vec2 v_texCoords;
varying float v_sparkProgress;

void main()
{
    float fProgress = u_LoopingProgress + a_SparkInfo.x;

    vec4 v4Pos = a_position * u_Thickness * a_SparkInfo.w * fract(fProgress);

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(v4Pos.xy + a_Offset, 0.0, 1.0);

    vec2 v2TxOffset = vec2(mod(floor(fProgress) * a_SparkInfo.z + a_SparkInfo.y, 6.0) * 0.142857, 0.0);
	v_texCoords = a_texCoords + v2TxOffset;
	v_sparkProgress = fract(fProgress * a_SparkInfo.x);
}