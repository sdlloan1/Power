attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
varying vec2 v_texCoords;
varying vec2 v_mskCoords;
uniform float u_OffsetX;
uniform float u_OffsetY;
uniform float u_ScaleX;
uniform float u_ScaleY;
void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * a_position;
	v_texCoords = a_texCoords;
	
	v_mskCoords.x = ( a_texCoords.x + u_OffsetX ) * u_ScaleX;
	v_mskCoords.y = ( a_texCoords.y + u_OffsetY ) * u_ScaleY;
}