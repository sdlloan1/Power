
attribute vec4 a_position;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Pos = u_PMatrix * u_VMatrix * u_MMatrix * vec4(a_position.xy, 0.0, 1.0);
    v4Pos.y *= -1.0;
	gl_Position = v4Pos;
	v_texCoords = a_texCoords;
}