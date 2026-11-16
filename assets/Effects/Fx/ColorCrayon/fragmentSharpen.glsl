#ifndef HAS_OFFSCREEN_TEXTURE
	#ifdef INPUT_IS_OES_TEXTURE
	#extension GL_OES_EGL_image_external : require
		uniform samplerExternalOES u_texture0;
	#else
		uniform sampler2D u_texture0;
	#endif
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureSrc;
uniform sampler2D u_Mask;

precision mediump float;

uniform vec2 uOffset1;
uniform vec2 uOffset3;
uniform vec2 uOffset4;
uniform vec2 uOffset5;
uniform vec2 uOffset7;

uniform float uWeight1;
uniform float uWeight3;
uniform float uWeight4;
uniform float uWeight5;
uniform float uWeight7;

varying vec2 v_texCoords;
uniform vec2 uMaskCoordVect;

void main(){

	vec4 v4Src = texture2D(u_textureSrc, v_texCoords + uOffset1) * uWeight1;
	v4Src = v4Src + texture2D(u_textureSrc, v_texCoords + uOffset3) * uWeight3;
	v4Src = v4Src + texture2D(u_textureSrc, v_texCoords + uOffset4) * uWeight4;
	v4Src = v4Src + texture2D(u_textureSrc, v_texCoords + uOffset5) * uWeight5;
	v4Src = v4Src + texture2D(u_textureSrc, v_texCoords + uOffset7) * uWeight7;

    v4Src = (v4Src - 0.5) * 1.2 + 0.5;

    float fGrey = dot(v4Src.rgb, vec3(0.2125, 0.7154, 0.0721));
    v4Src = (v4Src - fGrey) * 1.5 + fGrey;

	vec4 v4Mask = texture2D(u_Mask, v_texCoords * uMaskCoordVect);
    v4Src = v4Src * 0.75 + v4Mask * 0.25;

    gl_FragColor = vec4(v4Src.rgb, texture2D(u_texture0, v_texCoords).a);
}
