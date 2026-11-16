#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_textureMask;
uniform sampler2D u_textureBorder;
uniform sampler2D u_textureShadow;

precision highp float;

uniform vec2 u_MagnifyRate;
uniform vec2 u_MagnifierCenter;
uniform vec2 u_DisplayCenter;
uniform vec2 u_MaskScale;
uniform vec2 u_DisplayOffset;
uniform vec4 u_FrameColor;
uniform vec4 u_ShadowColor;
uniform vec2 u_ShadowOffset;

varying vec2 v_texCoords;

void main() {

	float fDisplayMask = texture2D(u_textureMask, (v_texCoords - u_DisplayCenter) / u_MaskScale + vec2(0.5)).a;
	float fBorderMask = texture2D(u_textureBorder, (v_texCoords - u_DisplayCenter) / u_MaskScale + vec2(0.5)).a;
	float fShadowMask = texture2D(u_textureShadow, (v_texCoords - u_DisplayCenter - u_ShadowOffset) / u_MaskScale + vec2(0.5)).a;
	vec4 v4Src = texture2D(u_texture0, v_texCoords);

	vec2 texCoordMagnifier = (v_texCoords - u_DisplayOffset);
	vec2 texCoordMagnified = (texCoordMagnifier - u_MagnifierCenter) / u_MagnifyRate + u_MagnifierCenter;
	vec4 v4Magnifier = texture2D(u_texture0, texCoordMagnified);

	gl_FragColor = vec4(mix(mix(mix(v4Src, u_ShadowColor, fShadowMask * u_ShadowColor.a), v4Magnifier, fDisplayMask), u_FrameColor, fBorderMask * u_FrameColor.a).rgb, v4Src.a);
}