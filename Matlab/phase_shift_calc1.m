function [ X Y H_abs H_atan Xc ] = phase_shift_calc1( x, y)
%PHASE_SHIFT_CALC1 Summary of this function goes here
%   Detailed explanation goes here
sx = size(x);
if(sx(1) ~= 1)
    error('Only row vectors are allowed');
end
if(sx ~=size(y))
    error('Incompatible matrix dimensions');
end
n = 2^(ceil(log2(length(x))));
if(n ~= length(x))
    error('Vector length must be a power of two');
end
X = fft(x);
Y = fft(y);
H = Y./X;
H_abs = abs(H);
H_atan = angle(H);
N = length(x);
t = (2*pi*(N:-1:1)/N);
td = fftshift(H_atan)./(t-pi);
Xc = xcorr(y,x);
figure,subplot(3,2,1), plot(x);
subplot(3,2,2), plot(y);
subplot(3,2,3), plot(fftshift(H_abs));
subplot(3,2,4), plot(fftshift(H_atan));
subplot(3,2,5), plot(Xc);
subplot(3,2,6), plot(fftshift(td));
end

