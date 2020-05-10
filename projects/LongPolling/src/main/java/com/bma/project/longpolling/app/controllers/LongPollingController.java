package com.bma.project.longpolling.app.controllers;

import com.bma.project.longpolling.app.models.CustomMessage;
import com.bma.project.longpolling.app.models.GetMessage;
import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Log4j
@RestController
public class LongPollingController {

    private static final List<CustomMessage> messageStore = new ArrayList<>();

    @PostMapping("/sendMessage")
    public ResponseEntity<List<CustomMessage>> saveMessage(@RequestBody CustomMessage message) {
        log.debug(message);
        message.setId(messageStore.size() + 1);
        messageStore.add(message);
        return ResponseEntity.ok(messageStore);
    }

    @GetMapping("/getMessages")
    public ResponseEntity<List<CustomMessage>> getMessage(GetMessage input) throws InterruptedException {
        if (lastStoredMessage().isPresent() && lastStoredMessage().get().getId() > input.getId()) {
            List<CustomMessage> output = new ArrayList<>();
            for (int index = input.getId(); index < messageStore.size(); index++) {
                output.add(messageStore.get(index));
            }
            return ResponseEntity.ok(output);
        }

        return keepPolling(input);
    }

    private ResponseEntity<List<CustomMessage>> keepPolling(GetMessage input) throws InterruptedException {
        Thread.sleep(5000);
        HttpHeaders headers = new HttpHeaders();
        headers.setLocation(URI.create("/getMessages?id=" + input.getId() + "&to=" + input.getTo()));
        return new ResponseEntity<>(headers, HttpStatus.TEMPORARY_REDIRECT);
    }

    private Optional<CustomMessage> lastStoredMessage() {
        return messageStore.isEmpty() ? Optional.empty() : Optional.of(messageStore.get(messageStore.size()-1));
    }
}
