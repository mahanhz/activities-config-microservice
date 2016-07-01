package com.amhzing.activitiesconfig;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer
public class ActivitiesConfigApplication {

	public static void main(String[] args) {
		SpringApplication.run(ActivitiesConfigApplication.class, args);
	}
}
