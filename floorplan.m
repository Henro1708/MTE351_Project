% Parameters (all in meters and seconds)
tile_spacing = 0.3048;       % Tile length = 1 ft = 0.3048 m
grout_width = 0.01;          % Width of grout = 1 cm
grout_depth = 0.005;         % Depth of grout = 0.5 cm
v = 3;                     % Constant robot velocity (m/s)
total_length = 5;            % Total travel distance (meters)
dt = 0.00001;                  % Time step (seconds)

% Convert tile and groove lengths to time durations
tile_time = tile_spacing / v;
grout_time = grout_width / v;

% Time vectors for one tile and one grout
t_tile = 0:dt:tile_time - dt;
t_grout = 0:dt:grout_time - dt;

% Signal for tile = flat = zeros
z_tile = zeros(size(t_tile));

% Signal for groove = haversine dip = sin² profile
z_grout = grout_depth * sin(pi * v * t_grout / grout_width).^2;

% Combine tile + grout into one pattern
z_pattern = [z_tile, z_grout];
t_pattern = (0:length(z_pattern)-1) * dt;

% Repeat the pattern until reaching total distance
n_repeats = ceil(total_length / (tile_spacing + grout_width));

% Build full signal
z_full = repmat(z_pattern, 1, n_repeats);
t_full = (0:length(z_full)-1) * dt;

% Trim to exact total_time
total_time = total_length / v;
final_idx = find(t_full <= total_time, 1, 'last');
t = t_full(1:final_idx);
z = z_full(1:final_idx);

% Package for Simulink
z_signal = [t', z'];

% Plot
figure;
plot(t, z, 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Vertical wheel input (m)');
title('Tile + Groove Floor Signal (Repeated Pattern)');
grid on;
