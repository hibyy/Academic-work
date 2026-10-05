from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split

# Initialize Spark session
spark = SparkSession.builder \
    .appName("SparkStreamingKafkaExample") \
    .getOrCreate()

# Set log level to reduce verbosity
spark.sparkContext.setLogLevel("WARN")

# Read streaming data from Kafka
streaming_df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "broker:9092") \
    .option("subscribe", "test-topic") \
    .option("startingOffsets", "earliest") \
    .load()

# Convert the value column from binary to string
streaming_df = streaming_df.selectExpr("CAST(value AS STRING)")

# Split the string into words and explode into rows
words_df = streaming_df.select(
    explode(split(streaming_df.value, " ")).alias("word")
)

# Count the occurrences of each word
word_counts = words_df.groupBy("word").count()

# Write the results to the console
query = word_counts.writeStream \
    .outputMode("complete") \
    .format("console") \
    .trigger(processingTime="10 seconds") \
    .start()

# Keep the streaming query running
query.awaitTermination()