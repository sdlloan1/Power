
precision mediump float;

uniform sampler2D u_textureSrc;
uniform vec2 u_DirectionIntensity;
uniform float u_Offset;
uniform float u_Width;

varying vec2 v_texCoords;

void main()
{
	gl_FragColor = texture2D(u_textureSrc, fract(v_texCoords + u_DirectionIntensity * sin(6.2831853 * (v_texCoords.yx - u_Offset) / u_Width) + 2.0));
}
