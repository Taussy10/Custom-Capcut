import os
import re
import sys
import shutil

if len(sys.argv) < 2:
    print("Usage: python auto_backup.py <path_to_markdown_file>")
    sys.exit(1)

md_file = sys.argv[1]
if not os.path.exists(md_file):
    print(f"Error: {md_file} not found.")
    sys.exit(1)

basename = os.path.splitext(os.path.basename(md_file))[0]
us_china_dir = 'E:/Tausif/animations/us-china'
source_path = os.path.join(us_china_dir, 'src', 'Root.tsx')
backup_path = os.path.join(us_china_dir, 'src', 'backups', f'{basename}_backup.tsx')

if not os.path.exists(os.path.dirname(backup_path)):
    os.makedirs(os.path.dirname(backup_path))

with open(md_file, 'r', encoding='utf-8') as f:
    lines = f.readlines()

all_frames = []
for line in lines:
    if line.strip().startswith('| **Scene'):
        # Split by pipe
        columns = line.split('|')
        if len(columns) > 4:
            # Absolute Visual Frames is the 4th column (index 4 in split, since it starts with | )
            col_content = columns[4].strip()
            # Extract numbers
            m = re.search(r'(\d+)\s*-\s*(\d+)', col_content)
            if m:
                all_frames.append(int(m.group(1)))
                all_frames.append(int(m.group(2)))

if not all_frames:
    print(f"Error: Could not find Absolute Visual Frames in {md_file}.")
    sys.exit(1)

start_frame = min(all_frames)
end_frame = max(all_frames)

print(f"Parsed {basename}: extracted frame range [{start_frame} - {end_frame}]")

shutil.copy(source_path, backup_path)

with open(backup_path, 'r', encoding='utf-8') as f:
    content = f.read()

array_keys = [
    'cameraKeyframes', 'textOverlays', 'mapHighlights', 
    'geospatialIconGrids', 'economyCounters', 'customSymbols', 
    'iconOverlays', 'imageOverlays', 'populationIcons', 
    'blackScreens', 'movingIcons'
]

def clean_array(content, key):
    search_str = f"{key}: ["
    idx = content.find(search_str)
    if idx == -1: return content
    start_idx = content.find('[', idx)
    if start_idx == -1: return content
    
    open_brackets = 0
    end_idx = -1
    for i in range(start_idx, len(content)):
        if content[i] == '[': open_brackets += 1
        elif content[i] == ']':
            open_brackets -= 1
            if open_brackets == 0:
                end_idx = i
                break
                
    if end_idx == -1: return content
    
    array_content = content[start_idx+1:end_idx]
    new_array_content = ""
    i = 0
    while i < len(array_content):
        if array_content[i] == '{':
            obj_start = i
            obj_open = 0
            obj_end = -1
            for j in range(i, len(array_content)):
                if array_content[j] == '{': obj_open += 1
                elif array_content[j] == '}':
                    obj_open -= 1
                    if obj_open == 0:
                        obj_end = j
                        break
            if obj_end != -1:
                obj_text = array_content[obj_start:obj_end+1]
                keep = False
                
                frame_val = None
                frame_m = re.search(r'frame:\s*(\d+)', obj_text)
                if frame_m: frame_val = int(frame_m.group(1))
                    
                start_m = re.search(r'startFrame:\s*(\d+)', obj_text)
                if start_m: frame_val = int(start_m.group(1))
                    
                if frame_val is None:
                    keep = True
                else:
                    if start_frame <= frame_val <= end_frame:
                        keep = True
                    elif frame_val == 0 and "layer:" in obj_text:
                        keep = True
                
                if keep:
                    new_array_content += obj_text + ",\n"
                
                i = obj_end + 1
            else:
                break
        else:
            i += 1
            
    return content[:start_idx+1] + "\n" + new_array_content + content[end_idx:]

for key in array_keys:
    content = clean_array(content, key)

with open(backup_path, 'w', encoding='utf-8') as f:
    f.write(content)

print(f"Success! Created '{basename}_backup.tsx' strictly for frames {start_frame} to {end_frame}.")
