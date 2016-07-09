package com.amhzing.activitiesconfig;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@EnableConfigServer
public class ActivitiesConfigApplication {

	public static void main(String[] args) {
		SpringApplication.run(ActivitiesConfigApplication.class, args);
	}
}

@RestController
class PingController {

	@RequestMapping("/ping")
	final String getMessage() {
		return "Hi there! I'm awake!";
	}
}