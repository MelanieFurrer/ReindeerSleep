%% SLOW WAVE DETECTION ALGORITHM
%
% THIS ALGORITHM DEFINES A SLOW WAVE TO HAVE A FORM LIKE THIS:
%
%            %%
%           %  %
%          %    %
%    %     %
%     %   %
%      %%%
%
% SO THAT IT STARTS AND ENDS WITH A NEGATIVE ZERO CROSSING.
%
%
% INPUT
% EEG:      The EEG structure, including EEG.data, EEG.srate, and EEG.pnts,
%           which stand for the data, sampling rate and number of samples,
%           respectively. EEG.data is a channel x sample matrix.
%           Rows: Channels; Columns: Sample points
%
% varagin:  Optional input arguments. This algorithm allows you to select a
%           subset of slow waves (e.g. higher than xx \muV or between
%           0.5 - 4 Hz). Current name-value pairs include:
%
%           'thresh_p2pamp', 20 - sets the minimal peak-to-peak amplitude
%           criterion to 20 \muV
%
%           'thresh_freq', [0.5, 4] - checks wether the negative part of the slow
%           wave is between 0.5 and 4Hz. The negative part of a slow wave
%           is between the negative and the positive zero crossing. If you
%           don't want a freq criterion, set it to [0, 1000] (default).
%
%           'thresh_negamp', 37.5 - only detects slow waves with a negative
%           peak amplitude of 37.5 \muV.
%
%           'fs', 500 - In case you want to work with a dataset with a
%           sampling rate of 500Hz, but you run this algorithm on a
%           dataset with 128Hz (speed reasons), the algorithm will adjust
%           the timings of the peaks, etc. for you to the dataset of 500Hz.
%
%           'moving_avg', 5 - applies a 5pnt moving average window on
%           the derivative of the data before finding peaks. This smoothes
%           the derivative a little.
%
%           'vissymb', ['0011223321rrr'] - when available, checks
%           whether the detected slow-wave (the whole wave is part of N2 or 
%           N3 sleep (the whole wave). 0: wake, 1=N1, 2=N2, 3=N3, r=REM
%
%           'visnum', [00-1-1-2-2-3-3] - when available, checks
%           whether the detected slow-wave (the whole wave is part of N2 or 
%           N3 sleep (the whole wave). 1: wake, -1=N1, -2=N2, -3=N3, 0=REM
%
%           'track', [a 2D or 3D matrix] - while sleep scoring, you can
%           reject 4s snippets of each 20s epoch. You can even do this
%
%           'artndxn', [2D matrix] - A channel x 20s epoch matrix consiting 
%           of zeros and other numbers, where 0: bad 20s epoch and 
%           >0: good 20s epoch.
%
%           'short_form', 0|1 - if 1, only saves most important features,
%           such as maximum amplitudes, slopes, frequency, etc., but
%           not every single peak (except the maximum peak) of a wave.
%
%           'remove_chans', [vector] - a vector of channels, which are
%           labelled are "bad" in artndxn. Slow waves will still be
%           detected in those channels, but whether an epoch was good or
%           does not rely on these channels.
%
%           'plot_chan', int - channel index (one!) of which you want
%           to have a plot with detected negative and positive peaks. If
%           not specified, no plot will be generated.
%
% OUTPUT
% sw_result: A structure, containing slow wave parameters for each channel.
%           The structure containts the time (in samples) of
%           wvend       - the end of all waves
%           wvstart     - the start of all waves
%           negzx       - all negative zero crossings
%           negpks      - all negative peaks within each wave
%           maxnegpk    - the maximum negative peak of each wave
%           negpkamp    - the amplitude of all negative peaks within each wave
%           maxnegpkamp - the amplitude of the maximum negative peak within each wave
%           poszx       - all posative zero crossings
%           pospks      - all positive peaks within each wave
%           maxpospk    - the maximum positive peak of each wave
%           pospkamp    - the amplitude of all positive peaks within each wave
%           maxpospkamp - the amplitude of the maximum positive peak within each wave
%           maxdnslope  - maximum down slope of the negative part of the wave
%           maxupslope  - maximum up slope of the negative part of the wave
%           meandnslope - average doen slope of the negative part of the wave
%           meanupslope - average up slope of the negative part of the wave
%           lindnslope  - linear down slupe (amplitude / time) of the negative part of the wave
%           linupslope  - linear up slupe (amplitude / time) of the negative part of the wave
%           freq        - frequency of the wave
%
%
% Original script from Mathilde Spiess et al. (31.03.2016). She modified it
% from the Visual Deprivation Project (CIRS). This version now (25.04.2019)
% includes optional inputs, a clean code and a clean output.
%
% - Sven Leach (25.04.2019) -
%

function sw_result = swdetect(EEG, varargin)


%% Varargin
%%%%%%%%%%%

% DEFAULT INPUT VALUE PAIRS
p = inputParser;
addParameter(p, 'thresh_negamp', 0,         @isnumeric);
addParameter(p, 'thresh_p2pamp', 0,         @isnumeric);
addParameter(p, 'thresh_freq',   [0, 1000], @isvector);
addParameter(p, 'fs',            EEG.srate, @isnumeric);
addParameter(p, 'moving_avg',    1,         @isnumeric);
addParameter(p, 'artndxn',       [],        @ismatrix);
addParameter(p, 'epoch_len',     20,        @isnumeric);
addParameter(p, 'vissymb',       [],        @isvector);
addParameter(p, 'visnum',        [],        @isvector);
addParameter(p, 'tracks',        [],        @isnumeric);
addParameter(p, 'short_form',    1,         @isnumeric);
addParameter(p, 'remove_chans',  [43 48 49 56 63 68 73 81 88 94 99 107 113 119 120 125 126 127 128], @isnumeric);
addParameter(p, 'plot_chan',     [],        @isnumeric);

% RETRIEVE THE SET VALUE BY THE USER, OR THE DEFAULT VALUE IF NO VALUE WAS SET
parse(p,varargin{:});
fs              = p.Results.fs;
thresh_p2pamp   = p.Results.thresh_p2pamp;
thresh_freq     = p.Results.thresh_freq/2;
thresh_negamp   = p.Results.thresh_negamp;
moving_avg      = p.Results.moving_avg;
artndxn         = p.Results.artndxn;
vissymb         = p.Results.vissymb;
visnum          = p.Results.visnum;
epoch_len       = p.Results.epoch_len;
tracks          = p.Results.tracks;
short_form      = p.Results.short_form;
remove_chans    = p.Results.remove_chans;
plot_chan        = p.Results.plot_chan;



%% ARTNDXN - DISCARD NOISY EPOCHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
artNdxGood = [];
if ~isempty(artndxn)
    if ~isempty(remove_chans)
        artndxn(remove_chans,:) = 0;                            % those channels are considered bad channels
    end
    ndxGoodCh  = find(sum(artndxn,2) > 0);                      % index of good channels
    nGoodCh    = numel(ndxGoodCh);                              % number of good channels
    artNdxGood = find(sum(artndxn(ndxGoodCh,:), 1) == nGoodCh); % Bad epochs have '0' in each column, good '1' --> take only epochs where all channels are good
end


%% VISSYMB - ONLY CONSIDER NREM EPOCHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sleepNdxn = [];
if ~isempty(vissymb)
    sleepNdxn  = find(vissymb == '2' | vissymb == '3');                  % NREM epochs
%     sleepSmpl  = (sleepNdxn-1)*EEG.srate*epoch_len;                    % NREM sample points (only the first sample of each epoch)
%     addMatrix  = repmat(1:EEG.srate*epoch_len, length(sleepSmpl), 1);  % add this matrix
%     sleepPnts  = bsxfun(@plus, sleepSmpl', addMatrix);                 % to get all sample points of an epoch  
%     wake     = setdiff((1:length(vissymb)),sleepndx);                  % Wake and REM and N1 epochs
end

% VISNUM
if ~isempty(visnum)
    sleepNdxn  = find(visnum == -2 | visnum == -3);  % NREM epochs
end


%% TRACK - ONLY CONSIDER CLEAN 4s epochs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trackNdxGood = [];
if ~isempty(tracks)
   trackSum     = sum(tracks == 49, 3);   % summarize all tracks, 49: bad epoch, number indicates how many tracks were bad in a 4s epoch.
%    trackNdxn = find(reshape(trackSum', 1, numel(trackSum)) == 0); % get the 4s epochs which are labeles as clean (zero = clean) 
   trackSum     = sum(trackSum,2);        % summarize all 4s windows per 20s window, >0: bad epoch 
   trackNdxGood = find(trackSum'==0);     % the zero's are good 20s epochs, find them
end


%% SLOW WAVE DETECTION
%%%%%%%%%%%%%%%%%%%%%%

disp(['**** Slow Wave Detection ****']);
disp(['Analyzing ', num2str(size(EEG.data,1)),' channels']);

% WAITBAR
h = waitbar(0, 'Detection Progress');

% FOR EACH CHANNEL
for chan = 1:size(EEG.data, 1)
    
    % WAITBAR
    waitbar(chan/size(EEG.data,1), h, 'Detection Progress')
    
    % PREPARE
    data = EEG.data(chan, :);
    fs_detect = EEG.srate;
    
    % SEARCH FOR NEG AND POS ZERO CROSSINGS
    pos_index                 = zeros(length(data), 1);     % Create an empty list for positive peaks
    pos_index(find(data>0))   = 1;                          % Index of all positive points for EEG
    difference                = diff(pos_index);            % Locate the first positive and negative point (in time) for each series of consecutive points
    poscross                  = find(difference ==  1);     % Return the position of all first positive points
    negcross                  = find(difference == -1);     % Return the position of all first negative points
    
    % APPLY MOVING AVERAGE FILTER IF WANTED
    deriv = meanfilt(diff(data), moving_avg);       % Meanfilt is a function that uses a X sample moving window to smooth derivative.    
%     B     = 1/moving_avg*ones(moving_avg,1);          % This moving average version (https://ch.mathworks.com/matlabcentral/answers/114442-how-to-design-a-moving-average-filter)
%     deriv = single(filtfilt(B,1,double(diff(data)))); % is way faster then the meanfilt() function written in this script. Cannot handle NAN values though.
    
    % SEARCH FOR TROUGHS AND PEAKS
    pos_index                 = zeros(length(deriv),1);           % Repeat above procedure on (smoothed) derivative of signal
    pos_index(find(deriv>0))  = 1;                                % Index of all positive points above minimum threshold
    difference                = diff(pos_index);                  % Locate first positive and negative points
    peaks                     = find(difference == -1) +1;        % Find pos ZX and neg ZX of the derivative (peaks)
    troughs                   = find(difference ==  1) +1;        % Find pos ZX and neg ZX of the derivative (troughs)
    peaks(data(peaks)<0)      = [];                               % Rejects peaks below zero
    troughs(data(troughs)>0)  = [];                               % Rejects troughs above zero
    
    % ALWAYS START WITH A NEGATIVE ZERO CROSSING
    if negcross(1) < poscross(1)
        start = 1;                                          % If first peak is negative
    else
        start = 2;                                          % If first peak is positive, skip it
        poscross(1) = [];                                   % In order to skip it, delete it
    end
    
    
    
    %% Wave parameters initialization
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sw_result.waves(chan).wvend(1)       = single(NaN);
    sw_result.waves(chan).wvmid(1)       = single(NaN);    
    sw_result.waves(chan).wvstart(1)     = single(NaN);
    sw_result.waves(chan).maxnegpk(1)    = single(NaN);
    sw_result.waves(chan).maxnegpkamp(1) = single(NaN);
    sw_result.waves(chan).maxpospk(1)    = single(NaN);
    sw_result.waves(chan).maxpospkamp(1) = single(NaN);
    sw_result.waves(chan).meandnslope(1) = single(NaN);
    sw_result.waves(chan).meanupslope(1) = single(NaN);    
    sw_result.waves(chan).maxdnslope(1)  = single(NaN);
    sw_result.waves(chan).maxupslope(1)  = single(NaN);
    sw_result.waves(chan).lindnslope(1)  = single(NaN);
    sw_result.waves(chan).linupslope(1)  = single(NaN);
    sw_result.waves(chan).freq(1)        = single(NaN);  
    
    % Wave parameters that are often not needed
    if ~short_form
        sw_result.waves(chan).negzx(1)       = NaN;  
        sw_result.waves(chan).poszx(1)       = NaN;  
        sw_result.waves(chan).negpks{1}      = NaN; 
        sw_result.waves(chan).pospks{1}      = NaN;  
        sw_result.waves(chan).negpkamp{1}    = NaN;  
        sw_result.waves(chan).pospkamp{1}    = NaN;  
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    
    %% Locate Peaks
    %%%%%%%%%%%%%%%
    wvi = 1;
    
    % FOR EVERY WAVE (
    num_waves = length(negcross)-1;
    textprogressbar(sprintf('Processing channel #%d:  ', chan));
    for wndx  = start:num_waves
        textprogressbar(wndx/num_waves*100);

        % FIND START AND END OF A WAVE (BETWEEN TWO NEGATIVE ZERO CROSSINGS)
        %
        %            %%
        %           %  %
        %          %    %
        %    %     %
        %     %   %
        %      %%%
        %
       
        wavestart  = negcross(wndx);                                    % Start of a wave
        wavend     = negcross(wndx+1) - 1;                              % End of a wave
        wavemid    = poscross(wndx);                                    % Midpoint of a wave (well, not necessarily, only for beautiful sine waves..)
        
        % frequency
        freq = 1 / ((wavend - wavestart) / fs_detect); % frequency of a full wave
        
%         if ceil(wavestart/EEG.srate/epoch_len) == 43
%             display('trouble shoot')
%         end
        
        % SLEEP STAGE CRITERION
        if ~isempty(vissymb) | ~isempty(visnum)
            if ~ismember(ceil(wavestart/EEG.srate/epoch_len), sleepNdxn) | ~ismember(ceil(wavend/EEG.srate/epoch_len), sleepNdxn) % Only consider a wave if it's start and endpoint is part of NREM 2 and NREM 3            
                continue
            end
        end 
        
        % ARTIFACT FROM SEMI-AUTOMATIC ARTIFACT DETECTION CRITERION
        if ~isempty(artndxn) 
            if ~ismember(ceil(wavestart/EEG.srate/epoch_len), artNdxGood) | ~ismember(ceil(wavend/EEG.srate/epoch_len), artNdxGood) % Only consider a wave if it's start and endpoint is part of NREM 2 and NREM 3            
                continue
            end
        end       
  
        % ARTIFACT TRACK CRITERION
        if ~isempty(tracks)
%             if wavestart == 844296 | wavestart == 1080838 %
%                 display('Delete this line later')
%             end
%             if ~ismember(ceil(wavestart/EEG.srate/4), trackNdxn) | ~ismember(ceil(wavend/EEG.srate/4), trackNdxn) % Only consider a wave if it's start and endpoint is not labeled as an artifact during sleep scoring
              if ~ismember(ceil(wavestart/EEG.srate/epoch_len), trackNdxGood) | ~ismember(ceil(wavend/EEG.srate/epoch_len), trackNdxGood) % Only consider a wave if it's start and endpoint is not labeled as an artifact during sleep scoring
               continue
            end
        end
                
        % FIND ALL PEAKS IN A WAVE
        negpeaks   = troughs(troughs > wavestart & troughs < wavend);   % all negative peaks
        wavepk     = negpeaks(data(negpeaks) == nanmin(data(negpeaks)));   % max negative peak
        pospeaks   = peaks(peaks > wavestart & peaks<=wavend);          % all positive peaks
        if isempty(pospeaks)
            pospeaks = wavend;                                          % if pospeaks is empty (so when the signal didn't cross 0 again) set pospeak to pos ZX
        end;
        
        % GET AMPLITUDE OF PEAKS ALL PEAKS IN A WAVE
        negpkamp   = data(negpeaks);      % amplitude of all negative peaks
        pospkamp   = data(pospeaks);      % amplitude of all positive peaks
        nump       = length(negpeaks);    % number of negative peaks
        
        % LOCATION OF THE MAX NEG AND POS PEAK AMPLTIDE
        maxb       = nanmin(data(negpeaks));                            % Max neg peak amp
        maxbx      = negpeaks(find(data(negpeaks) == maxb, 1, 'last')); % Location of the max neg peak amp (if there are several peaks with the same amplitude, take the last).
        
        maxc       = nanmax(data(pospeaks));                            % Max pos peak amp
        maxcx      = pospeaks(find(data(pospeaks) == maxc, 1));         % Location of the max pos peak amp (if there are several peaks with the same amplitude, take the first).
        
        % PEAK 2 PEAK AMPLITUDE
        waveamp    = abs(single(maxc)) + abs(single(maxb));             % neg to pos peak amplitude
        %     waveamp=abs(single(maxb)); %GBtest (neg peak amplitude)
        wavelength = abs((single(wavestart) - single(wavemid))./fs_detect);    % length of down-state in [s]
                
        
        % GET PARTS OF DATA
        downstate  = data(wavestart:wavemid);
        falling    = data(wavestart:wavepk);          % data from neg. zero crossing to neg. peak
        rising     = data(wavepk:wavemid);            % data from neg. peak to pos. zero crossing 
        
        % GET LATENCY OF STRONGEST DESCENDING AND ASCENDING SLOPE       
        mxdn       = abs(nanmin(meanfilt(diff(falling), moving_avg)))*fs_detect;   % Descending slope: the point in time where the signal goes down the quickest
        mxup       = abs(nanmax(meanfilt(diff(rising), moving_avg)))*fs_detect;    % Ascending slope: the point in time where the signal goes up the quickest                    
        
        % GET MEAN DESCENDING AND SCENDING SLOPE SLOPE
        meandn     = abs(nanmean(diff(falling)))*fs_detect;  % average descending slope
        meanup     = abs(nanmean(diff(rising)))*fs_detect;   % average ascending slope
        
        % LINEAR SLOPE
        lindn = abs(single(maxb)) / ( length(falling) / fs_detect );       % slope calculated as max neg peak over time needed from neg zero crossing to max neg peak
        linup = abs(single(maxb)) / ( length(rising)  / fs_detect );       % slope calculated as max neg peak over time needed from max neg peak to pos zero crossing
        
        % Correct slope in case rising phase only consists of one data point
        if length(rising) == 1
            mxup = NaN;
        end
        if length(falling) == 1
            mxdn = NaN;
        end        
        
        % FREQUENCY CRITERION
        if wavelength > thresh_freq(1) && wavelength < thresh_freq(2)
            
            % AMPLITUDE FROM NEG TO POS PEAK CRITERION
            if waveamp>thresh_p2pamp
                
                % AMPLITUDE OF NEGATIVE PEAK
                if abs(maxb) > abs(thresh_negamp)
                    
                    %% Wave parameters
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    sw_result.waves(chan).wvstart(wvi)     = single(round(wavestart./fs_detect.*fs));  % wave start ( = negative zx)
                    sw_result.waves(chan).wvmid(wvi)       = single(round(wavemid./fs_detect.*fs));    % wave midpoint ( = positive zx)  
                    sw_result.waves(chan).wvend(wvi)       = single(round(wavend./fs_detect.*fs));     % wave end ( = next negative zx)
                    sw_result.waves(chan).maxnegpk(wvi)    = single(round(maxbx./fs_detect.*fs));      % position of maximum negative peak in a wave
                    sw_result.waves(chan).maxnegpkamp(wvi) = single(maxb);                             % maximum amplitude of negative peak
                    sw_result.waves(chan).maxpospk(wvi)    = single(round(maxcx./fs_detect.*fs));      % position of maximum positive peak
                    sw_result.waves(chan).maxpospkamp(wvi) = single(maxc);                             % amplitude of all positive peaks
                    sw_result.waves(chan).freq(wvi)        = single(freq);                             % frequency of a wave
                    sw_result.waves(chan).meandnslope(wvi) = single(meandn);                           % mean descending slope in negatieve part of slow wave
                    sw_result.waves(chan).meanupslope(wvi) = single(meanup);                           % mean ascending slope in negatieve part of slow wave
                    sw_result.waves(chan).maxdnslope(wvi)  = single(mxdn);                             % maximum descending slope in negatieve part of slow wave
                    sw_result.waves(chan).maxupslope(wvi)  = single(mxup);                             % maximum ascending slope in negatieve part of slow wave                                        
                    sw_result.waves(chan).lindnslope(wvi)  = single(lindn);
                    sw_result.waves(chan).linupslope(wvi)  = single(linup);                    
                    
                    % Wave parameters that are often not needed
                    if ~short_form
                        sw_result.waves(chan).negzx(wvi)       = single(round(negcross(wndx)./fs_detect.*fs));    % negative zx
                        sw_result.waves(chan).poszx(wvi)       = single(round(poscross(wndx)./fs_detect.*fs));    % positive zx
                        sw_result.waves(chan).negpks{wvi}      = single(round(negpeaks./fs_detect.*fs));          % position of all negative peaks in a wave
                        sw_result.waves(chan).pospks{wvi}      = single(round(pospeaks./fs_detect.*fs));          % position of all positive peaks in a wave
                        sw_result.waves(chan).negpkamp{wvi}    = single(negpkamp);                                % amplitude of all negative peaks
                        sw_result.waves(chan).pospkamp{wvi}    = single(pospkamp);                                % amplitude of all positive peaks
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    wvi=wvi+1;
                    
                end
            end
        end
    end % wave loop
    textprogressbar('done');
    
    % ADD NUMBER OF WAVES
    sw_result.waves(chan).nwaves = wvi;                       
        
    % ADD CHANNEL LABELS
    if ~isempty(EEG.chanlocs)
        sw_result.waves(chan).chanlabel     = EEG.chanlocs(chan).labels;
    end

    

end % channel loop

% ADD DETECTION PARAMETERS
sw_result.params.pnts          = single(EEG.pnts);       % number of data points
sw_result.params.fs            = single(fs);             % all latencies are computed for this sampling rate
sw_result.params.fs_detect     = single(fs_detect);      % sampling rate used for slow detection
sw_result.params.thresh_negamp = single(thresh_negamp);
sw_result.params.thresh_p2pamp = single(thresh_p2pamp);
sw_result.params.thresh_freq   = single(thresh_freq);
sw_result.params.moving_avg    = single(moving_avg);
sw_result.params.artndxn       = isempty(artndxn);       % tells you whether artndxn was used or not.      
sw_result.params.epoch_len     = single(epoch_len);
sw_result.params.vissymb       = isempty(vissymb);       % tells you whether vissymb was used or not.      
sw_result.params.tracks        = isempty(tracks);        % tells you whether tracks was used or not.      
sw_result.params.short_form    = logical(short_form);
sw_result.params.remove_chans  = single(remove_chans);
sw_result.params.artNdxGood    = single(artNdxGood);     % Epochs that were considered as "good" in all channels from artndxn
sw_result.params.sleepNdxn     = single(sleepNdxn);      % Sleep epochs
sw_result.params.trackNdxGood  = single(trackNdxGood);   % Epochs that were considered as "good" from track changes

% CLOSE WAITBAR
close(h)
disp(['**** Detection Completed ****']);


%% PLOT OUTCOME 
%%%%%%%%%%%%%%%
if ~isempty(plot_chan)
    data = EEG.data(plot_chan, :);     % 1 channel
    sw   = sw_result.waves(plot_chan); % slow wave detection result

    figure('color', 'w'); hold on;
    p1 = plot(data, '-', 'LineWidth', 2, 'DisplayName', 'data');
    p2 = plot(sw.wvstart, data(sw.wvstart),  's', 'MarkerSize', 8, 'DisplayName', 'wve start');  % start of sw
    p3 = plot(sw.wvend, data(sw.wvend),      'x', 'MarkerSize', 8, 'DisplayName', 'wve end');    % end of sw
    p4 = plot(sw.maxpospk, sw.maxpospkamp,   '^', 'MarkerSize', 8, 'DisplayName', 'max + peak'); % max pos peak
    p5 = plot(sw.maxnegpk, sw.maxnegpkamp,   'v', 'MarkerSize', 8, 'DisplayName', 'max - peak'); % max neg peak
    plot(zeros(1, length(data)), ':', 'HandleVisibility', 'off');
    legend();
    ylabel('Amplitude (\muV)');
    xlabel('Time (samples)');
    
    % Good epochs
    if ~isempty(artNdxGood)
        artNdxnPlotX = bsxfun(@plus, (artNdxGood'*EEG.srate*epoch_len-EEG.srate*epoch_len), [1:EEG.srate*epoch_len]);
        artNdxnPlotY = ones(1, length(artNdxnPlotX))*min(data) - min(data)/20;
        p11 = plot(artNdxnPlotX, artNdxnPlotY, 'r.', 'MarkerSize', 8, 'HandleVisibility','off', 'DisplayName', 'Good epochs (artndxn)');
        legend([p1,p2,p3,p4,p5,p11(1)])    
    end
        
    % Sleep epochs
    if ~isempty(sleepNdxn)
        sleepNdxnX = bsxfun(@plus, (sleepNdxn'*EEG.srate*epoch_len-EEG.srate*epoch_len), [1:EEG.srate*epoch_len]);
        sleepNdxnY = ones(1, length(sleepNdxnX))*min(data);
        p12 = plot(sleepNdxnX, sleepNdxnY, 'k.', 'MarkerSize', 8, 'HandleVisibility','off', 'DisplayName', 'Sleep epochs (vissymb)');
        legend([p1,p2,p3,p4,p5,p12(1)])       
    end
    
    % Correct legend
    if ~isempty(artNdxGood) & ~isempty(sleepNdxn)
        legend([p1,p2,p3,p4,p5,p11(1),p12(1)])    
    end
        
    if ~isempty(EEG.chanlocs)
        title(sprintf('Channel: %s', sw.chanlabel))
    end
end

%% CHECK WHAT PARAMTERS DO
%%%%%%%%%%%%%%%%%%%%%%%%%%

% % slow-wave detection variables
% figure; hold on;
% data = EEG.data(end, :);                  
% plot(EEG.data(end, :), '.', 'LineWidth', 2)
% plot(deriv, '--')
% plot(meanfilt(deriv, 5))
% plot(poscross, data(poscross), 'g^', 'MarkerSize', 10)
% plot(negcross, data(negcross), 'rv', 'MarkerSize', 10)
% plot(peaks, data(peaks), 'go', 'MarkerSize', 10)
% plot(troughs, data(troughs), 'ro', 'MarkerSize', 10)
% plot(zeros(1, length(data)), ':')
% xlim([EEG.srate*5, EEG.srate*25])
% legend({'Data', '1st derivative', 'meanfilt(1st derivative, 5)', '+ crossings', '- crossings', 'peaks', 'troughs'})





% SLIDING AVERAGE WINDOW
function [filtdata]=meanfilt(datatofilt,pts);
    if length(datatofilt)>=pts & pts > 1
        filtdata=[];
        ptsaway=floor(pts/2);
        filtdata([1:pts])=datatofilt([1:pts]);
        filtdata([length(datatofilt)-(pts-1):length(datatofilt)])=datatofilt([length(datatofilt)-(pts-1):length(datatofilt)]);
        for wndw=pts-ptsaway:length(datatofilt)-(pts-ptsaway)
            filtdata(wndw)=nanmean(datatofilt([wndw-(ptsaway):wndw+(ptsaway)]));
        end
    else
        filtdata=datatofilt;
    end
    
% TEXT PROGRESS BAR
function textprogressbar(c)
    % This function creates a text progress bar. It should be called with a 
    % STRING argument to initialize and terminate. Otherwise the number correspoding 
    % to progress in % should be supplied.
    % INPUTS:   C   Either: Text string to initialize or terminate 
    %                       Percentage number to show progress 
    % OUTPUTS:  N/A
    % Example:  Please refer to demo_textprogressbar.m
    % Author: Paul Proteus (e-mail: proteus.paul (at) yahoo (dot) com)
    % Version: 1.0
    % Changes tracker:  29.06.2010  - First version
    % Inspired by: http://blogs.mathworks.com/loren/2007/08/01/monitoring-progress-of-a-calculation/
    %% Initialization
    persistent strCR;           %   Carriage return pesistent variable
    % Vizualization parameters
    strPercentageLength = 10;   %   Length of percentage string (must be >5)
    strDotsMaximum      = 10;   %   The total number of dots in a progress bar
    %% Main 
    if isempty(strCR) && ~ischar(c),
        % Progress bar must be initialized with a string
        error('The text progress must be initialized with a string');
    elseif isempty(strCR) && ischar(c),
        % Progress bar - initialization
        fprintf('%s',c);
        strCR = -1;
    elseif ~isempty(strCR) && ischar(c),
        % Progress bar  - termination
        strCR = [];  
        fprintf([c '\n']);
    elseif isnumeric(c)
        % Progress bar - normal progress
        c = floor(c);
        percentageOut = [num2str(c) '%%'];
        percentageOut = [percentageOut repmat(' ',1,strPercentageLength-length(percentageOut)-1)];
        nDots = floor(c/100*strDotsMaximum);
        dotOut = ['[' repmat('.',1,nDots) repmat(' ',1,strDotsMaximum-nDots) ']'];
        strOut = [percentageOut dotOut];

        % Print it on the screen
        if strCR == -1,
            % Don't do carriage return during first run
            fprintf(strOut);
        else
            % Do it during all the other runs
            fprintf([strCR strOut]);
        end

        % Update carriage return
        strCR = repmat('\b',1,length(strOut)-1);

    else
        % Any other unexpected input
        error('Unsupported argument type');
    end

