package it.alf.testk8s;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest
@ActiveProfiles("test")
@TestPropertySource(properties = {
    "k8s.configmap.name=TestConfigValue"
})
class ConfigMapInfoTest {

    @Autowired
    private ConfigMapInfo configMapInfo;

    @Test
    void configMapInfo_ShouldLoadFromProperties() {
        assertThat(configMapInfo).isNotNull();
        assertThat(configMapInfo.getName()).isEqualTo("TestConfigValue");
    }

    @Test
    void configMapInfo_ShouldHaveToStringMethod() {
        String result = configMapInfo.toString();
        assertThat(result).contains("TestConfigValue");
        assertThat(result).contains("AppInfo");
    }
}