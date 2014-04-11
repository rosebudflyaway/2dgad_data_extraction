function drawGridFrame
global PARAMETERFILENAME CALIBBASEINDEX

%% draw more stuff to assist watching
DELTA = 25;

%load the necessary parameters
load(PARAMETERFILENAME, ['n_sq_x_' num2str(CALIBBASEINDEX)]);
load(PARAMETERFILENAME, ['n_sq_y_' num2str(CALIBBASEINDEX)]);
load(PARAMETERFILENAME, ['x_' num2str(CALIBBASEINDEX)]);
load(PARAMETERFILENAME, ['y_' num2str(CALIBBASEINDEX)]);

no_grid = 0;
kk = CALIBBASEINDEX;

if exist(['y_' num2str(kk)], 'var'),
    if eval(['~isnan(y_' num2str(kk) '(1,1))']),
        if ~no_grid,
            eval(['x_kk = x_' num2str(kk) ';']);
            N_kk = size(x_kk,2);
            if ~exist(['n_sq_x_' num2str(kk)], 'var') || ...
               ~exist(['n_sq_y_' num2str(kk)], 'var'),
                no_grid = 1;
            end;
            if ~no_grid,
                eval(['n_sq_x = n_sq_x_' num2str(kk) ';']);
                eval(['n_sq_y = n_sq_y_' num2str(kk) ';']);
                if (N_kk ~= ((n_sq_x+1)*(n_sq_y+1))),
                    no_grid = 1;
                end;
            end;
        end;

        if ~no_grid,
            % plot more things on the figure (to help the user):
            Nx = n_sq_x+1;
            Ny = n_sq_y+1;
            
            ind_ori = (Ny - 1) * Nx + 1;
            ind_X = Nx*Ny;
            ind_Y = 1;
            ind_XY = Nx;

            xo = x_kk(1,ind_ori);
            yo = x_kk(2,ind_ori);

            xX = x_kk(1,ind_X);
            yX = x_kk(2,ind_X);

            xY = x_kk(1,ind_Y);
            yY = x_kk(2,ind_Y);

            xXY = x_kk(1,ind_XY);
            yXY = x_kk(2,ind_XY);

            uu = cross(cross([xo;yo;1],[xXY;yXY;1]), ...
                       cross([xX;yX;1],[xY;yY;1]));
            xc = uu(1)/uu(3);
            yc = uu(2)/uu(3);                

            bbb = cross(cross([xo;yo;1],[xY;yY;1]),   ...
                        cross([xX;yX;1],[xXY;yXY;1]));
            uu = cross(cross([xo;yo;1],[xX;yX;1]),  ...
                       cross([xc;yc;1],bbb));
            xXc = uu(1)/uu(3);
            yXc = uu(2)/uu(3);

            bbb = cross(cross([xo;yo;1],[xX;yX;1]),...
                        cross([xY;yY;1],[xXY;yXY;1]));
            uu = cross(cross([xo;yo;1],[xY;yY;1]),...
                       cross([xc;yc;1],bbb));
            xYc = uu(1)/uu(3);
            yYc = uu(2)/uu(3);

            uX = [xXc - xc;yXc - yc];
            uY = [xYc - xc;yYc - yc];
            uO = [xo - xc;yo - yc];

            uX = uX / norm(uX);
            uY = uY / norm(uY);
            uO = uO / norm(uO);

            

       %     plot([xo;xX]+1,[yo;yX]+1,'g-','linewidth',2);
        %    plot([xo;xY]+1,[yo;yY]+1,'g-','linewidth',2);
            drawArrow(xo+1, yo+1, xX+1, yX+1, 'k-','linewidth',2);
            drawArrow(xo+1, yo+1, xY+1, yY+1, 'k-','linewidth',2);
            
            text(xXc + DELTA * uX(1) +1 , ...
                 yXc + DELTA * uX(2) +1 , ...
                 'X','color','k','Fontsize',14);
            text(xYc + DELTA * uY(1)+1 ,yYc + DELTA * uY(2)+1, ...
                 'Y','color','k','Fontsize',14, ...
                 'HorizontalAlignment','center');
            text(xo + DELTA * uO(1) +1,yo + DELTA * uO(2)+1, ...
                 'O','color','k','Fontsize',14);

        end;
        drawnow;

      %  set(handleimg,'color',[1 1 1]);
     %   set(handleimg,'Name',num2str(real_image_no),'NumberTitle','off');            
    end;
end;
