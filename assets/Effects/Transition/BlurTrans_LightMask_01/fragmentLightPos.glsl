
uniform sampler2D u_txSrc;

precision mediump float;

varying vec2 v_texCoords;

uniform float u_EdgeThreshold;
uniform vec2 u_TexelSize;

void main() {

	vec4 v4Src_Up = texture2D(u_txSrc, v_texCoords - vec2(0.0, u_TexelSize.y));
	vec4 v4Src_Down = texture2D(u_txSrc, v_texCoords + vec2(0.0, u_TexelSize.y));
	vec4 v4Src_Left = texture2D(u_txSrc, v_texCoords - vec2(u_TexelSize.x, 0.0));
	vec4 v4Src_Right = texture2D(u_txSrc, v_texCoords + vec2(u_TexelSize.x, 0.0));
	float fEdge = dot(abs(v4Src_Up - v4Src_Down) + abs(v4Src_Left - v4Src_Right), vec4(1.0, 1.0, 1.0, 0.0));

	vec4 v4Src = texture2D(u_txSrc, v_texCoords);

	if(fEdge > u_EdgeThreshold)
		gl_FragColor = vec4(v4Src.rgb, dot(v4Src, vec4(0.333, 0.333, 0.333, 0.0)));
	else
		gl_FragColor = vec4(0.0);
}