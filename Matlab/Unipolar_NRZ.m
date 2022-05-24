%Digital signal....
%Unipolar NRZ
%If bit == 1 then y(from:to) = +amplitude
%If bit == 0 then y(from:to) = 0

clear all;
clc;
bit = [1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1];

v = 5;

fs = 100;
bit_duration = 2; % bitrate = 1/bitduration
T = length(bit) * bit_duration; % len/bitrate.
t = 0:1/fs:T;

x_digital = zeros(1, length(t));

%encoding
for i = 1:length(bit)
    if bit(i) == 1
        x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = v;
    else
        x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = 0;
    end
end

subplot(1,2,1);
plot(t, x_digital);
xlim([0, T]);
ylim([-10, 10]);
grid on;

%decoding
%method 1
data = zeros(1, length(bit));

for i=1:length(bit)
    if(x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) == v)
        data(i) = 1;
    else
        data(i) = 0;
    end
end

disp(data)

%method 2
data = zeros(1, length(bit));
counter = 0;

for i=1:length(t)
    if t(i) > counter*bit_duration
        counter = counter + 1;
        if(x_digital(i) == v)
            data(counter) = 1;
        else
            data(counter) = 0;
        end
    end
end

disp(data)