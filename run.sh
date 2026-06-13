#!/bin/bash

echo "=== Docker Homework3 Project ==="

if [ -z "$1" ]; then
    show_help
    exit 0
fi

case "$1" in
    build_generator)
        echo "Building generator image..."
        docker build -f Dockerfile.generator -t generate-app .
        echo "Done!"
        ;;
    run_generator)
        echo "Running generator..."
        mkdir -p data
        docker run --rm -v "$(pwd)/data:/data" generate-app
        echo "Generated data/data.csv"
        ;;
    create_local_data)
        echo "Creating local data..."
        mkdir -p local_data
        python3 generate.py local_data
        echo "Generated local_data/data.csv"
        ;;
    build_reporter)
        echo "Building reporter image..."
        docker build -f Dockerfile.reporter -t report-app .
        echo "Done!"
        ;;
    run_reporter)
        echo "Running reporter..."
        mkdir -p data
        if [ ! -f "data/data.csv" ]; then
            echo "ERROR: data/data.csv not found. Run './run.sh run_generator' first"
            exit 1
        fi
        docker run --rm -v "$(pwd)/data:/data" report-app
        echo "Generated data/report.html"
        ;;
    structure)
        echo "Project structure:"
        if command -v tree &> /dev/null; then
            tree -a -I '.git' --dirsfirst
        else
            find . -type f -o -type d | grep -v '.git' | sort | sed 's/[^-][^\/]*\//--/g;s/--/|/'
        fi
        ;;
    clear_data)
        echo "Cleaning data directory..."
        rm -f data/*.csv data/*.html
        echo "Done!"
        ;;
    inside_generator)
        echo "Entering generator container..."
        docker run --rm -it -v "$(pwd)/data:/data" --entrypoint sh generate-app
        ;;
    inside_reporter)
        echo "Entering reporter container..."
        docker run --rm -it -v "$(pwd)/data:/data" --entrypoint sh report-app
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac

show_help() {
    echo "Available commands:"
    echo "  ./run.sh build_generator"
    echo "  ./run.sh run_generator"
    echo "  ./run.sh create_local_data"
    echo "  ./run.sh build_reporter"
    echo "  ./run.sh run_reporter"
    echo "  ./run.sh structure"
    echo "  ./run.sh clear_data"
    echo "  ./run.sh inside_generator"
    echo "  ./run.sh inside_reporter"
}