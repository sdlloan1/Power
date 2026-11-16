
attribute vec4 a_position;
attribute vec4 a_Offset;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Thickness;
uniform float u_txCoordOffset;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Pos = a_position * a_Offset.z * u_Thickness;

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(v4Pos.xy + a_Offset.xy, 0.0, 1.0);

	v_texCoords = a_texCoords + vec2(u_txCoordOffset, 0.0);
}