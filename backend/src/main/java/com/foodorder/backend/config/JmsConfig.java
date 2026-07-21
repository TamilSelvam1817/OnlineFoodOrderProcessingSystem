package com.foodorder.backend.config;

import jakarta.jms.ConnectionFactory;
import org.apache.activemq.ActiveMQConnectionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jms.annotation.EnableJms;
import org.springframework.jms.config.DefaultJmsListenerContainerFactory;
import org.springframework.jms.core.JmsTemplate;

/**
 * ActiveMQ JMS configuration.
 * Explicitly configures ConnectionFactory, JmsTemplate for publishing,
 * and DefaultJmsListenerContainerFactory for consuming with dynamic broker URL support.
 */
@Configuration
@EnableJms
public class JmsConfig {

    private static final Logger log = LoggerFactory.getLogger(JmsConfig.class);

    public static final String ORDER_CREATED_QUEUE = "order.created";

    @Value("${spring.activemq.broker-url:vm://localhost?broker.persistent=false&broker.useShutdownHook=false}")
    private String brokerUrl;

    @Value("${spring.activemq.user:admin}")
    private String username;

    @Value("${spring.activemq.password:admin}")
    private String password;

    @Bean
    public ConnectionFactory connectionFactory() {
        ActiveMQConnectionFactory connectionFactory = new ActiveMQConnectionFactory();
        connectionFactory.setBrokerURL(brokerUrl);
        if (username != null && !username.isBlank()) {
            connectionFactory.setUserName(username);
        }
        if (password != null && !password.isBlank()) {
            connectionFactory.setPassword(password);
        }
        connectionFactory.setTrustAllPackages(true);
        return connectionFactory;
    }

    @Bean
    public JmsTemplate jmsTemplate(ConnectionFactory connectionFactory) {
        JmsTemplate template = new JmsTemplate(connectionFactory);
        template.setDefaultDestinationName(ORDER_CREATED_QUEUE);
        template.setPubSubDomain(false); // Point-to-Point Queue
        return template;
    }

    @Bean
    public DefaultJmsListenerContainerFactory jmsListenerContainerFactory(ConnectionFactory connectionFactory) {
        DefaultJmsListenerContainerFactory factory = new DefaultJmsListenerContainerFactory();
        factory.setConnectionFactory(connectionFactory);
        factory.setConcurrency("1-3");
        factory.setPubSubDomain(false);
        factory.setErrorHandler(t -> log.error("[ActiveMQ Error] Message consumption error: {}", t.getMessage()));
        return factory;
    }
}
