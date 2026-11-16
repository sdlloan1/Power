#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_txParticle;
uniform vec2 u_Offset;
uniform vec2 u_Scale;
uniform float u_Progress;
uniform float u_Flash;
uniform float u_Brightness;

varying vec2 v_texCoords;

void main()
{
    vec2 vTexCoords = (v_texCoords - vec2(0.5)) * u_Scale + vec2(0.5) + u_Offset;
	vec4 fadeOutColor = texture2D(u_texture0, vTexCoords);
	vec4 fadeInColor = texture2D(u_texture1, vTexCoords);
	vec4 v4Particle = texture2D(u_txParticle, vTexCoords) * u_Brightness;
	vec4 v4Mix = mix(fadeOutColor, fadeInColor, u_Progress) + v4Particle * v4Particle.a;

	gl_FragColor = v4Mix * u_Flash;
}