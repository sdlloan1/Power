#extension GL_OES_EGL_image_external : require

precision mediump float;

varying vec2 v_texCoords;
varying float v_Threshold;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;
uniform float u_TailRange;

void main(){

    if(fProgress < v_Threshold)
   	    gl_FragColor = texture2D(u_texture0, v_texCoords);
    else if(fProgress > (v_Threshold + u_TailRange))
   	    gl_FragColor = texture2D(u_texture1, v_texCoords);
    else
    {
        // Flash
        gl_FragColor = mix(vec4(1.0, 1.0, 1.0, 1.0), texture2D(u_texture1, v_texCoords), (fProgress - v_Threshold) / u_TailRange);
        // Blend
//        gl_FragColor = mix(texture2D(u_texture0, v_texCoords), texture2D(u_texture1, v_texCoords), (fProgress - v_Threshold) / u_TailRange);
    }
}