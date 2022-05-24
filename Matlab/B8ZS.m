%Digital signal....
%000VB0VB for 8 consecutive zeros..
%change state for 1

clear all;
clc;
bit = [1 0 0 0 0 0 0 0  1 0];

v = 2;

fs = 100;
bit_duration = 1; % bitrate = 1/bitduration
T = length(bit) * bit_duration; % len/bitrate.
t = 0:1/fs:T;

x_digital = zeros(1, length(t));

lastState = v;
counter = 0;
%encoding
for i = 1:length(bit)   
    if bit(i) == 0
        counter = counter + 1;
        if(counter == 8)
            x_digital((i-1-7)*fs*bit_duration+1 : (i-5)*fs*bit_duration) = 0;
            x_digital((i-1-4)*fs*bit_duration+1 : (i-4)*fs*bit_duration) = lastState;
            x_digital((i-1-3)*fs*bit_duration+1 : (i-3)*fs*bit_duration) = -lastState;
            lastState = -lastState;
            x_digital((i-1-2)*fs*bit_duration+1 : (i-2)*fs*bit_duration) = 0;
            x_digital((i-1-1)*fs*bit_duration+1 : (i-1)*fs*bit_duration) = lastState;
            x_digital((i-1-0)*fs*bit_duration+1 : (i-0)*fs*bit_duration) = -lastState;
            lastState = -lastState;
        end
    else
        counter = 0;
        x_digital((i-1-0)*fs*bit_duration+1 : (i-0)*fs*bit_duration) = -lastState;
        lastState = -lastState;
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
counter = 0;
i=1;
while i <= length(bit)
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    if(x_digital(from : to) == -lastState)
        data(i) = 1;
        lastState = -lastState;
    elseif(x_digital(from : to) == 0)
        data(i) = 0;
        counter = counter + 1;
        if(counter > 3)
            counter = 0;
        end
    elseif(x_digital(from : to) == lastState)
        counter = 0;
        data(i:i+4) = 0;
        i = i + 4;
    end
    i = i + 1;
end

disp(data)

%method 2

data = zeros(1, length(bit));
lastState = v;
counter = 0;
i=1;
while i <= length(t)/ fs*bit_duration
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    if(x_digital(from : to) == -lastState)
        data(i) = 1;
        lastState = -lastState;
    elseif(x_digital(from : to) == 0)
        data(i) = 0;
        counter = counter + 1;
        if(counter > 3)
            counter = 0;
        end
    elseif(x_digital(from : to) == lastState)
        counter = 0;
        data(i:i+4) = 0;
        i = i + 4;
    end
    i = i + 1;
end

disp(data)

%method 3

data = zeros(1, length(bit));
lastState = v;
counter = 0;
c = 0;
i=1;
while i <= length(t)
    if t(i) > c*bit_duration
        c = c + 1;
        if(x_digital(i) == -lastState)
            data(c) = 1;
            lastState = -lastState;
        elseif(x_digital(i) == 0)
            data(c) = 0;
            counter = counter + 1;
            if(counter > 3)
                counter = 0;
            end
        elseif(x_digital(i) == lastState)
            counter = 0;
            data(c:c+4) = 0;
            c = c + 4;
        end
    end
    i = i + 1;
end

disp(data)