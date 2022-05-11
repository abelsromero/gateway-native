package com.example.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import reactor.core.publisher.Mono;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import static org.springframework.http.HttpMethod.GET;
import static org.springframework.http.HttpMethod.POST;

@Configuration
public class RouteConfiguration {

	private static final Logger logger = LoggerFactory.getLogger(RouteConfiguration.class);

	@Bean
	public RouteLocator routes(RouteLocatorBuilder builder) {
		return builder.routes()
					  .route("rewrite_response_body", route -> route
							  .path("/body/**")
							  .and()
							  .method(GET, POST)
							  .filters(filterSpec -> filterSpec
									  .stripPrefix(1)
									  .modifyResponseBody(String.class, String.class,
											  (exchange, body) -> {
												  logger.debug(body);
												  return Mono.just(body.toUpperCase());
											  })).uri("http://perf-upstream-api-svc.test.svc"))
					  .build();
	}
}
