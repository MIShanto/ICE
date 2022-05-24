%Digital signal....
%Polar RZ
%If bit == 1 then y(from:mid) = +amplitude; y(mid+1:to) = 0
%If bit == 0 then y(from:mid) = -amplitude; y(mid+1:to) = 0

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
        x_digital(mid+1 : to) = 0;
    else
        x_digital(from : mid) = -v;
        x_digital(mid+1 : to) = 0;
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

%method 2
counter = 0;
data = zeros(1, length(bit));
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