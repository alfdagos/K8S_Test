package it.alf.testk8s;


import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@PropertySource("classpath:configmap.properties")
@ConfigurationProperties(prefix = "k8s.configmap")
@Configuration("appInfo")
public class ConfigMapInfo {

    private String name;

    public ConfigMapInfo() {
    }

    public ConfigMapInfo(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "AppInfo{" +
                "name='" + name + '\'' +
                '}';
    }
}
