package it.alf.testk8s.controller;

import it.alf.testk8s.ConfigMapInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {

    @Autowired
    ConfigMapInfo configMapInfo;

    @Value("${k8s.application.name}")
    private String name;

    @RequestMapping("/")
    public String hello() {
        return "Hello ConfigMap: "+ configMapInfo.getName()+
                "<br/>Hello Application.properties: "+name;
    }
}  