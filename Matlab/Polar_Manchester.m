%Digital signal....
%Polar Manchester
%If bit == 1 then y(from:mid) = +amplitude; y(mid+1:to) = -amplitude
%If bit == 0 then y(from:mid) = -amplitude; y(mid+1:to) = +amplitude

clear all;
clc;
bit = [1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1];

v = 2;

fs = 100;
bit_duration = 1; % bitrate = 1/bitduration
T = length(bit) * bit_duration; % len/bitrate.
t = 0:1/fs:T;

x_digital = zeros(1, length(t));

%encoding
for i = 1:length(bit)
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    mid = round((from+to)/2);
    
    if bit(i) == 1
        x_digital(from : mid) = v;
        x_digital(mid+1 : to) = -v;
    else
        x_digital(from : mid) = -v;
        x_digital(mid+1 : to) = v;
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
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    mid = round((from+to)/2);
    
    if(x_digital(from : mid) == v)
        data(i) = 1;
    else
        data(i) = 0;
    end
end

disp(data)