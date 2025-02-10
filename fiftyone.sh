#!/bin/bash

# Change to the Scripts directory
cd Scripts || { echo "Failed to change directory to Scripts. Exiting..."; exit 1; }

# Function to view dataset
view_dataset() {
    echo "Viewing the dataset..."
    python3 read_dataset.py --name "$dataset_name" --dataset_dir "$dataset_dir" --dataset_type "$dataset_type"
}

# Function to get embeddings
get_embeddings() {
    echo "Getting embeddings..."
    python3 viz_embeds.py --name "$dataset_name" --dataset_dir "$dataset_dir" --dataset_type "$dataset_type" --embedding_type "$embedding_type"
}

# Function to get near duplicates
get_near_duplicates() {
    echo "Getting near duplicates..."
    python3 near_duplicates.py --name "$dataset_name" --dataset_dir "$dataset_dir" --dataset_type "$dataset_type"
}

# Function to get exact duplicates
get_exact_duplicates() {
    echo "Getting exact duplicates..."
    python3 exact_duplicates.py --name "$dataset_name" --dataset_dir "$dataset_dir" --dataset_type "$dataset_type"
}

# Prompt the user for their choice
echo "What would you like to do?"
echo "1. View Dataset"
echo "2. Get Embeddings"
echo "3. Get Near Duplicates"
echo "4. Get Exact Duplicates"
read -p "Enter your choice (1-4): " choice

# Prompt for dataset details
read -p "Enter dataset name: " dataset_name
read -p "Enter dataset directory: " dataset_dir

# Choose dataset type from available options
echo "Choose dataset type from the following options:"
echo "1. ImageDirectory"
echo "2. VideoDirectory"
echo "3. ImageDirectoryTree"
echo "4. VideoDirectoryTree"
echo "5. yoloDataset"
read -p "Enter your choice (1-5): " dataset_type_choice

case $dataset_type_choice in
    1) dataset_type="ImageDirectory" ;;
    2) dataset_type="VideoDirectory" ;;
    3) dataset_type="ImageDirectoryTree" ;;
    4) dataset_type="VideoDirectoryTree" ;;
    5) dataset_type="yoloDataset" ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

# If the choice is for embeddings, ask for embedding type
if [ "$choice" -eq 2 ]; then
    echo "Choose embedding type from the following options:"
    echo "1. pixel"
    echo "2. resnet"
    echo "3. clip"
    echo "4. inception"
    read -p "Enter your choice (1-4): " embedding_type_choice

    case $embedding_type_choice in
        1) embedding_type="pixel" ;;
        2) embedding_type="resnet" ;;
        3) embedding_type="clip" ;;
        4) embedding_type="inception" ;;
        *)
            echo "Invalid choice. Exiting..."
            exit 1
            ;;
    esac
fi

# Run the corresponding Python script based on user choice
case $choice in
    1)
        view_dataset
        ;;
    2)
        get_embeddings
        ;;
    3)
        get_near_duplicates
        ;;
    4)
        get_exact_duplicates
        ;;
    *)
        echo "Invalid choice. Exiting..."
        ;;
esac

