
attribute vec2 a_position;
attribute vec2 a_texCoords;

attribute vec4 a_posOffset; // xyz -- particle offset related to (0, 0, 0), w -- size verient
attribute vec4 a_motion; // xyz -- rotate related to xyz axis, w -- Horozontal offset of particle
attribute float a_txOffset; // texture offset of different particle in one texture

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_RotateZCorrection;
uniform float u_Size;
uniform float u_OffsetY;
uniform vec3 u_RotateWeight;
uniform float u_Progress;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Pos = vec4(a_position * u_Size * a_posOffset.w, 0.0, 1.0);

    vec3 v3Rotate = (a_motion.xyz * u_Progress + a_posOffset.xyz) * u_RotateWeight;
    v3Rotate.z += u_RotateZCorrection;

    v4Pos.xy = vec2(v4Pos.x * cos(v3Rotate.z) - v4Pos.y * sin(v3Rotate.z), v4Pos.x * sin(v3Rotate.z) + v4Pos.y * cos(v3Rotate.z));
    v4Pos.xz = vec2(v4Pos.x * cos(v3Rotate.y) - v4Pos.z * sin(v3Rotate.y), v4Pos.x * sin(v3Rotate.y) + v4Pos.z * cos(v3Rotate.y));
    v4Pos.yz = vec2(v4Pos.y * cos(v3Rotate.x) - v4Pos.z * sin(v3Rotate.x), v4Pos.y * sin(v3Rotate.x) + v4Pos.z * cos(v3Rotate.x));

    v4Pos = v4Pos + vec4(a_posOffset.x + a_motion.w * u_Progress, a_posOffset.y + u_OffsetY, a_posOffset.z, 0.0);

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * v4Pos;

	v_texCoords = a_texCoords + vec2(a_txOffset, 0.0);
}