#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_txParticle;
uniform float u_Direction;
uniform float u_Distance;
uniform float u_AspectRatio;
uniform float u_Fade;

varying vec2 v_texCoords;

void main(){
	vec4 fadeOutColor = texture2D(u_texture0, v_texCoords);
	vec4 fadeInColor = texture2D(u_texture1, v_texCoords);
	vec2 v2Dir = vec2((v_texCoords.x - 0.5) * u_AspectRatio, 0.5 - v_texCoords.y);
	float fDistance = v2Dir.x * cos(u_Direction) + v2Dir.y * sin(u_Direction);
	vec4 v4Mix = mix(fadeOutColor, fadeInColor, clamp((fDistance - u_Distance + 0.2) * 2.5, 0.0, 1.0));

	vec4 v4Particle = texture2D(u_txParticle, v_texCoords) * u_Fade;
	gl_FragColor = v4Particle + v4Mix * (1.0 - v4Particle.a);
}