
precision mediump float;

uniform sampler2D u_textureSrc;
uniform sampler2D u_textureBackdrop;

uniform float u_SrcOpacity;

varying vec2 v_texCoords;

void main()
{
	vec4 v4ColorSrc = texture2D(u_textureSrc, v_texCoords);
	vec4 v4ColorBackdrop = texture2D(u_textureBackdrop, v_texCoords);

    float luma = dot(v4ColorSrc, vec4(0.257, 0.504, 0.098, 0.0)) * v4ColorSrc.a * u_SrcOpacity;

    gl_FragColor = vec4((mix(v4ColorBackdrop, v4ColorSrc, luma)).rgb, 1.0);
}
