function [u,v] = LKopticFlow(I_base,I_motion) 

    kernel = [-1 8 0 -8 1]/12;
    Ix = conv2(I_base,kernel,'same');
    Iy = conv2(I_base,kernel','same');
    [Gmag, Gdir] = imgradient(Ix, Iy);
    normIx = Ix./Gmag;
    normIy = Iy./Gmag;
    h = ones(5,5);

    sumIxIx = imfilter(Ix.*Ix,h);
    sumIyIy = imfilter(Iy.*Iy,h);
    sumIxIy = imfilter(Ix.*Iy,h);

    [x,y] = meshgrid(1:size(I_base,2),1:size(I_base,1));
    u0 = 0; v0 = 0;
    d_previous = 0;

    %while 1
        XI = x - u0;
        YI = y - v0;
        warped = imremap(I_base,XI,YI);

        It = I_motion - warped;

        sumIxIt = imfilter(Ix.*It,h);
        sumIyIt = imfilter(Iy.*It,h);

        detA = (sumIxIx.*sumIyIy) - (sumIxIy.*sumIxIy);
        detB1 = (-sumIxIt.*sumIyIy) - (sumIxIy.*(-sumIyIt));
        detB2 = (sumIxIx.*(-sumIyIt)) - (-sumIxIt.*sumIxIy);
        u = detB1./detA;
        v = detB2./detA;
        threshold = 0.0039;
        lamda1 = (sumIxIx + sumIyIy)/2 + sqrt(4*sumIxIy.^2 + (sumIxIx - sumIyIy).^2)/2;
        lamda2 = (sumIxIx + sumIyIy)/2 - sqrt(4*sumIxIy.^2 + (sumIxIx - sumIyIy).^2)/2;
        u(lamda1 < threshold & lamda2 < threshold) = 0;
        v(lamda1 < threshold & lamda2 < threshold) = 0;
        
        speed = -It./Gmag;
        u_norm = speed.*normIx;
        v_norm = speed.*normIy; 
        u_nan = find(isnan(u));
        v_nan = find(isnan(v));
        u(u_nan) = u_norm(u_nan);
        v(v_nan) = v_norm(v_nan);

        %displacement = max(sqrt(u.^2 + v.^2)(:));
        %displacement = sum(displacement(:))/numel(displacement);
        %u0 = u0 + u;
        %v0 = v0 + v;

        %if abs(displacement) < 0.5*d_previous
            %break
        %end
        %d_previous = displacement;

    %end

%u = u0; v = v0; 