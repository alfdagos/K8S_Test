package it.alf.testk8s.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {

    @Value("${name}")
    private String name;

    @RequestMapping("/")
    public String hello() {
        return "Hello "+name;
    }
}  