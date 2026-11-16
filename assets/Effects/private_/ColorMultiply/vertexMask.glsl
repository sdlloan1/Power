attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
varying vec2 v_texCoords;
varying vec2 v_Position;
void main()
{
    vec4 position = u_PMatrix * u_VMatrix * u_MMatrix * a_position;
	v_texCoords = a_texCoords;
	v_Position = vec2((position.x/position.w)*0.5+0.5, (position.y/position.w)*0.5+0.5);
	gl_Position = position;
}