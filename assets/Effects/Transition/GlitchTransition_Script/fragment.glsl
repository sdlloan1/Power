#extension GL_OES_EGL_image_external : require

precision mediump float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fRatio;

varying vec2 v_texCoords;

void main()
{
	vec4 fadeOutColor = texture2D(u_texture0, v_texCoords);
	vec4 fadeInColor = texture2D(u_texture1, v_texCoords);

	gl_FragColor = mix(fadeOutColor, fadeInColor, fRatio);
}
