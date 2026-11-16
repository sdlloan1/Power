#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_txParticle;
uniform float u_Progress;
uniform float u_Fade;
uniform float u_Flash;
uniform float u_Brightness;
uniform vec2 u_Center;
uniform float u_StepDistance;
uniform int u_BlurRange;

varying vec2 v_texCoords;

void main()
{
	vec4 fadeOutColor = texture2D(u_texture0, v_texCoords);
	vec4 fadeInColor = texture2D(u_texture1, v_texCoords);

	vec2 v2Step = u_Center - v_texCoords;
	v2Step = v2Step / length(v2Step) * u_StepDistance;

	vec2 v2BlurCoord = v_texCoords;
	vec4 v4Particle = texture2D(u_txParticle, v2BlurCoord);
	for(int index = 1 ; index <= u_BlurRange ; ++index)
	{
		v2BlurCoord += v2Step;
		v4Particle += texture2D(u_txParticle, v2BlurCoord);
	}
	v4Particle = v4Particle / float(u_BlurRange + 1) * u_Fade * u_Brightness;

	vec4 v4Mix = mix(fadeOutColor, fadeInColor, u_Progress) + v4Particle * v4Particle.a;

	gl_FragColor = v4Mix * u_Flash;
}