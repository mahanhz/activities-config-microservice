package com.amhzing.activitiesconfig.integrationtest;

import com.amhzing.activitiesconfig.ActivitiesConfigApplication;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.actuate.autoconfigure.LocalManagementPort;
import org.springframework.boot.context.embedded.LocalServerPort;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.springframework.boot.test.context.SpringBootTest.WebEnvironment;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = ActivitiesConfigApplication.class,
                webEnvironment = WebEnvironment.RANDOM_PORT)
public class ActivitiesConfigApplicationTest {

    @LocalServerPort
    private int port = 0;

    @LocalManagementPort
    private int managementPort = 0;

    @Value("${management.context-path}")
    private String managementContextPath;

    @Autowired
    private TestRestTemplate testRestTemplate;

    @Test
    public void configurationAvailable() {
        final ResponseEntity<String> entity = testRestTemplate.getForEntity(
                "http://localhost:" + port + "/config-message", String.class);

        assertEquals(HttpStatus.OK, entity.getStatusCode());
    }

    @Test
    public void managementAvailable() {
        ResponseEntity<Map> entity = testRestTemplate.getForEntity(
                "http://localhost:" + managementPort + managementContextPath, Map.class);

        assertEquals(HttpStatus.OK, entity.getStatusCode());
    }

    @Test
    public void envPostAvailable() {
        final MultiValueMap<String, String> form = new LinkedMultiValueMap<String, String>();
        final ResponseEntity<Map> entity = testRestTemplate.postForEntity(
                "http://localhost:" + managementPort + managementContextPath + "/env", form, Map.class);

        assertEquals(HttpStatus.OK, entity.getStatusCode());
    }
}