
precision mediump float;

uniform sampler2D u_txParticle;

varying vec2 v_texCoords;
varying float v_Lightness;

void main(){
    vec4 v4Particle = texture2D(u_txParticle, v_texCoords);
	gl_FragColor = vec4((v4Particle * v_Lightness).rgb, v4Particle.a);
}