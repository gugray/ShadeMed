#version 300 es

in float index;
uniform sampler2D particles;
uniform float szParticleState;
uniform vec2 resolution;
uniform float pointSize;
out vec2 props;

void main() {
    float x = mod(index, szParticleState);
    float y = floor(index / szParticleState);
    vec4 pstate = texelFetch(particles, ivec2(x, y), 0);
    gl_Position = vec4(1.);
    gl_Position.xy = vec2(-1.) + 2. * pstate.xy / resolution;
    props = pstate.zw;

    gl_PointSize = pointSize;
}
