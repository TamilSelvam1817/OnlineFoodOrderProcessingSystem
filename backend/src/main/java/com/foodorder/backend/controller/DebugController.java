package com.foodorder.backend.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class DebugController {

    @GetMapping("/debug")
    public Map<String, String> debug(HttpServletRequest request) {

        Map<String, String> map = new HashMap<>();

        map.put("scheme", request.getScheme());
        map.put("serverName", request.getServerName());
        map.put("serverPort", String.valueOf(request.getServerPort()));
        map.put("requestURL", request.getRequestURL().toString());
        map.put("x-forwarded-proto", request.getHeader("X-Forwarded-Proto"));
        map.put("forwarded", request.getHeader("Forwarded"));

        return map;
    }
}
