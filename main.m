clc
close all
clear all

[ matrix, filename_set ] = loadHangingmainFilter ;
%{
filename_set = {'kernel_uppershadow.csv',
                'kernel_realbody.csv',
                'kernel_lowershadow.csv',
                'kernel_close_price.csv'}';
%}

% -------------------------  ???  -------------------------
% ?? arccos ???? filter ? arccos ?
% ? matlab ? arccos ????, ??????????(??????,???)

n_matrix = length(matrix);
matrix_size = length(matrix{1});

matrix_arccos = cell(1,n_matrix);
key_phi = zeros(n_matrix,matrix_size);
for i_matrix = 1 : n_matrix
    this_matrix = matrix{i_matrix};
    this_matrix_arccos = real(acos(this_matrix));
    
    % -------------------------  ???  -------------------------
    % ? N ???????, ?????? phi_k ??? N ???
    % kernel > 10 ? matlab ??????????????????
    p = perms(1:matrix_size);
    n_p = length(p);
    all_phi = zeros(n_p,matrix_size);
    
    for i_p = 1 : n_p
         % ???????, ????????????
         % ????? 3, ?????? x_3 = cos(phi_3 + phi_3)
         % ?? arccos(x_3)/2 = phi_3 ?? phi_3
         this_p = p(i_p,:);
         first_this_p = this_p(1);
         first_phi = this_matrix_arccos(first_this_p,first_this_p)/2 ;
         % ???? phi ?? all_phi
         all_phi(i_p,this_p)=first_phi;
         
         % ?????? phi ?? this_p ??
         % ?? this_p = [1,3,5,4,2]
         % ??????? phi_1 ??? phi_1 ? phi_3 ?? phi_3 ? phi_5
         now_this_phi = first_phi ;
         for i_this_p = 1 : matrix_size - 1
             now_this_p  = this_p(i_this_p) ;
             next_this_p = this_p(i_this_p+1);
             next_phi = this_matrix_arccos(now_this_p,next_this_p)-now_this_phi;
             all_phi(i_p,i_this_p+1)=next_phi;
             now_this_phi = next_phi;
         end
    end
    
    % -------------------------  ???  -------------------------
    % ??????? phi ???, ????????????????? phi
    % ????? key phi
    this_key_phi = zeros(1,matrix_size);
    for i_key = 1 : matrix_size
         this_key_phi(i_key) = this_matrix_arccos(i_key,i_key)/2 ;
    end 
    key_phi(i_matrix,:) = this_key_phi;
    
    
    % -------------------------  ???(??)  -------------------------
    % ??????, ??????? "%{" "%}" ???
    % ??????, ?????? kernel ?????, ??????, ??????
    % ?????????, ???????????, ????
    figure;
    hold on
    n_quantile = 50 ;n_lin=1000;
    all_phi_q = quantile(all_phi,n_quantile,1);
    interp_x = linspace(1,matrix_size,n_lin);
    interp_y = zeros(n_quantile,n_lin);
    for i_q = 1 : n_quantile
    interp_y(i_q,:) = interp1([1:matrix_size],all_phi_q(i_q,:),interp_x, 'spline');
    end
    max_y = max(max(interp_y));min_y=min(min(interp_y));
    title(filename_set{i_matrix});
    plot(interp_x,interp_y',':','Color',[0 0 0],'LineWidth',1);
    plot(this_key_phi','-','Color',[0 1 0],'LineWidth',2);
    axis([1 matrix_size min_y max_y]);
    hold off
    drawnow
    
end

% ?? key_phi ?????
%{
filename_set = {'uppershadow',
                'realbody',
                'lowershadow',
                'close_price'}';
%}
upper_shadow = key_phi(1,:);
real_body    = key_phi(2,:);
lower_shadow = key_phi(3,:);
close_price  = key_phi(4,:);

% ?????? normalize ???????
us_lambda = 0.001 ;
rb_lambda = 0.001 ;
ls_lambda = 0.05 ;


high_price = close_price + us_lambda * upper_shadow ;
open_price = close_price - rb_lambda * real_body ;
low_price  = close_price - ls_lambda * lower_shadow ;

figure;
candle(high_price',low_price',close_price',open_price');












