
attribute vec4 a_position;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

uniform vec4 u_Offset;
uniform vec2 u_TxScale;

varying vec2 v_texCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * (a_position + u_Offset);
	v_texCoords = (a_texCoords - vec2(0.5, 0.5)) * u_TxScale + vec2(0.5, 0.5);
}