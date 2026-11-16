
precision mediump float;

uniform sampler2D u_textureBrush;
uniform float u_BorderOpacity;

varying vec2 v_texCoords;
varying float v_borderVal;

void main(){

    vec4 v4Brush = texture2D(u_textureBrush, v_texCoords);
    float borderVal = v4Brush.r * v_borderVal * u_BorderOpacity;
    gl_FragColor = vec4(borderVal, 0.0, 0.0, 0.0);
}
