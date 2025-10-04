package com.github.stn1slv.example;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.rest.RestBindingMode;
import org.springframework.stereotype.Component;

@Component
public class MySimpleCamelRouter extends RouteBuilder {
    @Override
    public void configure() throws Exception {
        restConfiguration()
                .component("servlet")
                .bindingMode(RestBindingMode.json);

        rest().get("/hello").to("direct:hello");

        from("direct:hello")
                .log("Received GET /hello request")
                .setBody(constant("Hello, World!"));
    }
}