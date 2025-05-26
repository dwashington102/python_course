#!/usr/bin/env python3

import sys
from gtts import gTTS
import os

def text_to_audio(input_file, output_file, lang='en'):
    """
    Convert a text file to an audio file using gTTS.
    
    Args:
        input_file (str): Path to the input text file
        output_file (str): Path to save the output MP3 file
        lang (str): Language code for text-to-speech (default: 'en' for English)
    """
    try:
        # Read the text file
        with open(input_file, 'r', encoding='utf-8') as file:
            text = file.read().strip()
        
        if not text:
            print("Error: The input file is empty.")
            return
        
        # Create gTTS object
        tts = gTTS(text=text, lang=lang, slow=False)

        # Ensure the output directory exists
        try:
            os.makedirs(os.path.dirname(output_file), exist_ok=True)
        except Exception as e:
            print(f'DEBUG failed - {e}')
        
        # Save the audio file
        tts.save(output_file)
        print(f"Audio file successfully created at: {output_file}")
        
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found.")
    except PermissionError:
        print(f"Error: Permission denied when accessing files.")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

def main():
    # Check if correct number of command-line arguments are provided
    if len(sys.argv) != 3:
        print("Usage: python text_to_audio.py <input_text_file> <output_audio_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    
    # Validate file extensions
    if not input_file.endswith('.txt'):
        print("Error: Input file must be a .txt file")
        sys.exit(1)
    if not output_file.endswith('.mp3'):
        print("Error: Output file must be a .mp3 file")
        sys.exit(1)
    
    # Convert text to audio
    text_to_audio(input_file, output_file)

if __name__ == "__main__":
    main()
