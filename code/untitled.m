whaleFile = fullfile(matlabroot,"examples","matlab","data","bluewhale.au");
[w,fs] = audioread(whaleFile);

whale = timetable(seconds((0:length(w)-1)'/fs),w);