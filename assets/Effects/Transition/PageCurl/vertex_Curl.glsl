attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
varying vec2 v_texCoords;

uniform float fProgress;
uniform int imode;

/**
 * Algorithm based on the paper of PARC(Palo Alto Research Center).
 * http://www2.parc.com/istl/groups/uir/publications/items/UIR-2004-10-Hong-DeformingPages.pdf
 */
const float PI = 3.1415926535897932384626433832795028841971693993751;
const float aspectRatioScale = 2.0;
float magicZScale(float z) {
	return z / 10000.0 - 0.001;
}

void main()
{
	vec4 vi = a_position;
	if (imode == 0)
		vi.x += aspectRatioScale;
	else
		vi.x -= aspectRatioScale;

	float theta = PI/2.0-PI*(fProgress/2.0);
	float A = -1.0 - (fProgress/2.0)*10.0;

    float R = sqrt(vi.x * vi.x + pow(vi.y - A, 2.0)); // Radius of the circle
                                                      //circumscribed by vertex
                                                      //(vi.x, vi.y) around A on the
                                                      //x-y plane.
    float r = R * sin(theta);                         // From R, calculate the
                                                      //radius of the cone cross
                                                      //section intersected by our
                                                      //vertex in 3D space.
    float beta = asin(vi.x / R) / sin(theta);         // Angle SCT, the angle of the
                                                      //cone cross section subtended
                                                      //by the arc |ST|.
    if (imode == 0)
        vi.x = r * sin(beta) - aspectRatioScale;
    else
        vi.x = r * sin(beta) + aspectRatioScale;
    vi.y = R + A - r * (1.0 - cos(beta)) * sin(theta); // *** MAGIC!!! ***
    vi.z = magicZScale(r * (1.0 - cos(beta)) * cos(theta));

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vi;
	v_texCoords = a_texCoords;
}
