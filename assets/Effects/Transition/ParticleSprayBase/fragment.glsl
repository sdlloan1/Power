#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform vec2 u_AspectRatio;
uniform vec2 u_FadeCenter;
uniform float u_FadeDistance;
uniform float u_FadeFeatherRange;

varying vec2 v_texCoords;

void main(){

	vec2 v2TxCoord = (v_texCoords - vec2(0.5)) * u_AspectRatio.yx + vec2(0.5);
	float fDistance = distance(u_FadeCenter, v2TxCoord);
	float fMixRatio = clamp((1.0 - (fDistance / u_FadeDistance)) * u_FadeDistance / u_FadeFeatherRange, 0.0, 1.0);

	gl_FragColor = mix(texture2D(u_texture0, v_texCoords), texture2D(u_texture1, v_texCoords), fMixRatio);
}