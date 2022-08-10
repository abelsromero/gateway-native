package com.example.demo;

import org.springframework.cloud.gateway.filter.FilterDefinition;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;


public class FilterDefinitionConverter implements Converter<String, FilterDefinition> {
    @Override
    public FilterDefinition convert(String source) {
        return new FilterDefinition(source);
    }
}
