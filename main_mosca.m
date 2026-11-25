close all;
clear all;
clc;

[audio, Fs] = audioread('mosca.wav');
src = mean(audio, 2);
N = length(src);

receptor = [0, 0, 0];

hop = 1024;
L_hrir = 512;
output = zeros(N + L_hrir, 2);
t_vec = (0:N-1)' / Fs;

for idx = 1:hop:N
    idx_end = min(idx + hop - 1, N);
    block = src(idx:idx_end);
    t = t_vec(round((idx + idx_end) / 2));

    % Trayectoria de la fuente alrededor del receptor
    freq_rot = 0.4;
    theta = 2 * pi * freq_rot * t;
    radius = 0.8 + 0.4 * sin(2 * pi * 0.25 * t);

    xs = radius * cos(theta);
    ys = radius * sin(theta);
    zs = 0.35 * sin(2 * pi * 0.5 * t);
    source = [xs, ys, zs];

    % Vector relativo source -> receptor
    rel_pos = source - receptor;
    dist = norm(rel_pos);

    [az_rad, el_rad, ~] = cart2sph(rel_pos(1), rel_pos(2), rel_pos(3));
    az_deg = mod(-rad2deg(az_rad), 360);
    el_deg = max(-40, min(90, rad2deg(el_rad)));

    h = interphrir(az_deg, el_deg);
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