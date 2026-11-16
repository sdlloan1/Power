
attribute vec4 a_position;
//attribute vec4 a_Offset;
attribute vec2 a_texCoords;

uniform mat4 u_RMatrix;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Pos = u_RMatrix * vec4(a_position.xyz, 1.0);

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * v4Pos;

	v_texCoords = a_texCoords;
}