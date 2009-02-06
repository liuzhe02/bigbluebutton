// Place your Spring DSL code here
beans = {

	jmsFactory(org.apache.activemq.pool.PooledConnectionFactory) { bean ->
		bean.destroyMethod = "stop"
		connectionFactory = {org.apache.activemq.ActiveMQConnectionFactory cf ->
			brokerURL = "tcp://localhost:61616"
		}
	}
	
	jmsTemplate(org.springframework.jms.core.JmsTemplate) {
		connectionFactory = jmsFactory
	}
	
	
//		   pbxLive(org.bigbluebutton.pbx.PbxLive) { bean ->
//			      bean.initMethod = "startup" 
//			      bean.destroyMethod = "shutdown"
//			      asteriskServer = ref("asteriskServer")
//		   }
			   
//		   asteriskServer(org.asteriskjava.live.DefaultAsteriskServer,
//					"192.168.0.101", "ralam", "secure") {}  		
}