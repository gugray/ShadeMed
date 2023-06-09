float calcSoftshadow(vec3 ro, vec3 rd, float tmin, float tmax, float k)
{
    // https://iquilezles.org/articles/rmshadows
    float res = 1.0;
    float t = tmin;
    for (int i=0; i<50; i++)
    {
        float h = map(ro + rd*t).x;
        res = min(res, k*h/t);
        t += clamp(h, 0.02, 0.20);
        if (res<0.005 || t>tmax) break;
    }
    return clamp(res, 0.0, 1.0);
}

float diffuseIllumination(vec3 p, vec3 normal, vec3 eye) {
    vec3 dir = normalize(eye - p);
    return dot(normal, dir);
}

/**
 * Lighting contribution of a single point light source via Phong illumination.
 * The vec3 returned is the RGB color of the light's contribution.
 * k_a: Ambient color
 * k_d: Diffuse color
 * k_s: Specular color
 * alpha: Shininess coefficient
 * p: position of point being lit
 * eye: the position of the camera
 * lightPos: the position of the light
 * lightIntensity: color/intensity of the light
 */
vec3 phongContribForLight(vec3 k_d, vec3 k_s, float alpha, vec3 p, vec3 N, vec3 eye, vec3 lightPos, vec3 lightIntensity) {

    vec3 L = normalize(lightPos - p);
    vec3 V = normalize(eye - p);
    vec3 R = normalize(reflect(-L, N));

    float dotLN = dot(L, N);
    float dotRV = dot(R, V);

    if (dotLN < 0.0) {
        // Light not visible from this point on the surface
        return vec3(0.0, 0.0, 0.0);
    }

    if (dotRV < 0.0) {
        // Light reflection in opposite direction as viewer, apply only diffuse
        // component
        return lightIntensity * (k_d * dotLN);
    }
    return lightIntensity * (k_d * dotLN + k_s * pow(dotRV, alpha));
}

/**
 * Lighting via Phong illumination.
 * The vec3 returned is the RGB color of that point after lighting is applied.
 * k_a: Ambient color
 * k_d: Diffuse color
 * k_s: Specular color
 * alpha: Shininess coefficient
 * p: position of point being lit
 * eye: the position of the camera
 */
vec3 phongIllumination(vec3 k_a, vec3 k_d, vec3 k_s, float alpha, vec3 p, vec3 N, vec3 eye) {

    const vec3 ambientLight = 0.5 * vec3(1.0, 1.0, 1.0);
    vec3 color = ambientLight * k_a;

    float t = 8.;

    vec3 light1Pos = vec3(4.0 * sin(t), 2.0, 4.0 * cos(t));
    vec3 light1Intensity = vec3(0.4, 0.4, 0.4);
    color += phongContribForLight(k_d, k_s, alpha, p, N, eye, light1Pos, light1Intensity);

    vec3 light2Pos = vec3(2.0 * sin(0.37 * t), 2.0 * cos(0.37 * t), 2.0);
    vec3 light2Intensity = vec3(0.4, 0.4, 0.4);
    color += phongContribForLight(k_d, k_s, alpha, p, N, eye, light2Pos, light2Intensity);
    return color;
}
