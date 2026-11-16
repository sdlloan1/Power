
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

	vec4 v4ColorBlendMax = max(vec4(0.0, 0.0, 0.0, 0.0), (v4ColorBackdrop + v4ColorSrc - v4ColorBackdrop * v4ColorSrc) * 2.0 - vec4(1.0, 1.0, 1.0, 1.0));
	vec4 v4ColorBlend = v4ColorBackdrop * v4ColorSrc * 2.0;

    bvec4 b4Greater = greaterThan(v4ColorSrc, vec4(0.5, 0.5, 0.5, 0.5));
    v4ColorBlend = v4ColorBlendMax * vec4(b4Greater) + v4ColorBlend * vec4(not(b4Greater));

	float fParam1 = (1.0 - fAlphaSrc) * fAlphaBackdrop;
	float fParam2 = (1.0 - fAlphaBackdrop) * fAlphaSrc;
	float fParam3 = fAlphaSrc * fAlphaBackdrop;

	vec4 v4Result = (v4ColorBackdrop * fParam1 + v4ColorSrc * fParam2 + v4ColorBlend * fParam3) / fAlphaDst;

	gl_FragColor = vec4(v4Result.rgb, fAlphaDst);
}
