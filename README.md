# activities-config-microservice

Contains the properties for the activities related microservices.

This is a [Spring cloud config server](https://cloud.spring.io/spring-cloud-config/spring-cloud-config.html#_spring_cloud_config_server) which applications can use to access properties from an external git repository.
One can connect directly to the server or via service discovery.

Example via service discovery:

```
spring:
  application:
    name: participant-microservice
  cloud:
    config:
      discovery:
        enabled: true
        serviceId: activities-config-microservice
```
Where the __spring.application.name__ matches a folder in the external git repository.

Example direct usage:

```
spring:
  application:
    name: eureka-server-microservice
  cloud:
    config:
      uri: http://localhost:13301
      failFast: true
      retry:
        initialInterval: 5000
        maxInterval: 10000
        maxAttempts: 20
```
Where the __uri__ is the location of the cloud config server 

__NOTE:__ The config server microservice does not use a context-path as it's reduces complexity when accessing the config server via service discovery.
