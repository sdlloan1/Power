
attribute vec2 a_position;
attribute vec2 a_Offset;
attribute vec3 a_Motion;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Thickness;
uniform float u_Flash[2];

varying vec2 v_texCoords;
varying float v_texID;
varying float v_brightness;

void main()
{
    vec2 v2Pos = a_position * u_Thickness * a_Motion.y;

    v_texID = a_Motion.z;
	v_texCoords = a_texCoords;
	v_brightness = a_Motion.x * u_Flash[int(a_Motion.z)];

   	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(v2Pos + a_Offset, 0.0, 1.0);
}