%% Train SVM  

ReadList1 = dir('./Out_File/'); % Read Positive Samples
sz1=size(ReadList1);    
label1=ones(sz1(1),1); %Label Positive Samples as 1  

ReadList2  = dir('./Out_File_n/'); % Read Negative Samples 
sz2=size(ReadList2);    
label2=zeros(sz2(1),1); % Label Negative Samples as 0   
label=[label1',label2']';    
total_num=length(label);    
data=zeros(total_num,1980);    
  
% Extract HOG Features of Positive Samples
for i=4:sz1(1)    
   name= ReadList1(i);    
   img=imread(strcat('./Out_File/',name.name));           
   hog =hogcalculator(img);    
   data(i-3,:)=hog;    
end    
  
% Extract HOG Features of Negative Samples   
for j=4:sz2(1)    
   name= ReadList2(j);    
   img=imread(strcat('./Out_File_n/',name.name));     
   hog =hogcalculator(img); 
   
%    [pc,score,latent,tsquare] = pca(hog);
%    hog_after_PCA=score(:,1:50);
   data(sz1(1)+j-3,:)=hog;    
end 

  
% % [train, test] = crossvalind('holdOut',label);    
% % cp = classperf(label);    
svmStruct = svmtrain(data,label);    
save('svmStrucct') ;
% classes = svmclassify(svmStruct,data(test,:));   
% 
% classperf(cp,classes,test);    
% cp.CorrectRate
% 
