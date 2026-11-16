
precision mediump float;

uniform sampler2D u_textureSrc;
uniform vec2 u_Offset;

varying vec2 v_texCoords;

void main()
{
	gl_FragColor = texture2D(u_textureSrc, fract(v_texCoords + u_Offset + vec2(1.0)));
}
