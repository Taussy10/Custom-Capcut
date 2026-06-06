import numpy as np
from scipy.io import wavfile
import sys
import os

def analyze(wav_path):
    if not os.path.exists(wav_path):
        print(f"Error: file {wav_path} not found")
        sys.exit(1)
        
    sample_rate, data = wavfile.read(wav_path)
    
    # Ensure it's floating point normalized between -1 and 1
    if data.dtype == np.int16:
        data = data.astype(np.float32) / 32768.0
    elif data.dtype == np.int32:
        data = data.astype(np.float32) / 2147483648.0
    elif data.dtype == np.uint8:
        data = (data.astype(np.float32) - 128.0) / 128.0
        
    # Mono check
    if len(data.shape) > 1:
        data = np.mean(data, axis=1)
        
    # Calculate RMS and Peak
    rms = np.sqrt(np.mean(data**2))
    rms_db = 20 * np.log10(rms + 1e-9)
    peak = np.max(np.abs(data))
    peak_db = 20 * np.log10(peak + 1e-9)
    
    print(f"--- Audio Levels ---")
    print(f"Peak Volume : {peak_db:.2f} dBFS")
    print(f"Average RMS : {rms_db:.2f} dBFS")
    print(f"Crest Factor (Dynamic Range) : {peak_db - rms_db:.2f} dB")
    print()
    
    # Calculate FFT
    n = len(data)
    fft_data = np.fft.rfft(data)
    fft_freqs = np.fft.rfftfreq(n, d=1.0/sample_rate)
    fft_mags = np.abs(fft_data)
    
    # Define frequency bands
    bands = {
        "Sub-Bass (20-60Hz)": (20, 60),
        "Bass (60-250Hz)": (60, 250),
        "Low-Mids (250-500Hz)": (250, 500),
        "Midrange (500-2000Hz)": (500, 2000),
        "Presence (2000-4000Hz)": (2000, 4000),
        "Brilliance (4000-15000Hz)": (4000, 15000)
    }
    
    total_energy = np.sum(fft_mags**2)
    
    print(f"--- Spectral Distribution ---")
    band_energies = {}
    for name, (low, high) in bands.items():
        idx = np.where((fft_freqs >= low) & (fft_freqs <= high))[0]
        band_energy = np.sum(fft_mags[idx]**2)
        percentage = (band_energy / total_energy) * 100
        band_energies[name] = percentage
        print(f"{name:<28}: {percentage:.2f}% of total energy")
        
    # Find dominant frequency in the voice range (80 - 8000 Hz)
    voice_idx = np.where((fft_freqs >= 80) & (fft_freqs <= 8000))[0]
    dom_freq = fft_freqs[voice_idx[np.argmax(fft_mags[voice_idx])]]
    print(f"\nDominant Voice Frequency: {dom_freq:.1f} Hz")
    
if __name__ == '__main__':
    analyze("E:\\Tausif\\Custom-Capcut\\scripts\\reference.wav")
