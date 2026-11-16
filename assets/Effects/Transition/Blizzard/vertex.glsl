attribute vec2 a_position;
attribute vec2 a_positionOffset;
attribute vec2 a_texCoords;
attribute float a_Threshold;

uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_MoveProgress;

varying vec2 v_texCoords;
varying float v_Threshold;

void main()
{
    vec2 v2Position = a_position + a_positionOffset * u_MoveProgress;
	gl_Position = u_PMatrix * u_VMatrix * vec4(v2Position.xy, 0.0, 1.0);
	v_texCoords = a_texCoords;
	v_Threshold = a_Threshold;
}