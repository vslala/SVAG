package com.bma.project.longpolling.app.models;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class CustomMessage {
    private Integer id;
    private String from;
    private String to;
    private String msg;
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime createdAt;
}
