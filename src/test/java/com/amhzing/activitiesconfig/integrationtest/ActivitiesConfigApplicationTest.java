package com.amhzing.activitiesconfig.integrationtest;

import com.amhzing.activitiesconfig.ActivitiesConfigApplication;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.boot.test.TestRestTemplate;
import org.springframework.boot.test.WebIntegrationTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import java.util.Map;

import static org.junit.Assert.assertEquals;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = ActivitiesConfigApplication.class)
@WebIntegrationTest({"server.port=0", "management.port=0"})
public class ActivitiesConfigApplicationTest {

    @Value("${local.server.port}")
    private int port = 0;

    @Value("${local.management.port}")
    private int managementPort = 0;

    @Test
    public void configurationAvailable() {
        final ResponseEntity<Map> entity = new TestRestTemplate().getForEntity(
                "http://localhost:" + port + "/app/default", Map.class);

        assertEquals(HttpStatus.OK, entity.getStatusCode());
    }

    @Test
    public void managementAvailable() {
        ResponseEntity<Map> entity = new TestRestTemplate().getForEntity(
                "http://localhost:" + managementPort + "/manage", Map.class);

        assertEquals(HttpStatus.OK, entity.getStatusCode());
    }

    @Test
    public void envPostAvailable() {
        final MultiValueMap<String, String> form = new LinkedMultiValueMap<String, String>();
        final ResponseEntity<Map> entity = new TestRestTemplate().postForEntity(
                "http://localhost:" + managementPort + "/manage/env", form, Map.class);

        assertEquals(HttpStatus.OK, entity.getStatusCode());
    }
}