package com.bma.project.longpolling.app.controllers;

import com.bma.project.longpolling.app.models.CustomMessage;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class LongPollingControllerTest {

    @LocalServerPort
    private int port;

    @Bean
    @Primary
    public TestRestTemplate testRestTemplate() {
        return new TestRestTemplate(TestRestTemplate.HttpClientOption.ENABLE_REDIRECTS, TestRestTemplate.HttpClientOption.ENABLE_COOKIES);
    }

    @Autowired
    TestRestTemplate restTemplate;

    @Test
    public void itShouldSendMessageToTheServer() {
        CustomMessage message = new CustomMessage();
        message.setMsg("Test Message");
        message.setFrom("Foo");
        message.setTo("Bar");
        message.setCreatedAt(LocalDateTime.now());
        List<CustomMessage> response = restTemplate.postForObject(url("/sendMessage"), message, List.class);

        Assertions.assertEquals(1, response.size());
    }

    private String url(String path) {
        return String.format("http://localhost:%d/%s", port, path);
    }

    @Test
    public void itShouldPollTheServerUntilItGetsTheResponse() {
        Thread t1 = new Thread(() -> {
            try {
                Thread.sleep(10000);
                CustomMessage message = new CustomMessage();
                message.setMsg("Test Message");
                message.setFrom("Foo");
                message.setTo("Bar");
                message.setCreatedAt(LocalDateTime.now());
                System.out.println("Sending Message: " + message);
                restTemplate.postForObject(url("/sendMessage"), message, List.class);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        t1.start();
        List<CustomMessage> response = restTemplate.getForObject(url("/getMessages?id=0&to=Bar"), List.class);

        System.out.println("Response: " + response);

        assertEquals(1, response.size());
    }
}