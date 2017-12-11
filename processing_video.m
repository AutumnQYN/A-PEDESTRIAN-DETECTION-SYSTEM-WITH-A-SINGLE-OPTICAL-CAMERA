load svmStrucct.mat
writerObj = VideoWriter('myfile3_test3');
fileName = 'myfile3.mp4';
vObj = VideoReader(fileName);
open(writerObj);
for k = 1 : 99

    I1 = readFrame(vObj);
    I2 = readFrame(vObj);
    img3 = ProcessingImage(I1,I2);
    img3 = regiongrow(img3,1);
    img1=rgb2gray(I1);
    img2=rgb2gray(I2);
    status=regionprops(img3,'BoundingBox','Extrema');
    S = size(status);
    imshow(I1); hold on;
    for i=1:S(1)
        x = status(i).BoundingBox(1);
        y = status(i).BoundingBox(2);
        w = status(i).BoundingBox(3);
        h = status(i).BoundingBox(4);
        top_point = status(i).Extrema(1,:);
        m = top_point(1);
        n = top_point(2);
        if x<450 && y<240 && k>30
            if h>96
                Img = imcrop(img1,[m-24,n,round(h/2),h]);
                Img = imresize(Img,[96,48],'nearest');
                hogt =hogcalculator(Img);
                classes = svmclassify(svmStruct,hogt);
                if classes == 1
                    rectangle('Position',[m-24,n,round(h/2),h],'EdgeColor','b','LineWidth',1);
                end
            elseif h>48 && h<97
                Img = imcrop(img1,[m-12,n,round(h/2),h]);
                Img = imresize(Img,[96,48],'nearest');
                hogt =hogcalculator(Img);
                classes = svmclassify(svmStruct,hogt);
                if classes == 1
                    rectangle('Position',[m-12,n,round(h/2),h],'EdgeColor','b','LineWidth',1);
                end
            elseif h>24 && h<49
                Img = imcrop(img1,[m-6,n,round(h/2),h]);
                Img = imresize(Img,[96,48],'nearest');
                hogt =hogcalculator(Img);
                classes = svmclassify(svmStruct,hogt);
                if classes == 1
                    rectangle('Position',[m-6,n,round(h/2),h],'EdgeColor','b','LineWidth',1);
                end
            elseif h>20 && h<25
                Img = imcrop(img1,[m-3,n,round(h/2),h]);
                Img = imresize(Img,[96,48],'nearest');
                hogt =hogcalculator(Img);
                classes = svmclassify(svmStruct,hogt);
                if classes == 1
                    rectangle('Position',[m-3,n,round(h/2),h],'EdgeColor','b','LineWidth',1);
                end
            end
        end
    end
    F1= getframe(gcf);
    imshow(I2); hold on;
    for i=1:S(1)
        x = status(i).BoundingBox(1);
        y = status(i).BoundingBox(2);
        w = status(i).BoundingBox(3);
        h = status(i).BoundingBox(4);
        top_point = status(i).Extrema(1,:);
        m = top_point(1);
        n = top_point(2);
        if x<580 && y<240 && k>30
            if h>96
                Img = imcrop(img2,[m-24,n,round(h/2),h]);
                Img = imresize(Img,[96,48],'nearest');
                hogt =hogcalculator(Img);
                classes = svmclassify(svmStruct,hogt);
                if classes == 1
                    rectangle('Position',[m-24,n,round(h/2),h],'EdgeColor','b','LineWidth',1);
                end
            elseif h>48 && h<97
                Img = imcrop(img2,[m-12,n,round(h/2),h]);
                Img = imresize(Img,[96,48],'nearest');
                hogt =hogcalculator(Img);
                classes = svmclassify(svmStruct,hogt);
                if classes == 1
                    rectangle('Position',[m-12,n,round(h/2),h],'EdgeColor','b','LineWidth',1);
                end
            elseif h>24 && h<49
                Img = imcrop(img2,[m-6,n,round(h/2),h]);
                Img = imresize(Img,[96,48],'nearest');
                hogt =hogcalculator(Img);
                classes = svmclassify(svmStruct,hogt);
                if classes == 1
                    rectangle('Position',[m-6,n,round(h/2),h],'EdgeColor','b','LineWidth',1);
                end
            elseif h>20 && h<25
                Img = imcrop(img2,[m-3,n,round(h/2),h]);
                Img = imresize(Img,[96,48],'nearest');
                hogt =hogcalculator(Img);
                classes = svmclassify(svmStruct,hogt);
                if classes == 1
                    rectangle('Position',[m-3,n,round(h/2),h],'EdgeColor','b','LineWidth',1);
                end
            end
        end
    end
    F2= getframe(gcf);

    
    writeVideo(writerObj,F1.cdata);
    writeVideo(writerObj,F2.cdata);
end
close(writerObj);