%% A function that returns a cell array consisting of videos read from an input directory
function  videos = read_videos(video_dir)
    
    num = length(video_dir);
    nframes = 200;
    videos = cell(num,1);
    
    for i = 1:num
        name = strcat(video_dir(i).folder,'/',video_dir(i).name);       
        videos{i} = readVideo(name, nframes, 0);
    end

end