close all;
clear all;
clc;

[audio, Fs] = audioread('mosca.wav');
src_raw = mean(audio, 2);

win = round(0.05 * Fs);
env = sqrt(movmean(src_raw.^2, win));
thresh = 0.3 * max(env);

active_idx = find(env > thresh);
margin = round(0.15 * Fs);
start_i = min(active_idx(1) + margin, floor(length(src_raw) * 0.4));
end_i = max(active_idx(end) - margin, ceil(length(src_raw) * 0.6));

src_base = src_raw(start_i:end_i);

target_sec = 60;
target_N = round(target_sec * Fs);

fade_len = min(round(0.2 * Fs), floor(length(src_base) / 3));
t_fade = linspace(0, pi/2, fade_len)';
w_out = cos(t_fade);
w_in = sin(t_fade);

src = src_base;
while length(src) < target_N
    overlap = src(end-fade_len+1:end) .* w_out + src_base(1:fade_len) .* w_in;
    src = [src(1:end-fade_len); overlap; src_base(fade_len+1:end)];
end
src = src(1:target_N);
N = length(src);

receptor = [0, 0, 0];

hop = 2048;
L_hrir = 512;
output = zeros(N + L_hrir, 2);
t_vec = (0:N-1)' / Fs;

hrir_cache = containers.Map('KeyType', 'char', 'ValueType', 'any');
angle_step = 2;

for idx = 1:hop:N
    idx_end = min(idx + hop - 1, N);
    block = src(idx:idx_end);
    t = t_vec(round((idx + idx_end) / 2));

    freq_rot = 0.4;
    theta = 2 * pi * freq_rot * t;
    radius = 0.8 + 0.4 * sin(2 * pi * 0.25 * t);

    xs = radius * cos(theta);
    ys = radius * sin(theta);
    zs = 0.35 * sin(2 * pi * 0.5 * t);
    source = [xs, ys, zs];

    rel_pos = source - receptor;
    dist = norm(rel_pos);

    [az_rad, el_rad, ~] = cart2sph(rel_pos(1), rel_pos(2), rel_pos(3));
    az_deg = mod(-rad2deg(az_rad), 360);
    el_deg = max(-40, min(90, rad2deg(el_rad)));

    az_key = mod(round(az_deg / angle_step) * angle_step, 360);
    el_key = round(el_deg / angle_step) * angle_step;
    key = sprintf('%d_%d', az_key, el_key);

    if isKey(hrir_cache, key)
        h = hrir_cache(key);
    else
        h = interphrir(az_key, el_key);
        hrir_cache(key) = h;
    end

    gain = 1 / max(dist, 0.25);

    conv_L = conv(block * gain, h(:, 1));
    conv_R = conv(block * gain, h(:, 2));

    out_range = idx : (idx + length(conv_L) - 1);
    output(out_range, 1) = output(out_range, 1) + conv_L;
    output(out_range, 2) = output(out_range, 2) + conv_R;
end

output = output / max(abs(output(:))) * 0.95;

audiowrite('mosca_3D.wav', output, Fs);
sound(output, Fs);