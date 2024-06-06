#!/bin/bash
#################################################################
#              This Script Brought to you by                    #
#                        theBluWiz                              #
#                   Happy Transcoding!                          #
#################################################################

# Current Version: 1.1.0
# Release Date: 2024-06-04
installed_version="v1.1.0"
# Function to display usage information
show_usage() {
  cat <<EOF
Usage: H265Repack <source> <target> <containerFormat> [crf] [compression lvl]

Arguments:
  <source>           Path to source video file(s).
  <target>           Path to save the converted video file(s).
  <containerFormat>  Desired output container format (e.g., mp4, mkv).
  [crf]              Optional. Constant Rate Factor for controlling the
                     output quality (e.g., poor, good, superb or 0-51).
  [compression lvl]  Optional. Preset for compression (e.g., fast, medium,
                     slow or 0-9).

Examples:
  Basic Conversion:
    H265Repack input.mp4 output mkv
  
  Custom Compression:
    H265Repack input.mp4 output mkv 23 medium
EOF
}

# Check if no arguments were passed or if the first argument is --help
if [ "$#" -eq 0 ] || [ "$1" == "--help" ]; then
  show_usage
  exit 0
fi

# Check if the first argument is --update
if [ "$1" == "--update" ]; then
  echo "Checking for updates"
  latest_version=$(curl -s https://api.github.com/repos/TheBluWiz/H265Repack/tags | jq -r '.[0].name')

  # Update homebrew
  brew update;

  # Check if ffmpeg is updated
  brew outdated ffmpeg || brew upgrade ffmpeg;

  # Check if jq is updated
  brew outdated jq || brew upgrade jq;

  if [ "$installed_version" == "$latest_version" ]; then
    echo "You are already using the latest version: $installed_version"
  else
    echo "$latest_version is available\nUpdating..."

    # Download and unzip the script
    curl -L -o /tmp/H265Repack.zip "https://github.com/TheBluWiz/H265Repack/archive/refs/tags/$latest_version.zip" || { echo "Failed to download the script"; exit 1; }
    unzip /tmp/H265Repack.zip -d /tmp || { echo "Failed to unzip the script"; exit 1; }

    # Copy the script to ~/.bin and make it executable
    folder_name=${latest_version:1}
    cp "/tmp/H265Repack-$folder_name/bin/H265RepackMac.sh" ~/.bin/H265Repack || { echo "Failed to copy the script to ~/.bin"; exit 1; }
    chmod +x ~/.bin/H265Repack || { echo "Failed to make the script executable"; exit 1; }

    # Update man page
    echo ""; echo "";
    echo "Super user password is required to install man(1) page."
    sudo cp /tmp/H265Repack-$folder_name/man/H265Repack.1 /usr/local/share/man/man1/H265Repack.1 || { echo "Failed to copy the man page"; exit 1; }
    sudo gzip /usr/local/share/man/man1/H265Repack.1 || { echo "Failed to gzip the man page"; exit 1; }
    sudo /usr/libexec/makewhatis /usr/local/share/man/man1 || { echo "Failed to update man database"; exit 1; }
    

    # Clean up
    rm -rf /tmp/H265Repack.zip /tmp/H265Repack-$latest_version || { echo "Failed to clean up"; exit 1; }
    echo "Update successful. Happy Transcoding!."
  exit 0
  fi
fi

# Function to convert CRF quality words to numeric values
convert_crf() {
  local crf_value=$1
  case $crf_value in
    "poor") echo 40 ;;
    "fair") echo 30 ;;
    "good") echo 23 ;;
    "excellent") echo 18 ;;
    "superb") echo 15 ;;
    *) 
      if [[ $crf_value =~ ^[0-9]+$ ]] && [ "$crf_value" -ge 0 ] && [ "$crf_value" -le 51 ]; then
        echo $crf_value
      else
        echo ""  # Return empty string if CRF value is invalid
      fi
      ;;
  esac
}

# Function to convert preset value to ffmpeg preset string
convert_preset() {
  local preset_value=$1
  case $preset_value in
    0 | "ultrafast") echo "ultrafast" ;;
    1 | "superfast") echo "superfast" ;;
    2 | "veryfast") echo "veryfast" ;;
    3 | "faster") echo "faster" ;;
    4 | "fast") echo "fast" ;;
    5 | "medium") echo "medium" ;;
    6 | "slow") echo "slow" ;;
    7 | "slower") echo "slower" ;;
    8 | "veryslow") echo "veryslow" ;;
    9 | "placebo") echo "placebo" ;;
    *) echo "" ;;  # Default to nothing if not specified
  esac
}

# Function to convert a single file
convert_file() {
  local src_file=$1
  local tgt_file=$2
  local crf=$3
  local preset=$4

  echo "Converting $src_file to $tgt_file"

  # Extract color range using ffprobe
  local color_range=$(ffprobe -v error -select_streams v:0 -show_entries stream=color_range -of default=noprint_wrappers=1:nokey=1 "$src_file")
  if [ -z "$color_range" ]; then
    echo "Color range not detected, using full range"
    color_range="full"
  fi

  # Map color range to ffmpeg parameter
  case $color_range in
    "tv") color_range_flag="tv" ;;
    "pc") color_range_flag="pc" ;;
    *) color_range_flag="full" ;;
  esac

  # Convert preset value if provided
  if [ -n "$preset" ]; then
    preset=$(convert_preset "$preset")
  fi

  # Check if optional values are provided
  if [ -z "$crf" ] && [ -z "$preset" ]; then
    # No CRF or preset, use hevc_videotoolbox without -preset or -crf
    ffmpeg -i "$src_file" -c:v hevc_videotoolbox -color_range $color_range_flag -c:a copy "$tgt_file"
  else
    # Use libx265 with optional CRF and preset
    ffmpeg -i "$src_file" -c:v libx265 ${preset:+-preset $preset} ${crf:+-crf $crf} -color_range $color_range_flag -c:a copy "$tgt_file"
  fi

  # Check if conversion was successful
  if [ $? -eq 0 ]; then
    echo "Conversion successful: $src_file to $tgt_file"
  else
    echo "Conversion failed for: $src_file"
  fi
}

# Function to create target directory if it does not exist
create_target_directory() {
  local target=$1
  if [ ! -d "$target" ]; then
    echo "Creating target directory: $target"
    mkdir -p "$target"
  fi
}

# Function to copy subdirectories
copy_subdirectories() {
  local source_dir=$1
  local target_dir=$2

  echo "Copying subdirectories from $source_dir to $target_dir"
  find "$source_dir" -type d | while read -r dir; do
    target_subdir="$target_dir/${dir#$source_dir}"
    mkdir -p "$target_subdir"
  done
}

# Function to find video files in a directory
find_video_files() {
  local source_dir=$1

  echo "Finding video files in $source_dir"
  find "$source_dir" -type f \( -iname "*.avi" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.flv" -o -iname "*.wmv" -o -iname "*.mpg" -o -iname "*.mpeg" -o -iname "*.webm" -o -iname "*.ogv" -o -iname "*.ts" -o -iname "*.3gp" -o -iname "*.asf" -o -iname "*.m2ts" -o -iname "*.vob" -o -iname "*.rm" \) -print0
}

# Function to process a batch of files
process_file_batch() {
  local file=$1
  local source_dir=$2
  local target_dir=$3
  local target_ext=$4
  local crf=$5
  local preset=$6

  relative_path="${file#$source_dir/}"
  target_file="$target_dir/${relative_path%.*}.$target_ext"
  convert_file "$file" "$target_file" "$crf" "$preset"
}

# Function to process files in a directory
process_files() {
  local source_dir=$1
  local target_dir=$2
  local target_ext=$3
  local crf=$4
  local preset=$5

  export -f convert_file
  export -f process_file_batch
  export -f convert_preset

  find_video_files "$source_dir" | xargs -0 -n 1 -P 4 -I {} bash -c 'process_file_batch "$@"' _ {} "$source_dir" "$target_dir" "$target_ext" "$crf" "$preset"
}

# Check for minimum arguments
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <Source File or Directory> <Target File or Directory> <Target extension> [CRF value (0-51 or quality word)] [preset (0-9 or preset name)]"
  exit 1
fi

# Assign arguments to variables
SOURCE=$1
TARGET=$2
TARGET_EXT=$3
CRF=$4
PRESET=$5

# Convert CRF value if it's a word
if [ -n "$CRF" ]; then
  CRF=$(convert_crf "$CRF")
fi

# Debugging output
echo "Source: $SOURCE"
echo "Target: $TARGET"
echo "Target Extension: $TARGET_EXT"
echo "CRF: $CRF"
echo "Preset: $PRESET"

# Check if source is a directory
if [ -d "$SOURCE" ]; then
  echo "Source is a directory. Processing all video files."
  # Create target directory
  create_target_directory "$TARGET"
  # Copy subdirectories
  copy_subdirectories "$SOURCE" "$TARGET"
  # Process files
  process_files "$SOURCE" "$TARGET" "$TARGET_EXT" "$CRF" "$PRESET"
else
  echo "Source is a single file. Processing the file."
  # If source is not a directory, treat it as a single file
  base_name=$(basename "$SOURCE")
  target_file="$TARGET.${TARGET_EXT}"
  convert_file "$SOURCE" "$target_file" "$CRF" "$PRESET"
fi
#################################################################
#              This Script Brought to you by                    #
#                        theBluWiz                              #
#                   Happy Transcoding!                          #
#################################################################
