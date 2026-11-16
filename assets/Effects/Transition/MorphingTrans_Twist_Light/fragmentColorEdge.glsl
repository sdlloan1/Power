
precision mediump float;

uniform sampler2D u_textureSrc;

varying vec2 v_texCoords;

uniform vec2 u_SamplingOffset[4];
uniform vec2 u_Enhance;

void main(){

    vec4 v4DiffX = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[0]) - texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[1]);
    vec4 v4DiffY = texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[2]) - texture2D(u_textureSrc, v_texCoords + u_SamplingOffset[3]);

    vec4 v4ColorEdge = sqrt(v4DiffX * v4DiffX + v4DiffY * v4DiffY);
    v4ColorEdge = clamp((v4ColorEdge - vec4(u_Enhance.x)) * u_Enhance.y + vec4(u_Enhance.x), 0.0, 1.0);

    gl_FragColor = vec4(v4ColorEdge.rgb, 1.0);
}