#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

precision mediump float;

uniform sampler2D u_textureGraySrc;
uniform sampler2D u_textureGrayDst;

uniform float u_Degree;

varying vec2 v_texCoords;

vec3 rgb2hsv(vec3 c)
{
	float e_zero = 1.0e-3;
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	return clamp(vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e_zero)), d / (q.x + e_zero), q.x), 0.0, 1.0);
}

vec3 hsv2rgb(vec3 c)
{
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return clamp(c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y), 0.0, 1.0);
}

void main() {

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 v4GraySrc = max(texture2D(u_textureGraySrc, v_texCoords), 0.001);
	vec4 v4GrayDst = texture2D(u_textureGrayDst, v_texCoords);

	vec4 v4MaxRatio = vec4(1.0) / max(v4Src, vec4(0.001));
	float fMaxRatio = min(min(v4MaxRatio.r, v4MaxRatio.g), v4MaxRatio.b);

	vec3 v3HSV = rgb2hsv(v4Src.rgb);
	v3HSV.b *= min(v4GrayDst.r / v4GraySrc.r, fMaxRatio);
	vec3 v3Result = hsv2rgb(v3HSV);

	gl_FragColor = vec4(mix(v4Src.rgb, v3Result, u_Degree), v4Src.a);
}
