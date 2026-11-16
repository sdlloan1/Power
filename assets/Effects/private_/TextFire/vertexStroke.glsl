
attribute vec4 a_position;
attribute vec4 a_offset;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

uniform vec2 u_TxOffset;

varying vec2 v_texCoords;
varying vec2 v_texOffset;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(a_position.xy + a_offset.xy, 0.0, 1.0);

	v_texCoords = a_texCoords;
	v_texOffset = u_TxOffset;
}