#!/bin/bash

PROJECT_NAME="ha-grow-monitor"
BASE_DIR="./$PROJECT_NAME"
DOMAIN="grow_monitor"

mkdir -p "$BASE_DIR/custom_components/$DOMAIN"
mkdir -p "$BASE_DIR/models"
mkdir -p "$BASE_DIR/tests"

touch "$BASE_DIR/custom_components/$DOMAIN/__init__.py"
touch "$BASE_DIR/custom_components/$DOMAIN/binary_sensor.py"
touch "$BASE_DIR/custom_components/$DOMAIN/sensor.py"
touch "$BASE_DIR/custom_components/$DOMAIN/manifest.json"
touch "$BASE_DIR/custom_components/$DOMAIN/const.py"
touch "$BASE_DIR/custom_components/$DOMAIN/model_processor.py"

touch "$BASE_DIR/models/labels.txt"
touch "$BASE_DIR/README.md"
touch "$BASE_DIR/requirements.txt"
touch "$BASE_DIR/.gitignore"

chmod +x "$0"
