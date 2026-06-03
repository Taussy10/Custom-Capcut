import whisper
import sys
import json
import os

def main():
    if len(sys.argv) < 5:
        print("Error: Missing arguments.")
        sys.exit(1)
        
    audio_path = sys.argv[1]
    try:
        fps = float(sys.argv[2])
    except ValueError:
        fps = 30.0
    model_name = sys.argv[3]
    json_path = sys.argv[4]

    print(f"Loading Whisper model '{model_name}'...")
    model = whisper.load_model(model_name)

    print("Transcribing with word-level timestamps...")
    # Enable word_timestamps=True to get individual word timings
    result = model.transcribe(audio_path, word_timestamps=True, verbose=False)

    audio_file_name = os.path.basename(audio_path)
    remotion_data = {
        "audio_file": audio_file_name,
        "fps": int(fps),
        "words": []
    }

    # Generate word-level list for Remotion
    for segment in result.get('segments', []):
        for w in segment.get('words', []):
            word_text = w['word'].strip()
            start_time = round(w['start'], 2)
            end_time = round(w['end'], 2)
            frame_start = int(round(start_time * fps))
            frame_end = int(round(end_time * fps))
            
            remotion_data["words"].append({
                "word": word_text,
                "start": start_time,
                "end": end_time,
                "frame_start": frame_start,
                "frame_end": frame_end
            })

    # Write Remotion JSON file
    with open(json_path, 'w', encoding='utf-8') as f_json:
        json.dump(remotion_data, f_json, indent=2, ensure_ascii=False)

    print("Successfully generated Remotion JSON file.")

if __name__ == '__main__':
    main()
