import os
from dotenv import load_dotenv
from uuid import uuid4
import time
import csv
import yaml
from clickhouse_driver import Client

def read_config():
    with open('config.yml', 'r') as file:
        config = yaml.safe_load(file)
    return config

def generate_last_query_execution_metrics_query(query_id, database):
    return f"""
    SELECT query, query_id, query_duration_ms, memory_usage, read_rows, read_bytes, written_rows, written_bytes, result_rows, result_bytes 
    FROM system.query_log sdf WHERE type = 'QueryFinish' AND current_database = '{database}' AND query_id = '{query_id}' LIMIT 1
    """

def read_queries():
    queries = []
    for filename in os.listdir('queries'):
        with open(os.path.join('queries', filename), 'r') as file:
            queries.append({"query": file.read(), "id": filename.split('.')[0]})
    return queries


def run_benchmark():
    load_dotenv()
    config = read_config()
    ch_client = Client(os.getenv('CH_HOST'),
                    user=os.getenv('CH_USER', 'default'),
                    password=os.getenv('CH_PASS', ''),
                    secure=True,
                    verify=False,
                    database=config["database"])
    queries = read_queries()
    data = []
    for query in queries:
        query_id = str(uuid4())
        print(query['id'])
        query_res = ch_client.execute(
            query["query"]
                .replace("${TABLE}", config["table"])
                .replace('${clientId}', config['clientId']), 
            query_id=query_id
        )
        print(query_res)
        time.sleep(config["sleep"])    
        res = ch_client.execute(
            generate_last_query_execution_metrics_query(query_id, config["database"])
        )
        while len(res) == 0:
            print("sleeping for retry")
            time.sleep(config["sleep_retry"])
            res = ch_client.execute(
                generate_last_query_execution_metrics_query(query_id, config["database"])
            )
        res[0] = res[0][2:]
        res[0] = (query["id"],) + res[0]
        data.append(res[0])
    
    with open('results.csv', 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([
            "id", 
            "query_duration_ms", 
            "memory_usage",
            "read_rows",
            "read_bytes",
            "written_rows",
            "written_bytes",
            "result_rows",
            "result_bytes"
        ])  # write header
        writer.writerows(data)

if __name__ == '__main__':
    run_benchmark()