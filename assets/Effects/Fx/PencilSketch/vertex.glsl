
attribute vec4 a_position;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

uniform vec2 u_SketchCoordsScale;
uniform vec2 u_SketchCoordsOffset;

varying vec2 v_texCoords;
varying vec2 v_texSketchCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * a_position;
	v_texCoords = a_texCoords;
	v_texSketchCoords = (a_texCoords * u_SketchCoordsScale) + u_SketchCoordsOffset;
}