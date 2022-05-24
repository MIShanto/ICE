%Digital signal....
%Bipolar AMI
%IF bit=1 y(from:to) = opposit of previous state for non zero bit
%IF bit=0 y(from:to) = 0

clear all;
clc;
bit = [1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1];

v = 2;

fs = 100;
bit_duration = 1; % bitrate = 1/bitduration
T = length(bit) * bit_duration; % len/bitrate.
t = 0:1/fs:T;

x_digital = zeros(1, length(t));

lastState = v;

%encoding
for i = 1:length(bit)
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    
    if bit(i) == 1
        x_digital(from : to) = -lastState;
        lastState = -lastState;
        
    else
        x_digital(from : to) = 0;
    end
end

%subplot(1,2,1);
plot(t, x_digital);
xlim([0, T]);
ylim([-10, 10]);
grid on;

%decoding
%method 1

data = zeros(1, length(bit));
lastState = v;
for i=1:length(bit)
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    
    if(x_digital(from : to) == 0)
        data(i) = 0;
    else
        data(i) = 1;
        
        
    end
end

disp(data)

%method 2
data = zeros(1, length(bit));
lastState = v;
counter = 0;

for i=1:length(t)/fs*bit_duration
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;

    if(x_digital(from : to) == 0)
        data(i) = 0;
    else
        data(i) = 1; 
    end
end

disp(data)

%method 3
data = zeros(1, length(bit));
lastState = v;
counter = 0;

for i=1:length(t)
    if t(i) > counter*bit_duration
        counter = counter + 1;
        if(x_digital(i) == 0)
            data(counter) = 0;
        else
            data(counter) = 1;
        end
    end
end

disp(data)