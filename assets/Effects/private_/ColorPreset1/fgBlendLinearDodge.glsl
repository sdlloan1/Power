
precision mediump float;

uniform sampler2D u_textureSrc;
uniform sampler2D u_textureBackdrop;

uniform float u_SrcOpacity;

varying vec2 v_texCoords;

void main()
{
	vec4 v4ColorSrc = texture2D(u_textureSrc, v_texCoords);
	vec4 v4ColorBackdrop = texture2D(u_textureBackdrop, v_texCoords);

	float fAlphaSrc = v4ColorSrc.a * u_SrcOpacity;
	float fAlphaBackdrop = v4ColorBackdrop.a;
	float fAlphaDst = fAlphaSrc + fAlphaBackdrop - (fAlphaSrc * fAlphaBackdrop);

	vec4 v4ColorBlend = min(vec4(1.0, 1.0, 1.0, 1.0), v4ColorSrc + v4ColorBackdrop);

	float fParam1 = (1.0 - fAlphaSrc) * fAlphaBackdrop;
	float fParam2 = (1.0 - fAlphaBackdrop) * fAlphaSrc;
	float fParam3 = fAlphaSrc * fAlphaBackdrop;

	vec4 v4Result = (v4ColorBackdrop * fParam1 + v4ColorSrc * fParam2 + v4ColorBlend * fParam3) / fAlphaDst;

	gl_FragColor = vec4(v4Result.rgb, fAlphaDst);
}
