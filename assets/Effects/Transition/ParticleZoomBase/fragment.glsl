#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_txParticle;
uniform vec2 u_AspectRatio;
uniform float u_Degree;
uniform vec2 u_Scale;
uniform float u_Progress;
uniform float u_Flash;
uniform float u_Brightness;
uniform vec2 u_Center;
uniform vec2 u_DirCtrl;

varying vec2 v_texCoords;

void main()
{
    vec2 v2TexCoord = (v_texCoords - u_Center) * u_AspectRatio;

    float fRatio = min((length(v2TexCoord) / length(u_AspectRatio) * 2.0), 1.0);
    fRatio = (u_DirCtrl.x - u_DirCtrl.y * fRatio);

    vec2 v2TexCoordZoom = (v2TexCoord * (1.0 - u_Degree * fRatio * fRatio));

    float fTheta = u_Progress * 3.14159265359;
    float fCos = cos(fTheta);
    float fSin = sin(fTheta);
    vec2 v2TexCoordRotate1 = vec2(v2TexCoordZoom.x * fCos - v2TexCoordZoom.y * fSin, v2TexCoordZoom.x * fSin + v2TexCoordZoom.y * fCos);
    vec2 v2TexCoordRotate2 = vec2(v2TexCoordZoom.x * -fCos - v2TexCoordZoom.y * -fSin, v2TexCoordZoom.x * -fSin + v2TexCoordZoom.y * -fCos);
    v2TexCoordRotate1 = v2TexCoordRotate1 / u_AspectRatio + u_Center;
    v2TexCoordRotate2 = v2TexCoordRotate2 / u_AspectRatio + u_Center;

    v2TexCoordRotate1 = v2TexCoordRotate1 - max((v2TexCoordRotate1 - vec2(1.0)) * 2.0, 0.0) - min(v2TexCoordRotate1 * 2.0, 0.0);
    v2TexCoordRotate2 = v2TexCoordRotate2 - max((v2TexCoordRotate2 - vec2(1.0)) * 2.0, 0.0) - min(v2TexCoordRotate2 * 2.0, 0.0);

	vec4 fadeOutColor = texture2D(u_texture0, v2TexCoordRotate1);
	vec4 fadeInColor = texture2D(u_texture1, v2TexCoordRotate2);
	vec4 v4Particle = texture2D(u_txParticle, v2TexCoordRotate2) * u_Brightness;
	vec4 v4Mix = mix(fadeOutColor, fadeInColor, u_Progress) + v4Particle * v4Particle.a;

	gl_FragColor = v4Mix * u_Flash;
}