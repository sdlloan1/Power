
uniform sampler2D u_textureBrush;

precision mediump float;

uniform float u_Opacity;

varying vec2 v_texCoords;

void main(){

    vec4 v4Brush = texture2D(u_textureBrush, v_texCoords);

	gl_FragColor = v4Brush * u_Opacity;
}
