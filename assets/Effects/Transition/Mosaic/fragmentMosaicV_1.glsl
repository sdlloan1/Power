#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform float u_fBlockCountY;
uniform int u_nBlockSizeY;
uniform float u_fBlockSizeY;
uniform float u_fPixelSizeY;
uniform float u_fMosaicBufferMappingX;

const int maxBlockSize = 