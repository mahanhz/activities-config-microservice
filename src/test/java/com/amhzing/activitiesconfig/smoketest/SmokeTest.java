package com.amhzing.activitiesconfig.smoketest;

import com.amhzing.activitiesconfig.ActivitiesConfigApplication;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = ActivitiesConfigApplication.class)
public class SmokeTest {

    @Value("${server.base-uri}")
    private String baseUri;

    @Value("${management.port}")
    private int managementPort;

    @Value("${management.context-path}")
    private String managementContextPath;

    @Autowired
    private TestRestTemplate testRestTemplate;

    @Test
    public void healthStatus() {
        final ResponseEntity<Map> entity = testRestTemplate.getForEntity(getUrl(), Map.class);

        assertEquals(HttpStatus.OK, entity.getStatusCode());

        final Map body = entity.getBody();
        assertTrue(body.containsKey("status"));
        assertEquals(body.get("status"), "UP");
    }

    private String getUrl() {
        return baseUri + ":" + managementPort + "/" + managementContextPath + "/health";
    }
}