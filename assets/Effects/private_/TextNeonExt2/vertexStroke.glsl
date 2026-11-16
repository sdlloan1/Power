
attribute vec4 a_position;
attribute vec3 a_Offset;
attribute vec2 a_texCoords;
attribute vec2 a_colorRatio;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Thickness;

varying vec2 v_texCoords;
varying vec2 v_colorRatio;

void main()
{
    vec4 v4Pos = a_position * a_Offset.z * u_Thickness;

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(v4Pos.xy + a_Offset.xy, 0.0, 1.0);

	v_texCoords = a_texCoords;
	v_colorRatio = a_colorRatio;
}