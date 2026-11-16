#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_txParticle;
uniform vec2 u_AspectRatio;
uniform float u_DegreeOut;
uniform float u_DegreeIn;
uniform vec2 u_Scale;
uniform float u_Progress;
uniform float u_Flash;
uniform float u_Brightness;
uniform vec2 u_Center;
uniform int u_TwistType;

varying vec2 v_texCoords;

void main()
{
    vec2 v2TexCoord = (v_texCoords - u_Center) * u_AspectRatio;
    float fTheta = 0.0;
    if(u_TwistType == 0)
        fTheta = (sin(length(v2TexCoord) / length(u_AspectRatio) * 20.0 - 1.5707963268) + 1.0) * 2.0;
    else
        fTheta = (0.5 - length(v2TexCoord) / length(u_AspectRatio)) * 10.0;

    float fSin = sin(fTheta * u_DegreeOut);
    float fCos = cos(fTheta * u_DegreeOut);
    vec2 v2TexCoordDistortion = vec2(v2TexCoord.x * fCos - v2TexCoord.y * fSin, v2TexCoord.x * fSin + v2TexCoord.y * fCos);
    v2TexCoordDistortion = abs(v2TexCoordDistortion / u_AspectRatio + u_Center);
    v2TexCoordDistortion = v2TexCoordDistortion - max((v2TexCoordDistortion - vec2(1.0)) * 2.0, 0.0) - min(v2TexCoordDistortion * 2.0, 0.0);
	vec4 fadeOutColor = texture2D(u_texture0, v2TexCoordDistortion);

    fSin = sin(fTheta * u_DegreeIn);
    fCos = cos(fTheta * u_DegreeIn);
    v2TexCoordDistortion = vec2(v2TexCoord.x * fCos - v2TexCoord.y * fSin, v2TexCoord.x * fSin + v2TexCoord.y * fCos);
    v2TexCoordDistortion = abs(v2TexCoordDistortion / u_AspectRatio + u_Center);
    v2TexCoordDistortion = v2TexCoordDistortion - max((v2TexCoordDistortion - vec2(1.0)) * 2.0, 0.0) - min(v2TexCoordDistortion * 2.0, 0.0);
	vec4 fadeInColor = texture2D(u_texture1, v2TexCoordDistortion);

    fSin = sin(fTheta * u_DegreeIn * 0.2);
    fCos = cos(fTheta * u_DegreeIn * 0.2);
    v2TexCoordDistortion = vec2(v2TexCoord.x * fCos - v2TexCoord.y * fSin, v2TexCoord.x * fSin + v2TexCoord.y * fCos);
    v2TexCoordDistortion = abs(v2TexCoordDistortion / u_AspectRatio + u_Center);
    v2TexCoordDistortion = v2TexCoordDistortion - max((v2TexCoordDistortion - vec2(1.0)) * 2.0, 0.0) - min(v2TexCoordDistortion * 2.0, 0.0);
	vec4 v4Particle = texture2D(u_txParticle, v2TexCoordDistortion) * u_Brightness;
	vec4 v4Mix = mix(fadeOutColor, fadeInColor, u_Progress) + v4Particle * v4Particle.a;

	gl_FragColor = v4Mix * u_Flash;
}