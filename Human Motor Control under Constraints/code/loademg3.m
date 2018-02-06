function [header, data] = loademg3(filename);
% LOADEMG3 reads the EMG data file specified in filename.
% Returns the Emg data in the variable data, which is a [channels,samples] matrix.
% header contains a description of the data acquisition setup.
% Returns -1 if file couldn't be opened.
% Example:
% >> [header, data]=loademg3('test.emg');

% Copyright 2003 Delsys Inc.
% 03/11/03 Version 1.0
% 03/11/03 Version 1.1 
%           Replaced fgets with char(fread(fId,255,'char'))' to prevent inadvertent reading of string terminator
% 03/18/03 Version 1.2
%           Changed FileId to 'DEMG' and version to uint16 for backwards compatibility.
% 04/30/03 Version 1.3
%           Added more comments.
% 05/20/03 Version 1.4 
%           Fixed issues with reading to many points
% 06/25/03 Version 1.5
%           Added support for old EMG file format
% 03/17/08 Version 1.6
%           Fixed bugs related to value scaling in EMG file versions V2 and V3.
% 07/29/08 Version 1.7
%           Implemented platform-independent fread precision.
% 04/16/09 Version 1.8
%           Implemented read of EMG format v4


data = -1; % Default value
fId=fopen(filename,'r','n');
if fId>0
   % Read in header information
   header.ID= fgets(fId,4);                                                         % File ID
   % Verify the file ID
   if header.ID == 'DEMG'
       fprintf(1, 'Reading file %s...\n',filename);        
       
       header.Version = fread(fId,1,'uint16');                                      % File version
       
       % Read old file format
       if header.Version  == 1 || header.Version  == 2
           header.FileType = 0;                                 % FileType (0 = RAW data)
           header.EMGworksVersion = '';                         % EMGworks Version ("1.0.0.0")
           header.DADLLversion = '';                            % DADLL Version ("1.0.0.0")
           header.CardManufacturer = '';                        % A/D card Manufacturer
           header.ADCardID = [];                                % A/D card Identifier
           header.ESeries = [];                                  % National Instruments E-Series Card? (0 = NO, 1 = YES)
           header.Channels = fread(fId,1,'unsigned short');     % Number of channels
           header.Fs= fread(fId,1,'unsigned long');             % Actual sampling frequency
           header.Samples = fread(fId,1,'unsigned long');       % Actual number of samples
           header.SamplesDesired = [];                          % Desired number of samples
           header.FsDesired = header.Fs;                        % Desired sampling frequency 
           header.DataStart = [];                              % Data start point in the file (byte count)
           header.TriggerStart = [];                             % Start Trigger mode (0 = Auto, 1 = Manual, 2 = External trigger)
           header.TriggerStop = [];                              % Stop Trigger mode (0 = Auto, 1 = Manual, 2 = External trigger)
           header.DaqSingleEnded = [];                           % Single ended Daq mode (1 = Single ended)
           header.DaqBipolar = [];                               % Bipolar ended Daq mode (1 = Bipolar)
           header.UseCamera = 0;                                % Camera use (0 = NO, 1 = YES)
           %strLength = fread(fId,1,'uint32'); 
           header.VideoFilename = '';                           % Associated Video File name
           % Read in Channel info
           for i = 1 : header.Channels
               header.ChannelInfo(i).Channel = i;               % Channel number (one based) 
               % strLength = fread(fId,1,'uint32'); 
               header.ChannelInfo(i).Unit = '';                 % Unit
               % strLength = fread(fId,1,'uint32'); 
               header.ChannelInfo(i).Label = ['Ch' int2str(i)]; % Label
               header.ChannelInfo(i).SystemGain = [];           % System Gain
               header.ChannelInfo(i).ADGain = [];               % AD Gain
               header.ChannelInfo(i).BitResolution = [];        % Bit resolution
               header.ChannelInfo(i).Bias = [];                 % System Bias
               header.ChannelInfo(i).HP = [];                   % High Pass cutoff frequency
               header.ChannelInfo(i).LP = [];      
           end%for i = 1 : header.Channels
           % read the data
           resolution=fread(fId,1,'uchar');%
           vMin=fread(fId,1,'schar');%
           vMax=fread(fId,1,'schar');%
           switch header.Version
               case 1	%data stored as floats
                   data=fread(fId,[header.Channels,header.Samples],'float32');	% read the emg matrix in
               case 2	%data stored as uints
                   data=fread(fId,[header.Channels,header.Samples],'uint16');	% read the emg matrix in
                   data=(data/(2^resolution)*(vMax-vMin) - 5) / 1000;			% scale the data	
           end
       
       elseif header.Version == 3 || header.Version == 4
           % Read the rest of the header.
           header.FileType = fread(fId,1,'uint32');                                 % FileType (0 = RAW data)
           header.EMGworksVersion = char(fread(fId,11,'uchar'))';                    % EMGworks Version ("1.0.0.0")
           header.DADLLversion = char(fread(fId,11,'uchar'))';                       % DADLL Version ("1.0.0.0")
           header.CardManufacturer = char(fread(fId,255,'uchar'))';                  % A/D card Manufacturer
           header.ADCardID = fread(fId,1,'uint32');                                 % A/D card Identifier
           header.ESeries = fread(fId,1,'uint32');                                  % National Instruments E-Series Card? (0 = NO, 1 = YES)
           header.Channels = fread(fId,1,'uint32');                                 % Number of channels
           header.Samples = fread(fId,1,'uint32');                                  % Actual number of samples
           header.SamplesDesired = fread(fId,1,'uint32');                           % Desired number of samples
           header.Fs= fread(fId,1,'double');                                        % Actual sampling frequency
           header.FsDesired = fread(fId,1,'double');                                % Desired sampling frequency 
           header.DataStart = fread(fId,1,'uint32');                                % Data start point in the file (byte count)
           header.TriggerStart = fread(fId,1,'uint32');                             % Start Trigger mode (0 = Auto, 1 = Manual, 2 = External trigger)
           header.TriggerStop = fread(fId,1,'uint32');                              % Stop Trigger mode (0 = Auto, 1 = Manual, 2 = External trigger)
           header.DaqSingleEnded = fread(fId,1,'uint32');                           % Single ended Daq mode (1 = Single ended)
           header.DaqBipolar = fread(fId,1,'uint32');                               % Bipolar ended Daq mode (1 = Bipolar)
           header.UseCamera = fread(fId,1,'uint32');                                % Camera use (0 = NO, 1 = YES)
           strLength = fread(fId,1,'uint32'); 
           header.VideoFilename = char(fread(fId,strLength,'uchar'))';               % Associated Video File name
           % Read in Channel info
           for i = 1 : header.Channels
               header.ChannelInfo(i).Channel = fread(fId,1,'uint32');               % Channel number (one based) 
               strLength = fread(fId,1,'uint32'); 
               header.ChannelInfo(i).Unit = char(fread(fId,strLength,'uchar'))';     % Unit
               strLength = fread(fId,1,'uint32'); 
               header.ChannelInfo(i).Label = char(fread(fId,strLength,'uchar'))';    % Label
               header.ChannelInfo(i).SystemGain = fread(fId,1,'double');            % System Gain
               header.ChannelInfo(i).ADGain = fread(fId,1,'double');                % AD Gain
               header.ChannelInfo(i).BitResolution = fread(fId,1,'double');         % Bit resolution
               header.ChannelInfo(i).Bias = fread(fId,1,'double');                  % System Bias
               header.ChannelInfo(i).HP = fread(fId,1,'double');                    % High Pass cutoff frequency
               header.ChannelInfo(i).LP = fread(fId,1,'double');                    % Low Pass cutoff frequency
               if header.Version == 4
                   header.ChannelInfo(i).SamplingFreq = fread(fId,1,'double');
                   header.ChannelInfo(i).StartOffset = fread(fId,1,'float32');
               end
           end    
           % Read the data.
           data = fread(fId,[header.Channels, header.Samples], 'int16');%
           
           % Scale the data
           for i = 1 : header.Channels
               data(i,:) = (data(i,:) * header.ChannelInfo(i).BitResolution - header.ChannelInfo(i).Bias) / header.ChannelInfo(i).SystemGain;
           end
       else
           fprintf(1, 'Uknown file version for file %s\n',filename);
       end
   else %if header.ID == 'DEMG'
       fprintf(1, 'File %s is not a proper EMG file\n',filename);
       header=[];  % need to return something otherwise error message
       data = [];  
   end %if header.ID == 'DEMG'
   fclose(fId);
else
    fprintf(1, 'File %s not found !!!\n',filename);
    header=[];  % need to return something otherwise error message
    data = [];  
end

  
