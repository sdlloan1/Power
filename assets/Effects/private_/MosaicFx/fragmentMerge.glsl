
uniform sampler2D u_textureSrc;
uniform sampler2D u_textureMosaic;
uniform sampler2D u_textureMask;

precision mediump float;

varying vec2 v_texCoords;
varying vec2 v_texAvgCoords;

void main(){

    vec4 v4Src = texture2D(u_textureSrc, v_texCoords);
    vec4 v4Mosaic = texture2D(u_textureMosaic, v_texAvgCoords);
    float fMask = texture2D(u_textureMask, v_texCoords).a;

	gl_FragColor = vec4(mix(v4Src, v4Mosaic, fMask).rgb, v4Src.a);
}