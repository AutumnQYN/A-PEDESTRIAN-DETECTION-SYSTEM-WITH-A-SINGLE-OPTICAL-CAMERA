function [ image_bw_grown ] = regiongrow( image_bw, c )

[SIZE_ROW, SIZE_COL] = size( image_bw );

cnt = 1;
flag = 1;
while ( cnt<=c && flag==1 )
    image_bw_ori = image_bw;
    for m = 2:(SIZE_ROW-1)
        for n = 2:(SIZE_COL-1)
            if ( image_bw_ori(m, n) == 1 )
                
                image_bw(m-1, n+1) = 1;
                
                
                image_bw(m, n+1) = 1;
                
                
                image_bw(m+1, n+1) = 1;
               
                
                
                image_bw(m-1, n) = 1;
                
                image_bw(m, n) = 1;
                
                image_bw(m-1, n-1) = 1;
                image_bw(m, n-1) = 1;
                image_bw(m+1, n-1) = 1;
                
            end
        end
    end
    if ( isequal(image_bw, image_bw_ori) )
        flag = 0;
    end
    cnt = cnt + 1;
end

image_bw_grown = image_bw;