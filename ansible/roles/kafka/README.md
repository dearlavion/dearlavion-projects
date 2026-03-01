Access local AKHQ UI:
http://localhost:8080


1️⃣ Create a topic

Kafka organizes messages into topics. First, create one called test-topic.

Run this in your terminal:

docker exec -it kafka \
/opt/kafka/bin/kafka-topics.sh \
--create \
--topic test-topic \
--bootstrap-server localhost:9092 \
--partitions 1 \
--replication-factor 1


✅ Explanation:

--topic test-topic → the topic name
--partitions 1 → single partition (dev setup)
--replication-factor 1 → single copy (single-node)
--bootstrap-server localhost:9092 → connect to your broker

Check that it exists:

docker exec -it kafka \
/opt/kafka/bin/kafka-topics.sh \
--list \
--bootstrap-server localhost:9092


You should see:

test-topic



2️⃣ Produce messages (send)

Open a producer console:

docker exec -it kafka \
/opt/kafka/bin/kafka-console-producer.sh \
--topic test-topic \
--bootstrap-server localhost:9092


The terminal will now wait for you to type messages.

Type anything, e.g.:

Hello Kafka!
This is a test.


Press Enter after each line → each line becomes a message.

3️⃣ Consume messages (receive)

Open another terminal and run the consumer:

docker exec -it kafka \
/opt/kafka/bin/kafka-console-consumer.sh \
--topic test-topic \
--from-beginning \
--bootstrap-server localhost:9092


--from-beginning → ensures it reads all messages, even those sent before the consumer started.

You should see the messages you typed:

Hello Kafka!
This is a test.


✅ This proves that producing and consuming works.