extern float exposure = 0.7;
extern float brightness = 1.0;
extern vec3 lumacomponents = vec3(1.0, 1.0, 1.0);
extern float time = 1239;

// luma 
const vec3 lumcoeff = vec3(0.212671, 0.715160, 0.072169);

// Function to generate a random value between 0 and 1 based on integer input
float random(vec2 seed)
{
    return fract(sin(dot(seed, vec2(12.9898, 78.233))) * 43758.5453);
}

// Cellular noise function
float cellularNoise(vec2 fragCoord, int numPoints)
{
    // Random offset for each cell
    vec2 offset = vec2( random(vec2(time, 0.0)), random(vec2(0.0, time)) );

    // Calculate the nearest distance to the points
    float minDistance = 1.0; // Initialize to a large value
    for (int i = 0; i < numPoints; i++)
    {
        vec2 point = vec2(random(vec2(float(i) + offset.x, offset.y)), 
                          random(vec2(offset.x, float(i) + offset.y)));
        
        float distance = distance(fragCoord, point);
        minDistance = min(minDistance, distance);
    }

    // Normalize the distance to the range [0, 1]
    float normalizedDistance = minDistance / length(vec2(800.0, 600.0)); // Adjust if your viewport size is different

    return normalizedDistance;
}

vec4 effect(vec4 vcolor, Image texture, vec2 texcoord, vec2 pixel_coords)
{
    // Number of points to use for cellular noise
    const int numPoints = 5;

    vec4 input0 = Texel(texture, texcoord);
        
    //exposure knee    
    input0 *= (exp2(input0)*vec4(exposure));
    
    vec4 lumacomponents = vec4(lumcoeff * lumacomponents, 0.0 );
    
    float luminance = dot(input0, lumacomponents);
    
    vec4 luma = vec4(luminance);

    // Calculate the cellular noise value for the current fragment
    float noiseValue = cellularNoise(pixel_coords, numPoints);

    // Darken and lighten the color based on the noise value
    vec3 color = luma.rgb * brightness * vec3(noiseValue); // Use the noise value to adjust the luma color

    return vec4(color, 1.0);
}
