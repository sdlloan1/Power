
attribute vec2 a_position;
attribute vec2 a_texCoords;

attribute vec3 a_posOffset; // xyz -- particle offset related to (0, 0, 0)
attribute vec2 a_size; // size and aspectratio
attribute vec4 a_motion; // xyz -- rotate related to xyz axis, w -- texture offset of different particle in one texture
attribute vec3 a_txInfo; // TxSlotIndex texCoord scale & offset to select texture inside a a big texture

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Progress;
uniform vec2 u_AspectRatio;
uniform float u_GlobalFade;
uniform float u_LightReflectionFactor;

varying float v_txIndex;
varying vec2 v_texCoords;
varying float v_lightness;

void main()
{
    vec4 v4Pos = vec4(a_position * a_size, 0.0, 1.0);

    v4Pos.yz = vec2(v4Pos.y * cos(a_motion.x) - v4Pos.z * sin(a_motion.x), v4Pos.y * sin(a_motion.x) + v4Pos.z * cos(a_motion.x));
    v4Pos.xz = vec2(v4Pos.x * cos(a_motion.y) - v4Pos.z * sin(a_motion.y), v4Pos.x * sin(a_motion.y) + v4Pos.z * cos(a_motion.y));
    v4Pos.xy = vec2(v4Pos.x * cos(a_motion.z) - v4Pos.y * sin(a_motion.z), v4Pos.x * sin(a_motion.z) + v4Pos.y * cos(a_motion.z));

    v4Pos = v4Pos * vec4(u_AspectRatio, 1.0, 1.0) + vec4(a_posOffset.xyz, 0.0);

    gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * v4Pos;

    float fReflection = (1.0 - abs(sin(a_motion.x))) * (1.0 - abs(sin(a_motion.y)));
    v_lightness = a_motion.w * u_GlobalFade * (fReflection * fReflection * u_LightReflectionFactor + 1.0);
    v_txIndex = a_txInfo.x;
    v_texCoords = a_texCoords * vec2(a_txInfo.y, 1.0) + vec2(a_txInfo.z, 0.0);
}