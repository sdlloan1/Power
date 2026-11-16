attribute vec4 a_position;
attribute vec2 a_texCoords;
attribute vec2 a_texMaskCoords;
uniform float u_Flip;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
varying vec2 v_texCoords;
varying vec2 v_texMaskCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * (a_position * vec4(1.0, u_Flip, 1.0, 1.0));
	v_texCoords = a_texCoords;
	v_texMaskCoords = a_texMaskCoords;
}