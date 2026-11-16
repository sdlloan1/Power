attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
varying vec2 v_texCoords;

uniform float fProgress;
uniform float translateOption;
uniform float translate;
uniform float scaleOffset;
uniform float scaleRange;
const float PI = 3.1415926535897932384626433832795028841971693993751;


const float LEFT_TOP = 1.0;
const float LEFT = 2.0;
const float LEFT_BOTTOM = 3.0;
const float TOP = 4.0;
const float CENTER = 5.0;
const float BOTTOM = 6.0;
const float RIGHT_TOP = 7.0;
const float RIGHT = 8.0;
const float RIGHT_BOTTOM = 9.0;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * a_position;

	vec2 v1 = a_texCoords;
	float scale = scaleRange * fProgress + scaleOffset;
	float translateX = 0.0;
	float translateY = 0.0;

	if (translateOption == LEFT_TOP) {
		translateX = -1.0 * fProgress * translate;
		translateY = -1.0 * fProgress * translate;
	} else if (translateOption == LEFT) {
		translateX = -1.0 * fProgress * translate;
	} else if (translateOption == LEFT_BOTTOM) {
		translateX = -1.0 * fProgress * translate;
		translateY = fProgress * translate;
	} else if (translateOption == TOP) {
		translateY = -1.0 * fProgress * translate;
	} else if (translateOption == BOTTOM) {
		translateY = fProgress * translate;
	} else if (translateOption == RIGHT_TOP) {
		translateX = fProgress * translate;
		translateY = -1.0 * fProgress * translate;
	} else if (translateOption == RIGHT) {
		translateX = fProgress * translate;
	} else if (translateOption == RIGHT_BOTTOM) {
		translateX = fProgress * translate;
		translateY = fProgress * translate;
	}

	v1.x = v1.x * scale + (1.0 - scale) / 2.0 + translateX;
	v1.y = v1.y * scale + (1.0 - scale) / 2.0 + translateY;

	v_texCoords = v1;
}
