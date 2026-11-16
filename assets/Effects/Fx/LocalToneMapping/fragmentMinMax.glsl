
uniform sampler2D u_textureSrc;
uniform sampler2D u_textureSum;

precision mediump float;

uniform int u_Step;
uniform vec2 u_TexelSize;
uniform float u_Weighting;

varying vec2 v_texCoords;

void main() {

	vec2 v2TexOffset = u_TexelSize;
	vec4 v4Min = vec4(1.0, 1.0, 1.0, 1.0);
	vec4 v4Max = vec4(0.0, 0.0, 0.0, 0.0);
	vec4 v4Src;

	v4Src = texture2D(u_textureSrc, v_texCoords);
	v4Min = min(v4Min, v4Src);
	v4Max = max(v4Max, v4Src);

	for(int index = 0 ; index < u_Step ; ++index)
	{
		v4Src = texture2D(u_textureSrc, clamp(v_texCoords + v2TexOffset, vec2(0.0), vec2(1.0)));
		v4Min = min(v4Min, v4Src);
		v4Max = max(v4Max, v4Src);

		v4Src = texture2D(u_textureSrc, clamp(v_texCoords - v2TexOffset, vec2(0.0), vec2(1.0)));
		v4Min = min(v4Min, v4Src);
		v4Max = max(v4Max, v4Src);

		v2TexOffset += u_TexelSize;
	}

	gl_FragColor = mix(texture2D(u_textureSum, v_texCoords), vec4(v4Min.r, v4Max.r, 0.0, 1.0), u_Weighting);
}