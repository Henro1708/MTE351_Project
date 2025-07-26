% Parameters (in meters and seconds)
tile_spacing = 0.3048;         % meters (1 ft)
grout_width = 0.01;            % meters (1 cm)
grout_depth = 0.005;           % meters (0.5 cm)
v = 0.1;                       % velocity in m/s (adjustable)
total_length = 5;              % total travel distance in meters
total_time = total_length / v; % total time to cross the floor

% Time discretization
dt = 0.001;                    % time step in seconds
t = 0:dt:total_time;           % time vector
x = v * t;                     % position as function of time

% Initialize vertical signal
z = zeros(size(t));            % vertical displacement of the wheel

% Apply sin^2 profile at each grout location
haversine_profile = @(s) grout_depth * sin(pi * s * v / grout_width).^2;

for i = 1:length(t)
    % Find position in current tile
    tile_pos = mod(x(i), tile_spacing);
    
    % If inside the grout
    if tile_pos >= (tile_spacing - grout_width)/2 && tile_pos <= (tile_spacing + grout_width)/2
        x_local = tile_pos - (tile_spacing - grout_width)/2;  % local x inside grout
        z(i) = haversine_profile(x_local);
    else
        z(i) = 0;
    end
end

% Plot signal
figure;
plot(t, z, 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Vertical input (m)');
title('Vertical Wheel Input Over Tiled Floor with Grout (Haversine sin² Profile)');
grid on;