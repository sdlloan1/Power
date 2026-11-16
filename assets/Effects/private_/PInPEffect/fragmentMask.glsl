
uniform sampler2D u_textureSrc;

precision mediump float;
varying vec2 v_texCoords;

void main(void)
{
    vec4 v4Src = texture2D(u_textureSrc, v_texCoords);
	gl_FragColor = vec4(v4Src.a);
}
