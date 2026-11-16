
precision mediump float;

uniform sampler2D u_txParticle;

varying vec2 v_texCoords;

void main(){
	gl_FragColor = texture2D(u_txParticle, v_texCoords);
}