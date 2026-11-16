#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform vec2 u_AspectRatio;
uniform vec2 u_Scale;
uniform vec2 u_Rotate;
uniform float u_Brightness;

varying vec2 v_texCoords;

void main(void)
{
	vec2 v2Coord = (v_texCoords - vec2(0.5)) * u_AspectRatio;
	vec2 v2CoordRotate = vec2(v2Coord.x * u_Rotate.y - v2Coord.y * u_Rotate.x, v2Coord.x * u_Rotate.x + v2Coord.y * u_Rotate.y);
	vec2 v2CoordScale = (v2CoordRotate * u_Scale) / u_AspectRatio + vec2(0.5);

	gl_FragColor = texture2D(u_texture0, v2CoordScale) * u_Brightness;
}