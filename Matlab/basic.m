clear all;
clc;

a1 = 5; 
fc1 = 4;
fs1 = 100;
phi_1 = 0;
T1 = 5;
t1 = 0:1/fs1:T1;

a2 = 2; 
fc2 = 2;
fs2 = 100;
phi_2 = 90;
T2 = 5;
t2 = 0:1/fs2:T2;

x1 = a1*sin(2*pi*fc1*t1+phi_1);
%x1 = 6 + a1*sin(2*pi*fc1*t1+phi_1); with dc component 6
x2 = a2*sin(2*pi*fc2*t2+phi_2);
x3 = x2 + x1;

subplot(3,2,1);
plot(t1,x1);
subplot(3,2,2);
plot(t2,x2);
subplot(3,2,3);
plot(t2,x3);

% show 10 harmonics of x1
h = zeros(1, length(t1))
for i = 1:10
    h = h + a1*sin(2*pi*i*fc1*t1+phi_1);
end
subplot(3,2,4);
plot(t1,h);

%Digital signal....

clear all;
clc;
bit = [1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1];

v_0 = -5;
v_1 = 5;

fs = 100;
bit_duration = 2;
T = length(bit) * bit_duration;
t = 0:1/fs:T;

x_digital = zeros(1, length(t));

for i = 1:length(bit)
    if bit(i) == 1
        x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = v_1;
    else
        x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = v_0;
    end
end

subplot(3,2,5);
plot(t, x_digital);
xlim([0, T]);
ylim([-10, 10]);
grid on;