%Digital signal....
%4 consecutive 0’s replaced by ‘000V’ or ‘B00V’ depending on number of non-zero pulses (odd or even)

clear all;
clc;
bit = [0 0 0 1 0 0 0 0 0 0 0 1];

v = 2;

fs = 100;
bit_duration = 1; % bitrate = 1/bitduration
T = length(bit) * bit_duration; % len/bitrate.
t = 0:1/fs:T;

x_digital = zeros(1, length(t));

lastState = v;
counter = 0;
non_zero_pulse = 0;
%encoding
for i = 1:length(bit)   
    if bit(i) == 0
        counter = counter + 1;
        if(counter == 4)
            if(mod(non_zero_pulse, 2)==0) % B00V
                non_zero_pulse = non_zero_pulse + 2;
                x_digital((i-1-3)*fs*bit_duration+1 : (i-3)*fs*bit_duration) = -lastState;
                lastState = -lastState;
                x_digital((i-1-2)*fs*bit_duration+1 : (i-1)*fs*bit_duration) = 0;
                x_digital((i-1-0)*fs*bit_duration+1 : (i-0)*fs*bit_duration) = lastState;
            else % 000V
                non_zero_pulse = non_zero_pulse + 1;
                x_digital((i-1-3)*fs*bit_duration+1 : (i-1)*fs*bit_duration) = 0;
                x_digital((i-1-0)*fs*bit_duration+1 : (i-0)*fs*bit_duration) = lastState;
            end
            counter = 0;
        end
    else
        non_zero_pulse = non_zero_pulse + 1;
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
data = zeros(1, length(bit));
lastState = v;
counter = 0;
i=1;
non_zero_pulse = 0;

while i <= length(bit)
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    if(x_digital(from : to) == -lastState) % either B or 1..
        lastState = - lastState;
        new_from = (i-1+3)*fs*bit_duration+1;
        new_to = (i+3)*fs*bit_duration;
        
        if(new_from <= length(t) && new_to <= length(t))
            if(x_digital(new_from : new_to) == lastState) %its V then it was B
                data(i:i+3) = 0;
                i = i + 3;
            else
                data(i) = 1;
            end
        else
            data(i) = 1;
        end
    end
    i = i + 1;
end


disp(data)