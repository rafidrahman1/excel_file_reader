package com.example.excel.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Data
@NoArgsConstructor
@Entity
public class ExcelData {
    @Id
    private Long id;
    private String name;
    private String email;
    private String projectLink;


    public void setId(Long id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setProjectLink(String projectLink) {
        this.projectLink = projectLink;
    }
}