#!/bin/bash
# generate_skeleton.sh - Generate Go project structure skeleton
# Usage: ./generate_skeleton.sh [--with-sample] [--clean]

set -e

WITH_SAMPLE=0
CLEAN=0
DEST="."

for arg in "$@"; do
  if [[ $arg == --with-sample ]]; then
    WITH_SAMPLE=1
  elif [[ $arg == --clean ]]; then
    CLEAN=1
  elif [[ $arg == --dest=* ]]; then
    DEST="${arg#--dest=}"
  fi
  # ignore unknown args for now
done

# Validate destination
if [[ -e "$DEST" && ! -d "$DEST" ]]; then
  echo "Error: Destination '$DEST' exists and is not a directory."
  exit 1
fi
if [[ ! -e "$DEST" ]]; then
  mkdir -p "$DEST"
  CREATED_DEST=1
else
  # Check for files in destination (excluding . and ..)
  shopt -s nullglob dotglob
  files=("$DEST"/*)
  shopt -u nullglob dotglob
  if (( ${#files[@]} )); then
    echo "Error: Destination '$DEST' is not empty. Aborting to avoid overwriting files."
    exit 1
  fi
fi

# List of directories to create
DIRS=(
  "ops"
  "cmd"
  "internal/adapters/carriers/mocks"
  "internal/adapters/carriers/fedex"
  "internal/adapters/tracking"
  "internal/config"
  "internal/domain/models"
  "internal/domain/repositories"
  "internal/domain/services"
  "internal/infrastructure/messaging/kafka/consumers"
  "internal/infrastructure/messaging/kafka/producers"
  "internal/infrastructure/messaging/kafka/config"
  "internal/infrastructure/messaging/kafka/messages"
  "internal/infrastructure/databases"
  "internal/infrastructure/webhooks"
  "internal/utils"
  "pkg/httpclient"
  "pkg/kafka"
  "pkg/logger"
  "testutils"
  "vendor"
)

if [[ $CLEAN -eq 1 ]]; then
  # Remove only the top-level parent folders from DIRS in DEST
  PARENTS=()
  for dir in "${DIRS[@]}"; do
    parent="${dir%%/*}"
    if [[ ! " ${PARENTS[@]} " =~ " $parent " ]]; then
      PARENTS+=("$parent")
    fi
  done
  for parent in "${PARENTS[@]}"; do
    rm -rf "$DEST/$parent"
  done
  echo "Project skeleton cleaned (all parent folders from DIRS removed in $DEST)."
  exit 0
fi

for dir in "${DIRS[@]}"; do
  mkdir -p "$DEST/$dir"
  # Add .gitkeep to keep empty folders in git
  touch "$DEST/$dir/.gitkeep"

done

if [[ $WITH_SAMPLE -eq 1 ]]; then
  # Sample files for demonstration
  echo -e "package main\n\nfunc main() {}" > "$DEST/cmd/main.go"
  echo -e "package config\n\n// App config struct" > "$DEST/internal/config/config.go"
  echo -e "package carriers\n\n// Carrier interface" > "$DEST/internal/adapters/carriers/carrier.go"
  echo -e "package fedex\n\n// FedEx implementation" > "$DEST/internal/adapters/carriers/fedex/fedex.go"
  echo -e "package mocks\n\n// Carrier mock" > "$DEST/internal/adapters/carriers/mocks/carrier_mock.go"
  echo -e "package models\n\n// Data models" > "$DEST/internal/domain/models/models.go"
  echo -e "package repositories\n\n// Data access layer" > "$DEST/internal/domain/repositories/repositories.go"
  echo -e "package services\n\n// Business logic" > "$DEST/internal/domain/services/services.go"
  echo -e "package kafka\n\n// Kafka consumer" > "$DEST/internal/infrastructure/messaging/kafka/consumers/consumer.go"
  echo -e "package kafka\n\n// Kafka producer" > "$DEST/internal/infrastructure/messaging/kafka/producers/producer.go"
  echo -e "package config\n\n// Kafka config" > "$DEST/internal/infrastructure/messaging/kafka/config/config.go"
  echo -e "package messages\n\n// Kafka messages" > "$DEST/internal/infrastructure/messaging/kafka/messages/messages.go"
  echo -e "package databases\n\n// Database connection" > "$DEST/internal/infrastructure/databases/databases.go"
  echo -e "package webhooks\n\n// Webhook handler" > "$DEST/internal/infrastructure/webhooks/webhooks.go"
  echo -e "package utils\n\n// Utility functions" > "$DEST/internal/utils/utils.go"
  echo -e "package httpclient\n\n// HTTP client" > "$DEST/pkg/httpclient/httpclient.go"
  echo -e "package kafka\n\n// Kafka wrapper" > "$DEST/pkg/kafka/kafka.go"
  echo -e "package logger\n\n// Logger utility" > "$DEST/pkg/logger/logger.go"
  echo -e "// Test utilities" > "$DEST/testutils/testutils.go"
fi

if [[ $CREATED_DEST -eq 1 ]]; then
  echo "Destination folder '$DEST' was created."
fi

echo "Project skeleton generated successfully in $DEST."
