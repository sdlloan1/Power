#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform float u_fBlockCountX;
uniform int u_nBlockSizeX;
uniform float u_fBlockSizeX;
uniform float u_fPixelSizeX;

const int maxBlockSize = 