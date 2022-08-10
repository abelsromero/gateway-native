package com.example.demo;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CustomConfiguration {

    @Bean
    FilterDefinitionConverter filterDefinitionConverter () {
        return new FilterDefinitionConverter();
    }
}
