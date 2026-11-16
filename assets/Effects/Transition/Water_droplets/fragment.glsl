#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform sampler2D fTexture;
uniform float smoothness;
uniform vec4 color;
uniform float border;

void main(){
	float blur_interval = smoothness / 150.0;
	float blur_half_interval = blur_interval*0.5;
	
	vec4 f4PixelA = texture2D(u_texture0, v_texCoords);
	vec4 f4PixelB = texture2D(u_texture1, v_texCoords);
	vec4 f4Texture = texture2D(fTexture, v_texCoords);
	
	float ratio =   ( f4Texture.x + f4Texture.y + f4Texture.z) / 3.0 - ( fProgress );
	
	if(ratio > blur_half_interval)
		gl_FragColor = f4PixelA;
	else if(ratio < -blur_half_interval)
		gl_FragColor = f4PixelB;
	else if(border > 0.5){
		if(ratio < 0.0){
			float blur_weight = (blur_half_interval+ratio)/(blur_half_interval);
			gl_FragColor = color*blur_weight + f4PixelB*(1.0 - blur_weight);
		}
		else {
			float blur_weight = (blur_half_interval-ratio)/(blur_half_interval);
			gl_FragColor = f4PixelA*(1.0 - blur_weight) + color*blur_weight;
		}
	}
	else {
		float blur_weight = (blur_half_interval-ratio)/(blur_interval);
		gl_FragColor = f4PixelA*(1.0 - blur_weight) + f4PixelB*blur_weight;
	}
}
