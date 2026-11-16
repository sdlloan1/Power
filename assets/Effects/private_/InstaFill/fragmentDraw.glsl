uniform sampler2D u_texture0;

precision mediump float;
varying vec2 v_texCoords;

uniform int u_FlipHorizontal;
uniform int u_FlipVertical;

void main(){
	vec2 v1 = v_texCoords;

	if (u_FlipHorizontal > 0) {
    	v1.x = 1.0 - v1.x;
    }
    if (u_FlipVertical > 0) {
    	v1.y = 1.0 - v1.y;
    }

	gl_FragColor = texture2D(u_texture0, v1);
}
