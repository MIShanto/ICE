%Digital signal....
%4 consecutive 0’s replaced by ‘000V’ or ‘B00V’ depending on number of non-zero pulses (odd or even)

clear all;
clc;
bit = [1 1 0 0 0 1 0 0 0 0 0 0 0 1];

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
%method 1
data = zeros(1, length(bit));
lastState = v;
counter = 0;
i=1;
non_zero_pulse = 0;

while i <= length(bit)
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    if(x_digital(from : to) == lastState) % either B or 1..
        data(i-3:i) = 0;
    elseif(x_digital(from : to) == 0)
            data(i) = 0;
    else
        data(i) = 1;
        lastState = -lastState;    
    end
    i = i + 1;
end

disp(data)

%method 2
data = zeros(1, length(bit));
lastState = v;
i=1;

while i <= length(t)/fs*bit_duration
    from = (i-1)*fs*bit_duration+1;
    to = i*fs*bit_duration;
    if(x_digital(from : to) == lastState) % either B or 1..
        data(i-3:i) = 0;
    elseif(x_digital(from : to) == 0)
            data(i) = 0;
    else
        data(i) = 1;
        lastState = -lastState;    
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
non_zero_pulse = 0;

for i = 1 : length(t)
  if t(i) > c*bit_duration
    c = c + 1;
    if x_digital(i) == lastState
      data(c-3:c) = 0;
    else
      if x_digital(i) == 0
        data(c) = 0;
      else
        data(c) = 1;
        lastState = -lastState;
      end
      end
      end
end
disp(data);