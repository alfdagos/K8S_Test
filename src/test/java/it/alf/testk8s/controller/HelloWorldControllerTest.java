package it.alf.testk8s.controller;

import org.junit.jupiter.api.Test;
import static org.mockito.Mockito.when;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import it.alf.testk8s.ConfigMapInfo;

@WebMvcTest(HelloWorldController.class)
@ActiveProfiles("test")
class HelloWorldControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private ConfigMapInfo configMapInfo;

    @Test
    void helloEndpoint_ShouldReturnGreeting() throws Exception {
        // Given
        when(configMapInfo.getName()).thenReturn("TestUser");

        // When & Then
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(content().string("Hello TestUser"));
    }

    @Test
    void helloEndpoint_ShouldHandleNullConfigMapName() throws Exception {
        // Given
        when(configMapInfo.getName()).thenReturn(null);

        // When & Then
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(content().string("Hello null"));
    }

    @Test
    void helloEndpoint_ShouldHandleEmptyConfigMapName() throws Exception {
        // Given
        when(configMapInfo.getName()).thenReturn("");

        // When & Then
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(content().string("Hello "));
    }
}