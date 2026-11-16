
uniform sampler2D u_texture0; 
uniform sampler2D gaussianTableTexture;

precision mediump float;

varying vec2 v_texCoords;
uniform highp float texelWidthOffset;
uniform highp float texelHeightOffset;
uniform highp float gaussianTableStep;
uniform int BlurRadius;

const mediump float maxBlurSize = 