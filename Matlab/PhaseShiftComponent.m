%%% Phase Shift Analyser

%%% Single signal analyser

%% Gather data from input port

signal_original = InputPort1.Sampled.Signal;
signal_output = InputPort2.Sampled.Signal; %Ignoring noise term

orig_len = length(signal_original);
out_len = length(signal_output);

%%

% Assuming input and output signals fall in same frequency window
time = InputPort1.Sampled.Time;
dt_samp = min(diff(time));
Fs = 1/dt_samp;


%%

[ X Y H_abs H_atan Xc t_delay] = phase_shift_calc1_pieceWise(signal_original,signal_output,Fs,orig_len,0);

%%

max_index = find(Xc == max(Xc));
delay = (max_index-orig_len)*dt_samp;
N = orig_len;
msgbox(strcat({'Autocorr maximum at index'},{' '},{num2str(max_index)},{' '},{'which corresponds to a time delay of'},{' '},{num2str(delay)},{' '},{'seconds'}));
nan_index = find(isnan(t_delay));
t_delay(nan_index) = 0;
msgbox(num2str(dt_samp*sum(abs(t_delay))/(N-1)));