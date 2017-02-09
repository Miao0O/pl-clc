conf = plClcConfig;
load(conf.trainData,'imData');
imData.concatenateGTBoxes();
[spc,updateBoxes] = singlePhraseCueSet(conf);
[imData,scores,boxes] = getSPCScores(conf,imData,spc,updateBoxes);

load(conf.spcWeights,'weights');
addGT = true;
scores = scoreRegionsWithSinglePhraseCues(conf,imData,weights,scores,boxes,addGT);

classFN = fullfile(conf.dictionarydir,'flickrVerbPair.txt');
classes = readClassesFromFile(classFN);
verbPairs = RelativePosition('verbPairs',[],classes);
maxTrainSamples = 10000; % just what worked best for us on validation data
verbPairs.trainModel(imData,scores,maxTrainSamples,conf.posThresh);
modelFN = sprintf('verbPairPhrase_defaultWeights_top%i_%fnms_subsample_%ik',conf.minNumInstances,conf.nmsThresh,maxTrainSamples/1000);
save(fullfile('models','svms',modelFN),'verbPairs');

classFN = fullfile(conf.dictionarydir,'flickrPrepPair.txt');
classes = readClassesFromFile(classFN);
prepPairs = RelativePosition('prepPairs',[],classes);
maxTrainSamples = 10000; % just what worked best for us on validation data
prepPairs.trainModel(imData,scores,maxTrainSamples,conf.posThresh);
modelFN = sprintf('prepPairPhrase_defaultWeights_top%i_%fnms_subsample_%ik',conf.minNumInstances,conf.nmsThresh,maxTrainSamples/1000);
save(fullfile('models','svms',modelFN),'prepPairs');

classFN = fullfile(conf.dictionarydir,'flickrClothingbpPair.txt');
classes = readClassesFromFile(classFN);
clbpPairs = ClothingBP('clbp',[],classes);
maxTrainSamples = 7000; % just what worked best for us on validation data
clbpPairs.trainModel(imData,scores,maxTrainSamples,conf.posThresh);
modelFN = sprintf('clbpPairPhrase_defaultWeights_top%i_%fnms_subsample_%ik',conf.minNumInstances,conf.nmsThresh,maxTrainSamples/1000);
save(fullfile('models','svms',modelFN),'clbpPairs');




