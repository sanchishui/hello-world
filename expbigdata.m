% ----------------------------读取数据文件-------------------------------
format short
% PathRoot='E:/文档/研究生相关/dataset/transposed 44';
PathRoot='E:/文档/研究生相关/dataset/bigdatatest';
list=dir(fullfile(PathRoot));
fileNum=size(list,1);
restest = [];
restest_ave = [];
simlist_ave = [];
numround = 1;
numxsd = 1;
numbar = 0;
downbeat = 0;
count = 0;
sumstates = [];

% for k=3:101
%     list(k).name
%     [nmat14 mstr]=readmidi(list(k).name);
%     %nmat15 = dropmidich(nmat14,2);
%     nmat16 = dropmidich(nmat14,1);
%     nmat16(:,1)=(round(nmat16(:,1)*4))/4;
%     nmat16(:,2)=(round(nmat16(:,2)*4))/4;
%     for i = 1:length(nmat16)
%         if i<=length(nmat16)
%            if nmat16(i,2)<0.25
%               nmat16(i,:)=[]; 
%               i=i-1;
%            end
%         end
%     end
%     lowest = min(nmat16(:,4));
%     nmat16(:,4) = nmat16(:,4)-floor(lowest/12)*12;
%     for i = 1:length(nmat16)-1                %没有音符事件的时间填充
%         if nmat16(i,1)+nmat16(i,2)<nmat16(i+1,1)
%             nmat16=[nmat16(1:i,:);[nmat16(i,1)+nmat16(i,2),nmat16(i+1,1)-nmat16(i,1)-nmat16(i,2),0,89,102,0,0];nmat16(i+1:end,:)];
%         end
%     end
%     numbar = numbar+floor(nmat16(length(nmat16),1)/4)+1;
%     numbeat = 1;
%     count = 0;
%     while((numbeat<length(nmat16))&&(count<nmat16(length(nmat16)))) %统计强拍新音数
%         if mod(nmat16(numbeat,1),2)==0
%             nmat16(numbeat,5) = 1;
%             downbeat = downbeat+1;
%             count = count+4;
%             while((nmat16(numbeat,1)<=count)&&(numbeat<length(nmat16)))
%                 numbeat = numbeat+1;
%             end
%         else
%             numbeat = numbeat+1;
%         end
%         if nmat16(numbeat,1)>(count+4)
%             count = count+4;
%         end
%     end
%     states = [];
%     for i = 1:length(nmat16)
%         states(i,:) = [nmat16(i,2)*4 nmat16(i,4)];
%     end
%     trstates = [];
%     for i = 1:length(states)
%         trstates(i) = states(i,2)+90*(states(i,1)-1)+1;
%     end
%     midstates = [];
%     for i = 1:length(states)-1
%         midstates(i,:) = [trstates(i),trstates(i+1)];
%     end
%     sumstates = [sumstates;midstates];
% end
% for k=102:fileNum
%     list(k).name
%     [nmat14 mstr]=readmidi(list(k).name);
%     %nmat15 = dropmidich(nmat14,2);
%     nmat16 = dropmidich(nmat14,0);
%     nmat16(:,1)=(round(nmat16(:,1)*4))/4;
%     nmat16(:,2)=(round(nmat16(:,2)*4))/4;
%     for i = 1:length(nmat16)
%         if i<=length(nmat16)
%            if nmat16(i,2)<0.25
%               nmat16(i,:)=[]; 
%               i=i-1;
%            end
%         end
%     end
%     lowest = min(nmat16(:,4));
%     nmat16(:,4) = nmat16(:,4)-floor(lowest/12)*12;
%     for i = 1:length(nmat16)-1                %没有音符事件的时间填充
%         if nmat16(i,1)+nmat16(i,2)<nmat16(i+1,1)
%             nmat16=[nmat16(1:i,:);[nmat16(i,1)+nmat16(i,2),nmat16(i+1,1)-nmat16(i,1)-nmat16(i,2),0,89,102,0,0];nmat16(i+1:end,:)];
%         end
%     end
%     numbar = numbar+floor(nmat16(length(nmat16),1)/4)+1;
%     numbeat = 1;
%     count = 0;
%     while((numbeat<length(nmat16))&&(count<nmat16(length(nmat16)))) %统计强拍新音数
%         if mod(nmat16(numbeat,1),2)==0
%             nmat16(numbeat,5) = 1;
%             downbeat = downbeat+1;
%             count = count+4;
%             while((nmat16(numbeat,1)<=count)&&(numbeat<length(nmat16)))
%                 numbeat = numbeat+1;
%             end
%         else
%             numbeat = numbeat+1;
%         end
%         if nmat16(numbeat,1)>(count+4)
%             count = count+4;
%         end
%     end
%     states = [];
%     for i = 1:length(nmat16)
%         states(i,:) = [nmat16(i,2)*4 nmat16(i,4)];
%     end
%     trstates = [];
%     for i = 1:length(states)
%         trstates(i) = states(i,2)+90*(states(i,1)-1)+1;
%     end
%     midstates = [];
%     for i = 1:length(states)-1
%         midstates(i,:) = [trstates(i),trstates(i+1)];
%     end
%     sumstates = [sumstates;midstates];
% end
% xlswrite('E:\文档\研究生相关\dataset\data.xlsx',sumstates);
sumstates = xlsread('E:\文档\研究生相关\dataset\data.xlsx');
maxi = max(max(sumstates));
TRestimate = zeros(maxi,maxi);
% for i = 1:length(TRestimate)
%     for j = 1:length(TRestimate)
%         TRestimate(i,j) = 1/length(TRestimate);
%     end
% end
for i = 1:length(sumstates)
    TRestimate(sumstates(i,1),sumstates(i,2)) = TRestimate(sumstates(i,1),sumstates(i,2))+1;
end

for i = 1:length(TRestimate)
    sumline = 0;
    for j = 1:length(TRestimate)
        sumline = sumline+TRestimate(i,j);
    end
    for j = 1:length(TRestimate)
        if sumline>0
            TRestimate(i,j) = TRestimate(i,j)/sumline;
        end
    end
end

%------------------------------人类作曲---------------------------------
for k=535:545
    resumstates = [];
    list(k).name;
    [real mstr]=readmidi(list(k).name);
    real = dropmidich(real,1);
    real(:,1)=(round(real(:,1)*4))/4;
    real(:,2)=(round(real(:,2)*4))/4;
    for i = 1:length(real)
        if i<=length(real)
           if real(i,2)<0.25
              real(i,:)=[]; 
              i=i-1;
           end
        end
    end
    lowest = min(real(:,4));
    real(:,4) = real(:,4)-floor(lowest/12)*12;
    for i = 1:length(real)-1                %没有音符事件的时间填充
        if real(i,1)+real(i,2)<real(i+1,1)
            real=[real(1:i,:);[real(i,1)+real(i,2),real(i+1,1)-real(i,1)-real(i,2),0,89,102,0,0];real(i+1:end,:)];
        end
    end
    renumbar =floor(real(length(real),1)/4)+1;
    redownbeat = 0;
    numbeat = 1;
    count = 0;
    
    while((numbeat<length(real))&&(count<real(length(real)))) %统计强拍新音数
        if mod(real(numbeat,1),2)==0
            real(numbeat,5) = 1;
            redownbeat = redownbeat+1;
            count = count+4;
            while((real(numbeat,1)<=count)&&(numbeat<length(real)))
                numbeat = numbeat+1;
            end
        else
            numbeat = numbeat+1;
        end
        if real(numbeat,1)>(count+4)
            count = count+4;
        end
    end
    reals=[];
    for i=1:length(real)
        reals(i,:) = [real(i,2)*4 real(i,4)];
    end
    trreal = [];
    for i = 1:length(reals)
        trreal(i) = reals(i,2)+90*(reals(i,1)-1)+1;
    end
    midstates = [];
    for i = 1:length(reals)-1
        midstates(i,:) = [trreal(i),trreal(i+1)];
    end
    resumstates = [resumstates;midstates];
    maxir = max(max(resumstates));
    reTRestimate = zeros(maxir,maxir);
    for i = 1:length(resumstates)
        reTRestimate(resumstates(i,1),resumstates(i,2)) = reTRestimate(resumstates(i,1),resumstates(i,2))+1;
    end
    
    for i = 1:length(reTRestimate)
        sumline = 0;
        for j = 1:length(reTRestimate)
            sumline = sumline+reTRestimate(i,j);
        end
        for j = 1:length(reTRestimate)
            if sumline>0
                reTRestimate(i,j) = reTRestimate(i,j)/sumline;
            end
        end
    end
    
    l = length(trreal)-1;
    oxsd = 0;
%     sxsd = 0;
    for i = 1:l
        trpre = trreal(i);
        trnex = trreal(i+1);
        %     for j = 1:size(estimateTR,2)
        %         bi(j) = estimateTR(trpre,j);
        %     end
        %     [trm,p] = max(bi);
        %     if trm==0
        %         li = 0;
        %     else
%         li = TRestimate(trpre,trnex);            %似然
%         sxsd = sxsd+log(li);
        
        repro = reTRestimate(trpre,trnex);       %欧氏距离
        if (trpre<=maxi)&&(trnex<=maxi)
            pro = TRestimate(trpre,trnex);
            oxsd = oxsd+sqrt((repro-pro)*(repro-pro));
        else
            oxsd = oxsd+repro;
        end
    end
    reradownbeat = redownbeat/renumbar;
    restest(numxsd,numround) = oxsd;
    restest_ave(numxsd,numround) = oxsd/length(real);
    numxsd = numxsd+1;
    simlist_ave(numxsd,numround) = sxsd/length(real);
end
for k=546:fileNum
    resumstates = [];
    list(k).name;
    [real mstr]=readmidi(list(k).name);
    real = dropmidich(real,0);
    real(:,1)=(round(real(:,1)*4))/4;
    real(:,2)=(round(real(:,2)*4))/4;
    for i = 1:length(real)
        if i<=length(real)
           if real(i,2)<0.25
              real(i,:)=[]; 
              i=i-1;
           end
        end
    end
    lowest = min(real(:,4));
    real(:,4) = real(:,4)-floor(lowest/12)*12;
    for i = 1:length(real)-1                %没有音符事件的时间填充
        if real(i,1)+real(i,2)<real(i+1,1)
            real=[real(1:i,:);[real(i,1)+real(i,2),real(i+1,1)-real(i,1)-real(i,2),0,89,102,0,0];real(i+1:end,:)];
        end
    end
    renumbar =floor(real(length(real),1)/4)+1;
    redownbeat = 0;
    numbeat = 1;
    count = 0;
    
    while((numbeat<length(real))&&(count<real(length(real)))) %统计强拍新音数
        if mod(real(numbeat,1),2)==0
            real(numbeat,5) = 1;
            redownbeat = redownbeat+1;
            count = count+4;
            while((real(numbeat,1)<=count)&&(numbeat<length(real)))
                numbeat = numbeat+1;
            end
        else
            numbeat = numbeat+1;
        end
        if real(numbeat,1)>(count+4)
            count = count+4;
        end
    end
    reals=[];
    for i=1:length(real)
        reals(i,:) = [real(i,2)*4 real(i,4)];
    end
    trreal = [];
    for i = 1:length(reals)
        trreal(i) = reals(i,2)+90*(reals(i,1)-1)+1;
    end
    midstates = [];
    for i = 1:length(reals)-1
        midstates(i,:) = [trreal(i),trreal(i+1)];
    end
    resumstates = [resumstates;midstates];
    maxir2 = max(max(resumstates));
    reTRestimate = zeros(maxir2,maxir2);
    for i = 1:length(resumstates)
        reTRestimate(resumstates(i,1),resumstates(i,2)) = reTRestimate(resumstates(i,1),resumstates(i,2))+1;
    end
    
    for i = 1:length(reTRestimate)
        sumline = 0;
        for j = 1:length(reTRestimate)
            sumline = sumline+reTRestimate(i,j);
        end
        for j = 1:length(reTRestimate)
            if sumline>0
                reTRestimate(i,j) = reTRestimate(i,j)/sumline;
            end
        end
    end
    
    l = length(trreal)-1;
    oxsd = 0;
%     sxsd = 0;
    for i = 1:l
        trpre = trreal(i);
        trnex = trreal(i+1);
        %     for j = 1:size(estimateTR,2)
        %         bi(j) = estimateTR(trpre,j);
        %     end
        %     [trm,p] = max(bi);
        %     if trm==0
        %         li = 0;
        %     else
%         li = TRestimate(trpre,trnex);            %似然
%         sxsd = sxsd+log(li);
        
        repro = reTRestimate(trpre,trnex);       %欧氏距离
        if (trpre<=maxi)&&(trnex<=maxi)
            pro = TRestimate(trpre,trnex);
            oxsd = oxsd+sqrt((repro-pro)*(repro-pro));
        else
            oxsd = oxsd+repro;
        end
    end
    reradownbeat = redownbeat/renumbar;
    restest(numxsd,numround) = oxsd;
    restest_ave(numxsd,numround) = oxsd/length(real);
    numxsd = numxsd+1;
    simlist_ave(numxsd,numround) = sxsd/length(real);
end
%-------------------------------机器作曲--------------------------
mastest = [];
mastest_ave = [];
masimlist_ave = [];
numround = 1;
numxsd = 1;
numbar = 0;
downbeat = 0;
count = 0;
for k=3:534
    resumstates = [];
    list(k).name;
    [real mstr]=readmidi(list(k).name);
%     real = dropmidich(real,0);
    real(:,1)=(round(real(:,1)*4))/4;
    real(:,2)=(round(real(:,2)*4))/4;
    for i = 1:length(real)
        if i<=length(real)
           if real(i,2)<0.25
              real(i,:)=[]; 
              i=i-1;
           end
        end
    end
    lowest = min(real(:,4));
    real(:,4) = real(:,4)-floor(lowest/12)*12;
    for i = 1:length(real)-1                %没有音符事件的时间填充
        if real(i,1)+real(i,2)<real(i+1,1)
            real=[real(1:i,:);[real(i,1)+real(i,2),real(i+1,1)-real(i,1)-real(i,2),0,89,102,0,0];real(i+1:end,:)];
        end
    end
%     renumbar =floor(real(length(real),1)/4)+1;
%     redownbeat = 0;
    numbeat = 1;
    count = 0;
    
    while((numbeat<length(real))&&(count<real(length(real)))) %统计强拍新音数
        if mod(real(numbeat,1),2)==0
            real(numbeat,5) = 1;
            redownbeat = redownbeat+1;
            count = count+4;
            while((real(numbeat,1)<=count)&&(numbeat<length(real)))
                numbeat = numbeat+1;
            end
        else
            numbeat = numbeat+1;
        end
        if real(numbeat,1)>(count+4)
            count = count+4;
        end
    end
    reals=[];
    for i=1:length(real)
        reals(i,:) = [real(i,2)*4 real(i,4)];
    end
    trreal = [];
    for i = 1:length(reals)
        trreal(i) = reals(i,2)+90*(reals(i,1)-1)+1;
    end
    midstates = [];
    for i = 1:length(reals)-1
        midstates(i,:) = [trreal(i),trreal(i+1)];
    end
    resumstates = [resumstates;midstates];
    maxim = max(max(resumstates));
    reTRestimate = zeros(maxim,maxim);
    for i = 1:length(resumstates)
        reTRestimate(resumstates(i,1),resumstates(i,2)) = reTRestimate(resumstates(i,1),resumstates(i,2))+1;
    end
    
    for i = 1:length(reTRestimate)
        sumline = 0;
        for j = 1:length(reTRestimate)
            sumline = sumline+reTRestimate(i,j);
        end
        for j = 1:length(reTRestimate)
            if sumline>0
                reTRestimate(i,j) = reTRestimate(i,j)/sumline;
            end
        end
    end
    
    l = length(trreal)-1;
    oxsd = 0;
%     sxsd = 0;
    for i = 1:l
        trpre = trreal(i);
        trnex = trreal(i+1);
        %     for j = 1:size(estimateTR,2)
        %         bi(j) = estimateTR(trpre,j);
        %     end
        %     [trm,p] = max(bi);
        %     if trm==0
        %         li = 0;
        %     else
%         li = TRestimate(trpre,trnex);            %似然
%         sxsd = sxsd+log(li);
        
        repro = reTRestimate(trpre,trnex);       %欧氏距离
        if (trpre<=maxi)&&(trnex<=maxi)
            pro = TRestimate(trpre,trnex);
            oxsd = oxsd+sqrt((repro-pro)*(repro-pro));
        else
            oxsd = oxsd+repro;
        end
    end
%     reradownbeat = redownbeat/renumbar;
    mastest(numxsd,numround) = oxsd;
    mastest_ave(numxsd,numround) = oxsd/length(real);
    numxsd = numxsd+1;
    masimlist_ave(numxsd,numround) = sxsd/length(real);
end
avg_real = mean(restest_ave);
avg_ma = mean(mastest_ave);
var_real = sum((restest_ave(:,1)-avg_real).^2)/length(restest_ave);
var_ma = sum((mastest_ave(:,1)-avg_ma).^2)/length(mastest_ave);


%-------------------------------画图------------------------------


% %-------------------------------只考虑音高---------------------------------
% PathRoot='E:/文档/研究生相关/dataset/all';
% list=dir(fullfile(PathRoot));
% fileNum=size(list,1);
% restest1 = [];
% restest_ave1 = [];
% numround = 1;
% numxsd = 1;
% numbar = 0;
% downbeat = 0;
% count = 0;
% sumstates = [];
% for k=93:fileNum
%     list(k).name
%     [nmat14 mstr]=readmidi(list(k).name);
%     nmat15 = dropmidich(nmat14,2);
%     nmat16 = dropmidich(nmat15,1);
%     lowest = min(nmat16(:,4));
%     nmat16(:,4) = nmat16(:,4)-floor(lowest/12)*12;
%     for i = 1:length(nmat16)-1                %没有音符事件的时间填充
%         if nmat16(i,1)+nmat16(i,2)<nmat16(i+1,1)
%             nmat16=[nmat16(1:i,:);[nmat16(i,1)+nmat16(i,2),nmat16(i+1,1)-nmat16(i,1)-nmat16(i,2),0,89,102,0,0];nmat16(i+1:end,:)];
%         end
%     end
%     numbar = numbar+floor(nmat16(length(nmat16),1)/4)+1;
%     numbeat = 1;
%     count = 0;
%     while((numbeat<length(nmat16))&&(count<nmat16(length(nmat16)))) %统计强拍新音数
%         if mod(nmat16(numbeat,1),2)==0
%             nmat16(numbeat,5) = 1;
%             downbeat = downbeat+1;
%             count = count+4;
%             while((nmat16(numbeat,1)<=count)&&(numbeat<length(nmat16)))
%                 numbeat = numbeat+1;
%             end
%         else
%             numbeat = numbeat+1;
%         end
%         if nmat16(numbeat,1)>(count+4)
%             count = count+4;
%         end
%     end
%     states = [];
%     for i = 1:length(nmat16)
%         states(i) = nmat16(i,4);
%     end
%     trstates = [];
%     for i = 1:length(states)
%         trstates(i) = states(i)+1;
%     end
%     midstates = [];
%     for i = 1:length(states)-1
%         midstates(i,:) = [trstates(i),trstates(i+1)];
%     end
%     sumstates = [sumstates;midstates];
% end
% maxi = max(max(sumstates));
% TRestimate = zeros(maxi,maxi);
% for i = 1:length(sumstates)
%     TRestimate(sumstates(i,1),sumstates(i,2)) = TRestimate(sumstates(i,1),sumstates(i,2))+1;
% end
% 
% for i = 1:length(TRestimate)
%     sumline = 0;
%     for j = 1:length(TRestimate)
%         sumline = sumline+TRestimate(i,j);
%     end
%     for j = 1:length(TRestimate)
%         if sumline>0
%             TRestimate(i,j) = TRestimate(i,j)/sumline;
%         end
%     end
% end
% radownbeat = downbeat/numbar;
% 
% renumbar = 0;
% for k=3:92
%     list(k).name
%     [real mstr]=readmidi(list(k).name);
%     lowest = min(real(:,4));
%     real(:,4) = real(:,4)-floor(lowest/12)*12;
%     for i = 1:length(real)-1                %没有音符事件的时间填充
%         if real(i,1)+real(i,2)<real(i+1,1)
%             real=[real(1:i,:);[real(i,1)+real(i,2),real(i+1,1)-real(i,1)-real(i,2),0,89,102,0,0];real(i+1:end,:)];
%         end
%     end
%     renumbar = renumbar+floor(real(length(real),1)/4)+1;
%     numbeat = 1;
%     count = 0;
%     redownbeat = 0;
%     while((numbeat<length(real))&&(count<real(length(real)))) %统计强拍新音数
%         if mod(real(numbeat,1),2)==0
%             real(numbeat,5) = 1;
%             redownbeat = redownbeat+1;
%             count = count+4;
%             while((real(numbeat,1)<=count)&&(numbeat<length(real)))
%                 numbeat = numbeat+1;
%             end
%         else
%             numbeat = numbeat+1;
%         end
%         if real(numbeat,1)>(count+4)
%             count = count+4;
%         end
%     end
%     reals=[];
%     for i=1:length(real)
%         reals(i) = real(i,4);
%     end
%     trreal = [];
%     for i = 1:length(reals)
%         trreal(i) = reals(i)+1;
%     end
%     
%     seqr = trreal;
%     l = length(trreal)-1;
%     xsd = 0;
%     for i = 1:l
%         trpre = trreal(i);
%         trnex = trreal(i+1);
%         %     for j = 1:size(estimateTR,2)
%         %         bi(j) = estimateTR(trpre,j);
%         %     end
%         %     [trm,p] = max(bi);
%         %     if trm==0
%         %         li = 0;
%         %     else
%         li = TRestimate(trpre,trnex);
%         if li>0
%             xsd = xsd+log(li);
%         end
%     end
%     restest1(numxsd,numround) = xsd;
%     restest_ave1(numxsd,numround) = xsd/(renumbar*length(real));
%     numxsd = numxsd+1;
%     disp(xsd);
% end
% 
% 
% 
% %----------------------------只考虑节奏----------------------------------
% PathRoot='E:/文档/研究生相关/dataset/all';
% list=dir(fullfile(PathRoot));
% fileNum=size(list,1);
% restest2 = [];
% restest_ave2 = [];
% numround = 1;
% numxsd = 1;
% numbar = 0;
% downbeat = 0;
% count = 0;
% sumstates = [];
% for k=93:fileNum
%     list(k).name
%     [nmat14 mstr]=readmidi(list(k).name);
%     nmat15 = dropmidich(nmat14,2);
%     nmat16 = dropmidich(nmat15,1);
%     lowest = min(nmat16(:,4));
%     nmat16(:,4) = nmat16(:,4)-floor(lowest/12)*12;
%     for i = 1:length(nmat16)-1                %没有音符事件的时间填充
%         if nmat16(i,1)+nmat16(i,2)<nmat16(i+1,1)
%             nmat16=[nmat16(1:i,:);[nmat16(i,1)+nmat16(i,2),nmat16(i+1,1)-nmat16(i,1)-nmat16(i,2),0,89,102,0,0];nmat16(i+1:end,:)];
%         end
%     end
%     numbar = numbar+floor(nmat16(length(nmat16),1)/4)+1;
%     numbeat = 1;
%     count = 0;
%     while((numbeat<length(nmat16))&&(count<nmat16(length(nmat16)))) %统计强拍新音数
%         if mod(nmat16(numbeat,1),2)==0
%             nmat16(numbeat,5) = 1;
%             downbeat = downbeat+1;
%             count = count+4;
%             while((nmat16(numbeat,1)<=count)&&(numbeat<length(nmat16)))
%                 numbeat = numbeat+1;
%             end
%         else
%             numbeat = numbeat+1;
%         end
%         if nmat16(numbeat,1)>(count+4)
%             count = count+4;
%         end
%     end
%     states = [];
%     for i = 1:length(nmat16)
%         states(i) = nmat16(i,2)*4;
%     end
%     trstates = [];
%     for i = 1:length(states)
%         trstates(i) = states(i);
%     end
%     midstates = [];
%     for i = 1:length(states)-1
%         midstates(i,:) = [trstates(i),trstates(i+1)];
%     end
%     sumstates = [sumstates;midstates];
% end
% maxi = max(max(sumstates));
% TRestimate = zeros(maxi,maxi);
% for i = 1:length(sumstates)
%     TRestimate(sumstates(i,1),sumstates(i,2)) = TRestimate(sumstates(i,1),sumstates(i,2))+1;
% end
% 
% for i = 1:length(TRestimate)
%     sumline = 0;
%     for j = 1:length(TRestimate)
%         sumline = sumline+TRestimate(i,j);
%     end
%     for j = 1:length(TRestimate)
%         if sumline>0
%             TRestimate(i,j) = TRestimate(i,j)/sumline;
%         end
%     end
% end
% radownbeat = downbeat/numbar;
% 
% renumbar = 0;
% for k=3:92
%     list(k).name
%     [real mstr]=readmidi(list(k).name);
%     lowest = min(real(:,4));
%     real(:,4) = real(:,4)-floor(lowest/12)*12;
%     for i = 1:length(real)-1                %没有音符事件的时间填充
%         if real(i,1)+real(i,2)<real(i+1,1)
%             real=[real(1:i,:);[real(i,1)+real(i,2),real(i+1,1)-real(i,1)-real(i,2),0,89,102,0,0];real(i+1:end,:)];
%         end
%     end
%     renumbar = renumbar+floor(real(length(real),1)/4)+1;
%     numbeat = 1;
%     count = 0;
%     redownbeat = 0;
%     while((numbeat<length(real))&&(count<real(length(real)))) %统计强拍新音数
%         if mod(real(numbeat,1),2)==0
%             real(numbeat,5) = 1;
%             redownbeat = redownbeat+1;
%             count = count+4;
%             while((real(numbeat,1)<=count)&&(numbeat<length(real)))
%                 numbeat = numbeat+1;
%             end
%         else
%             numbeat = numbeat+1;
%         end
%         if real(numbeat,1)>(count+4)
%             count = count+4;
%         end
%     end
%     reals=[];
%     for i=1:length(real)
%         reals(i) = real(i,2)*4;
%     end
%     trreal = [];
%     for i = 1:length(reals)
%         trreal(i) = reals(i);
%     end
%     
%     seqr = trreal;
%     l = length(trreal)-1;
%     xsd = 0;
%     for i = 1:l
%         trpre = trreal(i);
%         trnex = trreal(i+1);
%         %     for j = 1:size(estimateTR,2)
%         %         bi(j) = estimateTR(trpre,j);
%         %     end
%         %     [trm,p] = max(bi);
%         %     if trm==0
%         %         li = 0;
%         %     else
%         li = TRestimate(trpre,trnex);
%         if li>0
%             xsd = xsd+log(li);
%         end
%     end
%     restest2(numxsd,numround) = xsd;
%     restest_ave2(numxsd,numround) = xsd/(renumbar*length(real));
%     numxsd = numxsd+1;
%     disp(xsd);
% end
% 
