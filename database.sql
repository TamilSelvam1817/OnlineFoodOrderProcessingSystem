CREATE DATABASE  IF NOT EXISTS `foodorderdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `foodorderdb`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: foodorderdb
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `act_ge_bytearray`
--

DROP TABLE IF EXISTS `act_ge_bytearray`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ge_bytearray` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `BYTES_` longblob,
  `GENERATED_` tinyint DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` int DEFAULT NULL,
  `CREATE_TIME_` datetime DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_BYTEARR_DEPL` (`DEPLOYMENT_ID_`),
  KEY `ACT_IDX_BYTEARRAY_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_BYTEARRAY_RM_TIME` (`REMOVAL_TIME_`),
  KEY `ACT_IDX_BYTEARRAY_NAME` (`NAME_`),
  CONSTRAINT `ACT_FK_BYTEARR_DEPL` FOREIGN KEY (`DEPLOYMENT_ID_`) REFERENCES `act_re_deployment` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ge_bytearray`
--

LOCK TABLES `act_ge_bytearray` WRITE;
/*!40000 ALTER TABLE `act_ge_bytearray` DISABLE KEYS */;
INSERT INTO `act_ge_bytearray` VALUES ('6a39aa99-8337-11f1-92f8-94bb4319796b',1,'C:\\Users\\Tamil Selvam\\Downloads\\OnlineFoodOrderProcessingSystem\\backend\\target\\classes\\order-processing.bpmn','6a390e58-8337-11f1-92f8-94bb4319796b',_binary '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<bpmn:definitions xmlns:bpmn=\"http://www.omg.org/spec/BPMN/20100524/MODEL\"\n                  xmlns:bpmndi=\"http://www.omg.org/spec/BPMN/20100524/DI\"\n                  xmlns:dc=\"http://www.omg.org/spec/DD/20100524/DC\"\n                  xmlns:di=\"http://www.omg.org/spec/DD/20100524/DI\"\n                  xmlns:camunda=\"http://camunda.org/schema/1.0/bpmn\"\n                  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n                  id=\"Definitions_1\"\n                  targetNamespace=\"http://bpmn.io/schema/bpmn\">\n\n  <bpmn:process id=\"orderProcessing\" name=\"Order Processing Workflow\" isExecutable=\"true\">\n\n    <!-- Start Event -->\n    <bpmn:startEvent id=\"StartEvent_OrderPlaced\" name=\"Order Placed\">\n      <bpmn:outgoing>Flow_ToPayment</bpmn:outgoing>\n    </bpmn:startEvent>\n\n    <!-- Service Task 1: Process Payment -->\n    <bpmn:serviceTask id=\"Task_ProcessPayment\" name=\"Process Payment\"\n                      camunda:delegateExpression=\"${paymentService}\">\n      <bpmn:incoming>Flow_ToPayment</bpmn:incoming>\n      <bpmn:outgoing>Flow_ToGateway</bpmn:outgoing>\n    </bpmn:serviceTask>\n\n    <!-- Exclusive Gateway: Check Payment Result -->\n    <bpmn:exclusiveGateway id=\"Gateway_PaymentCheck\" name=\"Payment Successful?\">\n      <bpmn:incoming>Flow_ToGateway</bpmn:incoming>\n      <bpmn:outgoing>Flow_PaymentSuccess</bpmn:outgoing>\n      <bpmn:outgoing>Flow_PaymentFailed</bpmn:outgoing>\n    </bpmn:exclusiveGateway>\n\n    <!-- Service Task 2: Kitchen Preparation (Success Path) -->\n    <bpmn:serviceTask id=\"Task_KitchenPrep\" name=\"Kitchen Preparation\"\n                      camunda:delegateExpression=\"${kitchenService}\">\n      <bpmn:incoming>Flow_PaymentSuccess</bpmn:incoming>\n      <bpmn:outgoing>Flow_ToDelivery</bpmn:outgoing>\n    </bpmn:serviceTask>\n\n    <!-- Service Task 3: Delivery -->\n    <bpmn:serviceTask id=\"Task_Delivery\" name=\"Delivery\"\n                      camunda:delegateExpression=\"${deliveryService}\">\n      <bpmn:incoming>Flow_ToDelivery</bpmn:incoming>\n      <bpmn:outgoing>Flow_ToDelivered</bpmn:outgoing>\n    </bpmn:serviceTask>\n\n    <!-- Service Task 4: Mark Order Delivered -->\n    <bpmn:serviceTask id=\"Task_OrderDelivered\" name=\"Mark Order Delivered\"\n                      camunda:delegateExpression=\"${orderDeliveredDelegate}\">\n      <bpmn:incoming>Flow_ToDelivered</bpmn:incoming>\n      <bpmn:outgoing>Flow_ToEndSuccess</bpmn:outgoing>\n    </bpmn:serviceTask>\n\n    <!-- Service Task 5: Cancel Order (Failure Path) -->\n    <bpmn:serviceTask id=\"Task_CancelOrder\" name=\"Cancel Order\"\n                      camunda:delegateExpression=\"${orderCancelledDelegate}\">\n      <bpmn:incoming>Flow_PaymentFailed</bpmn:incoming>\n      <bpmn:outgoing>Flow_ToEndFailed</bpmn:outgoing>\n    </bpmn:serviceTask>\n\n    <!-- End Events -->\n    <bpmn:endEvent id=\"EndEvent_Success\" name=\"Order Delivered\">\n      <bpmn:incoming>Flow_ToEndSuccess</bpmn:incoming>\n    </bpmn:endEvent>\n\n    <bpmn:endEvent id=\"EndEvent_Cancelled\" name=\"Order Cancelled\">\n      <bpmn:incoming>Flow_ToEndFailed</bpmn:incoming>\n    </bpmn:endEvent>\n\n    <!-- Sequence Flows -->\n    <bpmn:sequenceFlow id=\"Flow_ToPayment\" sourceRef=\"StartEvent_OrderPlaced\" targetRef=\"Task_ProcessPayment\" />\n    <bpmn:sequenceFlow id=\"Flow_ToGateway\" sourceRef=\"Task_ProcessPayment\" targetRef=\"Gateway_PaymentCheck\" />\n\n    <bpmn:sequenceFlow id=\"Flow_PaymentSuccess\" name=\"Yes\" sourceRef=\"Gateway_PaymentCheck\" targetRef=\"Task_KitchenPrep\">\n      <bpmn:conditionExpression xsi:type=\"bpmn:tFormalExpression\">${paymentSuccess == true}</bpmn:conditionExpression>\n    </bpmn:sequenceFlow>\n\n    <bpmn:sequenceFlow id=\"Flow_PaymentFailed\" name=\"No\" sourceRef=\"Gateway_PaymentCheck\" targetRef=\"Task_CancelOrder\">\n      <bpmn:conditionExpression xsi:type=\"bpmn:tFormalExpression\">${paymentSuccess == false}</bpmn:conditionExpression>\n    </bpmn:sequenceFlow>\n\n    <bpmn:sequenceFlow id=\"Flow_ToDelivery\" sourceRef=\"Task_KitchenPrep\" targetRef=\"Task_Delivery\" />\n    <bpmn:sequenceFlow id=\"Flow_ToDelivered\" sourceRef=\"Task_Delivery\" targetRef=\"Task_OrderDelivered\" />\n    <bpmn:sequenceFlow id=\"Flow_ToEndSuccess\" sourceRef=\"Task_OrderDelivered\" targetRef=\"EndEvent_Success\" />\n    <bpmn:sequenceFlow id=\"Flow_ToEndFailed\" sourceRef=\"Task_CancelOrder\" targetRef=\"EndEvent_Cancelled\" />\n\n  </bpmn:process>\n\n  <!-- BPMN Diagram (Layout) -->\n  <bpmndi:BPMNDiagram id=\"BPMNDiagram_1\">\n    <bpmndi:BPMNPlane id=\"BPMNPlane_1\" bpmnElement=\"orderProcessing\">\n\n      <bpmndi:BPMNShape id=\"_BPMNShape_StartEvent\" bpmnElement=\"StartEvent_OrderPlaced\">\n        <dc:Bounds x=\"179\" y=\"259\" width=\"36\" height=\"36\" />\n      </bpmndi:BPMNShape>\n\n      <bpmndi:BPMNShape id=\"Activity_Payment_di\" bpmnElement=\"Task_ProcessPayment\">\n        <dc:Bounds x=\"270\" y=\"237\" width=\"100\" height=\"80\" />\n      </bpmndi:BPMNShape>\n\n      <bpmndi:BPMNShape id=\"Gateway_di\" bpmnElement=\"Gateway_PaymentCheck\" isMarkerVisible=\"true\">\n        <dc:Bounds x=\"425\" y=\"252\" width=\"50\" height=\"50\" />\n      </bpmndi:BPMNShape>\n\n      <bpmndi:BPMNShape id=\"Activity_Kitchen_di\" bpmnElement=\"Task_KitchenPrep\">\n        <dc:Bounds x=\"530\" y=\"237\" width=\"100\" height=\"80\" />\n      </bpmndi:BPMNShape>\n\n      <bpmndi:BPMNShape id=\"Activity_Delivery_di\" bpmnElement=\"Task_Delivery\">\n        <dc:Bounds x=\"690\" y=\"237\" width=\"100\" height=\"80\" />\n      </bpmndi:BPMNShape>\n\n      <bpmndi:BPMNShape id=\"Activity_Delivered_di\" bpmnElement=\"Task_OrderDelivered\">\n        <dc:Bounds x=\"850\" y=\"237\" width=\"100\" height=\"80\" />\n      </bpmndi:BPMNShape>\n\n      <bpmndi:BPMNShape id=\"Activity_Cancel_di\" bpmnElement=\"Task_CancelOrder\">\n        <dc:Bounds x=\"530\" y=\"380\" width=\"100\" height=\"80\" />\n      </bpmndi:BPMNShape>\n\n      <bpmndi:BPMNShape id=\"Event_EndSuccess_di\" bpmnElement=\"EndEvent_Success\">\n        <dc:Bounds x=\"1012\" y=\"259\" width=\"36\" height=\"36\" />\n      </bpmndi:BPMNShape>\n\n      <bpmndi:BPMNShape id=\"Event_EndCancelled_di\" bpmnElement=\"EndEvent_Cancelled\">\n        <dc:Bounds x=\"692\" y=\"402\" width=\"36\" height=\"36\" />\n      </bpmndi:BPMNShape>\n\n      <bpmndi:BPMNEdge id=\"Flow_ToPayment_di\" bpmnElement=\"Flow_ToPayment\">\n        <di:waypoint x=\"215\" y=\"277\" />\n        <di:waypoint x=\"270\" y=\"277\" />\n      </bpmndi:BPMNEdge>\n\n      <bpmndi:BPMNEdge id=\"Flow_ToGateway_di\" bpmnElement=\"Flow_ToGateway\">\n        <di:waypoint x=\"370\" y=\"277\" />\n        <di:waypoint x=\"425\" y=\"277\" />\n      </bpmndi:BPMNEdge>\n\n      <bpmndi:BPMNEdge id=\"Flow_PaymentSuccess_di\" bpmnElement=\"Flow_PaymentSuccess\">\n        <di:waypoint x=\"475\" y=\"277\" />\n        <di:waypoint x=\"530\" y=\"277\" />\n      </bpmndi:BPMNEdge>\n\n      <bpmndi:BPMNEdge id=\"Flow_PaymentFailed_di\" bpmnElement=\"Flow_PaymentFailed\">\n        <di:waypoint x=\"450\" y=\"302\" />\n        <di:waypoint x=\"450\" y=\"420\" />\n        <di:waypoint x=\"530\" y=\"420\" />\n      </bpmndi:BPMNEdge>\n\n      <bpmndi:BPMNEdge id=\"Flow_ToDelivery_di\" bpmnElement=\"Flow_ToDelivery\">\n        <di:waypoint x=\"630\" y=\"277\" />\n        <di:waypoint x=\"690\" y=\"277\" />\n      </bpmndi:BPMNEdge>\n\n      <bpmndi:BPMNEdge id=\"Flow_ToDelivered_di\" bpmnElement=\"Flow_ToDelivered\">\n        <di:waypoint x=\"790\" y=\"277\" />\n        <di:waypoint x=\"850\" y=\"277\" />\n      </bpmndi:BPMNEdge>\n\n      <bpmndi:BPMNEdge id=\"Flow_ToEndSuccess_di\" bpmnElement=\"Flow_ToEndSuccess\">\n        <di:waypoint x=\"950\" y=\"277\" />\n        <di:waypoint x=\"1012\" y=\"277\" />\n      </bpmndi:BPMNEdge>\n\n      <bpmndi:BPMNEdge id=\"Flow_ToEndFailed_di\" bpmnElement=\"Flow_ToEndFailed\">\n        <di:waypoint x=\"630\" y=\"420\" />\n        <di:waypoint x=\"692\" y=\"420\" />\n      </bpmndi:BPMNEdge>\n\n    </bpmndi:BPMNPlane>\n  </bpmndi:BPMNDiagram>\n</bpmn:definitions>\n',0,NULL,1,'2026-07-19 11:32:25',NULL,NULL);
/*!40000 ALTER TABLE `act_ge_bytearray` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ge_property`
--

DROP TABLE IF EXISTS `act_ge_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ge_property` (
  `NAME_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `VALUE_` varchar(300) COLLATE utf8mb3_bin DEFAULT NULL,
  `REV_` int DEFAULT NULL,
  PRIMARY KEY (`NAME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ge_property`
--

LOCK TABLES `act_ge_property` WRITE;
/*!40000 ALTER TABLE `act_ge_property` DISABLE KEYS */;
INSERT INTO `act_ge_property` VALUES ('camunda.installation.id','f767459d-04bb-41a6-81e6-ea173681e6d9',1),('camunda.telemetry.enabled','false',1),('deployment.lock','0',1),('history.cleanup.job.lock','0',1),('historyLevel','3',1),('installationId.lock','0',1),('next.dbid','1',1),('schema.history','create(fox)',1),('schema.version','fox',1),('startup.lock','0',1),('telemetry.lock','0',1);
/*!40000 ALTER TABLE `act_ge_property` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ge_schema_log`
--

DROP TABLE IF EXISTS `act_ge_schema_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ge_schema_log` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `TIMESTAMP_` datetime DEFAULT NULL,
  `VERSION_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ge_schema_log`
--

LOCK TABLES `act_ge_schema_log` WRITE;
/*!40000 ALTER TABLE `act_ge_schema_log` DISABLE KEYS */;
INSERT INTO `act_ge_schema_log` VALUES ('0','2026-07-19 11:30:02','7.21.0');
/*!40000 ALTER TABLE `act_ge_schema_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_actinst`
--

DROP TABLE IF EXISTS `act_hi_actinst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_actinst` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `PARENT_ACT_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CALL_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CALL_CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_TYPE_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `ASSIGNEE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `START_TIME_` datetime NOT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint DEFAULT NULL,
  `ACT_INST_STATE_` int DEFAULT NULL,
  `SEQUENCE_COUNTER_` bigint DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_ACTINST_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_ACT_INST_START_END` (`START_TIME_`,`END_TIME_`),
  KEY `ACT_IDX_HI_ACT_INST_END` (`END_TIME_`),
  KEY `ACT_IDX_HI_ACT_INST_PROCINST` (`PROC_INST_ID_`,`ACT_ID_`),
  KEY `ACT_IDX_HI_ACT_INST_COMP` (`EXECUTION_ID_`,`ACT_ID_`,`END_TIME_`,`ID_`),
  KEY `ACT_IDX_HI_ACT_INST_STATS` (`PROC_DEF_ID_`,`PROC_INST_ID_`,`ACT_ID_`,`END_TIME_`,`ACT_INST_STATE_`),
  KEY `ACT_IDX_HI_ACT_INST_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_HI_ACT_INST_PROC_DEF_KEY` (`PROC_DEF_KEY_`),
  KEY `ACT_IDX_HI_AI_PDEFID_END_TIME` (`PROC_DEF_ID_`,`END_TIME_`),
  KEY `ACT_IDX_HI_ACT_INST_RM_TIME` (`REMOVAL_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_actinst`
--

LOCK TABLES `act_hi_actinst` WRITE;
/*!40000 ALTER TABLE `act_hi_actinst` DISABLE KEYS */;
INSERT INTO `act_hi_actinst` VALUES ('EndEvent_Success:090e6dcc-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','EndEvent_Success',NULL,NULL,NULL,'Order Delivered','noneEndEvent',NULL,'2026-07-21 08:34:49','2026-07-21 08:34:49',1,1,13,NULL,NULL),('EndEvent_Success:3d4d7c51-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','EndEvent_Success',NULL,NULL,NULL,'Order Delivered','noneEndEvent',NULL,'2026-07-21 07:10:23','2026-07-21 07:10:23',1,1,13,NULL,NULL),('EndEvent_Success:946a76d3-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','EndEvent_Success',NULL,NULL,NULL,'Order Delivered','noneEndEvent',NULL,'2026-07-21 12:49:15','2026-07-21 12:49:15',1,1,13,NULL,NULL),('EndEvent_Success:ba20b343-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','EndEvent_Success',NULL,NULL,NULL,'Order Delivered','noneEndEvent',NULL,'2026-07-21 12:50:18','2026-07-21 12:50:18',0,1,13,NULL,NULL),('Gateway_PaymentCheck:090a00f4-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','Gateway_PaymentCheck',NULL,NULL,NULL,'Payment Successful?','exclusiveGateway',NULL,'2026-07-21 08:34:49','2026-07-21 08:34:49',3,4,5,NULL,NULL),('Gateway_PaymentCheck:3d46ec99-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','Gateway_PaymentCheck',NULL,NULL,NULL,'Payment Successful?','exclusiveGateway',NULL,'2026-07-21 07:10:23','2026-07-21 07:10:23',3,4,5,NULL,NULL),('Gateway_PaymentCheck:94645c4b-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','Gateway_PaymentCheck',NULL,NULL,NULL,'Payment Successful?','exclusiveGateway',NULL,'2026-07-21 12:49:15','2026-07-21 12:49:15',1,4,5,NULL,NULL),('Gateway_PaymentCheck:ba19121b-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','Gateway_PaymentCheck',NULL,NULL,NULL,'Payment Successful?','exclusiveGateway',NULL,'2026-07-21 12:50:18','2026-07-21 12:50:18',1,4,5,NULL,NULL),('StartEvent_OrderPlaced:09032320-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','StartEvent_OrderPlaced',NULL,NULL,NULL,'Order Placed','startEvent',NULL,'2026-07-21 08:34:49','2026-07-21 08:34:49',11,4,1,NULL,NULL),('StartEvent_OrderPlaced:3d4035d5-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','StartEvent_OrderPlaced',NULL,NULL,NULL,'Order Placed','startEvent',NULL,'2026-07-21 07:10:23','2026-07-21 07:10:23',6,4,1,NULL,NULL),('StartEvent_OrderPlaced:945bf7d7-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','StartEvent_OrderPlaced',NULL,NULL,NULL,'Order Placed','startEvent',NULL,'2026-07-21 12:49:15','2026-07-21 12:49:15',9,4,1,NULL,NULL),('StartEvent_OrderPlaced:b9fdc1e7-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','StartEvent_OrderPlaced',NULL,NULL,NULL,'Order Placed','startEvent',NULL,'2026-07-21 12:50:18','2026-07-21 12:50:18',1,4,1,NULL,NULL),('Task_Delivery:090c4ae8-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','Task_Delivery',NULL,NULL,NULL,'Delivery','serviceTask',NULL,'2026-07-21 08:34:49','2026-07-21 08:34:49',10,4,9,NULL,NULL),('Task_Delivery:3d4a20ed-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','Task_Delivery',NULL,NULL,NULL,'Delivery','serviceTask',NULL,'2026-07-21 07:10:23','2026-07-21 07:10:23',14,4,9,NULL,NULL),('Task_Delivery:9466a63f-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','Task_Delivery',NULL,NULL,NULL,'Delivery','serviceTask',NULL,'2026-07-21 12:49:15','2026-07-21 12:49:15',9,4,9,NULL,NULL),('Task_Delivery:ba1b0def-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','Task_Delivery',NULL,NULL,NULL,'Delivery','serviceTask',NULL,'2026-07-21 12:50:18','2026-07-21 12:50:18',20,4,9,NULL,NULL),('Task_KitchenPrep:090a9d35-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','Task_KitchenPrep',NULL,NULL,NULL,'Kitchen Preparation','serviceTask',NULL,'2026-07-21 08:34:49','2026-07-21 08:34:49',9,4,7,NULL,NULL),('Task_KitchenPrep:3d4788da-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','Task_KitchenPrep',NULL,NULL,NULL,'Kitchen Preparation','serviceTask',NULL,'2026-07-21 07:10:23','2026-07-21 07:10:23',16,4,7,NULL,NULL),('Task_KitchenPrep:9464aa6c-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','Task_KitchenPrep',NULL,NULL,NULL,'Kitchen Preparation','serviceTask',NULL,'2026-07-21 12:49:15','2026-07-21 12:49:15',11,4,7,NULL,NULL),('Task_KitchenPrep:ba19603c-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','Task_KitchenPrep',NULL,NULL,NULL,'Kitchen Preparation','serviceTask',NULL,'2026-07-21 12:50:18','2026-07-21 12:50:18',9,4,7,NULL,NULL),('Task_OrderDelivered:090df89b-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','Task_OrderDelivered',NULL,NULL,NULL,'Mark Order Delivered','serviceTask',NULL,'2026-07-21 08:34:49','2026-07-21 08:34:49',2,4,11,NULL,NULL),('Task_OrderDelivered:3d4c6ae0-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','Task_OrderDelivered',NULL,NULL,NULL,'Mark Order Delivered','serviceTask',NULL,'2026-07-21 07:10:23','2026-07-21 07:10:23',5,4,11,NULL,NULL),('Task_OrderDelivered:946805d2-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','Task_OrderDelivered',NULL,NULL,NULL,'Mark Order Delivered','serviceTask',NULL,'2026-07-21 12:49:15','2026-07-21 12:49:15',16,4,11,NULL,NULL),('Task_OrderDelivered:ba1e6952-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','Task_OrderDelivered',NULL,NULL,NULL,'Mark Order Delivered','serviceTask',NULL,'2026-07-21 12:50:18','2026-07-21 12:50:18',13,4,11,NULL,NULL),('Task_ProcessPayment:09054601-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','Task_ProcessPayment',NULL,NULL,NULL,'Process Payment','serviceTask',NULL,'2026-07-21 08:34:49','2026-07-21 08:34:49',30,4,3,NULL,NULL),('Task_ProcessPayment:3d416e56-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','Task_ProcessPayment',NULL,NULL,NULL,'Process Payment','serviceTask',NULL,'2026-07-21 07:10:23','2026-07-21 07:10:23',33,4,3,NULL,NULL),('Task_ProcessPayment:945dcc98-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','Task_ProcessPayment',NULL,NULL,NULL,'Process Payment','serviceTask',NULL,'2026-07-21 12:49:15','2026-07-21 12:49:15',42,4,3,NULL,NULL),('Task_ProcessPayment:b9fde8f8-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','Task_ProcessPayment',NULL,NULL,NULL,'Process Payment','serviceTask',NULL,'2026-07-21 12:50:18','2026-07-21 12:50:18',177,4,3,NULL,NULL);
/*!40000 ALTER TABLE `act_hi_actinst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_attachment`
--

DROP TABLE IF EXISTS `act_hi_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_attachment` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `URL_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `CONTENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_ATTACHMENT_CONTENT` (`CONTENT_ID_`),
  KEY `ACT_IDX_HI_ATTACHMENT_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_ATTACHMENT_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_ATTACHMENT_TASK` (`TASK_ID_`),
  KEY `ACT_IDX_HI_ATTACHMENT_RM_TIME` (`REMOVAL_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_attachment`
--

LOCK TABLES `act_hi_attachment` WRITE;
/*!40000 ALTER TABLE `act_hi_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_batch`
--

DROP TABLE IF EXISTS `act_hi_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_batch` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TOTAL_JOBS_` int DEFAULT NULL,
  `JOBS_PER_SEED_` int DEFAULT NULL,
  `INVOCATIONS_PER_JOB_` int DEFAULT NULL,
  `SEED_JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `MONITOR_JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `BATCH_JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `START_TIME_` datetime NOT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  `EXEC_START_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_HI_BAT_RM_TIME` (`REMOVAL_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_batch`
--

LOCK TABLES `act_hi_batch` WRITE;
/*!40000 ALTER TABLE `act_hi_batch` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_caseactinst`
--

DROP TABLE IF EXISTS `act_hi_caseactinst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_caseactinst` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `PARENT_ACT_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `CASE_ACT_ID_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CALL_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CALL_CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_ACT_NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_ACT_TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime NOT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint DEFAULT NULL,
  `STATE_` int DEFAULT NULL,
  `REQUIRED_` tinyint(1) DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_CAS_A_I_CREATE` (`CREATE_TIME_`),
  KEY `ACT_IDX_HI_CAS_A_I_END` (`END_TIME_`),
  KEY `ACT_IDX_HI_CAS_A_I_COMP` (`CASE_ACT_ID_`,`END_TIME_`,`ID_`),
  KEY `ACT_IDX_HI_CAS_A_I_CASEINST` (`CASE_INST_ID_`,`CASE_ACT_ID_`),
  KEY `ACT_IDX_HI_CAS_A_I_TENANT_ID` (`TENANT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_caseactinst`
--

LOCK TABLES `act_hi_caseactinst` WRITE;
/*!40000 ALTER TABLE `act_hi_caseactinst` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_caseactinst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_caseinst`
--

DROP TABLE IF EXISTS `act_hi_caseinst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_caseinst` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `BUSINESS_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `CREATE_TIME_` datetime NOT NULL,
  `CLOSE_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint DEFAULT NULL,
  `STATE_` int DEFAULT NULL,
  `CREATE_USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUPER_CASE_INSTANCE_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUPER_PROCESS_INSTANCE_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `CASE_INST_ID_` (`CASE_INST_ID_`),
  KEY `ACT_IDX_HI_CAS_I_CLOSE` (`CLOSE_TIME_`),
  KEY `ACT_IDX_HI_CAS_I_BUSKEY` (`BUSINESS_KEY_`),
  KEY `ACT_IDX_HI_CAS_I_TENANT_ID` (`TENANT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_caseinst`
--

LOCK TABLES `act_hi_caseinst` WRITE;
/*!40000 ALTER TABLE `act_hi_caseinst` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_caseinst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_comment`
--

DROP TABLE IF EXISTS `act_hi_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_comment` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TIME_` datetime NOT NULL,
  `USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACTION_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `MESSAGE_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `FULL_MSG_` longblob,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_COMMENT_TASK` (`TASK_ID_`),
  KEY `ACT_IDX_HI_COMMENT_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_COMMENT_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_COMMENT_RM_TIME` (`REMOVAL_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_comment`
--

LOCK TABLES `act_hi_comment` WRITE;
/*!40000 ALTER TABLE `act_hi_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_dec_in`
--

DROP TABLE IF EXISTS `act_hi_dec_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_dec_in` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `DEC_INST_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `CLAUSE_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CLAUSE_NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `VAR_TYPE_` varchar(100) COLLATE utf8mb3_bin DEFAULT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_DEC_IN_INST` (`DEC_INST_ID_`),
  KEY `ACT_IDX_HI_DEC_IN_CLAUSE` (`DEC_INST_ID_`,`CLAUSE_ID_`),
  KEY `ACT_IDX_HI_DEC_IN_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_DEC_IN_RM_TIME` (`REMOVAL_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_dec_in`
--

LOCK TABLES `act_hi_dec_in` WRITE;
/*!40000 ALTER TABLE `act_hi_dec_in` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_dec_in` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_dec_out`
--

DROP TABLE IF EXISTS `act_hi_dec_out`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_dec_out` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `DEC_INST_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `CLAUSE_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CLAUSE_NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `RULE_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `RULE_ORDER_` int DEFAULT NULL,
  `VAR_NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `VAR_TYPE_` varchar(100) COLLATE utf8mb3_bin DEFAULT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_DEC_OUT_INST` (`DEC_INST_ID_`),
  KEY `ACT_IDX_HI_DEC_OUT_RULE` (`RULE_ORDER_`,`CLAUSE_ID_`),
  KEY `ACT_IDX_HI_DEC_OUT_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_DEC_OUT_RM_TIME` (`REMOVAL_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_dec_out`
--

LOCK TABLES `act_hi_dec_out` WRITE;
/*!40000 ALTER TABLE `act_hi_dec_out` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_dec_out` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_decinst`
--

DROP TABLE IF EXISTS `act_hi_decinst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_decinst` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `DEC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `DEC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `DEC_DEF_NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `EVAL_TIME_` datetime NOT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  `COLLECT_VALUE_` double DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_DEC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DEC_REQ_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DEC_REQ_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_DEC_INST_ID` (`DEC_DEF_ID_`),
  KEY `ACT_IDX_HI_DEC_INST_KEY` (`DEC_DEF_KEY_`),
  KEY `ACT_IDX_HI_DEC_INST_PI` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_DEC_INST_CI` (`CASE_INST_ID_`),
  KEY `ACT_IDX_HI_DEC_INST_ACT` (`ACT_ID_`),
  KEY `ACT_IDX_HI_DEC_INST_ACT_INST` (`ACT_INST_ID_`),
  KEY `ACT_IDX_HI_DEC_INST_TIME` (`EVAL_TIME_`),
  KEY `ACT_IDX_HI_DEC_INST_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_HI_DEC_INST_ROOT_ID` (`ROOT_DEC_INST_ID_`),
  KEY `ACT_IDX_HI_DEC_INST_REQ_ID` (`DEC_REQ_ID_`),
  KEY `ACT_IDX_HI_DEC_INST_REQ_KEY` (`DEC_REQ_KEY_`),
  KEY `ACT_IDX_HI_DEC_INST_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_DEC_INST_RM_TIME` (`REMOVAL_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_decinst`
--

LOCK TABLES `act_hi_decinst` WRITE;
/*!40000 ALTER TABLE `act_hi_decinst` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_decinst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_detail`
--

DROP TABLE IF EXISTS `act_hi_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_detail` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `VAR_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `VAR_TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `REV_` int DEFAULT NULL,
  `TIME_` datetime NOT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `SEQUENCE_COUNTER_` bigint DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `OPERATION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  `INITIAL_` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_DETAIL_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_DETAIL_PROC_INST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_DETAIL_ACT_INST` (`ACT_INST_ID_`),
  KEY `ACT_IDX_HI_DETAIL_CASE_INST` (`CASE_INST_ID_`),
  KEY `ACT_IDX_HI_DETAIL_CASE_EXEC` (`CASE_EXECUTION_ID_`),
  KEY `ACT_IDX_HI_DETAIL_TIME` (`TIME_`),
  KEY `ACT_IDX_HI_DETAIL_NAME` (`NAME_`),
  KEY `ACT_IDX_HI_DETAIL_TASK_ID` (`TASK_ID_`),
  KEY `ACT_IDX_HI_DETAIL_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_HI_DETAIL_PROC_DEF_KEY` (`PROC_DEF_KEY_`),
  KEY `ACT_IDX_HI_DETAIL_BYTEAR` (`BYTEARRAY_ID_`),
  KEY `ACT_IDX_HI_DETAIL_RM_TIME` (`REMOVAL_TIME_`),
  KEY `ACT_IDX_HI_DETAIL_TASK_BYTEAR` (`BYTEARRAY_ID_`,`TASK_ID_`),
  KEY `ACT_IDX_HI_DETAIL_VAR_INST_ID` (`VAR_INST_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_detail`
--

LOCK TABLES `act_hi_detail` WRITE;
/*!40000 ALTER TABLE `act_hi_detail` DISABLE KEYS */;
INSERT INTO `act_hi_detail` VALUES ('08ffeecf-84df-11f1-b4aa-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'08fbf72d-84df-11f1-b4aa-94bb4319796b','08fedd5e-84df-11f1-b4aa-94bb4319796b','orderId','long',0,'2026-07-21 08:34:49',NULL,NULL,8,'8',NULL,1,NULL,NULL,NULL,1),('09098bc3-84df-11f1-b4aa-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_ProcessPayment:09054601-84df-11f1-b4aa-94bb4319796b','09098bc2-84df-11f1-b4aa-94bb4319796b','paymentSuccess','boolean',0,'2026-07-21 08:34:49',NULL,NULL,1,NULL,NULL,1,NULL,NULL,NULL,0),('090bfcc7-84df-11f1-b4aa-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_KitchenPrep:090a9d35-84df-11f1-b4aa-94bb4319796b','090bd5b6-84df-11f1-b4aa-94bb4319796b','kitchenStatus','string',0,'2026-07-21 08:34:49',NULL,NULL,NULL,'READY',NULL,1,NULL,NULL,NULL,0),('090daa7a-84df-11f1-b4aa-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_Delivery:090c4ae8-84df-11f1-b4aa-94bb4319796b','090daa79-84df-11f1-b4aa-94bb4319796b','deliveryStatus','string',0,'2026-07-21 08:34:49',NULL,NULL,NULL,'DELIVERED',NULL,1,NULL,NULL,NULL,0),('3d3e8824-84d3-11f1-8c8e-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3debe3-84d3-11f1-8c8e-94bb4319796b','orderId','long',0,'2026-07-21 07:10:23',NULL,NULL,7,'7',NULL,1,NULL,NULL,NULL,1),('3d465058-84d3-11f1-8c8e-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_ProcessPayment:3d416e56-84d3-11f1-8c8e-94bb4319796b','3d462947-84d3-11f1-8c8e-94bb4319796b','paymentSuccess','boolean',0,'2026-07-21 07:10:23',NULL,NULL,1,NULL,NULL,1,NULL,NULL,NULL,0),('3d49abbc-84d3-11f1-8c8e-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_KitchenPrep:3d4788da-84d3-11f1-8c8e-94bb4319796b','3d49abbb-84d3-11f1-8c8e-94bb4319796b','kitchenStatus','string',0,'2026-07-21 07:10:23',NULL,NULL,NULL,'READY',NULL,1,NULL,NULL,NULL,0),('3d4c1cbf-84d3-11f1-8c8e-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_Delivery:3d4a20ed-84d3-11f1-8c8e-94bb4319796b','3d4c1cbe-84d3-11f1-8c8e-94bb4319796b','deliveryStatus','string',0,'2026-07-21 07:10:23',NULL,NULL,NULL,'DELIVERED',NULL,1,NULL,NULL,NULL,0),('945911a6-8502-11f1-92ac-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'94554114-8502-11f1-92ac-94bb4319796b','94584e55-8502-11f1-92ac-94bb4319796b','orderId','long',0,'2026-07-21 12:49:15',NULL,NULL,9,'9',NULL,1,NULL,NULL,NULL,1),('94640e2a-8502-11f1-92ac-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_ProcessPayment:945dcc98-8502-11f1-92ac-94bb4319796b','94640e29-8502-11f1-92ac-94bb4319796b','paymentSuccess','boolean',0,'2026-07-21 12:49:15',NULL,NULL,1,NULL,NULL,1,NULL,NULL,NULL,0),('9466581e-8502-11f1-92ac-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_KitchenPrep:9464aa6c-8502-11f1-92ac-94bb4319796b','9466310d-8502-11f1-92ac-94bb4319796b','kitchenStatus','string',0,'2026-07-21 12:49:15',NULL,NULL,NULL,'READY',NULL,1,NULL,NULL,NULL,0),('9467dec1-8502-11f1-92ac-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_Delivery:9466a63f-8502-11f1-92ac-94bb4319796b','9467dec0-8502-11f1-92ac-94bb4319796b','deliveryStatus','string',0,'2026-07-21 12:49:15',NULL,NULL,NULL,'DELIVERED',NULL,1,NULL,NULL,NULL,0),('b9fd9ad6-8502-11f1-92ac-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad5-8502-11f1-92ac-94bb4319796b','orderId','long',0,'2026-07-21 12:50:18',NULL,NULL,10,'10',NULL,1,NULL,NULL,NULL,1),('ba18c3fa-8502-11f1-92ac-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_ProcessPayment:b9fde8f8-8502-11f1-92ac-94bb4319796b','ba189ce9-8502-11f1-92ac-94bb4319796b','paymentSuccess','boolean',0,'2026-07-21 12:50:18',NULL,NULL,1,NULL,NULL,1,NULL,NULL,NULL,0),('ba1ae6de-8502-11f1-92ac-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_KitchenPrep:ba19603c-8502-11f1-92ac-94bb4319796b','ba1ae6dd-8502-11f1-92ac-94bb4319796b','kitchenStatus','string',0,'2026-07-21 12:50:18',NULL,NULL,NULL,'READY',NULL,1,NULL,NULL,NULL,0),('ba1e1b31-8502-11f1-92ac-94bb4319796b','VariableUpdate','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'Task_Delivery:ba1b0def-8502-11f1-92ac-94bb4319796b','ba1e1b30-8502-11f1-92ac-94bb4319796b','deliveryStatus','string',0,'2026-07-21 12:50:18',NULL,NULL,NULL,'DELIVERED',NULL,1,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `act_hi_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_ext_task_log`
--

DROP TABLE IF EXISTS `act_hi_ext_task_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_ext_task_log` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `TIMESTAMP_` timestamp NOT NULL,
  `EXT_TASK_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `RETRIES_` int DEFAULT NULL,
  `TOPIC_NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `WORKER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PRIORITY_` bigint NOT NULL DEFAULT '0',
  `ERROR_MSG_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `ERROR_DETAILS_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `STATE_` int DEFAULT NULL,
  `REV_` int DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_HI_EXT_TASK_LOG_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_HI_EXT_TASK_LOG_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_HI_EXT_TASK_LOG_PROCDEF` (`PROC_DEF_ID_`),
  KEY `ACT_HI_EXT_TASK_LOG_PROC_DEF_KEY` (`PROC_DEF_KEY_`),
  KEY `ACT_HI_EXT_TASK_LOG_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_HI_EXTTASKLOG_ERRORDET` (`ERROR_DETAILS_ID_`),
  KEY `ACT_HI_EXT_TASK_LOG_RM_TIME` (`REMOVAL_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_ext_task_log`
--

LOCK TABLES `act_hi_ext_task_log` WRITE;
/*!40000 ALTER TABLE `act_hi_ext_task_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_ext_task_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_identitylink`
--

DROP TABLE IF EXISTS `act_hi_identitylink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_identitylink` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `TIMESTAMP_` timestamp NOT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `GROUP_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `OPERATION_TYPE_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ASSIGNER_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_USER` (`USER_ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_GROUP` (`GROUP_ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_PROC_DEF_KEY` (`PROC_DEF_KEY_`),
  KEY `ACT_IDX_HI_IDENT_LINK_TASK` (`TASK_ID_`),
  KEY `ACT_IDX_HI_IDENT_LINK_RM_TIME` (`REMOVAL_TIME_`),
  KEY `ACT_IDX_HI_IDENT_LNK_TIMESTAMP` (`TIMESTAMP_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_identitylink`
--

LOCK TABLES `act_hi_identitylink` WRITE;
/*!40000 ALTER TABLE `act_hi_identitylink` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_identitylink` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_incident`
--

DROP TABLE IF EXISTS `act_hi_incident`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_incident` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` timestamp NOT NULL,
  `END_TIME_` timestamp NULL DEFAULT NULL,
  `INCIDENT_MSG_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `INCIDENT_TYPE_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `ACTIVITY_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `FAILED_ACTIVITY_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `CAUSE_INCIDENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_CAUSE_INCIDENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CONFIGURATION_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `HISTORY_CONFIGURATION_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `INCIDENT_STATE_` int DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ANNOTATION_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_INCIDENT_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_HI_INCIDENT_PROC_DEF_KEY` (`PROC_DEF_KEY_`),
  KEY `ACT_IDX_HI_INCIDENT_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_INCIDENT_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_INCIDENT_RM_TIME` (`REMOVAL_TIME_`),
  KEY `ACT_IDX_HI_INCIDENT_CREATE_TIME` (`CREATE_TIME_`),
  KEY `ACT_IDX_HI_INCIDENT_END_TIME` (`END_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_incident`
--

LOCK TABLES `act_hi_incident` WRITE;
/*!40000 ALTER TABLE `act_hi_incident` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_incident` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_job_log`
--

DROP TABLE IF EXISTS `act_hi_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_job_log` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `TIMESTAMP_` datetime NOT NULL,
  `JOB_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `JOB_DUEDATE_` datetime DEFAULT NULL,
  `JOB_RETRIES_` int DEFAULT NULL,
  `JOB_PRIORITY_` bigint NOT NULL DEFAULT '0',
  `JOB_EXCEPTION_MSG_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `JOB_EXCEPTION_STACK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `JOB_STATE_` int DEFAULT NULL,
  `JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `JOB_DEF_TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `JOB_DEF_CONFIGURATION_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `FAILED_ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_INSTANCE_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `SEQUENCE_COUNTER_` bigint DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `HOSTNAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_JOB_LOG_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_JOB_LOG_PROCINST` (`PROCESS_INSTANCE_ID_`),
  KEY `ACT_IDX_HI_JOB_LOG_PROCDEF` (`PROCESS_DEF_ID_`),
  KEY `ACT_IDX_HI_JOB_LOG_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_HI_JOB_LOG_JOB_DEF_ID` (`JOB_DEF_ID_`),
  KEY `ACT_IDX_HI_JOB_LOG_PROC_DEF_KEY` (`PROCESS_DEF_KEY_`),
  KEY `ACT_IDX_HI_JOB_LOG_EX_STACK` (`JOB_EXCEPTION_STACK_ID_`),
  KEY `ACT_IDX_HI_JOB_LOG_RM_TIME` (`REMOVAL_TIME_`),
  KEY `ACT_IDX_HI_JOB_LOG_JOB_CONF` (`JOB_DEF_CONFIGURATION_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_job_log`
--

LOCK TABLES `act_hi_job_log` WRITE;
/*!40000 ALTER TABLE `act_hi_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_op_log`
--

DROP TABLE IF EXISTS `act_hi_op_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_op_log` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `JOB_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `BATCH_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TIMESTAMP_` timestamp NOT NULL,
  `OPERATION_TYPE_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `OPERATION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ENTITY_TYPE_` varchar(30) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROPERTY_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ORG_VALUE_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `NEW_VALUE_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  `CATEGORY_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXTERNAL_TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ANNOTATION_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_OP_LOG_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_OP_LOG_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_OP_LOG_PROCDEF` (`PROC_DEF_ID_`),
  KEY `ACT_IDX_HI_OP_LOG_TASK` (`TASK_ID_`),
  KEY `ACT_IDX_HI_OP_LOG_RM_TIME` (`REMOVAL_TIME_`),
  KEY `ACT_IDX_HI_OP_LOG_TIMESTAMP` (`TIMESTAMP_`),
  KEY `ACT_IDX_HI_OP_LOG_USER_ID` (`USER_ID_`),
  KEY `ACT_IDX_HI_OP_LOG_OP_TYPE` (`OPERATION_TYPE_`),
  KEY `ACT_IDX_HI_OP_LOG_ENTITY_TYPE` (`ENTITY_TYPE_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_op_log`
--

LOCK TABLES `act_hi_op_log` WRITE;
/*!40000 ALTER TABLE `act_hi_op_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_op_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_procinst`
--

DROP TABLE IF EXISTS `act_hi_procinst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_procinst` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `BUSINESS_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `START_TIME_` datetime NOT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint DEFAULT NULL,
  `START_USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `START_ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `END_ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUPER_PROCESS_INSTANCE_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUPER_CASE_INSTANCE_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DELETE_REASON_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `STATE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `PROC_INST_ID_` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_PRO_INST_END` (`END_TIME_`),
  KEY `ACT_IDX_HI_PRO_I_BUSKEY` (`BUSINESS_KEY_`),
  KEY `ACT_IDX_HI_PRO_INST_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_HI_PRO_INST_PROC_DEF_KEY` (`PROC_DEF_KEY_`),
  KEY `ACT_IDX_HI_PRO_INST_PROC_TIME` (`START_TIME_`,`END_TIME_`),
  KEY `ACT_IDX_HI_PI_PDEFID_END_TIME` (`PROC_DEF_ID_`,`END_TIME_`),
  KEY `ACT_IDX_HI_PRO_INST_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_PRO_INST_RM_TIME` (`REMOVAL_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_procinst`
--

LOCK TABLES `act_hi_procinst` WRITE;
/*!40000 ALTER TABLE `act_hi_procinst` DISABLE KEYS */;
INSERT INTO `act_hi_procinst` VALUES ('08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','8','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','2026-07-21 08:34:49','2026-07-21 08:34:49',NULL,133,NULL,'StartEvent_OrderPlaced','EndEvent_Success',NULL,'08fbf72d-84df-11f1-b4aa-94bb4319796b',NULL,NULL,NULL,NULL,'COMPLETED'),('3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','7','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','2026-07-21 07:10:23','2026-07-21 07:10:23',NULL,127,NULL,'StartEvent_OrderPlaced','EndEvent_Success',NULL,'3d3c3e32-84d3-11f1-8c8e-94bb4319796b',NULL,NULL,NULL,NULL,'COMPLETED'),('94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','9','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','2026-07-21 12:49:15','2026-07-21 12:49:15',NULL,159,NULL,'StartEvent_OrderPlaced','EndEvent_Success',NULL,'94554114-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,'COMPLETED'),('b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','10','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','2026-07-21 12:50:18','2026-07-21 12:50:18',NULL,230,NULL,'StartEvent_OrderPlaced','EndEvent_Success',NULL,'b9fd9ad4-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,'COMPLETED');
/*!40000 ALTER TABLE `act_hi_procinst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_taskinst`
--

DROP TABLE IF EXISTS `act_hi_taskinst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_taskinst` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `TASK_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PARENT_TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `OWNER_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ASSIGNEE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `START_TIME_` datetime NOT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint DEFAULT NULL,
  `DELETE_REASON_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `PRIORITY_` int DEFAULT NULL,
  `DUE_DATE_` datetime DEFAULT NULL,
  `FOLLOW_UP_DATE_` datetime DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_TASKINST_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_TASK_INST_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_HI_TASK_INST_PROC_DEF_KEY` (`PROC_DEF_KEY_`),
  KEY `ACT_IDX_HI_TASKINST_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_TASKINSTID_PROCINST` (`ID_`,`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_TASK_INST_RM_TIME` (`REMOVAL_TIME_`),
  KEY `ACT_IDX_HI_TASK_INST_START` (`START_TIME_`),
  KEY `ACT_IDX_HI_TASK_INST_END` (`END_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_taskinst`
--

LOCK TABLES `act_hi_taskinst` WRITE;
/*!40000 ALTER TABLE `act_hi_taskinst` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_hi_taskinst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_hi_varinst`
--

DROP TABLE IF EXISTS `act_hi_varinst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_hi_varinst` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `VAR_TYPE_` varchar(100) COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime DEFAULT NULL,
  `REV_` int DEFAULT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `STATE_` varchar(20) COLLATE utf8mb3_bin DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_VARINST_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_HI_PROCVAR_PROC_INST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_PROCVAR_NAME_TYPE` (`NAME_`,`VAR_TYPE_`),
  KEY `ACT_IDX_HI_CASEVAR_CASE_INST` (`CASE_INST_ID_`),
  KEY `ACT_IDX_HI_VAR_INST_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_HI_VAR_INST_PROC_DEF_KEY` (`PROC_DEF_KEY_`),
  KEY `ACT_IDX_HI_VARINST_BYTEAR` (`BYTEARRAY_ID_`),
  KEY `ACT_IDX_HI_VARINST_RM_TIME` (`REMOVAL_TIME_`),
  KEY `ACT_IDX_HI_VAR_PI_NAME_TYPE` (`PROC_INST_ID_`,`NAME_`,`VAR_TYPE_`),
  KEY `ACT_IDX_HI_VARINST_NAME` (`NAME_`),
  KEY `ACT_IDX_HI_VARINST_ACT_INST_ID` (`ACT_INST_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_hi_varinst`
--

LOCK TABLES `act_hi_varinst` WRITE;
/*!40000 ALTER TABLE `act_hi_varinst` DISABLE KEYS */;
INSERT INTO `act_hi_varinst` VALUES ('08fedd5e-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'orderId','long','2026-07-21 08:34:49',0,NULL,NULL,8,'8',NULL,NULL,'CREATED',NULL),('09098bc2-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'paymentSuccess','boolean','2026-07-21 08:34:49',0,NULL,NULL,1,NULL,NULL,NULL,'CREATED',NULL),('090bd5b6-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'kitchenStatus','string','2026-07-21 08:34:49',0,NULL,NULL,NULL,'READY',NULL,NULL,'CREATED',NULL),('090daa79-84df-11f1-b4aa-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b','08fbf72d-84df-11f1-b4aa-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'deliveryStatus','string','2026-07-21 08:34:49',0,NULL,NULL,NULL,'DELIVERED',NULL,NULL,'CREATED',NULL),('3d3debe3-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'orderId','long','2026-07-21 07:10:23',0,NULL,NULL,7,'7',NULL,NULL,'CREATED',NULL),('3d462947-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'paymentSuccess','boolean','2026-07-21 07:10:23',0,NULL,NULL,1,NULL,NULL,NULL,'CREATED',NULL),('3d49abbb-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'kitchenStatus','string','2026-07-21 07:10:23',0,NULL,NULL,NULL,'READY',NULL,NULL,'CREATED',NULL),('3d4c1cbe-84d3-11f1-8c8e-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b','3d3c3e32-84d3-11f1-8c8e-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'deliveryStatus','string','2026-07-21 07:10:23',0,NULL,NULL,NULL,'DELIVERED',NULL,NULL,'CREATED',NULL),('94584e55-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'orderId','long','2026-07-21 12:49:15',0,NULL,NULL,9,'9',NULL,NULL,'CREATED',NULL),('94640e29-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'paymentSuccess','boolean','2026-07-21 12:49:15',0,NULL,NULL,1,NULL,NULL,NULL,'CREATED',NULL),('9466310d-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'kitchenStatus','string','2026-07-21 12:49:15',0,NULL,NULL,NULL,'READY',NULL,NULL,'CREATED',NULL),('9467dec0-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b','94554114-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'deliveryStatus','string','2026-07-21 12:49:15',0,NULL,NULL,NULL,'DELIVERED',NULL,NULL,'CREATED',NULL),('b9fd9ad5-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'orderId','long','2026-07-21 12:50:18',0,NULL,NULL,10,'10',NULL,NULL,'CREATED',NULL),('ba189ce9-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'paymentSuccess','boolean','2026-07-21 12:50:18',0,NULL,NULL,1,NULL,NULL,NULL,'CREATED',NULL),('ba1ae6dd-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'kitchenStatus','string','2026-07-21 12:50:18',0,NULL,NULL,NULL,'READY',NULL,NULL,'CREATED',NULL),('ba1e1b30-8502-11f1-92ac-94bb4319796b','orderProcessing','orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b','b9fd9ad4-8502-11f1-92ac-94bb4319796b',NULL,NULL,NULL,NULL,NULL,'deliveryStatus','string','2026-07-21 12:50:18',0,NULL,NULL,NULL,'DELIVERED',NULL,NULL,'CREATED',NULL);
/*!40000 ALTER TABLE `act_hi_varinst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_id_group`
--

DROP TABLE IF EXISTS `act_id_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_id_group` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_id_group`
--

LOCK TABLES `act_id_group` WRITE;
/*!40000 ALTER TABLE `act_id_group` DISABLE KEYS */;
INSERT INTO `act_id_group` VALUES ('camunda-admin',1,'camunda BPM Administrators','SYSTEM');
/*!40000 ALTER TABLE `act_id_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_id_info`
--

DROP TABLE IF EXISTS `act_id_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_id_info` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `USER_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `VALUE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PASSWORD_` longblob,
  `PARENT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_id_info`
--

LOCK TABLES `act_id_info` WRITE;
/*!40000 ALTER TABLE `act_id_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_id_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_id_membership`
--

DROP TABLE IF EXISTS `act_id_membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_id_membership` (
  `USER_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `GROUP_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`USER_ID_`,`GROUP_ID_`),
  KEY `ACT_FK_MEMB_GROUP` (`GROUP_ID_`),
  CONSTRAINT `ACT_FK_MEMB_GROUP` FOREIGN KEY (`GROUP_ID_`) REFERENCES `act_id_group` (`ID_`),
  CONSTRAINT `ACT_FK_MEMB_USER` FOREIGN KEY (`USER_ID_`) REFERENCES `act_id_user` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_id_membership`
--

LOCK TABLES `act_id_membership` WRITE;
/*!40000 ALTER TABLE `act_id_membership` DISABLE KEYS */;
INSERT INTO `act_id_membership` VALUES ('admin','camunda-admin');
/*!40000 ALTER TABLE `act_id_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_id_tenant`
--

DROP TABLE IF EXISTS `act_id_tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_id_tenant` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_id_tenant`
--

LOCK TABLES `act_id_tenant` WRITE;
/*!40000 ALTER TABLE `act_id_tenant` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_id_tenant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_id_tenant_member`
--

DROP TABLE IF EXISTS `act_id_tenant_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_id_tenant_member` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `USER_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `GROUP_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_UNIQ_TENANT_MEMB_USER` (`TENANT_ID_`,`USER_ID_`),
  UNIQUE KEY `ACT_UNIQ_TENANT_MEMB_GROUP` (`TENANT_ID_`,`GROUP_ID_`),
  KEY `ACT_FK_TENANT_MEMB_USER` (`USER_ID_`),
  KEY `ACT_FK_TENANT_MEMB_GROUP` (`GROUP_ID_`),
  CONSTRAINT `ACT_FK_TENANT_MEMB` FOREIGN KEY (`TENANT_ID_`) REFERENCES `act_id_tenant` (`ID_`),
  CONSTRAINT `ACT_FK_TENANT_MEMB_GROUP` FOREIGN KEY (`GROUP_ID_`) REFERENCES `act_id_group` (`ID_`),
  CONSTRAINT `ACT_FK_TENANT_MEMB_USER` FOREIGN KEY (`USER_ID_`) REFERENCES `act_id_user` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_id_tenant_member`
--

LOCK TABLES `act_id_tenant_member` WRITE;
/*!40000 ALTER TABLE `act_id_tenant_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_id_tenant_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_id_user`
--

DROP TABLE IF EXISTS `act_id_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_id_user` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `FIRST_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `LAST_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `EMAIL_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PWD_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `SALT_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `LOCK_EXP_TIME_` datetime DEFAULT NULL,
  `ATTEMPTS_` int DEFAULT NULL,
  `PICTURE_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_id_user`
--

LOCK TABLES `act_id_user` WRITE;
/*!40000 ALTER TABLE `act_id_user` DISABLE KEYS */;
INSERT INTO `act_id_user` VALUES ('admin',1,'Admin','Admin','admin@localhost','{SHA-512}f2ZpE9hW5x4CFkqsUBmzRb7PgfUVfvjS2RHGfccDiKL/kc2jwGzt5SYPxVD0BCDCYW84+7twYNquPm8+ZT16tQ==','UGBj0ZTraaAdJA8OdYVC1w==',NULL,NULL,NULL);
/*!40000 ALTER TABLE `act_id_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_re_camformdef`
--

DROP TABLE IF EXISTS `act_re_camformdef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_re_camformdef` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `VERSION_` int NOT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `RESOURCE_NAME_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_re_camformdef`
--

LOCK TABLES `act_re_camformdef` WRITE;
/*!40000 ALTER TABLE `act_re_camformdef` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_re_camformdef` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_re_case_def`
--

DROP TABLE IF EXISTS `act_re_case_def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_re_case_def` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `VERSION_` int NOT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `RESOURCE_NAME_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `DGRM_RESOURCE_NAME_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `HISTORY_TTL_` int DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_CASE_DEF_TENANT_ID` (`TENANT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_re_case_def`
--

LOCK TABLES `act_re_case_def` WRITE;
/*!40000 ALTER TABLE `act_re_case_def` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_re_case_def` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_re_decision_def`
--

DROP TABLE IF EXISTS `act_re_decision_def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_re_decision_def` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `VERSION_` int NOT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `RESOURCE_NAME_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `DGRM_RESOURCE_NAME_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `DEC_REQ_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DEC_REQ_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `HISTORY_TTL_` int DEFAULT NULL,
  `VERSION_TAG_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_DEC_DEF_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_DEC_DEF_REQ_ID` (`DEC_REQ_ID_`),
  CONSTRAINT `ACT_FK_DEC_REQ` FOREIGN KEY (`DEC_REQ_ID_`) REFERENCES `act_re_decision_req_def` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_re_decision_def`
--

LOCK TABLES `act_re_decision_def` WRITE;
/*!40000 ALTER TABLE `act_re_decision_def` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_re_decision_def` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_re_decision_req_def`
--

DROP TABLE IF EXISTS `act_re_decision_req_def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_re_decision_req_def` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `VERSION_` int NOT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `RESOURCE_NAME_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `DGRM_RESOURCE_NAME_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_DEC_REQ_DEF_TENANT_ID` (`TENANT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_re_decision_req_def`
--

LOCK TABLES `act_re_decision_req_def` WRITE;
/*!40000 ALTER TABLE `act_re_decision_req_def` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_re_decision_req_def` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_re_deployment`
--

DROP TABLE IF EXISTS `act_re_deployment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_re_deployment` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `DEPLOY_TIME_` datetime DEFAULT NULL,
  `SOURCE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_DEPLOYMENT_NAME` (`NAME_`),
  KEY `ACT_IDX_DEPLOYMENT_TENANT_ID` (`TENANT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_re_deployment`
--

LOCK TABLES `act_re_deployment` WRITE;
/*!40000 ALTER TABLE `act_re_deployment` DISABLE KEYS */;
INSERT INTO `act_re_deployment` VALUES ('6a390e58-8337-11f1-92f8-94bb4319796b','SpringAutoDeployment','2026-07-19 11:32:25',NULL,NULL);
/*!40000 ALTER TABLE `act_re_deployment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_re_procdef`
--

DROP TABLE IF EXISTS `act_re_procdef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_re_procdef` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `VERSION_` int NOT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `RESOURCE_NAME_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `DGRM_RESOURCE_NAME_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `HAS_START_FORM_KEY_` tinyint DEFAULT NULL,
  `SUSPENSION_STATE_` int DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `VERSION_TAG_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `HISTORY_TTL_` int DEFAULT NULL,
  `STARTABLE_` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_PROCDEF_DEPLOYMENT_ID` (`DEPLOYMENT_ID_`),
  KEY `ACT_IDX_PROCDEF_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_PROCDEF_VER_TAG` (`VERSION_TAG_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_re_procdef`
--

LOCK TABLES `act_re_procdef` WRITE;
/*!40000 ALTER TABLE `act_re_procdef` DISABLE KEYS */;
INSERT INTO `act_re_procdef` VALUES ('orderProcessing:1:6a4e1cfa-8337-11f1-92f8-94bb4319796b',1,'http://bpmn.io/schema/bpmn','Order Processing Workflow','orderProcessing',1,'6a390e58-8337-11f1-92f8-94bb4319796b','C:\\Users\\Tamil Selvam\\Downloads\\OnlineFoodOrderProcessingSystem\\backend\\target\\classes\\order-processing.bpmn',NULL,0,1,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `act_re_procdef` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_authorization`
--

DROP TABLE IF EXISTS `act_ru_authorization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_authorization` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int NOT NULL,
  `TYPE_` int NOT NULL,
  `GROUP_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `RESOURCE_TYPE_` int NOT NULL,
  `RESOURCE_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PERMS_` int DEFAULT NULL,
  `REMOVAL_TIME_` datetime DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_UNIQ_AUTH_USER` (`USER_ID_`,`TYPE_`,`RESOURCE_TYPE_`,`RESOURCE_ID_`),
  UNIQUE KEY `ACT_UNIQ_AUTH_GROUP` (`GROUP_ID_`,`TYPE_`,`RESOURCE_TYPE_`,`RESOURCE_ID_`),
  KEY `ACT_IDX_AUTH_GROUP_ID` (`GROUP_ID_`),
  KEY `ACT_IDX_AUTH_RESOURCE_ID` (`RESOURCE_ID_`),
  KEY `ACT_IDX_AUTH_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_AUTH_RM_TIME` (`REMOVAL_TIME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_authorization`
--

LOCK TABLES `act_ru_authorization` WRITE;
/*!40000 ALTER TABLE `act_ru_authorization` DISABLE KEYS */;
INSERT INTO `act_ru_authorization` VALUES ('1b9b2b88-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,0,'*',2147483647,NULL,NULL),('1b9d0049-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,1,'*',2147483647,NULL,NULL),('1b9e38ca-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,2,'*',2147483647,NULL,NULL),('1b9f714b-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,3,'*',2147483647,NULL,NULL),('1ba0d0dc-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,4,'*',2147483647,NULL,NULL),('1ba2306d-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,5,'*',2147483647,NULL,NULL),('1ba31ace-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,6,'*',2147483647,NULL,NULL),('1ba47a5f-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,7,'*',2147483647,NULL,NULL),('1ba60100-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,8,'*',2147483647,NULL,NULL),('1ba7aeb1-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,9,'*',2147483647,NULL,NULL),('1ba93552-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,10,'*',2147483647,NULL,NULL),('1baa6dd3-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,11,'*',2147483647,NULL,NULL),('1babf474-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,12,'*',2147483647,NULL,NULL),('1bacb7c5-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,13,'*',2147483647,NULL,NULL),('1bae3e66-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,14,'*',2147483647,NULL,NULL),('1baf76e7-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,15,'*',2147483647,NULL,NULL),('1bb0d678-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,16,'*',2147483647,NULL,NULL),('1bb1c0d9-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,17,'*',2147483647,NULL,NULL),('1bb3206a-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,18,'*',2147483647,NULL,NULL),('1bb458eb-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,19,'*',2147483647,NULL,NULL),('1bb5b87c-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,20,'*',2147483647,NULL,NULL),('1bb6f0fd-8337-11f1-ada2-94bb4319796b',1,1,'camunda-admin',NULL,21,'*',2147483647,NULL,NULL);
/*!40000 ALTER TABLE `act_ru_authorization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_batch`
--

DROP TABLE IF EXISTS `act_ru_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_batch` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int NOT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TOTAL_JOBS_` int DEFAULT NULL,
  `JOBS_CREATED_` int DEFAULT NULL,
  `JOBS_PER_SEED_` int DEFAULT NULL,
  `INVOCATIONS_PER_JOB_` int DEFAULT NULL,
  `SEED_JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `BATCH_JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `MONITOR_JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUSPENSION_STATE_` int DEFAULT NULL,
  `CONFIGURATION_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `START_TIME_` datetime DEFAULT NULL,
  `EXEC_START_TIME_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_BATCH_SEED_JOB_DEF` (`SEED_JOB_DEF_ID_`),
  KEY `ACT_IDX_BATCH_MONITOR_JOB_DEF` (`MONITOR_JOB_DEF_ID_`),
  KEY `ACT_IDX_BATCH_JOB_DEF` (`BATCH_JOB_DEF_ID_`),
  CONSTRAINT `ACT_FK_BATCH_JOB_DEF` FOREIGN KEY (`BATCH_JOB_DEF_ID_`) REFERENCES `act_ru_jobdef` (`ID_`),
  CONSTRAINT `ACT_FK_BATCH_MONITOR_JOB_DEF` FOREIGN KEY (`MONITOR_JOB_DEF_ID_`) REFERENCES `act_ru_jobdef` (`ID_`),
  CONSTRAINT `ACT_FK_BATCH_SEED_JOB_DEF` FOREIGN KEY (`SEED_JOB_DEF_ID_`) REFERENCES `act_ru_jobdef` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_batch`
--

LOCK TABLES `act_ru_batch` WRITE;
/*!40000 ALTER TABLE `act_ru_batch` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_case_execution`
--

DROP TABLE IF EXISTS `act_ru_case_execution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_case_execution` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUPER_CASE_EXEC_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUPER_EXEC_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `BUSINESS_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PARENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PREV_STATE_` int DEFAULT NULL,
  `CURRENT_STATE_` int DEFAULT NULL,
  `REQUIRED_` tinyint(1) DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_CASE_EXEC_BUSKEY` (`BUSINESS_KEY_`),
  KEY `ACT_IDX_CASE_EXE_CASE_INST` (`CASE_INST_ID_`),
  KEY `ACT_FK_CASE_EXE_PARENT` (`PARENT_ID_`),
  KEY `ACT_FK_CASE_EXE_CASE_DEF` (`CASE_DEF_ID_`),
  KEY `ACT_IDX_CASE_EXEC_TENANT_ID` (`TENANT_ID_`),
  CONSTRAINT `ACT_FK_CASE_EXE_CASE_DEF` FOREIGN KEY (`CASE_DEF_ID_`) REFERENCES `act_re_case_def` (`ID_`),
  CONSTRAINT `ACT_FK_CASE_EXE_CASE_INST` FOREIGN KEY (`CASE_INST_ID_`) REFERENCES `act_ru_case_execution` (`ID_`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ACT_FK_CASE_EXE_PARENT` FOREIGN KEY (`PARENT_ID_`) REFERENCES `act_ru_case_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_case_execution`
--

LOCK TABLES `act_ru_case_execution` WRITE;
/*!40000 ALTER TABLE `act_ru_case_execution` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_case_execution` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_case_sentry_part`
--

DROP TABLE IF EXISTS `act_ru_case_sentry_part`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_case_sentry_part` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_EXEC_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `SENTRY_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `SOURCE_CASE_EXEC_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `STANDARD_EVENT_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `SOURCE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `VARIABLE_EVENT_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `VARIABLE_NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `SATISFIED_` tinyint(1) DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_CASE_SENTRY_CASE_INST` (`CASE_INST_ID_`),
  KEY `ACT_FK_CASE_SENTRY_CASE_EXEC` (`CASE_EXEC_ID_`),
  CONSTRAINT `ACT_FK_CASE_SENTRY_CASE_EXEC` FOREIGN KEY (`CASE_EXEC_ID_`) REFERENCES `act_ru_case_execution` (`ID_`),
  CONSTRAINT `ACT_FK_CASE_SENTRY_CASE_INST` FOREIGN KEY (`CASE_INST_ID_`) REFERENCES `act_ru_case_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_case_sentry_part`
--

LOCK TABLES `act_ru_case_sentry_part` WRITE;
/*!40000 ALTER TABLE `act_ru_case_sentry_part` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_case_sentry_part` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_event_subscr`
--

DROP TABLE IF EXISTS `act_ru_event_subscr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_event_subscr` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `EVENT_TYPE_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `EVENT_NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACTIVITY_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `CONFIGURATION_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATED_` datetime NOT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_EVENT_SUBSCR_CONFIG_` (`CONFIGURATION_`),
  KEY `ACT_IDX_EVENT_SUBSCR_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_FK_EVENT_EXEC` (`EXECUTION_ID_`),
  KEY `ACT_IDX_EVENT_SUBSCR_EVT_NAME` (`EVENT_NAME_`),
  CONSTRAINT `ACT_FK_EVENT_EXEC` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_event_subscr`
--

LOCK TABLES `act_ru_event_subscr` WRITE;
/*!40000 ALTER TABLE `act_ru_event_subscr` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_event_subscr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_execution`
--

DROP TABLE IF EXISTS `act_ru_execution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_execution` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `BUSINESS_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PARENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUPER_EXEC_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUPER_CASE_EXEC_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `IS_ACTIVE_` tinyint DEFAULT NULL,
  `IS_CONCURRENT_` tinyint DEFAULT NULL,
  `IS_SCOPE_` tinyint DEFAULT NULL,
  `IS_EVENT_SCOPE_` tinyint DEFAULT NULL,
  `SUSPENSION_STATE_` int DEFAULT NULL,
  `CACHED_ENT_STATE_` int DEFAULT NULL,
  `SEQUENCE_COUNTER_` bigint DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_EXEC_ROOT_PI` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_EXEC_BUSKEY` (`BUSINESS_KEY_`),
  KEY `ACT_IDX_EXEC_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_FK_EXE_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_EXE_PARENT` (`PARENT_ID_`),
  KEY `ACT_FK_EXE_SUPER` (`SUPER_EXEC_`),
  KEY `ACT_FK_EXE_PROCDEF` (`PROC_DEF_ID_`),
  CONSTRAINT `ACT_FK_EXE_PARENT` FOREIGN KEY (`PARENT_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_EXE_PROCDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_EXE_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ACT_FK_EXE_SUPER` FOREIGN KEY (`SUPER_EXEC_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_execution`
--

LOCK TABLES `act_ru_execution` WRITE;
/*!40000 ALTER TABLE `act_ru_execution` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_execution` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_ext_task`
--

DROP TABLE IF EXISTS `act_ru_ext_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_ext_task` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int NOT NULL,
  `WORKER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TOPIC_NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `RETRIES_` int DEFAULT NULL,
  `ERROR_MSG_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `ERROR_DETAILS_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `LOCK_EXP_TIME_` datetime DEFAULT NULL,
  `CREATE_TIME_` datetime DEFAULT NULL,
  `SUSPENSION_STATE_` int DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PRIORITY_` bigint NOT NULL DEFAULT '0',
  `LAST_FAILURE_LOG_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_EXT_TASK_TOPIC` (`TOPIC_NAME_`),
  KEY `ACT_IDX_EXT_TASK_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_EXT_TASK_PRIORITY` (`PRIORITY_`),
  KEY `ACT_IDX_EXT_TASK_ERR_DETAILS` (`ERROR_DETAILS_ID_`),
  KEY `ACT_IDX_EXT_TASK_EXEC` (`EXECUTION_ID_`),
  CONSTRAINT `ACT_FK_EXT_TASK_ERROR_DETAILS` FOREIGN KEY (`ERROR_DETAILS_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_EXT_TASK_EXE` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_ext_task`
--

LOCK TABLES `act_ru_ext_task` WRITE;
/*!40000 ALTER TABLE `act_ru_ext_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_ext_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_filter`
--

DROP TABLE IF EXISTS `act_ru_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_filter` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int NOT NULL,
  `RESOURCE_TYPE_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `OWNER_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `QUERY_` longtext COLLATE utf8mb3_bin NOT NULL,
  `PROPERTIES_` longtext COLLATE utf8mb3_bin,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_filter`
--

LOCK TABLES `act_ru_filter` WRITE;
/*!40000 ALTER TABLE `act_ru_filter` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_filter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_identitylink`
--

DROP TABLE IF EXISTS `act_ru_identitylink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_identitylink` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `GROUP_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_IDENT_LNK_USER` (`USER_ID_`),
  KEY `ACT_IDX_IDENT_LNK_GROUP` (`GROUP_ID_`),
  KEY `ACT_IDX_ATHRZ_PROCEDEF` (`PROC_DEF_ID_`),
  KEY `ACT_FK_TSKASS_TASK` (`TASK_ID_`),
  CONSTRAINT `ACT_FK_ATHRZ_PROCEDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_TSKASS_TASK` FOREIGN KEY (`TASK_ID_`) REFERENCES `act_ru_task` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_identitylink`
--

LOCK TABLES `act_ru_identitylink` WRITE;
/*!40000 ALTER TABLE `act_ru_identitylink` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_identitylink` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_incident`
--

DROP TABLE IF EXISTS `act_ru_incident`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_incident` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int NOT NULL,
  `INCIDENT_TIMESTAMP_` datetime NOT NULL,
  `INCIDENT_MSG_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `INCIDENT_TYPE_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACTIVITY_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `FAILED_ACTIVITY_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CAUSE_INCIDENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_CAUSE_INCIDENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CONFIGURATION_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ANNOTATION_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_INC_CONFIGURATION` (`CONFIGURATION_`),
  KEY `ACT_IDX_INC_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_INC_JOB_DEF` (`JOB_DEF_ID_`),
  KEY `ACT_IDX_INC_CAUSEINCID` (`CAUSE_INCIDENT_ID_`),
  KEY `ACT_IDX_INC_EXID` (`EXECUTION_ID_`),
  KEY `ACT_IDX_INC_PROCDEFID` (`PROC_DEF_ID_`),
  KEY `ACT_IDX_INC_PROCINSTID` (`PROC_INST_ID_`),
  KEY `ACT_IDX_INC_ROOTCAUSEINCID` (`ROOT_CAUSE_INCIDENT_ID_`),
  CONSTRAINT `ACT_FK_INC_CAUSE` FOREIGN KEY (`CAUSE_INCIDENT_ID_`) REFERENCES `act_ru_incident` (`ID_`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ACT_FK_INC_EXE` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_INC_JOB_DEF` FOREIGN KEY (`JOB_DEF_ID_`) REFERENCES `act_ru_jobdef` (`ID_`),
  CONSTRAINT `ACT_FK_INC_PROCDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_INC_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_INC_RCAUSE` FOREIGN KEY (`ROOT_CAUSE_INCIDENT_ID_`) REFERENCES `act_ru_incident` (`ID_`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_incident`
--

LOCK TABLES `act_ru_incident` WRITE;
/*!40000 ALTER TABLE `act_ru_incident` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_incident` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_job`
--

DROP TABLE IF EXISTS `act_ru_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_job` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `LOCK_EXP_TIME_` datetime DEFAULT NULL,
  `LOCK_OWNER_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCLUSIVE_` tinyint(1) DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_INSTANCE_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `RETRIES_` int DEFAULT NULL,
  `EXCEPTION_STACK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCEPTION_MSG_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `FAILED_ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `DUEDATE_` datetime DEFAULT NULL,
  `REPEAT_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `REPEAT_OFFSET_` bigint DEFAULT '0',
  `HANDLER_TYPE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_CFG_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUSPENSION_STATE_` int NOT NULL DEFAULT '1',
  `JOB_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PRIORITY_` bigint NOT NULL DEFAULT '0',
  `SEQUENCE_COUNTER_` bigint DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime DEFAULT NULL,
  `LAST_FAILURE_LOG_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_JOB_EXECUTION_ID` (`EXECUTION_ID_`),
  KEY `ACT_IDX_JOB_HANDLER` (`HANDLER_TYPE_`(100),`HANDLER_CFG_`(155)),
  KEY `ACT_IDX_JOB_PROCINST` (`PROCESS_INSTANCE_ID_`),
  KEY `ACT_IDX_JOB_ROOT_PROCINST` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_JOB_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_JOB_JOB_DEF_ID` (`JOB_DEF_ID_`),
  KEY `ACT_FK_JOB_EXCEPTION` (`EXCEPTION_STACK_ID_`),
  KEY `ACT_IDX_JOB_HANDLER_TYPE` (`HANDLER_TYPE_`),
  CONSTRAINT `ACT_FK_JOB_EXCEPTION` FOREIGN KEY (`EXCEPTION_STACK_ID_`) REFERENCES `act_ge_bytearray` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_job`
--

LOCK TABLES `act_ru_job` WRITE;
/*!40000 ALTER TABLE `act_ru_job` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_jobdef`
--

DROP TABLE IF EXISTS `act_ru_jobdef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_jobdef` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `JOB_TYPE_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `JOB_CONFIGURATION_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `SUSPENSION_STATE_` int DEFAULT NULL,
  `JOB_PRIORITY_` bigint DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_JOBDEF_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_JOBDEF_PROC_DEF_ID` (`PROC_DEF_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_jobdef`
--

LOCK TABLES `act_ru_jobdef` WRITE;
/*!40000 ALTER TABLE `act_ru_jobdef` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_jobdef` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_meter_log`
--

DROP TABLE IF EXISTS `act_ru_meter_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_meter_log` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `NAME_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REPORTER_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `VALUE_` bigint DEFAULT NULL,
  `TIMESTAMP_` datetime DEFAULT NULL,
  `MILLISECONDS_` bigint DEFAULT '0',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_METER_LOG_MS` (`MILLISECONDS_`),
  KEY `ACT_IDX_METER_LOG_NAME_MS` (`NAME_`,`MILLISECONDS_`),
  KEY `ACT_IDX_METER_LOG_REPORT` (`NAME_`,`REPORTER_`,`MILLISECONDS_`),
  KEY `ACT_IDX_METER_LOG_TIME` (`TIMESTAMP_`),
  KEY `ACT_IDX_METER_LOG` (`NAME_`,`TIMESTAMP_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_meter_log`
--

LOCK TABLES `act_ru_meter_log` WRITE;
/*!40000 ALTER TABLE `act_ru_meter_log` DISABLE KEYS */;
INSERT INTO `act_ru_meter_log` VALUES ('04a5e16c-8500-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('04a5e16d-8500-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('04a5e16e-8500-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('04a5e16f-8500-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('04a5e170-8500-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('04a5e171-8500-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('04a5e172-8500-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('04a5e173-8500-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('04a5e174-8500-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('04a62e95-8500-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-21 12:30:55',1784637054966),('04a62e96-8500-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('04a62e97-8500-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 12:30:55',1784637054966),('05ebca08-852c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('05ebca09-852c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('05ebca0a-852c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('05ebca0b-852c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('05ebca0c-852c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('05ebca0d-852c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('05ebca0e-852c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('05ebca0f-852c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('05ebca10-852c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('05ebca11-852c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-21 17:45:55',1784655954958),('05ebca12-852c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('05ebca13-852c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:45:55',1784655954958),('12ae986d-838f-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('12ae986e-838f-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('12ae986f-838f-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('12ae9870-838f-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('12ae9871-838f-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('12ae9872-838f-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('12ae9873-838f-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('12ae9874-838f-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('12ae9875-838f-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('12ae9876-838f-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',9,'2026-07-19 21:59:54',1784478594218),('12ae9877-838f-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('12ae9878-838f-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 21:59:54',1784478594218),('15578c14-859b-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('15578c15-859b-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('15578c16-859b-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('15578c17-859b-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('15578c18-859b-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('15578c19-859b-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('15578c1a-859b-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('15578c1b-859b-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('15578c1c-859b-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('15578c1d-859b-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',11,'2026-07-22 07:00:55',1784703654967),('15578c1e-859b-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('15578c1f-859b-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 07:00:55',1784703654967),('1766210e-84d7-11f1-8c8e-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('1766210f-84d7-11f1-8c8e-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('17662110-84d7-11f1-8c8e-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('17666f31-84d7-11f1-8c8e-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('17666f32-84d7-11f1-8c8e-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('17666f33-84d7-11f1-8c8e-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('17666f34-84d7-11f1-8c8e-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('17666f35-84d7-11f1-8c8e-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('17666f36-84d7-11f1-8c8e-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('17666f37-84d7-11f1-8c8e-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',9,'2026-07-21 07:37:57',1784619477060),('17666f38-84d7-11f1-8c8e-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('17666f39-84d7-11f1-8c8e-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 07:37:57',1784619477060),('1ba60009-8397-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba6000a-8397-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba6000b-8397-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba6000c-8397-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba6000d-8397-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba6000e-8397-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba6000f-8397-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba60010-8397-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba60011-8397-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba60012-8397-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',8,'2026-07-19 22:57:25',1784482045234),('1ba60013-8397-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba60014-8397-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045234),('1ba84a05-8397-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a06-8397-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a07-8397-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a08-8397-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a09-8397-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a0a-8397-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a0b-8397-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a0c-8397-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a0d-8397-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a0e-8397-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a0f-8397-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1ba84a10-8397-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045250),('1bb198e1-8397-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb198e2-8397-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb198e3-8397-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb1bff4-8397-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb1bff5-8397-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb1bff6-8397-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb1bff7-8397-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb1bff8-8397-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb1bff9-8397-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb1bffa-8397-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb1bffb-8397-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb1bffc-8397-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045312),('1bb3e2dd-8397-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2de-8397-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2df-8397-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2e0-8397-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2e1-8397-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2e2-8397-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2e3-8397-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2e4-8397-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2e5-8397-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2e6-8397-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2e7-8397-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1bb3e2e8-8397-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 22:57:25',1784482045327),('1d168548-8502-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1d168549-8502-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1d16854a-8502-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1d16854b-8502-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1d16854c-8502-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1d16854d-8502-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1d16854e-8502-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1d16854f-8502-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1d168550-8502-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1d168551-8502-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-21 12:45:55',1784637954963),('1d168552-8502-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1d168553-8502-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 12:45:55',1784637954963),('1e3ed90d-839f-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e3ed90e-839f-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e3ed90f-839f-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e3ed910-839f-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e3ed911-839f-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e3ed912-839f-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e3ed913-839f-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e3ed914-839f-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e3ed915-839f-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e3ed916-839f-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',14,'2026-07-19 23:54:46',1784485485564),('1e3ed917-839f-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e3ed918-839f-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 23:54:46',1784485485564),('1e5dce74-852e-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('1e5dce75-852e-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('1e5dce76-852e-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('1e5dce77-852e-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('1e5dce78-852e-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('1e5dce79-852e-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('1e5dce7a-852e-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('1e5dce7b-852e-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('1e5dce7c-852e-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('1e5dce7d-852e-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-21 18:00:55',1784656854963),('1e5dce7e-852e-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('1e5dce7f-852e-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 18:00:55',1784656854963),('2e711b20-859d-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('2e711b21-859d-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('2e711b22-859d-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('2e711b23-859d-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('2e711b24-859d-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('2e711b25-859d-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('2e711b26-859d-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('2e711b27-859d-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('2e711b28-859d-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('2e711b29-859d-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 07:15:56',1784704556071),('2e711b2a-859d-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('2e711b2b-859d-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 07:15:56',1784704556071),('36cf84c0-8530-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('36cf84c1-8530-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('36cf84c2-8530-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('36cf84c3-8530-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('36cf84c4-8530-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('36cf84c5-8530-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('36cf84c6-8530-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('36cf84c7-8530-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('36cf84c8-8530-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('36cf84c9-8530-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-21 18:15:55',1784657754967),('36cf84ca-8530-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('36cf84cb-8530-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 18:15:55',1784657754967),('395d0568-8588-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('395d0569-8588-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('395d056a-8588-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('395d056b-8588-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('395d056c-8588-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('395d056d-8588-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('395d056e-8588-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('395d056f-8588-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('395d0570-8588-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('395d0571-8588-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',10,'2026-07-22 04:45:55',1784695554963),('395d0572-8588-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('395d0573-8588-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 04:45:55',1784695554963),('3aa4c3a4-85b4-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('3aa4c3a5-85b4-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('3aa4c3a6-85b4-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('3aa4c3a7-85b4-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('3aa4c3a8-85b4-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('3aa4c3a9-85b4-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('3aa4c3aa-85b4-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('3aa4c3ab-85b4-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('3aa4c3ac-85b4-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('3aa4c3ad-85b4-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',14,'2026-07-22 10:00:55',1784714454966),('3aa4c3ae-85b4-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('3aa4c3af-85b4-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 10:00:55',1784714454966),('40135236-84de-11f1-8c8e-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('40135237-84de-11f1-8c8e-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('40135238-84de-11f1-8c8e-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('40135239-84de-11f1-8c8e-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('4013523a-84de-11f1-8c8e-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('4013523b-84de-11f1-8c8e-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('4013523c-84de-11f1-8c8e-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('4013523d-84de-11f1-8c8e-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('4013523e-84de-11f1-8c8e-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('4013523f-84de-11f1-8c8e-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',14,'2026-07-21 08:29:12',1784622551780),('40135240-84de-11f1-8c8e-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('40135241-84de-11f1-8c8e-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551780),('40159c32-84de-11f1-8c8e-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c33-84de-11f1-8c8e-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c34-84de-11f1-8c8e-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c35-84de-11f1-8c8e-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c36-84de-11f1-8c8e-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c37-84de-11f1-8c8e-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c38-84de-11f1-8c8e-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c39-84de-11f1-8c8e-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c3a-84de-11f1-8c8e-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c3b-84de-11f1-8c8e-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c3c-84de-11f1-8c8e-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('40159c3d-84de-11f1-8c8e-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 08:29:12',1784622551796),('41018e90-85b2-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('41018e91-85b2-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('41018e92-85b2-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('41018e93-85b2-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('41018e94-85b2-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('41018e95-85b2-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('41018e96-85b2-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('41018e97-85b2-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('41018e98-85b2-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('41018e99-85b2-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 09:46:47',1784713606648),('41018e9a-85b2-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('41018e9b-85b2-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606648),('4107f73c-85b2-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f73d-85b2-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f73e-85b2-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f73f-85b2-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f740-85b2-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f741-85b2-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f742-85b2-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f743-85b2-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f744-85b2-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f745-85b2-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f746-85b2-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4107f747-85b2-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606690),('4110a9d8-85b2-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9d9-85b2-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9da-85b2-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9db-85b2-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9dc-85b2-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9dd-85b2-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9de-85b2-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9df-85b2-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9e0-85b2-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9e1-85b2-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9e2-85b2-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('4110a9e3-85b2-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 09:46:47',1784713606746),('455342ea-84d9-11f1-8c8e-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('455342eb-84d9-11f1-8c8e-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('455342ec-84d9-11f1-8c8e-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('455342ed-84d9-11f1-8c8e-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('455342ee-84d9-11f1-8c8e-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('455342ef-84d9-11f1-8c8e-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('455342f0-84d9-11f1-8c8e-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('455342f1-84d9-11f1-8c8e-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('455342f2-84d9-11f1-8c8e-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('455342f3-84d9-11f1-8c8e-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',15,'2026-07-21 07:53:33',1784620413104),('455342f4-84d9-11f1-8c8e-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('455342f5-84d9-11f1-8c8e-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 07:53:33',1784620413104),('463887ac-859f-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('463887ad-859f-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('463887ae-859f-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('463887af-859f-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('463887b0-859f-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('463887b1-859f-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('463887b2-859f-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('463887b3-859f-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('463887b4-859f-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('463887b5-859f-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 07:30:55',1784705454959),('463887b6-859f-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('463887b7-859f-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 07:30:55',1784705454959),('4f409ecc-8532-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('4f409ecd-8532-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('4f409ece-8532-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('4f409ecf-8532-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('4f409ed0-8532-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('4f409ed1-8532-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('4f409ed2-8532-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('4f409ed3-8532-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('4f409ed4-8532-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('4f409ed5-8532-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-21 18:30:55',1784658654968),('4f409ed6-8532-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('4f409ed7-8532-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 18:30:55',1784658654968),('51cee2c4-858a-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('51cee2c5-858a-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('51cee2c6-858a-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('51cee2c7-858a-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('51cee2c8-858a-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('51cee2c9-858a-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('51cee2ca-858a-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('51cee2cb-858a-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('51cee2cc-858a-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('51cee2cd-858a-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 05:00:55',1784696454967),('51cee2ce-858a-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('51cee2cf-858a-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 05:00:55',1784696454967),('53147e20-85b6-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('53147e21-85b6-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('53147e22-85b6-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('53147e23-85b6-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('53147e24-85b6-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('53147e25-85b6-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('53147e26-85b6-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('53147e27-85b6-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('53147e28-85b6-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('53147e29-85b6-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 10:15:55',1784715354959),('53147e2a-85b6-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('53147e2b-85b6-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 10:15:55',1784715354959),('67b16ab8-8534-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('67b16ab9-8534-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('67b16aba-8534-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('67b16abb-8534-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('67b16abc-8534-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('67b16abd-8534-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('67b16abe-8534-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('67b16abf-8534-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('67b16ac0-8534-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('67b16ac1-8534-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-21 18:45:55',1784659554967),('67b16ac2-8534-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('67b16ac3-8534-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 18:45:55',1784659554967),('6a407200-858c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('6a407201-858c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('6a407202-858c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('6a407203-858c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('6a407204-858c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('6a407205-858c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('6a407206-858c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('6a407207-858c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('6a407208-858c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('6a407209-858c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 05:15:55',1784697354972),('6a40720a-858c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('6a40720b-858c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 05:15:55',1784697354972),('771bcd34-85a3-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('771bcd35-85a3-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('771bcd36-85a3-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('771bcd37-85a3-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('771bcd38-85a3-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('771bcd39-85a3-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('771bcd3a-85a3-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('771bcd3b-85a3-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('771bcd3c-85a3-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('771bcd3d-85a3-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',4,'2026-07-22 08:00:55',1784707254965),('771bcd3e-85a3-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('771bcd3f-85a3-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 08:00:55',1784707254965),('77330e0d-84f3-11f1-b4aa-94bb4319796b','root-process-instance-start','10.27.192.142$default',1,'2026-07-21 11:01:04',1784631663688),('7733351e-84f3-11f1-b4aa-94bb4319796b','activity-instance-start','10.27.192.142$default',7,'2026-07-21 11:01:04',1784631663688),('7733351f-84f3-11f1-b4aa-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663688),('77333520-84f3-11f1-b4aa-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663688),('77333521-84f3-11f1-b4aa-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663688),('77333522-84f3-11f1-b4aa-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663688),('77333523-84f3-11f1-b4aa-94bb4319796b','activity-instance-end','10.27.192.142$default',7,'2026-07-21 11:01:04',1784631663688),('77333524-84f3-11f1-b4aa-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663688),('77333525-84f3-11f1-b4aa-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663688),('77333526-84f3-11f1-b4aa-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',18,'2026-07-21 11:01:04',1784631663688),('77333527-84f3-11f1-b4aa-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663688),('77333528-84f3-11f1-b4aa-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663688),('77357f19-84f3-11f1-b4aa-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f1a-84f3-11f1-b4aa-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f1b-84f3-11f1-b4aa-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f1c-84f3-11f1-b4aa-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f1d-84f3-11f1-b4aa-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f1e-84f3-11f1-b4aa-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f1f-84f3-11f1-b4aa-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f20-84f3-11f1-b4aa-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f21-84f3-11f1-b4aa-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f22-84f3-11f1-b4aa-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f23-84f3-11f1-b4aa-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77357f24-84f3-11f1-b4aa-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663711),('77377af5-84f3-11f1-b4aa-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a206-84f3-11f1-b4aa-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a207-84f3-11f1-b4aa-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a208-84f3-11f1-b4aa-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a209-84f3-11f1-b4aa-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a20a-84f3-11f1-b4aa-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a20b-84f3-11f1-b4aa-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a20c-84f3-11f1-b4aa-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a20d-84f3-11f1-b4aa-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a20e-84f3-11f1-b4aa-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a20f-84f3-11f1-b4aa-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('7737a210-84f3-11f1-b4aa-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663724),('77394fc1-84f3-11f1-b4aa-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fc2-84f3-11f1-b4aa-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fc3-84f3-11f1-b4aa-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fc4-84f3-11f1-b4aa-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fc5-84f3-11f1-b4aa-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fc6-84f3-11f1-b4aa-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fc7-84f3-11f1-b4aa-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fc8-84f3-11f1-b4aa-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fc9-84f3-11f1-b4aa-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fca-84f3-11f1-b4aa-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fcb-84f3-11f1-b4aa-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('77394fcc-84f3-11f1-b4aa-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663736),('773b248d-84f3-11f1-b4aa-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b248e-84f3-11f1-b4aa-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b248f-84f3-11f1-b4aa-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b2490-84f3-11f1-b4aa-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b2491-84f3-11f1-b4aa-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b2492-84f3-11f1-b4aa-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b2493-84f3-11f1-b4aa-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b2494-84f3-11f1-b4aa-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b2495-84f3-11f1-b4aa-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b2496-84f3-11f1-b4aa-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b2497-84f3-11f1-b4aa-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773b2498-84f3-11f1-b4aa-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663747),('773c8429-84f3-11f1-b4aa-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c842a-84f3-11f1-b4aa-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c842b-84f3-11f1-b4aa-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c842c-84f3-11f1-b4aa-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c842d-84f3-11f1-b4aa-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c842e-84f3-11f1-b4aa-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c842f-84f3-11f1-b4aa-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c8430-84f3-11f1-b4aa-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c8431-84f3-11f1-b4aa-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c8432-84f3-11f1-b4aa-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c8433-84f3-11f1-b4aa-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('773c8434-84f3-11f1-b4aa-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663757),('7741b455-84f3-11f1-b4aa-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b456-84f3-11f1-b4aa-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b457-84f3-11f1-b4aa-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b458-84f3-11f1-b4aa-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b459-84f3-11f1-b4aa-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b45a-84f3-11f1-b4aa-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b45b-84f3-11f1-b4aa-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b45c-84f3-11f1-b4aa-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b45d-84f3-11f1-b4aa-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b45e-84f3-11f1-b4aa-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b45f-84f3-11f1-b4aa-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7741b460-84f3-11f1-b4aa-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663791),('7743b031-84f3-11f1-b4aa-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b032-84f3-11f1-b4aa-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b033-84f3-11f1-b4aa-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b034-84f3-11f1-b4aa-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b035-84f3-11f1-b4aa-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b036-84f3-11f1-b4aa-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b037-84f3-11f1-b4aa-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b038-84f3-11f1-b4aa-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b039-84f3-11f1-b4aa-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b03a-84f3-11f1-b4aa-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b03b-84f3-11f1-b4aa-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7743b03c-84f3-11f1-b4aa-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663804),('7746213d-84f3-11f1-b4aa-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('7746213e-84f3-11f1-b4aa-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('7746213f-84f3-11f1-b4aa-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('77462140-84f3-11f1-b4aa-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('77462141-84f3-11f1-b4aa-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('77462142-84f3-11f1-b4aa-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('77462143-84f3-11f1-b4aa-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('77462144-84f3-11f1-b4aa-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('77462145-84f3-11f1-b4aa-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('77462146-84f3-11f1-b4aa-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('77462147-84f3-11f1-b4aa-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('77462148-84f3-11f1-b4aa-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 11:01:04',1784631663820),('85337724-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',2,'2026-07-21 17:06:32',1784653591517),('85337725-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',14,'2026-07-21 17:06:32',1784653591517),('85337726-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591517),('85337727-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591517),('85337728-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591517),('85337729-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591517),('8533772a-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',14,'2026-07-21 17:06:32',1784653591517),('8533772b-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591517),('8533772c-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591517),('8533772d-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-21 17:06:32',1784653591517),('8533772e-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591517),('8533772f-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591517),('8537bcf0-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcf1-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcf2-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcf3-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcf4-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcf5-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcf6-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcf7-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcf8-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcf9-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcfa-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('8537bcfb-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591546),('853bdbac-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbad-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbae-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbaf-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbb0-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbb1-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbb2-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbb3-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbb4-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbb5-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbb6-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('853bdbb7-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591573),('85402178-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('85402179-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('8540217a-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('8540217b-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('8540217c-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('8540217d-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('8540217e-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('8540217f-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('85402180-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('85402181-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('85402182-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('85402183-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591602),('8541f644-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f645-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f646-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f647-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f648-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f649-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f64a-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f64b-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f64c-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f64d-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f64e-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('8541f64f-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591614),('85450390-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('85450391-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('85450392-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('85450393-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('85450394-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('85450395-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('85450396-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('85450397-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('85450398-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('85450399-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('8545039a-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('8545039b-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591633),('85463c1c-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c1d-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c1e-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c1f-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c20-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c21-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c22-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c23-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c24-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c25-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c26-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('85463c27-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591642),('8547c2c8-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2c9-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2ca-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2cb-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2cc-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2cd-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2ce-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2cf-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2d0-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2d1-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2d2-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8547c2d3-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591651),('8548d444-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d445-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d446-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d447-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d448-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d449-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d44a-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d44b-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d44c-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d44d-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d44e-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('8548d44f-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591659),('854af730-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854af731-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854af732-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854af733-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854af734-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854af735-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854af736-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854b1e47-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854b1e48-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854b1e49-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854b1e4a-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854b1e4b-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591673),('854d1a1c-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a1d-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a1e-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a1f-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a20-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a21-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a22-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a23-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a24-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a25-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a26-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('854d1a27-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591687),('85504e78-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e79-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e7a-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e7b-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e7c-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e7d-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e7e-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e7f-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e80-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e81-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e82-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('85504e83-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591707),('8553a9e4-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9e5-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9e6-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9e7-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9e8-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9e9-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9ea-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9eb-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9ec-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9ed-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9ee-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('8553a9ef-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591729),('85557eb0-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557eb1-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557eb2-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557eb3-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557eb4-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557eb5-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557eb6-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557eb7-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557eb8-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557eb9-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557eba-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('85557ebb-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591741),('8556691c-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('8556691d-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('8556691e-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('8556691f-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('85566920-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('85566921-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('85566922-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('85566923-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('85566924-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('85566925-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('85566926-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('85566927-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591748),('85588c08-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c09-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c0a-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c0b-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c0c-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c0d-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c0e-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c0f-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c10-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c11-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c12-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('85588c13-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591762),('8559eba4-8526-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559eba5-8526-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559eba6-8526-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559eba7-8526-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559eba8-8526-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559eba9-8526-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559ebaa-8526-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559ebab-8526-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559ebac-8526-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559ebad-8526-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559ebae-8526-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('8559ebaf-8526-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:06:32',1784653591771),('88996288-8599-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('88996289-8599-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('8899628a-8599-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('8899628b-8599-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('8899628c-8599-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('8899628d-8599-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('8899628e-8599-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('8899628f-8599-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('88996290-8599-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('88996291-8599-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',9,'2026-07-22 06:49:49',1784702989343),('88996292-8599-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('88996293-8599-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 06:49:49',1784702989343),('8e1f9d59-8398-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8e1fc46a-8398-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8e1fc46b-8398-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8e1fc46c-8398-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8e1fc46d-8398-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8e1fc46e-8398-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8e1fc46f-8398-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8e1fc470-8398-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8e1fc471-8398-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8e1fc472-8398-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',11,'2026-07-19 23:07:47',1784482666790),('8e1fc473-8398-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8e1fc474-8398-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 23:07:47',1784482666790),('8f8c9920-85a5-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('8f8c9921-85a5-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('8f8c9922-85a5-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('8f8c9923-85a5-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('8f8c9924-85a5-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('8f8c9925-85a5-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('8f8c9926-85a5-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('8f8c9927-85a5-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('8f8c9928-85a5-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('8f8c9929-85a5-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 08:15:55',1784708154964),('8f8c992a-85a5-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('8f8c992b-85a5-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 08:15:55',1784708154964),('9209f3ef-833f-11f1-adaf-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('920a4210-833f-11f1-adaf-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('920a4211-833f-11f1-adaf-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('920a4212-833f-11f1-adaf-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('920a4213-833f-11f1-adaf-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('920a4214-833f-11f1-adaf-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('920a4215-833f-11f1-adaf-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('920a4216-833f-11f1-adaf-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('920a4217-833f-11f1-adaf-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('920a4218-833f-11f1-adaf-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',18,'2026-07-19 12:30:48',1784444448145),('920a4219-833f-11f1-adaf-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('920a421a-833f-11f1-adaf-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 12:30:48',1784444448145),('9838de7c-858e-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9838de7d-858e-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9838de7e-858e-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9838de7f-858e-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9838de80-858e-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9838de81-858e-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9838de82-858e-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9838de83-858e-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9838de84-858e-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9838de85-858e-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 05:31:31',1784698291091),('9838de86-858e-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9838de87-858e-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 05:31:31',1784698291091),('9b20aa48-8590-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('9b20aa49-8590-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('9b20aa4a-8590-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('9b20aa4b-8590-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('9b20aa4c-8590-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('9b20aa4d-8590-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('9b20aa4e-8590-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('9b20aa4f-8590-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('9b20aa50-8590-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('9b20aa51-8590-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',14,'2026-07-22 05:45:55',1784699154959),('9b20aa52-8590-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('9b20aa53-8590-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 05:45:55',1784699154959),('a7fd16ec-85a7-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('a7fd16ed-85a7-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('a7fd16ee-85a7-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('a7fd16ef-85a7-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('a7fd16f0-85a7-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('a7fd16f1-85a7-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('a7fd16f2-85a7-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('a7fd16f3-85a7-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('a7fd16f4-85a7-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('a7fd16f5-85a7-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 08:30:55',1784709054960),('a7fd16f6-85a7-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('a7fd16f7-85a7-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 08:30:55',1784709054960),('ae65fd5d-8383-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae65fd5e-8383-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae65fd5f-8383-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae65fd60-8383-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae65fd61-8383-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae65fd62-8383-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae65fd63-8383-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae65fd64-8383-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae65fd65-8383-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae65fd66-8383-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',15,'2026-07-19 20:38:22',1784473701505),('ae65fd67-8383-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae65fd68-8383-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701505),('ae6a6a39-8383-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a3a-8383-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a3b-8383-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a3c-8383-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a3d-8383-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a3e-8383-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a3f-8383-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a40-8383-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a41-8383-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a42-8383-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a43-8383-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6a6a44-8383-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701534),('ae6dc5a5-8383-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5a6-8383-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5a7-8383-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5a8-8383-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5a9-8383-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5aa-8383-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5ab-8383-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5ac-8383-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5ad-8383-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5ae-8383-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5af-8383-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6dc5b0-8383-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701557),('ae6fe891-8383-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036b2-8383-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036b3-8383-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036b4-8383-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036b5-8383-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036b6-8383-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036b7-8383-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036b8-8383-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036b9-8383-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036ba-8383-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036bb-8383-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae7036bc-8383-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701572),('ae72a7bd-8383-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7be-8383-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7bf-8383-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7c0-8383-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7c1-8383-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7c2-8383-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7c3-8383-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7c4-8383-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7c5-8383-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7c6-8383-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7c7-8383-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae72a7c8-8383-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701589),('ae753fd9-8383-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fda-8383-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fdb-8383-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fdc-8383-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fdd-8383-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fde-8383-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fdf-8383-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fe0-8383-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fe1-8383-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fe2-8383-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fe3-8383-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae753fe4-8383-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701605),('ae7789d5-8383-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789d6-8383-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789d7-8383-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789d8-8383-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789d9-8383-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789da-8383-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789db-8383-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789dc-8383-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789dd-8383-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789de-8383-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789df-8383-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7789e0-8383-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701621),('ae7a7011-8383-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a7012-8383-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a7013-8383-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a9724-8383-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a9725-8383-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a9726-8383-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a9727-8383-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a9728-8383-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a9729-8383-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a972a-8383-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a972b-8383-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('ae7a972c-8383-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 20:38:22',1784473701640),('b226c45d-8385-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b226c45e-8385-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b226c45f-8385-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b226c460-8385-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b226c461-8385-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b226c462-8385-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b226c463-8385-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b226c464-8385-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b226c465-8385-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b226c466-8385-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',15,'2026-07-19 20:52:47',1784474566796),('b226c467-8385-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b226c468-8385-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 20:52:47',1784474566796),('b704a1a1-838c-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b704a1a2-838c-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b704a1a3-838c-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b704a1a4-838c-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b704a1a5-838c-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b704a1a6-838c-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b704a1a7-838c-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b704a1a8-838c-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b704a1a9-838c-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b704a1aa-838c-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',15,'2026-07-19 21:43:01',1784477581437),('b704a1ab-838c-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b704a1ac-838c-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 21:43:01',1784477581437),('b9aa6ff9-84f3-11f1-b4aa-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('b9aa6ffa-84f3-11f1-b4aa-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('b9aa6ffb-84f3-11f1-b4aa-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('b9aa6ffc-84f3-11f1-b4aa-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('b9aa6ffd-84f3-11f1-b4aa-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('b9aa6ffe-84f3-11f1-b4aa-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('b9aa6fff-84f3-11f1-b4aa-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('b9aa7000-84f3-11f1-b4aa-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('b9aa7001-84f3-11f1-b4aa-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('b9aa7002-84f3-11f1-b4aa-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',2,'2026-07-21 11:02:55',1784631775206),('b9aa7003-84f3-11f1-b4aa-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('b9aa7004-84f3-11f1-b4aa-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 11:02:55',1784631775206),('bc34c8e9-8389-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bc34c8ea-8389-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bc34c8eb-8389-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bc34c8ec-8389-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bc34c8ed-8389-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bc34c8ee-8389-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bc34c8ef-8389-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bc34c8f0-8389-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bc34c8f1-8389-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bc34c8f2-8389-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',15,'2026-07-19 21:21:42',1784476301652),('bc34c8f3-8389-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bc34c8f4-8389-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 21:21:42',1784476301652),('bdbb4ab5-8370-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bdbb4ab6-8370-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bdbb4ab7-8370-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bdbb4ab8-8370-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bdbb4ab9-8370-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bdbb71ca-8370-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bdbb71cb-8370-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bdbb71cc-8370-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bdbb71cd-8370-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bdbb71ce-8370-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',18,'2026-07-19 18:22:47',1784465566789),('bdbb71cf-8370-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bdbb71d0-8370-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 18:22:47',1784465566789),('bf26e7ec-857d-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('bf26e7ed-857d-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('bf26e7ee-857d-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('bf26e7ef-857d-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('bf26e7f0-857d-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('bf26e7f1-857d-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('bf26e7f2-857d-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('bf26e7f3-857d-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('bf26e7f4-857d-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('bf26e7f5-857d-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',5,'2026-07-22 03:30:55',1784691054960),('bf26e7f6-857d-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('bf26e7f7-857d-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:30:55',1784691054960),('c06ecd38-85a9-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c06ecd39-85a9-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c06ecd3a-85a9-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c06ecd3b-85a9-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c06ecd3c-85a9-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c06ecd3d-85a9-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c06ecd3e-85a9-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c06ecd3f-85a9-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c06ecd40-85a9-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c06ecd41-85a9-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 08:45:55',1784709954963),('c06ecd42-85a9-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c06ecd43-85a9-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 08:45:55',1784709954963),('c59ed8c5-839a-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c59ed8c6-839a-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c59ed8c7-839a-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c59ed8c8-839a-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c59ed8c9-839a-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c59ed8ca-839a-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c59ed8cb-839a-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c59ed8cc-839a-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c59ed8cd-839a-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c59ed8ce-839a-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',15,'2026-07-19 23:23:39',1784483618889),('c59ed8cf-839a-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c59ed8d0-839a-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 23:23:39',1784483618889),('c76e4cf4-8592-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('c76e4cf5-8592-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('c76e4cf6-8592-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('c76e4cf7-8592-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('c76e4cf8-8592-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('c76e4cf9-8592-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('c76e4cfa-8592-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('c76e4cfb-8592-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('c76e4cfc-8592-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('c76e4cfd-8592-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 06:01:28',1784700088280),('c76e4cfe-8592-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('c76e4cff-8592-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 06:01:28',1784700088280),('cc02b750-8594-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc02b751-8594-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc02b752-8594-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc02b753-8594-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc02b754-8594-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc02b755-8594-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc02b756-8594-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc02b757-8594-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc02b758-8594-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc02b759-8594-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',14,'2026-07-22 06:15:55',1784700954958),('cc02b75a-8594-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc02b75b-8594-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 06:15:55',1784700954958),('cc64cd2c-8597-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('cc64cd2d-8597-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('cc64cd2e-8597-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('cc64cd2f-8597-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('cc64cd30-8597-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('cc64cd31-8597-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('cc64cd32-8597-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('cc64cd33-8597-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('cc64cd34-8597-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('cc64cd35-8597-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 06:37:24',1784702244091),('cc64cd36-8597-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('cc64cd37-8597-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 06:37:24',1784702244091),('d3c29be4-84fb-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d3c29be5-84fb-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d3c29be6-84fb-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d3c29be7-84fb-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d3c29be8-84fb-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d3c29be9-84fb-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d3c29bea-84fb-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d3c29beb-84fb-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d3c29bec-84fb-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d3c29bed-84fb-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',18,'2026-07-21 12:00:55',1784635254958),('d3c29bee-84fb-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d3c2c2ff-84fb-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 12:00:55',1784635254958),('d50bb8d0-8527-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d50bb8d1-8527-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d50bb8d2-8527-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d50bb8d3-8527-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d50bb8d4-8527-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d50bb8d5-8527-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d50bb8d6-8527-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d50bb8d7-8527-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d50bb8d8-8527-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d50bb8d9-8527-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',10,'2026-07-21 17:15:55',1784654154972),('d50bb8da-8527-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d50bb8db-8527-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:15:55',1784654154972),('d5ce7d71-8339-11f1-a713-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d5ce7d72-8339-11f1-a713-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d5ce7d73-8339-11f1-a713-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d5ce7d74-8339-11f1-a713-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d5ce7d75-8339-11f1-a713-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d5ce7d76-8339-11f1-a713-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d5ce7d77-8339-11f1-a713-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d5ce7d78-8339-11f1-a713-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d5ce7d79-8339-11f1-a713-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d5ce7d7a-8339-11f1-a713-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',18,'2026-07-19 11:49:45',1784441984863),('d5ce7d7b-8339-11f1-a713-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d5ce7d7c-8339-11f1-a713-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 11:49:45',1784441984863),('d62bef91-8372-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d62bef92-8372-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d62bef93-8372-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d62bef94-8372-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d62bef95-8372-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d62bef96-8372-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d62c16a7-8372-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d62c16a8-8372-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d62c16a9-8372-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d62c16aa-8372-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',15,'2026-07-19 18:37:47',1784466466789),('d62c16ab-8372-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d62c16ac-8372-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 18:37:47',1784466466789),('d7993a78-857f-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d7993a79-857f-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d7993a7a-857f-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d7993a7b-857f-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d7993a7c-857f-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d7993a7d-857f-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d7993a7e-857f-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d7993a7f-857f-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d7993a80-857f-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d7993a81-857f-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 03:45:55',1784691954966),('d7993a82-857f-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d7993a83-857f-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:45:55',1784691954966),('d8ded5d4-85ab-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('d8ded5d5-85ab-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('d8ded5d6-85ab-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('d8ded5d7-85ab-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('d8ded5d8-85ab-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('d8ded5d9-85ab-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('d8ded5da-85ab-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('d8ded5db-85ab-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('d8ded5dc-85ab-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('d8ded5dd-85ab-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 09:00:55',1784710854958),('d8ded5de-85ab-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('d8ded5df-85ab-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 09:00:55',1784710854958),('dba186c9-83a3-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba186ca-83a3-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba186cb-83a3-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba186cc-83a3-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba186cd-83a3-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba186ce-83a3-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba186cf-83a3-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba186d0-83a3-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba186d1-83a3-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba186d2-83a3-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',13,'2026-07-20 00:28:41',1784487521289),('dba186d3-83a3-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba186d4-83a3-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521289),('dba49415-83a3-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba49416-83a3-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba49417-83a3-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba49418-83a3-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba49419-83a3-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba4941a-83a3-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba4941b-83a3-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba4941c-83a3-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba4941d-83a3-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba4941e-83a3-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba4941f-83a3-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('dba49420-83a3-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-20 00:28:41',1784487521309),('de5d1ae2-84d5-11f1-8c8e-94bb4319796b','root-process-instance-start','10.27.192.142$default',1,'2026-07-21 07:29:12',1784618951872),('de5d1ae3-84d5-11f1-8c8e-94bb4319796b','activity-instance-start','10.27.192.142$default',7,'2026-07-21 07:29:12',1784618951872),('de5d1ae4-84d5-11f1-8c8e-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-21 07:29:12',1784618951872),('de5d1ae5-84d5-11f1-8c8e-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-21 07:29:12',1784618951872),('de5d1ae6-84d5-11f1-8c8e-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-21 07:29:12',1784618951872),('de5d1ae7-84d5-11f1-8c8e-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-21 07:29:12',1784618951872),('de5d1ae8-84d5-11f1-8c8e-94bb4319796b','activity-instance-end','10.27.192.142$default',7,'2026-07-21 07:29:12',1784618951872),('de5d1ae9-84d5-11f1-8c8e-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-21 07:29:12',1784618951872),('de5d1aea-84d5-11f1-8c8e-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-21 07:29:12',1784618951872),('de5d1aeb-84d5-11f1-8c8e-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',18,'2026-07-21 07:29:12',1784618951872),('de5d1aec-84d5-11f1-8c8e-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-21 07:29:12',1784618951872),('de5d1aed-84d5-11f1-8c8e-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-21 07:29:12',1784618951872),('e3091f85-8389-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e3091f86-8389-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e3091f87-8389-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e3091f88-8389-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e3091f89-8389-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e3091f8a-8389-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e3091f8b-8389-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e3091f8c-8389-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e3091f8d-8389-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e3091f8e-8389-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',1,'2026-07-19 21:22:47',1784476366796),('e3091f8f-8389-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e3091f90-8389-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 21:22:47',1784476366796),('e6bc7bb0-8586-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6bc7bb1-8586-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6bc7bb2-8586-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6bc7bb3-8586-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6bc7bb4-8586-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6bc7bb5-8586-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6bc7bb6-8586-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6bc7bb7-8586-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6bc7bb8-8586-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6bc7bb9-8586-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 04:36:27',1784694986840),('e6bc7bba-8586-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6bc7bbb-8586-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986840),('e6c1f9fc-8586-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1f9fd-8586-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1f9fe-8586-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1f9ff-8586-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1fa00-8586-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1fa01-8586-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1fa02-8586-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1fa03-8586-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1fa04-8586-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1fa05-8586-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1fa06-8586-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('e6c1fa07-8586-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 04:36:27',1784694986877),('eaa85483-84f5-11f1-8baf-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716388),('eaa87b94-84f5-11f1-8baf-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716389),('eaa87b95-84f5-11f1-8baf-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716389),('eaa87b96-84f5-11f1-8baf-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716389),('eaa87b97-84f5-11f1-8baf-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716389),('eaa87b98-84f5-11f1-8baf-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716389),('eaa87b99-84f5-11f1-8baf-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716389),('eaa87b9a-84f5-11f1-8baf-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716389),('eaa87b9b-84f5-11f1-8baf-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716389),('eaa87b9c-84f5-11f1-8baf-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',18,'2026-07-21 11:18:36',1784632716389),('eaa87b9d-84f5-11f1-8baf-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716389),('eaa87b9e-84f5-11f1-8baf-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 11:18:36',1784632716389),('eabda541-839c-11f1-8311-94bb4319796b','root-process-instance-start','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('eabda542-839c-11f1-8311-94bb4319796b','activity-instance-start','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('eabda543-839c-11f1-8311-94bb4319796b','job-acquired-failure','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('eabda544-839c-11f1-8311-94bb4319796b','job-locked-exclusive','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('eabda545-839c-11f1-8311-94bb4319796b','job-execution-rejected','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('eabda546-839c-11f1-8311-94bb4319796b','executed-decision-elements','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('eabda547-839c-11f1-8311-94bb4319796b','activity-instance-end','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('eabda548-839c-11f1-8311-94bb4319796b','job-successful','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('eabda549-839c-11f1-8311-94bb4319796b','job-acquired-success','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('eabda54a-839c-11f1-8311-94bb4319796b','job-acquisition-attempt','10.27.192.142$default',14,'2026-07-19 23:39:00',1784484540160),('eabda54b-839c-11f1-8311-94bb4319796b','executed-decision-instances','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('eabda54c-839c-11f1-8311-94bb4319796b','job-failed','10.27.192.142$default',0,'2026-07-19 23:39:00',1784484540160),('ec347940-84fd-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ec347941-84fd-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ec347942-84fd-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ec347943-84fd-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ec347944-84fd-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ec347945-84fd-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ec347946-84fd-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ec347947-84fd-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ec347948-84fd-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ec34c769-84fd-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-21 12:15:55',1784636154965),('ec34c76a-84fd-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ec34c76b-84fd-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 12:15:55',1784636154965),('ed7b9a5c-8529-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('ed7bc16d-8529-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('ed7bc16e-8529-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('ed7bc16f-8529-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('ed7bc170-8529-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('ed7bc171-8529-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('ed7bc172-8529-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('ed7bc173-8529-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('ed7bc174-8529-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('ed7bc175-8529-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-21 17:30:55',1784655054964),('ed7bc176-8529-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('ed7bc177-8529-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-21 17:30:55',1784655054964),('f0096924-8581-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f0096925-8581-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f0096926-8581-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f0096927-8581-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f0096928-8581-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f0096929-8581-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f009692a-8581-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f009692b-8581-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f009692c-8581-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f009692d-8581-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 04:00:55',1784692854961),('f009692e-8581-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f009692f-8581-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 04:00:55',1784692854961),('f6d8fae4-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6d8fae5-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6d8fae6-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6d8fae7-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6d8fae8-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6d8fae9-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6d8faea-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6d8faeb-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6d8faec-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6d8faed-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 03:25:19',1784690718904),('f6d8faee-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6d8faef-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718904),('f6dcf290-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf291-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf292-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf293-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf294-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf295-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf296-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf297-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf298-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf299-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf29a-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6dcf29b-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718930),('f6e04dfc-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04dfd-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04dfe-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04dff-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04e00-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04e01-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04e02-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04e03-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04e04-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04e05-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04e06-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e04e07-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718951),('f6e30d28-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d29-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d2a-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d2b-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d2c-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d2d-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d2e-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d2f-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d30-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d31-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d32-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e30d33-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718970),('f6e64184-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e64185-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e64186-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e64187-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e64188-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e64189-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e6418a-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e6418b-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e6418c-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e6418d-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e6418e-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e6418f-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690718991),('f6e975e0-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975e1-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975e2-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975e3-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975e4-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975e5-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975e6-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975e7-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975e8-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975e9-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975ea-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6e975eb-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719012),('f6ed1f6c-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f6d-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f6e-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f6f-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f70-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f71-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f72-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f73-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f74-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f75-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f76-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6ed1f77-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719036),('f6f02cb8-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cb9-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cba-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cbb-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cbc-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cbd-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cbe-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cbf-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cc0-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cc1-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cc2-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f02cc3-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719057),('f6f3d644-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d645-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d646-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d647-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d648-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d649-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d64a-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d64b-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d64c-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d64d-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d64e-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f3d64f-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719080),('f6f66e60-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e61-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e62-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e63-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e64-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e65-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e66-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e67-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e68-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e69-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e6a-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f66e6b-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719098),('f6f8df6c-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df6d-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df6e-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df6f-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df70-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df71-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df72-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df73-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df74-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df75-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df76-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6f8df77-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719113),('f6fb2968-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb2969-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb296a-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb296b-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb296c-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb296d-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb296e-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb296f-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb2970-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb2971-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb2972-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fb2973-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719129),('f6fde894-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde895-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde896-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde897-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde898-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde899-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde89a-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde89b-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde89c-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde89d-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde89e-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f6fde89f-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719146),('f7040320-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f7040321-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f7040322-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f7040323-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f7040324-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f7040325-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f7040326-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f7040327-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f7040328-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f7040329-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f704032a-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f704032b-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719186),('f707106c-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f707106d-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f707106e-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f707106f-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f7071070-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f7071071-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f7071072-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f7071073-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f7071074-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f7071075-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f7071076-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f7071077-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719206),('f709a788-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a789-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a78a-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a78b-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a78c-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a78d-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a78e-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a78f-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a790-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a791-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a792-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f709a793-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719224),('f70cb4d4-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4d5-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4d6-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4d7-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4d8-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4d9-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4da-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4db-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4dc-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4dd-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4de-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f70cb4df-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719243),('f710ac80-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac81-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac82-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac83-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac84-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac85-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac86-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac87-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac88-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac89-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac8a-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f710ac8b-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719269),('f713449c-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f713449d-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f713449e-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f713449f-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f71344a0-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f71344a1-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f71344a2-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f71344a3-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f71344a4-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f71344a5-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f71344a6-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f71344a7-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719287),('f7151968-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f7151969-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f715196a-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f715196b-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f715196c-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f715196d-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f715196e-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f715196f-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f7151970-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f7151971-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f7151972-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f7151973-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719298),('f7171544-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f7171545-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f7171546-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f7171547-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f7171548-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f7171549-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f717154a-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f717154b-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f717154c-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f717154d-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f717154e-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f717154f-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719310),('f7191120-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f7191121-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f7191122-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f7191123-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f7191124-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f7191125-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f7191126-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f7193837-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f7193838-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f7193839-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f719383a-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f719383b-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719325),('f71b0cfc-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0cfd-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0cfe-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0cff-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0d00-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0d01-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0d02-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0d03-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0d04-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0d05-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0d06-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71b0d07-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719337),('f71ce1c8-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1c9-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1ca-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1cb-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1cc-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1cd-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1ce-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1cf-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1d0-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1d1-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1d2-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71ce1d3-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719349),('f71e6874-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e6875-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e6876-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e6877-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e6878-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e6879-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e687a-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e687b-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e687c-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e687d-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e687e-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71e687f-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719358),('f71fef20-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef21-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef22-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef23-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef24-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef25-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef26-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef27-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef28-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef29-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef2a-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f71fef2b-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719370),('f722120c-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f722120d-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f722120e-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f722120f-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f7221210-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f7221211-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f7221212-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f7221213-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f7221214-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f7221215-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f7221216-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f7221217-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719383),('f7254668-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f7254669-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f725466a-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f725466b-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f725466c-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f725466d-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f725466e-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f725466f-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f7254670-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f7254671-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f7254672-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f7254673-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719403),('f7287ac4-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287ac5-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287ac6-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287ac7-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287ac8-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287ac9-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287aca-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287acb-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287acc-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287acd-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287ace-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f7287acf-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719425),('f72b8810-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b8811-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b8812-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b8813-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b8814-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b8815-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b8816-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b8817-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b8818-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b8819-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b881a-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72b881b-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719446),('f72dd20c-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd20d-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd20e-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd20f-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd210-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd211-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd212-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd213-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd214-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd215-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd216-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72dd217-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719460),('f72fa6d8-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6d9-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6da-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6db-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6dc-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6dd-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6de-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6df-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6e0-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6e1-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6e2-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f72fa6e3-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719473),('f7323ef4-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323ef5-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323ef6-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323ef7-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323ef8-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323ef9-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323efa-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323efb-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323efc-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323efd-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323efe-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f7323eff-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:19',1784690719489),('f736f9f0-857c-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9f1-857c-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9f2-857c-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9f3-857c-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9f4-857c-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9f5-857c-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9f6-857c-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9f7-857c-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9f8-857c-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9f9-857c-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9fa-857c-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('f736f9fb-857c-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 03:25:20',1784690719521),('fa435a28-85a2-11f1-92ac-94bb4319796b','root-process-instance-start','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509),('fa435a29-85a2-11f1-92ac-94bb4319796b','activity-instance-start','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509),('fa435a2a-85a2-11f1-92ac-94bb4319796b','job-acquired-failure','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509),('fa435a2b-85a2-11f1-92ac-94bb4319796b','job-locked-exclusive','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509),('fa435a2c-85a2-11f1-92ac-94bb4319796b','job-execution-rejected','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509),('fa435a2d-85a2-11f1-92ac-94bb4319796b','executed-decision-elements','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509),('fa435a2e-85a2-11f1-92ac-94bb4319796b','activity-instance-end','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509),('fa435a2f-85a2-11f1-92ac-94bb4319796b','job-successful','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509),('fa435a30-85a2-11f1-92ac-94bb4319796b','job-acquired-success','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509),('fa435a31-85a2-11f1-92ac-94bb4319796b','job-acquisition-attempt','192.168.88.21$default',15,'2026-07-22 07:57:26',1784707045509),('fa435a32-85a2-11f1-92ac-94bb4319796b','executed-decision-instances','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509),('fa435a33-85a2-11f1-92ac-94bb4319796b','job-failed','192.168.88.21$default',0,'2026-07-22 07:57:26',1784707045509);
/*!40000 ALTER TABLE `act_ru_meter_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_task`
--

DROP TABLE IF EXISTS `act_ru_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_task` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `PARENT_TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_DEF_KEY_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `OWNER_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `ASSIGNEE_` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `DELEGATION_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PRIORITY_` int DEFAULT NULL,
  `CREATE_TIME_` datetime DEFAULT NULL,
  `LAST_UPDATED_` datetime DEFAULT NULL,
  `DUE_DATE_` datetime DEFAULT NULL,
  `FOLLOW_UP_DATE_` datetime DEFAULT NULL,
  `SUSPENSION_STATE_` int DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_TASK_CREATE` (`CREATE_TIME_`),
  KEY `ACT_IDX_TASK_LAST_UPDATED` (`LAST_UPDATED_`),
  KEY `ACT_IDX_TASK_ASSIGNEE` (`ASSIGNEE_`),
  KEY `ACT_IDX_TASK_OWNER` (`OWNER_`),
  KEY `ACT_IDX_TASK_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_FK_TASK_EXE` (`EXECUTION_ID_`),
  KEY `ACT_FK_TASK_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_TASK_PROCDEF` (`PROC_DEF_ID_`),
  KEY `ACT_FK_TASK_CASE_EXE` (`CASE_EXECUTION_ID_`),
  KEY `ACT_FK_TASK_CASE_DEF` (`CASE_DEF_ID_`),
  CONSTRAINT `ACT_FK_TASK_CASE_DEF` FOREIGN KEY (`CASE_DEF_ID_`) REFERENCES `act_re_case_def` (`ID_`),
  CONSTRAINT `ACT_FK_TASK_CASE_EXE` FOREIGN KEY (`CASE_EXECUTION_ID_`) REFERENCES `act_ru_case_execution` (`ID_`),
  CONSTRAINT `ACT_FK_TASK_EXE` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_TASK_PROCDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_TASK_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_task`
--

LOCK TABLES `act_ru_task` WRITE;
/*!40000 ALTER TABLE `act_ru_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_task_meter_log`
--

DROP TABLE IF EXISTS `act_ru_task_meter_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_task_meter_log` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `ASSIGNEE_HASH_` bigint DEFAULT NULL,
  `TIMESTAMP_` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_TASK_METER_LOG_TIME` (`TIMESTAMP_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_task_meter_log`
--

LOCK TABLES `act_ru_task_meter_log` WRITE;
/*!40000 ALTER TABLE `act_ru_task_meter_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_task_meter_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `act_ru_variable`
--

DROP TABLE IF EXISTS `act_ru_variable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `act_ru_variable` (
  `ID_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `NAME_` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_EXECUTION_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `CASE_INST_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `BATCH_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8mb3_bin DEFAULT NULL,
  `VAR_SCOPE_` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `SEQUENCE_COUNTER_` bigint DEFAULT NULL,
  `IS_CONCURRENT_LOCAL_` tinyint DEFAULT NULL,
  `TENANT_ID_` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_UNIQ_VARIABLE` (`VAR_SCOPE_`,`NAME_`),
  KEY `ACT_IDX_VARIABLE_TASK_ID` (`TASK_ID_`),
  KEY `ACT_IDX_VARIABLE_TENANT_ID` (`TENANT_ID_`),
  KEY `ACT_IDX_VARIABLE_TASK_NAME_TYPE` (`TASK_ID_`,`NAME_`,`TYPE_`),
  KEY `ACT_FK_VAR_EXE` (`EXECUTION_ID_`),
  KEY `ACT_FK_VAR_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_VAR_BYTEARRAY` (`BYTEARRAY_ID_`),
  KEY `ACT_IDX_BATCH_ID` (`BATCH_ID_`),
  KEY `ACT_FK_VAR_CASE_EXE` (`CASE_EXECUTION_ID_`),
  KEY `ACT_FK_VAR_CASE_INST` (`CASE_INST_ID_`),
  CONSTRAINT `ACT_FK_VAR_BATCH` FOREIGN KEY (`BATCH_ID_`) REFERENCES `act_ru_batch` (`ID_`),
  CONSTRAINT `ACT_FK_VAR_BYTEARRAY` FOREIGN KEY (`BYTEARRAY_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_VAR_CASE_EXE` FOREIGN KEY (`CASE_EXECUTION_ID_`) REFERENCES `act_ru_case_execution` (`ID_`),
  CONSTRAINT `ACT_FK_VAR_CASE_INST` FOREIGN KEY (`CASE_INST_ID_`) REFERENCES `act_ru_case_execution` (`ID_`),
  CONSTRAINT `ACT_FK_VAR_EXE` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_VAR_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `act_ru_variable`
--

LOCK TABLES `act_ru_variable` WRITE;
/*!40000 ALTER TABLE `act_ru_variable` DISABLE KEYS */;
/*!40000 ALTER TABLE `act_ru_variable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deliveries`
--

DROP TABLE IF EXISTS `deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deliveries` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `delivered_at` datetime(6) DEFAULT NULL,
  `driver_name` varchar(255) DEFAULT NULL,
  `order_id` bigint NOT NULL,
  `status` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deliveries`
--

LOCK TABLES `deliveries` WRITE;
/*!40000 ALTER TABLE `deliveries` DISABLE KEYS */;
INSERT INTO `deliveries` VALUES (1,'2026-07-21 07:10:22.647401','2026-07-21 07:10:22.647401','Raj Kumar',7,'DELIVERED'),(2,'2026-07-21 08:34:48.960349','2026-07-21 08:34:48.960349','Deepa Nair',8,'DELIVERED'),(3,'2026-07-21 12:49:15.140279','2026-07-21 12:49:15.140279','Priya Sharma',9,'DELIVERED'),(4,'2026-07-21 12:50:18.397495','2026-07-21 12:50:18.397495','Amit Singh',10,'DELIVERED');
/*!40000 ALTER TABLE `deliveries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_items`
--

DROP TABLE IF EXISTS `food_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `image_url` varchar(1000) DEFAULT NULL,
  `is_available` bit(1) NOT NULL,
  `is_veg` bit(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `restaurant_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1f3re9f14rtkoyghyuhx3cv9l` (`restaurant_id`),
  CONSTRAINT `FK1f3re9f14rtkoyghyuhx3cv9l` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_items`
--

LOCK TABLES `food_items` WRITE;
/*!40000 ALTER TABLE `food_items` DISABLE KEYS */;
INSERT INTO `food_items` VALUES (1,'Pizza','Classic tomato sauce, fresh mozzarella, and aromatic basil leaves.','https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=300&q=80',_binary '',_binary '','Margherita Pizza',249,1),(2,'Pizza','Generous double pepperoni slices with stringy fresh mozzarella cheese.','https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=300&q=80',_binary '',_binary '\0','Pepperoni Pizza',349,1),(3,'Starters','Baked fresh daily with home-churned garlic butter and cheese dip.','https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?w=300&q=80',_binary '',_binary '','Garlic Bread Sticks',129,1),(4,'Burger','Flame-grilled single patty with lettuce, tomato, house pickles, and bistro sauce.','https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&q=80',_binary '',_binary '\0','Classic Beef Burger',189,2),(5,'Burger','Spicy mashed potato & pea crispy patty loaded with liquid cheese dressing.','https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=300&q=80',_binary '',_binary '','Crunchy Veggie Burger',149,2),(6,'Starters','Double fried potato fries topped with warm jalapeno liquid cheese.','https://images.unsplash.com/photo-1576107232684-1279f390859f?w=300&q=80',_binary '',_binary '','Loaded Cheese Fries',119,2),(7,'Biryani','Served with 2 pieces of juicy chicken, boiled egg, spiced salan, and raita.','https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=300&q=80',_binary '',_binary '\0','Special Chicken Biryani',279,3),(8,'Biryani','Perfect blend of fresh cottage cheese cubes, saffron basmati rice, and mint garnish.','https://images.unsplash.com/photo-1633945274405-b6c8069047b0?w=300&q=80',_binary '',_binary '','Paneer Dum Biryani',239,3),(9,'Dessert','Dense fudge brownie loaded with dark chocolate chunks.','https://images.unsplash.com/photo-1564355808539-22fda35bed7e?w=300&q=80',_binary '',_binary '','Chocolate Brownie',89,3);
/*!40000 ALTER TABLE `food_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `google_accounts`
--

DROP TABLE IF EXISTS `google_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `google_accounts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `access_token` varchar(2000) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `expires_at` datetime(6) DEFAULT NULL,
  `google_id` varchar(255) NOT NULL,
  `refresh_token` varchar(2000) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKn83mh0jqffir44l37xe19bomm` (`user_id`),
  CONSTRAINT `FKhl5jqeo11rg841r17n7veo69v` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `google_accounts`
--

LOCK TABLES `google_accounts` WRITE;
/*!40000 ALTER TABLE `google_accounts` DISABLE KEYS */;
INSERT INTO `google_accounts` VALUES (1,'RHNi9EPkotF4vRPmXCksBYQYkxrFK7a73ykjDMONQmqL0H6c4ZImrVBkM2adCa0EKAQG8KzF8630atmdJOFGehenGrTTLvpqo/9Y74hI9N/arat3Jb9J0VhfKLq4IVhy21T2KLsq7Zj5lRudjSY4+M8TjhuF2+Zo+HdC7zC4NBZ7MfQs0/CACLLq0Ozxk6lnccXyVNSSeua92Y8JXCfkrGpJ418iswTABje31CKSMQiSn0ImrAYfVJurFeADE99wOCuFNu5ozOJDzyFb3shJ3pah1TKKG+aMlRhZprTUGGxYLG21Dsn5iZlCPbqj8qo9H1E7CLtaEajbAVDIzQoQCMIUv0UeU6urlPkSIbHsEVaP753cQ3+nrxyb5ZioLfU4weg1zUSHxQqEkyv/DMTfKsTLd4+TFgw0ubBjZ7nVQl63R1NNdew6XHklIOn60XFagZ9ZzcwVQTd3sURgOwJwtw==','2026-07-21 07:08:46.753873','selvam181711@gmail.com','2026-07-21 13:49:55.176464','103748030758033108818',NULL,'2026-07-21 12:49:56.200384',6),(2,'YUy+m1/yUxeaP6ymbZRWgV+3NrQe+rWOixZHiz6bMfOUCQnpv4WahBc7vA0N78DEbwZuqLRRUKvquNsCyFLBKtzlziShKzLTlIEmVZ+nYYgY4gUq0o5BIYhiy1TaxIVrhTqArQw916TU205PapJh9AsR032/s+p9bISXVdUaB5u6S1cy9gWnOgdaKsHJXLrBimPZZLbgKgi2E8uzZRlwIrbOLhXzMm0A+WFFCTYQEpVXAUeM4wMO+nKQi6jVj5E02dep8f/CJ8j/tLpoqxjQ1MmxJULOLClTkrLX02oL1zOF4ipmEGoRWUHTVSD6EzbMiIeRwnC24q0az3jW2s4r+/pOW1P/AuXS1ZIL+eibWDEY+5imkUlWQOIGIFeQSIGcmFGpKN03TcC5Mmwub7mE5yW8532al4T/3mg27mD4CRUYSU+ErGB5Ao8hCW7ms0awcGxLMdSCftTwf9F0VyOCQQ==','2026-07-21 08:34:13.061362','tamil181711@gmail.com','2026-07-21 09:34:08.897677','101293639831040645387',NULL,'2026-07-21 08:34:13.061362',7),(3,'xVngLBXkOrVkAxGi5FHdMx59ySmCUFMi08db6+QLdzhgltBt997aHIGK09Y16eIe/gTsc5yOEIP8dxbrjkEfCSGBdGEUAO+VA6gv69LLzl8ly2VSLYF/wp6T2Aws4R4lJ41RbsTKgzui3Gpgg8bEbWdq+oWP4VV6dyXaYHWDWK+fU0aHaYVCAlw+6uYRPxsdimFsnWg3bCo8gZOBVTPvPycfj/ltloSkQ22jjoDOZbck/9oSJ1oBLcVZMFxgkUhDNXuLUZM8tLOYH1SGDqyXKJkobj3b8Q/rl+YIlUGCIBkSz7SKTNC10gmOD9325CFh4YOYOJLesJq5sVlXp7tBZyayrc1cz8Dsy2OiMOpUXhqCiek99uPmblMIZuaTt/0JciQ+q9qUDdrpPDrqiKA+nqE1ypAC+VzSj/gPOIFR+bpkNtlaG4G7F5AafQT6ke1/gZ9ZzcwVQTd3sURgOwJwtw==','2026-07-21 12:48:26.205823','tamilselvamrcb@gmail.com','2026-07-21 13:48:24.836924','115873448083490856526',NULL,'2026-07-21 12:48:26.205823',4);
/*!40000 ALTER TABLE `google_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kitchen_tickets`
--

DROP TABLE IF EXISTS `kitchen_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kitchen_tickets` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `assigned_chef` varchar(255) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `order_id` bigint NOT NULL,
  `status` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kitchen_tickets`
--

LOCK TABLES `kitchen_tickets` WRITE;
/*!40000 ALTER TABLE `kitchen_tickets` DISABLE KEYS */;
INSERT INTO `kitchen_tickets` VALUES (1,'Chef Julia','2026-07-21 07:10:22.628573','2026-07-21 07:10:22.628573',7,'READY'),(2,'Chef Julia','2026-07-21 08:34:48.948579','2026-07-21 08:34:48.948579',8,'READY'),(3,'Chef Sanjeev','2026-07-21 12:49:15.126266','2026-07-21 12:49:15.126266',9,'READY'),(4,'Chef Sanjeev','2026-07-21 12:50:18.389236','2026-07-21 12:50:18.389236',10,'READY');
/*!40000 ALTER TABLE `kitchen_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `price` double NOT NULL,
  `quantity` int NOT NULL,
  `food_item_id` bigint DEFAULT NULL,
  `order_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKbmnfj15j0ngros6mbdx7q5c01` (`food_item_id`),
  KEY `FKbioxgbv59vetrxe0ejfubep1w` (`order_id`),
  CONSTRAINT `FKbioxgbv59vetrxe0ejfubep1w` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `FKbmnfj15j0ngros6mbdx7q5c01` FOREIGN KEY (`food_item_id`) REFERENCES `food_items` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,249,2,1,1),(2,129,1,3,1),(3,189,1,4,2),(4,119,1,6,2),(5,279,1,7,3),(6,89,1,9,4),(7,89,1,9,5),(8,249,1,1,6),(9,189,1,4,7),(10,279,1,7,8),(11,189,1,4,9),(12,189,1,4,10);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `delivery_address` varchar(255) DEFAULT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `total_amount` double NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `restaurant_id` bigint DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `delivered_at` datetime(6) DEFAULT NULL,
  `estimated_delivery` varchar(255) DEFAULT NULL,
  `invoice_generated` bit(1) NOT NULL,
  `invoice_number` varchar(255) DEFAULT NULL,
  `kitchen_preparing_at` datetime(6) DEFAULT NULL,
  `order_placed_at` datetime(6) DEFAULT NULL,
  `out_for_delivery_at` datetime(6) DEFAULT NULL,
  `payment_processing_at` datetime(6) DEFAULT NULL,
  `payment_status` varchar(255) DEFAULT NULL,
  `restaurant_accepted_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK32ql8ubntj5uh44ph9659tiih` (`user_id`),
  KEY `FK2m9qulf12xm537bku3jnrrbup` (`restaurant_id`),
  CONSTRAINT `FK2m9qulf12xm537bku3jnrrbup` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`),
  CONSTRAINT `FK32ql8ubntj5uh44ph9659tiih` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'2026-07-14 15:50:30.597676','123 Food Street, Foodville','UPI','DELIVERED',627,1,1,NULL,NULL,NULL,_binary '\0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'2026-07-16 14:50:30.636159','123 Food Street, Foodville','Card','PREPARING',338,1,2,NULL,NULL,NULL,_binary '\0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'2026-07-16 15:30:30.647355','456 Tech Lane, Silicon Valley','Cash on Delivery','DELIVERED',309,1,3,NULL,'2026-07-21 07:08:18.268194',NULL,_binary '\0',NULL,'2026-07-21 07:08:08.279561',NULL,'2026-07-21 07:08:13.284210','2026-07-21 07:07:58.435529','PAID','2026-07-21 07:08:03.271415','2026-07-21 07:08:18.274586'),(4,'2026-07-16 16:15:27.089874','MGR Nagar, Chennai - 600078','Cash on Delivery','DELIVERED',123.45,1,3,NULL,'2026-07-21 07:08:18.284006',NULL,_binary '\0',NULL,'2026-07-21 07:08:08.304389',NULL,'2026-07-21 07:08:13.303102','2026-07-21 07:07:58.504808','PAID','2026-07-21 07:08:03.288729','2026-07-21 07:08:18.290565'),(5,'2026-07-16 16:18:03.284700','Ashok Pillar, Chennai - 600078','Card','DELIVERED',123.45,1,3,NULL,'2026-07-21 07:08:18.297266',NULL,_binary '\0',NULL,'2026-07-21 07:08:08.318711',NULL,'2026-07-21 07:08:13.316381','2026-07-21 07:07:58.531617','PAID','2026-07-21 07:08:03.322754','2026-07-21 07:08:18.305158'),(6,'2026-07-18 12:24:18.593460','Guindy, Chennai ','UPI','DELIVERED',291.45,1,1,NULL,'2026-07-21 07:08:18.312682',NULL,_binary '\0',NULL,'2026-07-21 07:08:08.335006',NULL,'2026-07-21 07:08:13.329362','2026-07-21 07:07:58.546571','PAID','2026-07-21 07:08:03.339713','2026-07-21 07:08:18.320957'),(7,'2026-07-21 07:10:22.149178','Velachery, Chennai','Cash on Delivery','DELIVERED',202.45,6,2,'Selvam D','2026-07-21 07:10:22.661886','25-35 mins',_binary '','INV-000007','2026-07-21 07:10:22.627959','2026-07-21 07:10:22.149178','2026-07-21 07:10:22.646247','2026-07-21 07:10:22.599355','PAID',NULL,'2026-07-21 07:10:22.737295'),(8,'2026-07-21 08:34:48.304974','Guindy','Cash on Delivery','DELIVERED',296.95,7,3,'TAMIL SELVAM','2026-07-21 08:34:48.969614','25-35 mins',_binary '','INV-000008','2026-07-21 08:34:48.947390','2026-07-21 08:34:48.304974','2026-07-21 08:34:48.959769','2026-07-21 08:34:48.925726','PAID',NULL,'2026-07-21 08:34:49.042911'),(9,'2026-07-21 12:49:14.526474','Velachery, Chennai','UPI','DELIVERED',202.45,4,2,'TAMIL SELVAM','2026-07-21 12:49:15.148229','25-35 mins',_binary '','INV-000009','2026-07-21 12:49:15.126266','2026-07-21 12:49:14.526474','2026-07-21 12:49:15.139283','2026-07-21 12:49:15.091823','PAID',NULL,'2026-07-21 12:49:15.229028'),(10,'2026-07-21 12:50:18.073800','Guindy','Cash on Delivery','DELIVERED',202.45,6,2,'Selvam D','2026-07-21 12:50:18.418935','25-35 mins',_binary '','INV-000010','2026-07-21 12:50:18.388549','2026-07-21 12:50:18.073800','2026-07-21 12:50:18.397091','2026-07-21 12:50:18.304045','PAID',NULL,'2026-07-21 12:50:18.459686');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `amount` double NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `order_id` bigint NOT NULL,
  `status` varchar(255) NOT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,202.45,'2026-07-21 07:10:22.602676',7,'SUCCESS','643DF864'),(2,296.95,'2026-07-21 08:34:48.931389',8,'SUCCESS','3D03DFE0'),(3,202.45,'2026-07-21 12:49:15.095965',9,'SUCCESS','400B3348'),(4,202.45,'2026-07-21 12:50:18.306035',10,'SUCCESS','C4EC385D');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurants`
--

DROP TABLE IF EXISTS `restaurants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurants` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `delivery_time` int NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `image_url` varchar(1000) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `opening_hours` varchar(255) DEFAULT NULL,
  `owner_id` bigint DEFAULT NULL,
  `rating` double NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `owner_email` varchar(255) DEFAULT NULL,
  `owner_name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurants`
--

LOCK TABLES `restaurants` WRITE;
/*!40000 ALTER TABLE `restaurants` DISABLE KEYS */;
INSERT INTO `restaurants` VALUES (1,_binary '',25,'Authentic wood-fired Italian pizzas and gourmet garlic breads.','https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&q=80','Pizza Paradise','11:00 AM - 11:00 PM',2,4.8,NULL,NULL,NULL,NULL),(2,_binary '',20,'Premium grass-fed beef burgers with artisanal cheddar cheese and local ingredients.','https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80','Burger Bistro','10:00 AM - 10:00 PM',2,4.5,NULL,NULL,NULL,NULL),(3,_binary '',35,'Legacy recipe Hyderabadi Dum Biryani with slow-cooked tender meat and premium basmati rice.','https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&q=80','Biryani House','12:00 PM - 10:30 PM',2,4.9,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `restaurants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_addresses`
--

DROP TABLE IF EXISTS `user_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_addresses` (
  `user_id` bigint NOT NULL,
  `addresses` varchar(255) DEFAULT NULL,
  KEY `FKn2fisxyyu3l9wlch3ve2nocgp` (`user_id`),
  CONSTRAINT `FKn2fisxyyu3l9wlch3ve2nocgp` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_addresses`
--

LOCK TABLES `user_addresses` WRITE;
/*!40000 ALTER TABLE `user_addresses` DISABLE KEYS */;
INSERT INTO `user_addresses` VALUES (1,'123 Food Street, Foodville'),(1,'456 Tech Lane, Silicon Valley'),(1,'SeethalaiSathnar Street, MGR Nagar, Chennai - 600078');
/*!40000 ALTER TABLE `user_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_favorites`
--

DROP TABLE IF EXISTS `user_favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_favorites` (
  `user_id` bigint NOT NULL,
  `favorite_restaurant_ids` bigint DEFAULT NULL,
  KEY `FK4sv7b9w9adr0fjnc4u10exlwm` (`user_id`),
  CONSTRAINT `FK4sv7b9w9adr0fjnc4u10exlwm` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_favorites`
--

LOCK TABLES `user_favorites` WRITE;
/*!40000 ALTER TABLE `user_favorites` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_oauth`
--

DROP TABLE IF EXISTS `user_oauth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_oauth` (
  `user_id` bigint NOT NULL,
  `access_token` varchar(2000) DEFAULT NULL,
  `expiry_time` datetime(6) DEFAULT NULL,
  `google_email` varchar(255) NOT NULL,
  `google_id` varchar(255) NOT NULL,
  `refresh_token` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `FKrehn7hnmnbnie1fu849n8ss9t` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_oauth`
--

LOCK TABLES `user_oauth` WRITE;
/*!40000 ALTER TABLE `user_oauth` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_oauth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'customer@food.com','John Doe','$2a$10$LWEauG/Xq08rfrVDJ7XuTeGHyDpZ0xPxQa55nKsSYe4wxw5Y1GxW6','ROLE_CUSTOMER',NULL),(2,'owner@food.com','Chef Mario','$2a$10$I7GSU9g6kEfQc9WXa7vonupzW2bYYz0leyk1zJKr/k3z8FOuY4LTS','ROLE_RESTAURANT',NULL),(3,'admin@food.com','Admin Manager','$2a$10$G7tEpfVapqjQWrxUK3sgPOoB84OGHrCDTYSztC81cXaltwR8IBeHu','ROLE_ADMIN',NULL),(4,'tamilselvamrcb@gmail.com','TAMIL SELVAM','$2a$10$vGmLvK4D4EGFQTdHizGfEe1ssiSEbvtSMPCtmg0GR8WOx7yLwu7au','ROLE_RESTAURANT',NULL),(5,'tamil1817111@gmail.com','TAMIL SELVAM','$2a$10$eUpuRJjl2tywB2/7wdA/D.hpV.ynWmnNM/ijOc.ROMwa/lena6Teu','ROLE_CUSTOMER',NULL),(6,'selvam181711@gmail.com','Selvam D','$2a$10$3LQk0/OMJZ1/xqRAityjQ..T3IKU5FIdTpP5f5q0Q693IQbHsi092','ROLE_CUSTOMER','+1 (555) 019-2834'),(7,'tamil181711@gmail.com','TAMIL SELVAM','$2a$10$N5EbXCLkEsrv.IrnbAi19.76E28B.VeuZEG8jnj7HvW9XpRTu4GVy','ROLE_CUSTOMER','+1 (555) 019-2834');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-24 10:03:20
