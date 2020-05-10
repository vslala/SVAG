package com.bma.project.longpolling.app.models;

import lombok.Data;

@Data
public class GetMessage {
    private String to;
    private Integer id;
}
