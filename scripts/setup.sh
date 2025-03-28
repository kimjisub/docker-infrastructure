#!/bin/bash

# Function to ask for multiple choice options
ask_choice() {
  local message=$1
  local options=("${@:2}")
  local default_option=$2
  local required=$3
  local choice=""
  local options_display=""
  
  # Build options display string
  for i in "${!options[@]}"; do
    if [[ "${options[$i]}" == "$default_option" ]]; then
      options_display+="[$((i+1))] ${options[$i]} (default) "
    else
      options_display+="[$((i+1))] ${options[$i]} "
    fi
  done
  
  if [[ "$required" == "true" ]]; then
    read -p "$message (Required) $options_display: " choice
  else
    read -p "$message (Optional) $options_display: " choice
  fi
  
  # If empty, use default
  if [[ -z "$choice" ]]; then
    echo "$default_option"
    return 0
  fi
  
  # Check if input is a valid option number
  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
    echo "${options[$((choice-1))]}"
    return 0
  fi
  
  # Check if input matches any option directly
  for option in "${options[@]}"; do
    if [[ "$choice" == "$option" ]]; then
      echo "$option"
      return 0
    fi
  done
  
  # Invalid choice
  if [[ "$required" == "true" ]]; then
    echo "Invalid selection for required option. Exiting."
    exit 1
  else
    echo "Invalid selection. Using default: $default_option"
    echo "$default_option"
    return 0
  fi
}

# Function to ask for confirmation with yes/no
ask_confirmation() {
  local message=$1
  local default=$2
  local required=$3
  local prompt_default=""
  local continue_var=""
  
  if [[ "$default" == "y" ]]; then
    prompt_default="Y/n"
  else
    prompt_default="y/N"
  fi
  
  if [[ "$required" == "true" ]]; then
    read -p "$message (Required) [$prompt_default]: " continue_var
  else
    read -p "$message (Optional) [$prompt_default]: " continue_var
  fi
  
  # If empty, use default
  if [[ -z "$continue_var" ]]; then
    continue_var=$default
  fi
  
  if [[ "$continue_var" != "y" && "$continue_var" != "Y" ]]; then
    if [[ "$required" == "true" ]]; then
      echo "Required setup cancelled. Installation terminated."
      exit 1
    else
      echo "Skipping this step."
      return 1
    fi
  fi
  return 0
}

echo "Docker Installation Setup"
if ask_confirmation "Do you want to install Docker?" "y" "true"; then
  echo "Installing Docker..."
  ./docker-install.sh
fi

# Ask before setting up log retention
if ask_confirmation "Do you want to configure Docker log retention?" "y" "false"; then
  echo "Configuring Docker log retention..."
  ./docker-log-retention.sh
fi

# Ask for network type
if ask_confirmation "Do you want to create Docker network?" "y" "true"; then
  echo "Creating Docker network..."
  docker network create proxy
fi

mkdir -p volumes

# Ask before starting Docker Compose
if ask_confirmation "Do you want to start Docker Compose?" "y" "false"; then
  echo "Starting Docker Compose..."
  docker compose up -d
fi
