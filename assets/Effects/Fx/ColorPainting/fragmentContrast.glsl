
uniform sampler2D u_texture0;
uniform sampler2D u_textureContrast;

precision mediump float;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fRes = texture2D(u_textureContrast, vec2(v4Src.r + 0.0015, 0.5)).a;

	gl_FragColor = vec4(fRes, fRes, fRes, 1.0);
}