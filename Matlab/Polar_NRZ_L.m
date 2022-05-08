%Digital signal....
%Polar NRZ-L
%If bit == 1 then y(from:to) = +amplitude
%If bit == 0 then y(from:to) = -amplitude

clear all;
clc;
bit = [1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1];

v_0 = -5;
v_1 = 5;

fs = 100;
bit_duration = 2; % bitrate = 1/bitduration
T = length(bit) * bit_duration; % len/bitrate.
t = 0:1/fs:T;

x_digital = zeros(1, length(t));

%encoding
for i = 1:length(bit)
    if bit(i) == 1
        x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = v_1;
    else
        x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = v_0;
    end
end

subplot(1,2,1);
plot(t, x_digital);
xlim([0, T]);
ylim([-10, 10]);
grid on;

%decoding
data = zeros(1, length(bit));

for i=1:length(bit)
    if(x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) == v_1)
        data(i) = 1;
    else
        data(i) = 0;
    end
end

disp(data)