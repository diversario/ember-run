//void main( void )
//{
//    float time = u_time * .5;
//    vec2 sp = gl_FragCoord.xy / size.xy;
//    vec2 p = sp * 6.0 - 20.0;
//    vec2 i = p;
//    float c = 1.0;
//    float inten = .05;
//    
//    for (int n = 0; n < 5; n++)
//    {
//        float t = time * (1.0 - (3.5 / float(n+1)));
//        i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
//        c += 1.0/length(vec2(p.x / (sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
//    }
//    
//    c /= float(5);
//    c = 1.55-sqrt(c);
//    vec3 colour = vec3(pow(abs(c), 15.0));
//    
//    gl_FragColor = vec4(clamp(colour + vec3(0.0, 0.17, 0.3), 0.0, .5), 0.3);
//}
//
//void main (void) {
//    vec2 st = gl_FragCoord.xy/size.xy;
//    float aspect = size.x/size.y;
//    st.x *= aspect;
//    
//    vec3 color = vec3(0.0);
//    color = vec3(st.x, st.y, (1.0+sin(u_time))*0.5);
//    
//    //if ( u_sprite_size != vec2(0.0) ) {
//    float imgAspect = u_sprite_size.x/u_sprite_size.y;
//    vec4 img = texture2D(u_texture, st*vec2(1.,imgAspect));
//    // color = img.rgb;
//    color = mix(color,img.rgb,img.a);
//    
//    float offset = smoothstep(0.0, 1.0, sin(st.y) * cos(u_time)) / 50.0;
//    color.r = texture2D(u_tex0, vec2(st.x + offset, st.y)).r;
//    
//    offset = smoothstep(0.0, 1.0, cos(st.y) * sin(u_time)) / 50.0;
//    color.g = texture2D(u_tex0, vec2(st.x + offset, st.y)).g;
//    
//    offset = smoothstep(0.0, 1.0, cos(st.y) + sin(u_time)) / 50.0;
//    color.b = texture2D(u_tex0, vec2(st.x + offset, st.y)).b;
//    //}
//    
//    gl_FragColor = vec4(color,1.0);
//}

//void main(void) {
//    vec2 st = gl_FragCoord.xy/size.xy;
//    float aspect = size.x/size.y;
//    //st.x *= aspect;
//    
//    vec3 color = vec3(0.0);
//    color = vec3(st.x, st.y, (1.0+sin(u_time))*0.5);
//    
//    //if ( u_sprite_size != vec2(0.0) ) {
//    float imgAspect = size.x/size.y;
//    vec4 img = texture2D(u_texture, st * vec2(1.0, aspect));
//    
//    color = mix(color,img.rgb,img.a);
//    
//    float offset = smoothstep(0.0, 1.0, sin(st.y) * cos(u_time)) / 50.0;
//    color.r = texture2D(u_texture, vec2(st.x + offset, st.y)).r;
//    //color = vec3(1.0);
//    gl_FragColor = vec4(color,1.0);
//}
//
void main(void) {
    vec2 st = v_tex_coord;

    vec3 color = vec3(0.0);
    //color = vec3(st.x, st.y, (1.0+sin(u_time))*0.5);

    //if ( u_sprite_size != vec2(0.0) ) {
//    float imgAspect = size.x/size.y;
    vec4 img = texture2D(u_texture, v_tex_coord);

    color = mix(color,img.rgb,img.a);

    float offset = smoothstep(0.0, 1.0, sin(st.y) * cos(u_time)) / 50.0;
    color.r = texture2D(u_texture, vec2(v_tex_coord.x + offset, v_tex_coord.y)).r;
    
    offset = smoothstep(0.0, 1.0, cos(st.y) * sin(u_time)) / 50.0;
    color.g = texture2D(u_texture, vec2(v_tex_coord.x - offset, v_tex_coord.y)).g;
    
    offset = smoothstep(0.0, 1.0, pow(sin(st.y) * cos(u_time), 5.0)) / 50.0;
    color.b = texture2D(u_texture, vec2(v_tex_coord.x + offset, v_tex_coord.y)).b;
    
    gl_FragColor = vec4(color,1.0);
}

//void main(void) {
//    vec2 st = gl_FragCoord.xy/size.xy;
//    
//    vec4 px = SKDefaultShading();
//    
//    px.r = texture2D(u_texture, vec2(0.9, 0.9)).g;
//    
//    gl_FragColor = vec4(0.4, 0.1, 0.8, 1.0);

//}

//void main() {
//    
//    vec4 sum = vec4(0.1, 0.3, 0.5, 1.0);
//    int j;
//    int i;
//    
//    for( i= -2 ;i < 2; i++) {
//        for (j = -2; j < 2; j++) {
//            sum += texture2D(u_texture, v_tex_coord + vec2(j, i)*0.004) * 0.25;
//        }
//    }
//    
//    if (texture2D(u_texture, v_tex_coord).r < 0.3) {
//        gl_FragColor = sum*sum*0.012 + texture2D(u_texture, v_tex_coord);
//    }
//    else {
//        if (texture2D(u_texture, v_tex_coord).r < 0.5) {
//            gl_FragColor = sum*sum*0.009 + texture2D(u_texture, v_tex_coord);
//        }
//        else {
//            gl_FragColor = sum*sum*0.0075 + texture2D(u_texture, v_tex_coord);
//        }
//    }
//}