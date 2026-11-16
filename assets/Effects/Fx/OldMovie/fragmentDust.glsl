
precision mediump float;

uniform sampler2D u_texture0;

varying vec2 v_texCoords;

void main(){

    vec4 v4Dust = texture2D(u_texture0, v_texCoords);

    gl_FragColor = vec4(v4Dust.a, v4Dust.a, v4Dust.a, 1.0);
}
