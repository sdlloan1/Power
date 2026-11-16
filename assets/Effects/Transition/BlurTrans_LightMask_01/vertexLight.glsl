
attribute vec2 a_position;
attribute vec2 a_texCoords;
attribute vec2 a_Offset;
attribute vec4 a_Color;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform mat4 u_RMatrix;
uniform float u_Size;

varying vec2 v_texCoords;
varying vec4 v_Color;

void main()
{
	vec4 v4Pos = u_RMatrix * vec4(a_position * u_Size, 0.0, 1.0);

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * (v4Pos + vec4(a_Offset, 0.0, 0.0));

	v_texCoords = a_texCoords;
	v_Color = a_Color;
}
