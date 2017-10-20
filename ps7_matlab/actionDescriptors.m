function [CM_desc, SI_desc] = actionDescriptors(videoFiles)
    
    CM_desc = [];
    SI_desc = [];
    for i = 1:length(videoFiles)
        videoFileName = strcat('input/',videoFiles(i).name);
        readerobj = VideoReader(videoFileName);
        numFrames = get(readerobj, 'NumberOfFrames');
        actionStop = numFrames - round(0.1*numFrames);
        tao = round(numFrames/2);
        [CM, SI] = MHIdesc(readerobj,tao,actionStop);
        CM_desc = [CM_desc; CM];
        SI_desc = [SI_desc; SI];
    end
   