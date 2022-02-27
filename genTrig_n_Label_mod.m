function [ trig_sig,label_sig, trialStartIndexes, trialEndIndexes,classLabels] = genTrig_n_Label_mod(nofTrials,initDelay,iti_Min,iti_Max,sampRate,trialLength,cueAppear,nofClasses)

% nofTrials=10;initDelay=12;iti_Min=2;iti_Max=3;trialLength=8;cueAppear=3;nofClasses=2;sampRate=512;
chunks=crossvalind('kfold', 4, 2);
for i=1:length(chunks)
    classLabels((i-1)*10+1:(i-1)*10+10)= chunks(i);
end
% classLabels = crossvalind('kfold', nofTrials, nofClasses);

trig_sig=zeros(1,initDelay*sampRate);
for trl=1:nofTrials
    tempTrl=ones(1,trialLength*sampRate);
    tempITI=zeros(1,round((iti_Min+rand)*sampRate));
    
    trlSeg=[tempTrl tempITI];
    
    trig_sig=[trig_sig trlSeg];
end

tsi=1;tei=1;
for trlIndex=2:length(trig_sig)
    if(trig_sig(trlIndex)==1 && trig_sig(trlIndex-1)==0)
        trialStartIndexes(tsi)=trlIndex;
        tsi=tsi+1;
    elseif(trig_sig(trlIndex)==0 && trig_sig(trlIndex-1)==1)
        trialEndIndexes(tei)=trlIndex;
        tei=tei+1;
    end
end

label_sig=zeros(1,length(trig_sig));
for trl=1:nofTrials
    label_sig(trialStartIndexes(trl)+cueAppear*sampRate:trialEndIndexes(trl))=classLabels(trl);
end

tm=0:1/sampRate:length(trig_sig)/sampRate-1/sampRate;
classLabels=classLabels';
% plot(tm,trig_sig,'-r');hold on;plot(tm,label_sig,'-g');
% axis([0 inf -1 4]);

