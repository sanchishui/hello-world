% ----------------------------读取数据文件-------------------------------
PathRoot='E:/文档/研究生相关/dataset/all';
list=dir(fullfile(PathRoot));
fileNum=size(list,1);
allset = [];

list(3).name % 文件名，如果有子文件夹，则也包含在里面。
disp(list(3).name);
[nmat11 mstr]=readmidi(list(3).name);
nmat12 = dropmidich(nmat11,2);
nmat13 = dropmidich(nmat12,1);
lowest = min(nmat13(:,4));
nmat13(:,4) = nmat13(:,4)-floor(lowest/12)*12;
allset = [allset;nmat13];


for k=4:fileNum
    i1 = length(allset);
	list(k).name 
    [nmat14 mstr]=readmidi(list(k).name);
    nmat15 = dropmidich(nmat14,2);
    nmat16 = dropmidich(nmat15,1);
    lowest = min(nmat16(:,4));
    nmat16(:,4) = nmat16(:,4)-floor(lowest/12)*12;
    allset = [allset;nmat16];
    for i = i1:length(allset)
        if allset(i+1)<allset(i)
          bantime = allset(i,1)+allset(i,2); 
           for j = (i+1):length(allset)
               allset(j) = allset(j)+(floor(bantime/4)+1)*4;
           end
        end    
    end
end
for i = 1:length(allset)-1                %没有音符事件的时间填充
    if allset(i,1)+allset(i,2)<allset(i+1,1)
        allset=[allset(1:i,:);[allset(i,1)+allset(i,2),allset(i+1,1)-allset(i,1)-allset(i,2),0,133,102,0,0];allset(i+1:end,:)];
    end
end
fir = 0;
count = 0;
numbeat = 1;
while((numbeat<length(allset))&&(count<allset(length(allset)))) %统计强拍新音数
    if mod(allset(numbeat,1),2)==0
        allset(numbeat,5) = 1;
        fir = fir+1;
        count = count+4;
        while((allset(numbeat,1)<=count)&&(numbeat<length(allset)))
            numbeat = numbeat+1;
        end
    else
        numbeat = numbeat+1;
    end
    if allset(numbeat,1)>(count+4)
        count = count+4;
    end
end
firra = fir/(floor(allset((length(allset)),1)/4)+1)

obsev = max(allset(:,2));

% ----------------------------旋律相似度--------------------------
states =[];
for i=1:length(allset)
    states(i,:) = [allset(i,2)*4 allset(i,4)];
end
trstates = [];
for i = 1:length(states)
    trstates(i) = states(i,2)+133*(states(i,1)-1)+1;      
end

yichu = max(states(:,1));     
seq = trstates;
[estimateTR,estimateE] = hmmestimate(seq,trstates);  

[real2 mstr]=readmidi('A Day in the Life.mid');     
real1 = dropmidich(real2,2);
real = dropmidich(real1,1);
lowest = min(real(:,4));
real(:,4) = real(:,4)-floor(lowest/12)*12;

for i = 1:length(real)-1                %没有音符事件的时间填充
    if real(i,1)+real(i,2)<real(i+1,1)
        real=[real(1:i,:);[real(i,1)+real(i,2),real(i+1,1)-real(i,1)-real(i,2),0,133,102,0,0];real(i+1:end,:)];
    end
end
reals=[];
for i=1:length(real)
    reals(i,:) = [real(i,2)*4 real(i,4)];
end
trreal = [];
for i = 1:length(reals)
    trreal(i) = reals(i,2)+133*(reals(i,1)-1)+1;      
end

seqr = trreal;
l = length(trreal)-1;
xsd = 0;
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
    li = estimateTR(trpre,trnex);
    if li>0
    xsd = xsd+log(li);
    end
end
disp(xsd);
%---------------------------和弦相似度---------------------------
% chostates = [2 1 3 2 4 3 4 2 1 4 3 1 2 3 1 3 4 1];
% choseq = [5 5 3 1 5 9 1 4 2 4 7 2 2 4 7 8 4 1];
% [TRANS_EST, EMIS_EST] = hmmestimate(choseq, chostates);
% disp(EMIS_EST);
% choreal = [2 4 3 1 2 3 2 4 2 3 1 3 2 3 2 4 3 2];
% chorseq = [1 1 5 5 6 6 5 5 5 4 4 3 3 2 2 1 1 5];
% cl = length(choreal)-1;
% ctxsd = 0;
% for i = 1:cl
%     trpre = choreal(i);
%     trnex = choreal(i+1);
%     reseq = chorseq(i+1);
%     for j = 1:size(TRANS_EST,2)
%         bi(j) = TRANS_EST(trpre,j);
%     end
%     [trm,p] = max(bi);
%     if trm==0
%         li = 0;
%     else
%         li = estimateTR(trpre,trnex)/(cl*trm);
%     end
%     disp(li);
%     for j = 1:size(EMIS_EST,2)
%         cbi(j) = EMIS_EST(trnex,j);
%     end
%     [cemi,cp] = max(cbi);
%     if cemi==0
%         ki = 0;
%     else
%         ki = EMIS_EST(trnex,reseq)/cemi;
%     end
%    ci = li*ki;
%    ctxsd = ctxsd+ci;        
% end
% tr1 = choreal(1);
% re1 = chorseq(1);
% for j = 1:size(EMIS_EST,2)
%         cb1(j) = EMIS_EST(tr1,j);
% end
% [cemi1,cp] = max(cb1);
% if cemi1==0
%     k1 = 0;
% else
%     k1 = EMIS_EST(tr1,re1)/cemi1;
% end
% ctxsd = ctxsd+k1/32;
% disp(ctxsd);







        
    




    