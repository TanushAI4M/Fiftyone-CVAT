#!/usr/bin/env python3

import os
import fiftyone as fo
import argparse

from clear_cache import delete_dataset

def load_dataset(dataset_dir, name, dataset_type):
    if not os.path.exists(dataset_dir):
        raise FileNotFoundError(f'Path "{dataset_dir}" does not exist')

    dataset_types = {
        "ImageDirectory": fo.types.ImageDirectory,
        "VideoDirectory": fo.types.VideoDirectory,
        "ImageDirectoryTree": fo.types.ImageClassificationDirectoryTree,
        "VideoDirectoryTree": fo.types.VideoClassificationDirectoryTree,
        "yoloDataset": fo.types.YOLOv5Dataset,
    }

    if dataset_type not in dataset_types:
        raise ValueError(f'Invalid dataset_type "{dataset_type}". Choose from {list(dataset_types.keys())}.')

    dataset = fo.Dataset.from_dir(
        dataset_dir=dataset_dir,
        dataset_type=dataset_types[dataset_type],
        name=name
    )

    dataset.compute_metadata()
    return dataset

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Load a FiftyOne dataset from a directory.")
    parser.add_argument("--name", type=str, required=True, help="Name of the dataset")
    parser.add_argument("--dataset_dir", type=str, required=True, help="Path to the dataset directory")
    parser.add_argument(
        "--dataset_type", type=str, default="ImageDirectory", 
        choices=["ImageDirectory", "VideoDirectory", "ImageDirectoryTree", "VideoDirectoryTree", "yoloDataset"], 
        help="Type of the dataset (default: ImageDirectory)"
    )
    parser.add_argument(
        "--force", action="store_true",
        help="Deletes existing dataset with the same name before loading"
    )

    args = parser.parse_args()

    # Delete dataset if it already exists and --force is set
    if args.force:
        delete_dataset(args.name)

    # Load dataset
    dataset = load_dataset(args.dataset_dir, args.name, args.dataset_type)

    # Launch the FiftyOne App
    session = fo.launch_app(dataset)
    session.wait()

