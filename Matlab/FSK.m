%Digital signal....
%ASK 1 = has signal else no;

clear all;
clc;
bit = [1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1];

v = 2;

am = 2;
fm = 10;
f2 = 3;
fs = 100;
bit_duration = 1; % bitrate = 1/bitduration
T = length(bit) * bit_duration; % len/bitrate.
t = 0:1/fs:T;

x_analog = am*sin(2*pi*fm*t);
subplot(4, 1, 1);
plot(t,x_analog);
xlim([0, T]);
ylim([-5, 5]);
grid on;

x_analog_2 = am*sin(2*pi*f2*t);
subplot(4, 1, 2);
plot(t,x_analog_2);
xlim([0, T]);
ylim([-5, 5]);
grid on;

x_digital = zeros(1, length(t));

%encoding
for i = 1:length(bit)
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    
    if bit(i) == 1
        x_digital(from : to) = v;        
    else
        x_digital(from : to) = 0;
    end
end

subplot(4,1, 3);
plot(t, x_digital);
xlim([0, T]);
ylim([-5, 5]);
grid on;

%FSK
fsk = zeros(1, length(t));

for i = 1:length(bit)
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    
    if bit(i) == 1
        fsk(from:to) = x_analog(from:to);
    else
        fsk(from:to) = x_analog_2(from:to);
    end
end

subplot(4,1, 4);
plot(t, fsk);
xlim([0, T]);
ylim([-5, 5]);
grid on;