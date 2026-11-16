
precision mediump float;

uniform sampler2D u_txParticle[10];

varying float v_txIndex;
varying vec2 v_texCoords;
varying float v_lightness;

void main(){
	gl_FragColor = texture2D(u_txParticle[int(v_txIndex)], v_texCoords) * v_lightness;
}