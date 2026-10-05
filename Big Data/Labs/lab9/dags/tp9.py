from datetime import datetime
import json
import os

import requests
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator


def get_pictures():
    os.makedirs("/opt/airflow/dags/tmp/images", exist_ok=True)

    with open("/opt/airflow/dags/tmp/launches.json", "r") as f:
        data = json.load(f)

    launches = data["results"]

    for launch in launches:
        image_url = launch.get("image")

        if image_url:
            image_name = image_url.split("/")[-1]
            image_path = f"/opt/airflow/dags/tmp/images/{image_name}"

            response = requests.get(image_url, timeout=30)
            response.raise_for_status()

            with open(image_path, "wb") as img_file:
                img_file.write(response.content)


with DAG(
    dag_id="download_rocket_launches",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
) as dag:

    download_launches = BashOperator(
        task_id="download_launches",
        bash_command=(
            'mkdir -p /opt/airflow/dags/tmp && '
            'curl -Lk "https://ll.thespacedevs.com/2.0.0/launch/upcoming" '
            '-o /opt/airflow/dags/tmp/launches.json'
        ),
    )

    get_pictures_task = PythonOperator(
        task_id="get_pictures",
        python_callable=get_pictures,
    )

    notify = BashOperator(
        task_id="notify",
        bash_command=(
            'echo "There are now '
            '$(ls /opt/airflow/dags/tmp/images | wc -l) images."'
        ),
    )

    download_launches >> get_pictures_task >> notify