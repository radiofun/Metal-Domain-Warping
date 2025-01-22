//
//  Metal.metal
//  VoiceModeMetal
//
//  Created by Minsang Choi on 1/20/25.
//
//  https://thebookofshaders.com/13/

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

//randomizer
float randomWithSeed(float2 st) {
    return fract(sin(dot(st, float2(12.9898, 78.233))) * 43758.5453123);
}

float noise2D(float2 st) {
    float2 i = floor(st);
    float2 f = fract(st);

    // Sample the four corners
    float a = randomWithSeed(i);
    float b = randomWithSeed(i + float2(1.0, 0.0));
    float c = randomWithSeed(i + float2(0.0, 1.0));
    float d = randomWithSeed(i + float2(1.0, 1.0));

    // Quintic curve for smooth interpolation
    float2 u = f * f * (3.0 - 2.0 * f);

    // Bilinear interpolation of the corners
    return mix(a, b, u.x)
         + (c - a) * u.y * (1.0 - u.x)
         + (d - b) * u.x * u.y;
}

#define NUM_OCTAVES 100
float fbm(float2 st) {
    float value = 0.0;
    float amp   = 0.5;

    float2 shift = float2(100.0, 100.0);

    float c = cos(0.5);
    float s = sin(0.5);
    float2x2 rot = float2x2(c, s, -s, c);

    for (int i = 0; i < NUM_OCTAVES; i++) {
        value += amp * noise2D(st);
        st = rot * (st * 2.0) + shift;
        amp *= 0.5;
    }

    return value;
}


[[ stitchable ]] half4 fractalNoiseBlueWhite(
    float2 pos,
    SwiftUI::Layer l,
    float4 boundingRect,
    float progress,float scale)
{
    float2 size = float2(boundingRect[2], boundingRect[3]);
    float2 uv         = pos / size * scale;
    float  time       = 0.1 * (-progress * 40.0);

    float2 q;
    q.x = fbm(uv + 0.00 * time);
    q.y = fbm(uv + float2(1.0, 0.0));

    float2 r;
    r.x = fbm(uv + 1.0 * q + float2(1.7, 9.2) + 0.15  * time);
    r.y = fbm(uv + 1.0 * q + float2(8.3, 2.8) + 0.126 * time);

    float f   = fbm(uv + r);

    float2 newpos = uv;
    newpos *= f;
    
    half3 color = half3(l.sample(newpos * size).rgb);
    
    return half4(color, 1.0);
}
