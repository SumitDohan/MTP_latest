#!/bin/bash
# run_all.sh - Run full local pipeline (DVC + MLflow + FastAPI)

# Activate conda environment
echo "Activating conda environment..."
source ~/anaconda3/etc/profile.d/conda.sh
conda activate newenv

# Pull DVC-tracked data
echo "📥 Pulling DVC-tracked data..."
dvc pull || echo "No remote storage configured"

# Run ingestion, preprocessing, and model scripts
echo "🛠 Running data pipeline..."
python src/ingestion.py
python src/preprocessing.py
python src/model.py

# Start MLflow UI in background
echo "🚀 Starting MLflow UI on port 5000..."
mlflow ui --port 5000 --backend-store-uri ./mlruns &

# Start FastAPI server
echo "🚀 Starting FastAPI on port 8000..."
uvicorn src.app:app --reload --host 127.0.0.1 --port 8000
