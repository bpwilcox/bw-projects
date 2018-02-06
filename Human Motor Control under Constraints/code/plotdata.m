function [ ] = plotdata( file )
    dos(['"C:\Program Files\Delsys, Inc\EMGworks 4.0 RC4\DelsysFileUtil.exe" -nogui -o CSV -i ' file]);
    data = csvread([file '.csv'], 1, 0);
    plot(data(:,1), data(:,2));
end