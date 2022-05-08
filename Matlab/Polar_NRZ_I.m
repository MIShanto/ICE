%Digital signal....
%Polar NRZ-I
%If nextbit is 1, Inversion Occurs
%If bit == 1 then y(from:to) = -laststate; laststate = -laststate
%If bit == 0 then y(from:to) = laststate

clear all;
clc;
bit = [1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1];

v = 5;
lastState = v;

fs = 100;
bit_duration = 1; % bitrate = 1/bitduration
T = length(bit) * bit_duration; % len/bitrate.
t = 0:1/fs:T;

x_digital = zeros(1, length(t));

%encoding
for i = 1:length(bit)
    if bit(i) == 1
        x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = -lastState;
        lastState = -lastState;
    else
        x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = lastState;
    end
end

subplot(1,2,1);
plot(t, x_digital);
xlim([0, T]);
ylim([-10, 10]);
grid on;

%decoding
data = zeros(1, length(bit));
lastState = v;
for i=1:length(bit)
    if(x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) == -lastState)
        data(i) = 1;
        lastState = -lastState;
    else
        data(i) = 0;
    end
end

disp(data)