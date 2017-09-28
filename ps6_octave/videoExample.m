% Construct a multimedia reader object associated with file 'xylophone.mpg' with
% user tag set to 'myreader1'.
readerobj = VideoReader('input/pedestrians.avi', 'tag', 'myreader1');

% Read in all video frames.
vidFrames = read(readerobj);

% Get the number of frames.
numFrames = get(readerobj, 'NumberOfFrames');

% Create a MATLAB movie struct from the video frames.
for k = 1 : numFrames
    mov(k).cdata = vidFrames(:,:,:,k);
    mov(k).colormap = [];
end

% Create a figure
hf = figure; 
       
% Resize figure based on the video's width and height
set(hf, 'position', [150 150 readerobj.Width readerobj.Height])
 
% Playback movie once at the video's frame rate
movie(hf, mov, 1, readerobj.FrameRate);