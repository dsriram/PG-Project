function [ X Y H_abs H_atan Xc t_delay ] = phase_shift_calc1_pieceWise( x, y, Fs, nFFT, skipCount)
%PHASE_SHIFT_CALC1 Summary of this function goes here
%   Detailed explanation goes here

%%
x = x(skipCount+1:end);
y = y(skipCount+1:end);

sx = size(x);
sy = size(y);

if((sx(1) ~= 1) || (sy(1) ~= 1))
    error('Only row vectors are allowed');
end

N = 2^(ceil(log2(nFFT)));

if(N ~= nFFT)
    error('FFT length must be a power of two');
end
nIter = min(floor(length(x)/nFFT),floor(length(y)/nFFT))

H = zeros(1,nFFT);
X = zeros(1,nFFT);
Y = zeros(1,nFFT);

%%
for i = 1:nIter
    start_index = 1+(i-1)*nFFT;
    end_index = i*nFFT;
    X = fft(x(start_index:end_index));
    Y = fft(y(start_index:end_index));
    H = H + (Y./X);
end

%%
H = H/nIter;
H_abs = abs(H);
H_atan = angle(H);
t = (2*pi*(N:-1:1)/N);
ph = [unwrap(H_atan(1:N/2)) unwrap(H_atan((N/2)+1:N))];
td = fftshift(ph)./(t-pi);
Xc = xcorr(y,x);
freq_axis = linspace(-Fs/2,(Fs/2)-(Fs/(2*N)),N);
t_delay = td;
%%
figure,subplot(3,2,1), plot(x);
title('Reference Signal');
subplot(3,2,2), plot(y);
title('Ouput Signal');
subplot(3,2,3), plot(freq_axis,fftshift(H_abs));
title('Frequency response');
subplot(3,2,4), plot(freq_axis,fftshift(ph));
title('Phase response');
subplot(3,2,5), plot(Xc);
title('Autocorrelation');
subplot(3,2,6), plot(freq_axis((N/2)+1:N),fftshift(td((N/2)+1:N)));
title('Time delay');
end

