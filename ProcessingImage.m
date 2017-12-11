function img_processed = ProcessingImage(I1,I2)


I3 = rgb2gray(I1);
I4 = rgb2gray(I2);
I3 = imcrop(I3,[1,1,640,270]);
I4 = imcrop(I4,[1,1,640,270]);


points1 = detectSURFFeatures(I3);
points2 = detectSURFFeatures(I4);


[f1, vpts1] = extractFeatures(I3, points1);
[f2, vpts2] = extractFeatures(I4, points2);


indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(:, 1));
matchedPoints2 = vpts2(indexPairs(:, 2));


% figure(1); ax = axes;
% showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'Parent',ax);
% title(ax, 'Putative point matches');
% legend(ax,'Matched points 1','Matched points 2');




[x,~] = size(matchedPoints1.Location);
Distance = 0;
for i = 1:x
    if matchedPoints1.Location(i,1)>340 && matchedPoints1.Location(i,2)<280
        distance = (matchedPoints1.Location(i,2)-matchedPoints2.Location(i,2))^2 + (matchedPoints1.Location(i,1)-matchedPoints2.Location(i,1))^2;
        if distance > Distance
            Distance = distance;
                j=i;
        end
    end
end

W_rate = matchedPoints2.Location(j,1)/matchedPoints1.Location(j,1);
H_rate = matchedPoints2.Location(j,2)/matchedPoints1.Location(j,2);
if W_rate < 1
    W_rate = 1/W_rate;
end
if H_rate < 1
    H_rate = 1/H_rate;
end

m=double(H_rate);              %放大或缩小的高度
n=double(W_rate);              %放大或缩小的宽度
% img=imread('myfile2\99.tif');
% img2=imread('myfile2\100.tif');
img=rgb2gray(I1);
img2=rgb2gray(I2);
% imshow(img);
[h,w]=size(img);
H = floor(h*m);
W = floor(w*n);
imgn=zeros(H,W);
rot=[m 0 0;0 n 0;0 0 1];                                   %变换矩阵

for i=1:H
    for j=1:W
        pix=[i j 1]/rot;   
        
        float_Y=pix(1)-floor(pix(1)); 
        float_X=pix(2)-floor(pix(2));
       
        if pix(1) < 1 %边界处理
            pix(1) = 1;
        end
        
        if pix(1) > h
            pix(1) = h;
        end
        
        if pix(2) < 1
            pix(2) =1;
        end
        
        if pix(2) > w
            pix(2) =w;
        end
        
        pix_up_left=[floor(pix(1)) floor(pix(2))];%四个相邻的点
        pix_up_right=[floor(pix(1)) ceil(pix(2))];
        pix_down_left=[ceil(pix(1)) floor(pix(2))];
        pix_down_right=[ceil(pix(1)) ceil(pix(2))];     
    
        value_up_left=(1-float_X)*(1-float_Y);%计算临近四个点的权重
        value_up_right=float_X*(1-float_Y);
        value_down_left=(1-float_X)*float_Y;
        value_down_right=float_X*float_Y;%按权重进行双线性插值
        imgn(i,j)=value_up_left*img(pix_up_left(1),pix_up_left(2))+ ...
                  value_up_right*img(pix_up_right(1),pix_up_right(2))+ ...
                  value_down_left*img(pix_down_left(1),pix_down_left(2))+ ...
                  value_down_right*img(pix_down_right(1),pix_down_right(2));        
    end
end

% figure,imshow(uint8(imgn))
ww=(W-w)/2;
if ww == 0
    ww=1;
end
hh=(H-h)/2;
if hh == 0
    hh=1;
end
imgn = imcrop(imgn,[ww,hh,639,359]);
imgn = imadjust(uint8(imgn));
img2 = imadjust(uint8(img2));
imgn = imbinarize(imgn,0.2);
imgn = ~imgn;
se = strel('disk',1);
img_fill = imclose(imgn,se);
img_fill = imfill(img_fill,'holes');

stats = regionprops(img_fill ,'Area','Centroid' ,'PixelList' );
noiseArea=5000;
noisearea=100;
for i=1:size(stats)
    area = stats(i).Area;
    if area>noiseArea || area<noisearea
        pointList = stats(i).PixelList;
        for j=1:size(pointList)
            imgn(pointList(j,2),pointList(j,1))=0;
        end
    end
end
% figure,imshow(uint8(imgn));

% figure,imshow(img2);

% imgm = uint8(imgn)-uint8(img2);
% % figure,imshow(imgm);
% imgm = imbinarize(imgm);
% % figure,imshow(imgm);
% 
% imgm = regiongrow(imgm, 1);
% % figure,imshow(imgm);
% 
% se = strel('disk',3);
% img_fill = imclose(imgm,se);
% img_fill = imfill(img_fill,'holes');
% 
% % figure,imshow(img_fill);
% 
% stats = regionprops(img_fill ,'Area','Centroid' ,'PixelList' );
% noiseArea=100;
% for i=1:size(stats)
%     area = stats(i).Area;
%     if area>noiseArea
%         pointList = stats(i).PixelList;
%         for j=1:size(pointList)
%             imgm(pointList(j,2),pointList(j,1))=0;
%         end
%     end
% end
% % figure,imshow(imgm);
img_processed = imgn;
end