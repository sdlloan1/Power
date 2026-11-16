#extension GL_OES_EGL_image_external : require

precision mediump float;

varying vec2 v_texCoords;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_textureMask;
uniform sampler2D u_textureShape;

void main(){

    vec4 v4Src1 = texture2D(u_texture0, v_texCoords);
    vec4 v4Src2 = texture2D(u_texture1, v_texCoords);
    vec4 v4Mask = texture2D(u_textureMask, v_texCoords);
    vec4 v4Shape = texture2D(u_textureShape, v_texCoords);

    vec4 v4Res = mix(v4Src1, v4Src2, v4Mask.a);

    gl_FragColor = mix(v4Res, v4Shape, v4Shape.a);
}